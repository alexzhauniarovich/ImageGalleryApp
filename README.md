# Image Gallery App

## Overview 

The repository contains an implementation of the test task "Image Gallery App"
There is no git strategy for the reason that the repository doesn't mean any production use.
The implementation represents the iOS application, supports iOS from 13.0, and contains 2 screens.


## The "Recent Uploads" screen

<a href="url"><img src="https://github.com/alexzhauniarovich/ImageGalleryApp/assets/77155155/5f372d6a-749f-49c2-8370-03f2eca665d0"  width="350" ></a>

The screen displays the images grid of downloaded image thumbnails data from https://unsplash.com API, which supports paginated loading of data while the user scrolls the grid, there are 30 items received by each request.
During the first portion of the image request from the API, the user sees the loading indicator at the centre of the screen. When the first portion of images is already on the screen,
the loading indicator appears as always the last item of the grid, this loading indicator will be removed from the screen in the case when there are no more items responded.
Each image on the screen contains a favourite icon, in the case when the image was marked as a favourite before. By tapping on the image, the app redirects the user to the next screen.


## The "Image Gallery" screen

<a href="url"><img src="https://github.com/alexzhauniarovich/ImageGalleryApp/assets/77155155/85832d10-0794-4fa3-9be3-0de62f79f151"  width="350" ></a>   <a href="url"><img src="https://github.com/alexzhauniarovich/ImageGalleryApp/assets/77155155/ace3c677-bfbe-43e1-9382-103735a2b63d"   width="350" ></a>

The screen displays the image in better quality on full-screen view with the description and location of the particular image, if they are available. The screen supports the user swipe gesture to slide between the image set which was loaded on the previous screen in the navigation stack and also there is supporting the pitch-to-zoom gesture on board. The user has the ability to like or remove a like for a particular photo.


## Achitecture

The code base was written with respect to a "Clean Architecture" guideline, to achieve layers separation the SwiftPackageManager was integrated.
The MVVM was implemented as an architecture approach, for communication between layers and data binding in View-ViewModel, the native framework Combine with reactive programming was used under the hood.
The application contains the next layers:

 - Domain: Representation of application Domain layer. The Domain layer is responsible for handling the particular use cases in the app. Contains business logic. The top-level layer has no dependencies.
   
 - Data: Representation of application Data layer. The data package is responsible for retrieving and storing the data. Handles network requests and persistence local storage. Depends on the Domain layer.
   
 - Presentation: Representation of application Presentation layer. The presentation layer is responsible for the preparation of the user interface and handling user events on it. Depends on the Domain layer.

## Implementation

  - Getting the ability to use networking was solved by using URLSession.
  - The persistence storage is implemented with CoreData.
  - The user interface is implemented on UIKit, without using storyboard and xib files.
  - Pods were not integrated with reasons of usage SPM.
  - Downloading images and caching them is achieved by using KingFisher third-party framework.
  - The dependency injection is implemented with a custom dependencies graph.
  - The tests are not available for a while, the codebase is written with meaning to cover it with the tests, and all required architecture preparation is implemented as well.
 
 
