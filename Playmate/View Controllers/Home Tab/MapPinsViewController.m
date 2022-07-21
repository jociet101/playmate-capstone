//
//  MapPinsViewController.m
//  Playmate
//
//  Created by Jocelyn Tseng on 7/15/22.
//

#import "MapPinsViewController.h"
#import "LocationAnnotation.h"
#import "SessionDetailsViewController.h"
#import "Session.h"
#import "Location.h"
#import "Helpers.h"
#import "MapFiltersViewController.h"
#import "Filters.h"

@interface MapPinsViewController () <CLLocationManagerDelegate, MKMapViewDelegate, MapFiltersViewControllerDelegate>

@property (weak, nonatomic) IBOutlet MKMapView *mapView;
@property (nonatomic, strong) Session *selectedSession;
@property (nonatomic, strong) NSArray *sessionList;

@property (assign, nonatomic) BOOL appliedFilters;
@property (nonatomic, strong) Filters * _Nullable filters;

@property (nonatomic, strong) NSMutableArray *currentAnnotations;

@end

@implementation MapPinsViewController

CLLocationManager *pinLocationManager;
BOOL isFirstTimeGettingLocation;

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.appliedFilters = NO;
    self.filters = nil;
    
    self.mapView.delegate = self;
    self.mapView.showsUserLocation = YES;
    
    self.currentAnnotations = [[NSMutableArray alloc] init];
    
    isFirstTimeGettingLocation = YES;
    
    [CLLocationManager locationServicesEnabled];
    
    [self initPinLocationManager];
    
    if (self.appliedFilters == YES) {
        [self fetchDataWithFilters:self.filters];
    } else {
        [self fetchData];
    }
}

- (void)initPinLocationManager {
    //Create location manager
    pinLocationManager = [[CLLocationManager alloc] init];
    [pinLocationManager setDelegate:self];
    [pinLocationManager requestAlwaysAuthorization];
    [pinLocationManager startUpdatingLocation];
    [pinLocationManager startUpdatingHeading];
    pinLocationManager.distanceFilter = kCLDistanceFilterNone;
    pinLocationManager.desiredAccuracy = kCLLocationAccuracyBest;
}

#pragma mark - Location manager delegate methods

- (void)locationManagerDidChangeAuthorization:(CLLocationManager *)manager {
    [pinLocationManager requestLocation];
}

- (void)locationManager:(CLLocationManager *)manager
     didUpdateLocations:(NSArray<CLLocation *> *)locations {
    if (isFirstTimeGettingLocation == YES) {
        isFirstTimeGettingLocation = NO;
        
        CLLocation *loc = [locations firstObject];
        
        MKCoordinateRegion region = MKCoordinateRegionMake([loc coordinate], MKCoordinateSpanMake(0.8, 0.8));
        [self.mapView setRegion:region animated:YES];
    }
}

- (void)locationManager:(CLLocationManager *)manager
       didFailWithError:(NSError *)error {
}

#pragma mark - Fetch data

- (void)fetchData {
    if (self.appliedFilters == YES) {
        [self fetchDataWithFilters:self.filters];
        return;
    }
    
    PFQuery *query = [PFQuery queryWithClassName:@"SportsSession"];
    query.limit = 20;

    // fetch data asynchronously
    [query findObjectsInBackgroundWithBlock:^(NSArray *sessions, NSError *error) {
        if (sessions != nil) {
            NSMutableArray *filteredSessions = [[NSMutableArray alloc] init];
            
            for (Session *session in sessions) {
                NSDate *now = [NSDate date];
                NSComparisonResult result = [now compare:session.occursAt];
                
                if (result == NSOrderedAscending) {
                    [filteredSessions addObject:session];
                }
            }
            
            self.sessionList = (NSArray *)filteredSessions;
            
            [self addPins];
        } else {
            [Helpers handleAlert:error withTitle:@"Error" withMessage:nil forViewController:self];
        }
    }];
}

- (void)fetchDataWithFilters:(Filters *)filter {
    
    if (self.appliedFilters == NO) {
        self.filters = filter;
        self.appliedFilters = YES;
    }
    
    PFQuery *query = [PFQuery queryWithClassName:@"SportsSession"];
    query.limit = 20;
    
    [query orderByDescending:@"createdAt"];
    
    if (filter.sport != nil) {
        [query whereKey:@"sport" equalTo:filter.sport];
    }
    if (filter.skillLevel != nil) {
        [query whereKey:@"skillLevel" equalTo:filter.skillLevel];
    }

    // fetch data asynchronously
    [query findObjectsInBackgroundWithBlock:^(NSArray *sessions, NSError *error) {
        if (sessions != nil) {
            self.sessionList = (filter.location != nil) ? [self filterSessions:sessions
                                                                  withLocation:filter.location
                                                                     andRadius:filter.radius] : sessions;
            [self addPins];
        } else {
            [Helpers handleAlert:error withTitle:@"Error" withMessage:nil forViewController:self];
        }
    }];
}

#pragma mark - Filters related

- (void)clearFilters {
    if (self.appliedFilters == YES) {
        self.filters = nil;
        self.appliedFilters = NO;
        [self fetchData];
    }
}

- (void)didApplyFilters:(MapFilters *)filter {
    [self clearFilters];
    [self fetchDataWithFilters:filter];
    [self.navigationController popToViewController:self
                                                  animated:YES];
}

- (float)euclideanDistanceBetween:(Location *)location1 and:(Location *)location2 {
    [location1 fetchIfNeeded];
    [location2 fetchIfNeeded];
    
    float latitude1 = [location1.lat floatValue];
    float latitude2 = [location2.lat floatValue];
    float longitude1 = [location1.lng floatValue];
    float longitude2 = [location2.lng floatValue];
    
    float sumSquaredDifferences = pow(latitude1-latitude2, 2) + pow(longitude1-longitude2, 2);
    
    return pow(sumSquaredDifferences, 0.5);
}

- (NSArray *)filterSessions:(NSArray *)sessions withLocation:(Location *)location andRadius:(NSNumber *)radiusInMiles {
    float radiusInUnits = [radiusInMiles floatValue]/69;
    
    NSMutableArray *filteredSessions = [[NSMutableArray alloc] init];
    
    for (Session *session in sessions) {
        float distance = [self euclideanDistanceBetween:location and:session.location];
                
        NSDate *now = [NSDate date];
        NSComparisonResult result = [now compare:session.occursAt];
        
        if (distance <= radiusInUnits && result == NSOrderedAscending) {
            [filteredSessions addObject:session];
        }
    }
    
    return (NSArray *)filteredSessions;
}

#pragma mark - Pin Annotation tasks

// TODO: solve bug where two pins overlap and only one is visible
// Idea: manually change latitude and longitude by a bit if there are multiple pins in the same exact location

- (void)addPins {
    [self.mapView removeAnnotations:(NSArray *)self.currentAnnotations];
    [self.currentAnnotations removeAllObjects];
    
    for (Session *session in self.sessionList) {
        Location *location = [session[@"location"] fetchIfNeeded];
        
        CLLocationCoordinate2D coordinate = CLLocationCoordinate2DMake([location.lat doubleValue], [location.lng doubleValue]);
        LocationAnnotation *point = [[LocationAnnotation alloc] init];
        point.coordinate = coordinate;
        NSArray *parsedLocation = [location.locationName componentsSeparatedByString:@", "];
        point.locationName = [parsedLocation firstObject];
        point.session = session;
                
        [self.mapView addAnnotation:point];
        [self.currentAnnotations addObject:point];
    }
}

- (MKAnnotationView *)mapView:(MKMapView *)mapView viewForAnnotation:(id<MKAnnotation>)annotation {
    if ([annotation.title isEqualToString:@"My Location"]) {
        return nil;
    }
    
    MKPinAnnotationView *annotationView = (MKPinAnnotationView*)[mapView dequeueReusableAnnotationViewWithIdentifier:@"Pin"];
    
    if (annotationView == nil) {
        annotationView = [[MKPinAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:@"Pin"];
        annotationView.canShowCallout = true;
    } else {
        annotationView.annotation = annotation;
    }
    
    annotationView.rightCalloutAccessoryView = [UIButton buttonWithType:UIButtonTypeDetailDisclosure];
    annotationView.pinTintColor = [UIColor systemTealColor];
    
    return annotationView;
}

- (void)mapView:(MKMapView *)mapView
 annotationView:(MKAnnotationView *)view
calloutAccessoryControlTapped:(UIControl *)control {
    LocationAnnotation *locationAnnotationItem = view.annotation;
    self.selectedSession = locationAnnotationItem.session;
    [self performSegueWithIdentifier:@"pinToDetailsSegue" sender:nil];
}

#pragma mark - Navigation

 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
     if([segue.identifier isEqualToString:@"pinToDetailsSegue"]) {
         SessionDetailsViewController *vc = segue.destinationViewController;
         vc.sessionDetails = self.selectedSession;
     }
     else if ([segue.identifier isEqualToString:@"mapPinsToMapFilters"]) {
         MapFiltersViewController *vc = [segue destinationViewController];
         vc.delegate = self;
     }
}

@end
