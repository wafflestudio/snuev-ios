//
//  SignupViewController.swift
//  snuev-ios
//
//  Created by 김동욱 on 20/01/2019.
//  Copyright © 2019 이동현. All rights reserved.
//

import SafariServices

import UIKit
import ObjectMapper
import RxCocoa
import RxSwift
import Moya
import ReactorKit
import DropDown

class SignupViewController: SNUEVBaseViewController, StoryboardView {
    typealias Reactor = SignupViewReactor
    @IBOutlet weak var inputUsername: UITextField!
    @IBOutlet weak var inputDepartment: UITextField!
    @IBOutlet weak var inputNickname: UITextField!
    @IBOutlet weak var inputPassword: UITextField!
    @IBOutlet weak var btnSignup: SNUEVButton!
    @IBOutlet weak var btnLogin: SNUEVButton!
    let dropDown = DropDown()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        btnSignup.setButtonType(.Square)
        btnLogin.setButtonType(.withRoundImage)
        Reactor.Action.fetchDepartments
        
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        dropDown.anchorView = inputDepartment // UIView or UIBarButtonItem
        dropDown.dataSource = ["Car", "Motorcycle", "Truck"]
        dropDown.bottomOffset = CGPoint(x: 0, y:(dropDown.anchorView?.plainView.bounds.height)!)
        dropDown.dismissMode = .onTap
    }
    
    func bind(reactor: SignupViewReactor) {
        // Action
        btnSignup.rx.tap
            .map { Reactor.Action.signupRequest(username: self.inputUsername.text, department: self.inputDepartment.text, nickname: self.inputNickname.text, password: self.inputPassword.text) }
            .bind(to: reactor.action)
            .disposed(by: disposeBag)
//
//        btnSignup.rx.tap
//            .map { Reactor.Action.fetchDepartments }
//            .bind(to: reactor.action)
//            .disposed(by: disposeBag)
//
        inputDepartment.rx.text
            .asObservable()
            .subscribe({_ in
                self.dropDown.show()
            }).disposed(by: disposeBag)
        
        inputDepartment.rx.text
            .subscribe({_ in
                self.dropDown.show()
            }).disposed(by: disposeBag)
        // State
//        reactor.state.map { $0.departments }
//            .bind(to: UITableView.rx.items(cellIdentifier: "cell")) { indexPath, repo, cell in
//                cell.textLabel?.text = repo
//            }
//            .disposed(by: disposeBag)
        reactor.state.map { $0.signupSuccess }
            .distinctUntilChanged()
            .filter { $0 }
            .subscribe(onNext: { [weak self] success in
                self?.showToast(message: "Signup success!!!")
            }).disposed(by: disposeBag)
        
        reactor.state.map { $0.errorMessage }
            .filter { $0 != nil }
            .subscribe(onNext: { [weak self] error in
                if let error = error, !error.isEmpty {
                    self?.showToast(message: error)
                }
            }).disposed(by: disposeBag)
        
        reactor.state.map { $0.selectedDepartments }
            .bind(to: tableView.rx.items(cellIdentifier: "cell")) { indexPath, repo, cell in
                cell.textLabel?.text = repo
            }
            .disposed(by: disposeBag)
        // View
        btnLogin.rx.tap
            .subscribe(onNext: {
                let loginViewController = UIStoryboard(name: "Login", bundle: nil).instantiateViewController(withIdentifier: "LoginViewController") as! LoginViewController
                loginViewController.reactor = LoginViewReactor(provider: MoyaProvider<Login>(plugins: [NetworkLoggerPlugin(verbose: true)]), authManager: AuthManager())
                self.present(loginViewController, animated: true, completion: nil)
            })
    }
}

