//
//  navigator.swift
//  snuev-ios
//
//  Created by 이동현 on 01/03/2019.
//  Copyright © 2019 이동현. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

protocol LoginNavigator {
    func toLogin()
    func toSignup()
    func toMain()
    func toSearchDepartment(_: [Department]?)
    func popToSignup(department: Department)
    func toVerifyEmail(username: String)
}

class DefaultLoginNavigator: LoginNavigator {
    private let storyboard: UIStoryboard
    private let navigationController: UINavigationController
    private let useCaseProvider: UseCaseProvider
    
    private let selectedDepartmentSubject = PublishSubject<Department>()
    var selectedDepartment: Observable<Department> {
        return selectedDepartmentSubject.asObservable()
    }
    
    var mainNavigator: MainNavigator?
    var disposeBag = DisposeBag()
    
    init(navigationController: UINavigationController, storyboard: UIStoryboard, useCaseProvider: UseCaseProvider) {
        self.navigationController = navigationController
        self.storyboard = storyboard
        self.useCaseProvider = useCaseProvider
    }
    
    func toLogin() {
        let vc = storyboard.instantiateViewController(withIdentifier: "LoginViewController") as! LoginViewController
        vc.reactor = LoginViewReactor(useCase: useCaseProvider.makeLoginUseCase(), navigator: self)
        navigationController.pushViewController(vc, animated: true)
    }
    
    func toSignup() {
        let vc = storyboard.instantiateViewController(withIdentifier: "SignupViewController") as! SignupViewController
        selectedDepartment.subscribe(onNext: {[weak self] dp in
            vc.selectedDepartment = dp
            vc.inputDepartment.text = dp.name
            }, onDisposed: {
                print("complete select department")
        })
            .disposed(by: disposeBag)
        vc.reactor = SignupViewReactor(useCase: useCaseProvider.makeLoginUseCase(), authManager: AuthManager(), navigator: self)
        navigationController.pushViewController(vc, animated: true)
    }
    
    func toMain() {
        mainNavigator?.toMain()
    }
    
    func toSearchDepartment(_ departments: [Department]?) {
        let vc = storyboard.instantiateViewController(withIdentifier: "SearchDepartmentViewController") as! SearchDepartmentViewController
        vc.reactor = SearchDepartmentViewReactor(useCase: useCaseProvider.makeLoginUseCase(), authManager: AuthManager(), navigator: self, departments: departments)
        navigationController.pushViewController(vc, animated: true)
    }
    
    func popToSignup(department: Department) {
        selectedDepartmentSubject.onNext(department)
        navigationController.popViewController(animated: true)
    }
    
    func toVerifyEmail(username: String) {
        let vc = storyboard.instantiateViewController(withIdentifier: "VerifyEmailViewController") as! VerifyEmailViewController
        vc.reactor = VerifyEmailViewReactor(useCase: useCaseProvider.makeLoginUseCase(), navigator: self)
        vc.username = username
        navigationController.pushViewController(vc, animated: true)
    }
}
