# 👩🏻‍🏫 What does this PR do?

Refactoring:
- Created Constants.h and .m files, went through all other files and put in constants here
- Removed unnecessary log statements and methods

API/Networking:
- Create API Manager
- Integrate "geoapify" API for geocoding

Map view:
- User can search for an address


# 🧪 How can I test it?

Map:
- Desired behavior: User can search address into Search bar on map view and the map should show a pin and center at that location
    - How to test:
        - Copy repo to local
        - Run app and go to create tab
        - Click "select on map" button and search for an address
        - Once the user returns to the create tab, the location should show accordingly
        - Try for multiple addresses!

# 💅🏽 Are there any screenshots / GIF ?
Add any screenshots / GIFS if there are any
# ✅ This PR is related to:
- [ ] 🏠 Home
- [ ] 🔍 Search
- [] ➕ Create
- [ ] 📷 Profile
- [x] Map view
- [ ] ⁉️ Other
    - [x] Refactoring
