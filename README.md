# SNUEV-IOS

![logo](snuev-ios/images/img-logo-220-px.png)

This codebase is SNUEV client, a course evaluation system for SNU students.

## Features
- Using ReactorKit
- Using Swinject
- Clean Architecture and DI

## Architecture
- Uni-directional hierarchy
- `ViewController` -> `Reactor` -> `UseCase`

### SNUEVContainer
- Container for DI
- Resolves actual implementation of protocols
- Resolves viewController from its type
```swift
// Service
container.register(Service.self) { _ in DefaultService() }
...
        
// UseCase
container.register(LoginUseCase.self) { r in
    return DefaultLoginUseCase(service: r.resolve(Service.self)!)
}
...
        
// View
container.register(LoginViewController.self) { r in
    let vc = loginStoryboard.instantiateViewController(withIdentifier: "LoginViewController") as! LoginViewController
    vc.reactor = LoginViewReactor(loginUseCase: r.resolve(LoginUseCase.self)!)
    return vc
}
...

```
### Resource
- Each services returns `Observable` of `Resource`
- Must handle status: `.Loading`, `.Success` or `.Failure`
```swift
return loginUseCase.login(username: username, password: password)
                    .map { resource in
                        switch resource.status {
                        case .Loading:
                            return .setIsLoading
                        case .Success:
                            return .setLoginSuccess
                        default:
                            return .setErrorMessage("로그인에 실패했습니다.")
                        }
                    }
```

### UseCase
- Provides useCases for entities
- Handles networking and caching 
```swift
protocol DepartmentUseCase {
    func fetchDepartments() -> Observable<Resource<[Department]>>
    ...
}
```

### View and Reactor
- Each viewControllers implements StoryboardView from reactorKit and has reactor
- View gets resources from reactor and handles logic about controlling view
- Reactor handles useCases by useCase object

### Others
- To be updated








