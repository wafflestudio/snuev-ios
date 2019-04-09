# SNUEV-IOS

![logo](snuev-ios/images/img-logo-220-px.png)

This codebase is SNUEV client, a course evaluation system for SNU students.

## Features
- Using ReactorKit
- Clean Architecture and DI with Provider Pattern

## Architecture
- Uni-directional hierarchy
- ViewController -> Reactor -> UseCases

### Application.swift
- Configures main interface
- Make navigators and set `rootViewController`

### Navigators
- Contains viewController navigating functions
```swift
protocol LoginNavigator {
    func toLogin()
    func toSignup()
    ...
}
```
### UseCaseProvider
- Make UseCase classes that contains usecase functions
```swift
protocol UseCaseProvider {
    func makeLoginUseCase() -> LoginUseCase
    ...
}
```
- UseCase classes has network and cache providers
- UseCase functions deal with usecases by network or cached resources

### NetworkProviders
- Provide network classes that contain networking functions
```swift
protocol NetworkProvider {
    func makeLoginNetwork() -> LoginNetwork
    ...
}
```
- Network classes have networking functions that returns Observable (or Driver) of response
```swift
protocol LoginNetwork {
    ...
    func fetchDepartments() -> Driver<[Department]?>
    ...
}
```
### Cache Provider
- To be updated

### View and Reactor
- Each viewControllers implements StoryboardView from reactorKit and has reactor
- View gets resources from reactor and handles logics about controlling view
- Reactor (kind of ViewModel) handles useCases by useCase object
- Reactor shouldn't know about views (view knows reactor) so do not reference view on reactor

### Others
- To be updated








