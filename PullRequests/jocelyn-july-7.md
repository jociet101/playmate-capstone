# ๐ฉ๐ปโ๐ซ What does this PR do?

### Refactoring:
- Created Constants.h and .m files, went through all other files and put in constants here
- Removed unnecessary log statements and methods

### API/Networking:
- Create API Manager
- Integrate "geoapify" API for geocoding
- Integrate decathalon API for sports list

### Map view:
- User can search for an address and pin will appear on map
- Location data is saved to parse and will show on filters/create session view controller

### Session details:
- Location will show up on details view

### Create tab:
- Retrieve sports list from Decathalon api


# ๐งช How can I test it?

Map:
- Desired behavior: User can search address into Search bar on map view and the map should show a pin and center at that location
    - How to test:
        - Copy repo to local, go through create account and login process too
        - Run app and go to create tab
        - Click "select on map" button and search for an address (Feel free to customize other fields too!)
        - Once the user returns to the create tab, the location should show accordingly
        - Try for multiple addresses!

# ๐๐ฝ Are there any screenshots / GIF ?
Add any screenshots / GIFS if there are any
# โ This PR is related to:
- [ ] ๐  Home
- [ ] ๐ Search
- [x] โ Create
- [ ] ๐ท Profile
- [x] Map view
- [x] Session details
- [x] โ๏ธ Other
    - [x] Refactoring
