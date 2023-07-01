# Image Gallery App

** Overview **

The repository contains an implementation of the test task "Image Gallery App"
There is no git strategy for the reason that the repository doesn't mean any production use.
The implementation represents the iOS application, supports iOS from 13.0, and contains 2 screens.

*The "Recent Uploads" screen*
![Simulator Screen Shot - iPhone 14 - 2023-07-01 at 17 09 20](https://github.com/alexzhauniarovich/ImageGalleryApp/assets/77155155/701970bb-59b2-4db9-bdb7-332f5b0b7293)

The screen displays the images grid of downloaded image thumbnails data from https://unsplash.com API, which supports paginated loading of data while the user scrolls the grid, there are 30 items received by each request.
During the first portion of the image request from the API, the user sees the loading indicator at the centre of the screen. When the first portion of images is already on the screen,
the loading indicator appears as always the last item of the grid, this loading indicator will be removed from the screen in the case when there are no more items responded.
Each image on the screen contains a favourite icon, in the case when the image was marked as a favourite before. By tapping on the image, the app redirects the user to the next screen.

*The "Image Gallery" screen*
![Simulator Screen Shot - iPhone 14 - 2023-07-01 at 17 08 41](https://github.com/alexzhauniarovich/ImageGalleryApp/assets/77155155/69407514-bd9f-46b6-8b1b-409a648ce5aa)
![Simulator Screen Shot - iPhone 14 - 2023-07-01 at 17 09 05](https://github.com/alexzhauniarovich/ImageGalleryApp/assets/77155155/19fbafe2-c6e8-4604-ace8-af589eaa32a8)


The screen displays the image in better quality on full-screen view with the description and location of the particular image, if they are available. The screen supports the user swipe gesture to slide between the image set which was loaded on the previous screen in the navigation stack and also there is supporting the pitch-to-zoom gesture on board. The user has the ability to like or remove a like for a particular photo.


** Implementation **
