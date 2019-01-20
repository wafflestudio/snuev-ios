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

class SignupViewController: UIViewController, StoryboardView {
    var disposeBag = DisposeBag()
    typealias Reactor = SignupViewReactor
    @IBOutlet weak var inputDepartment: UITextField!
    @IBOutlet weak var inputNickname: UITextField!
    @IBOutlet weak var inputPassword: UITextField!
    @IBOutlet weak var btnSignup: SNUEVButton!
    @IBOutlet weak var btnLogin: SNUEVButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        reactor = SignupViewReactor()
        btnSignup.setButtonType(.Square)
        btnLogin.setButtonType(.Square)
    }
    
    func bind(reactor: SignupViewReactor) {
        // Action
        buttonLogin.rx.tap
            .map { Reactor.Action.loginRequest(username: self.inputUsername.text, password: self.inputPassword.text) }
            .bind(to: reactor.action)
            .disposed(by: disposeBag)
        
        // State
        
        reactor.state.map { $0.loginSuccess }
            .subscribe(onNext: { success in
                if success {
                    print("fetch departments success!!!")
                }
            }).disposed(by: disposeBag)
        
        reactor.state.map { $0.errorMessage }
            .distinctUntilChanged()
            .subscribe(onNext: { error in
                if !error.isEmpty {
                    print(error)
                }
            }).disposed(by: disposeBag)
    }
}

