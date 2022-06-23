# MovieApp
Movie app built with SwiftUI

# Features
- Onboarding
- Search movies (with regions filter)
- Localization
- Sign In
- Save movies into favourite list
- Remove movies from favourite list
- Widget

## Demo

### Widget
 <p float="left">
     <img src="https://user-images.githubusercontent.com/36991424/175325634-efa3981d-ae75-4302-8fe7-ff2feeb59a83.gif" width="200" />
     <img src="https://user-images.githubusercontent.com/36991424/172134362-0b15e38f-da4f-4f55-a551-72a480bed6f0.gif" width="200" />
     <img src="https://user-images.githubusercontent.com/36991424/172131959-acb9b4ab-78d9-4b02-8a6b-1ccb9bf9c38f.png" width="200" />
     <img src="https://user-images.githubusercontent.com/36991424/172132000-6a47c40e-f00a-4e6b-b99a-22b5c167734a.png" width="200" />
     <img src="https://user-images.githubusercontent.com/36991424/172132008-e9f6af36-fc8c-4033-b5c2-13780e0aff3c.png" width="200" />
</p>

### App
 <p float="left">
 <img src="https://user-images.githubusercontent.com/36991424/170828822-4bb06ae6-da84-4895-bc35-b9a385bff828.gif" width="300" />
 <img src="https://user-images.githubusercontent.com/36991424/171419202-ea1dadc5-f8e2-4f1f-b452-ab51cbc8c888.gif" width="300" />
</p>

<video src="https://user-images.githubusercontent.com/36991424/172018145-afa1d94b-3284-44d2-a899-579abb28b382.mp4" width="300" alt="SearchFiltering"></video>


## Tech details
- MVVM pattern
- Unit Testing
- UI Testing
- UrlSession for API integration

## Setup guide (if you are interested)
- Create a swift file (eg: APIKeys.swift) in the ``Models/`` directory, and add the following code:
- Create and start your own backend server (for testing Stripe payment feature) [Backend source code](https://github.com/Vong3432/movieapp-backend). 

```swift

import Foundation

struct Keys {
    static let apiToken = "API_TOKEN_FROM_MOVIEDB_API"
    static let username = "USERNAME_FROM_MOVIEDB_API"
    static let pw = "PASSWORD_FROM_MOVIEDB_API"
    static var stripePublishToken: String {
        #if DEBUG
        "STRIPE_PUBLISH_KEY_FOR_TESTING"
        #else
        "STRIPE_PUBLISH_KEY_FOR_PRODUCTION"
        #endif
    }
}

```
