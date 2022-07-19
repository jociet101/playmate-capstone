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

@interface MapPinsViewController () <CLLocationManagerDelegate, MKMapViewDelegate>

@property (weak, nonatomic) IBOutlet MKMapView *mapView;
@property (nonatomic, strong) Session *selectedSession;
@property (nonatomic, strong) NSArray *sessionList;

@end

@implementation MapPinsViewController

CLLocationManager *pinLocationManager;
BOOL isFirstTimeGettingLoc;

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.mapView.delegate = self;
    self.mapView.showsUserLocation = YES;
    
    isFirstTimeGettingLoc = YES;
    
    [CLLocationManager locationServicesEnabled];
    
    [self initPinLocationManager];
    
    [self fetchData];
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
    if (isFirstTimeGettingLoc == YES) {
        isFirstTimeGettingLoc = NO;
        
        CLLocation *loc = [locations firstObject];
        
        MKCoordinateRegion region = MKCoordinateRegionMake([loc coordinate], MKCoordinateSpanMake(0.8, 0.8));
        [self.mapView setRegion:region animated:YES];
    }
}

- (void)locationManager:(CLLocationManager *)manager
       didFailWithError:(NSError *)error {
}

#pragma mark - Pin Annotation tasks

- (void)fetchData {
    PFQuery *query = [PFQuery queryWithClassName:@"SportsSession"];
    query.limit = 20;

    [query orderByAscending:@"occursAt"];

    // fetch data asynchronously
    [query findObjectsInBackgroundWithBlock:^(NSArray *sessions, NSError *error) {
        if (sessions != nil) {
            self.sessionList = sessions;
            [self addPins];
        } else {
            [Helpers handleAlert:error withTitle:@"Error" withMessage:nil forViewController:self];
        }
    }];
}

- (void)addPins {
    for (Session *session in self.sessionList) {
        Location *location = [session[@"location"] fetchIfNeeded];
        
        CLLocationCoordinate2D coordinate = CLLocationCoordinate2DMake([location.lat doubleValue], [location.lng doubleValue]);
        LocationAnnotation *point = [[LocationAnnotation alloc] init];
        point.coordinate = coordinate;
        NSArray *parsedLocation = [location.locationName componentsSeparatedByString:@", "];
        point.locationName = [parsedLocation firstObject];
        point.session = session;
                
        [self.mapView addAnnotation:point];
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
}

@end
