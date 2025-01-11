# TravelDiaryApp
This app allows users to create and manage their own travel diaries. Users can document their trips, add detailed entries, and include images, locations, and texts.
The app supports offline functionality, allowing entries to be created and saved locally, and it is also possible to publish the entries to a public backend.

### Features:
- **Create Trips**: Users can create trips and associate entries with them. Trips cannot be edited, only deleted, by swiping.
- **Manage Entries**: Each entry can include a title, text, images, an optional location, and a automatically generated timestamp. Entries can be added, edited, or deleted at any time.
- **Image Support**: Users can add images to entries by selecting them from their phone gallery.
- **Offline Mode**: Entries can be created without an internet connection and they are saved locally by using SwiftData.
- **Publish Entries**: Once ready, entries can be published to a backend, where they are stored permanently. Published entries cannot be edited or deleted.
- **View Backend-Entries**: Users can also view all the Entries which were published to the backend.
