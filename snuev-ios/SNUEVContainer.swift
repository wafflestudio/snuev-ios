//
//  SNUEVContainer.swift
//  snuev-ios
//
//  Created by 이동현 on 2019. 4. 20..
//  Copyright © 2019년 이동현. All rights reserved.
//
import Swinject
import SwinjectAutoregistration

class SNUEVContainer {
    static var shared: Container = {
        let container = Container()
        let mainStoryboard = UIStoryboard(name: "Main", bundle: nil)
        let loginStoryboard = UIStoryboard(name: "Login", bundle: nil)
        // Service
        container.autoregister(Service.self, initializer: DefaultService.init)
        
        // UseCase
        container.autoregister(LoginUseCase.self, initializer: DefaultLoginUseCase.init)
        container.autoregister(DepartmentUseCase.self, initializer: DefaultDepartmentUseCase.init)
        
        
        // Reactor
        container.autoregister(LoginViewReactor.self, initializer: LoginViewReactor.init)
        container.autoregister(SignupViewReactor.self, initializer: SignupViewReactor.init)
        container.autoregister(SearchDepartmentViewReactor.self, initializer: SearchDepartmentViewReactor.init)
        
        // View
        container.register(LoginViewController.self) { r in
            let vc = loginStoryboard.instantiateViewController(withIdentifier: "LoginViewController") as! LoginViewController
            vc.reactor = r.resolve(LoginViewReactor.self)
            return vc
        }
        container.register(SignupViewController.self) { r in
            let vc = loginStoryboard.instantiateViewController(withIdentifier: "SignupViewController") as! SignupViewController
            vc.reactor = r.resolve(SignupViewReactor.self)
            return vc
        }
        container.register(SearchDepartmentViewController.self) { (r, departments: [Department]) in
            let vc = loginStoryboard.instantiateViewController(withIdentifier: "SearchDepartmentViewController") as! SearchDepartmentViewController
            vc.reactor = r.resolve(SearchDepartmentViewReactor.self)
            return vc
        }
        
        return container
    }()
}

