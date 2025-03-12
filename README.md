# Github Users

## Features
- The administrator can look through fetched users’ information. 
- The administrator can scroll down to see more users’ information with 20
items per fetch
- Users’ information must be shown immediately when the administrator
launches the application for the second time. 
- Clicking on an item will navigate to the page of user details.

## Architecture and structure

Apply MVVM clean architecture includes:
- Domain Layer (Business logic and core models)
- Data Layer (Networking Service, Data model with SwiftData)
- Presentation Layer (View, ViewModel)
- Common (contain common using in app - the image view with cache)

## Technical stuff in app

- SwiftUI, SwiftData for Persistence, XCTest for unit test, handle loading image queue and cache image,
Networking apply singleton pattern using URLSession
- Using Dependency Injection with Protocols for testability

