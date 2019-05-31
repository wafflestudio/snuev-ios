//
//  SNUEVContainer.swift
//  snuev-ios
//
//  Created by 이동현 on 2019. 4. 20..
//  Copyright © 2019년 이동현. All rights reserved.
//
import Swinject

class SNUEVContainer {
    static var shared: Container = {
        let container = Container()
        let mainStoryboard = UIStoryboard(name: "Main", bundle: nil)
        let loginStoryboard = UIStoryboard(name: "Login", bundle: nil)
        // Service
        container.register(Service.self) { _ in DefaultService() }
        
        // UseCase
        container.register(LoginUseCase.self) { r in
            return DefaultLoginUseCase(service: r.resolve(Service.self)!)
        }
        container.register(DepartmentUseCase.self) { r in
            return DefaultDepartmentUseCase(service: r.resolve(Service.self)!)
        }
        
        // View
        container.register(LoginViewController.self) { r in
            let vc = loginStoryboard.instantiateViewController(withIdentifier: "LoginViewController") as! LoginViewController
            vc.reactor = LoginViewReactor(loginUseCase: r.resolve(LoginUseCase.self)!)
            return vc
        }
        container.register(SignupViewController.self) { r in
            let vc = loginStoryboard.instantiateViewController(withIdentifier: "SignupViewController") as! SignupViewController
            vc.reactor = SignupViewReactor(loginUseCase: r.resolve(LoginUseCase.self)!, departmentUseCase: r.resolve(DepartmentUseCase.self)!)
            return vc
        }
        container.register(SearchDepartmentViewController.self) { (r, departments: [Department]) in
            let vc = loginStoryboard.instantiateViewController(withIdentifier: "SearchDepartmentViewController") as! SearchDepartmentViewController
            vc.reactor = SearchDepartmentViewReactor(departments: departments)
            return vc
        }
        
        return container
    }()
}

