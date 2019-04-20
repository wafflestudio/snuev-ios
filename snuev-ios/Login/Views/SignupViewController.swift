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

class SignupViewController: SNUEVBaseViewController, StoryboardView {
    typealias Reactor = SignupViewReactor
    @IBOutlet weak var inputUsername: UITextField!
    @IBOutlet weak var inputDepartment: UITextField!
    @IBOutlet weak var inputNickname: UITextField!
    @IBOutlet weak var inputPassword: UITextField!
    @IBOutlet weak var btnSignup: SNUEVButton!
    @IBOutlet weak var btnLogin: SNUEVButton!
    @IBOutlet weak var searchDepartmentButton: UIButton!
    var deparmtments: [Department]?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        btnSignup.setButtonType(.Square)
        btnLogin.setButtonType(.withRoundImage)
    }
    
    func bind(reactor: SignupViewReactor) {
        // Action
        reactor.action.onNext(Reactor.Action.fetchDepartment)
        
        btnSignup.rx.tap
            .map { Reactor.Action.signupRequest(username: self.inputUsername.text, department: self.inputDepartment.text, nickname: self.inputNickname.text, password: self.inputPassword.text) }
            .bind(to: reactor.action)
            .disposed(by: disposeBag)

        // State
        reactor.state.map { $0.signupSuccess }
            .distinctUntilChanged()
            .filter { $0 }
            .subscribe(onNext: { [weak self] success in
                self?.showToast(message: "회원가입에 성공했습니다!!")
            }).disposed(by: disposeBag)
        
        reactor.state.map { $0.errorMessage }
            .filter { $0 != nil }
            .subscribe(onNext: { [weak self] error in
                if let error = error, !error.isEmpty {
                    self?.showToast(message: error)
                }
            }).disposed(by: disposeBag)
        
        // View
        btnLogin.rx.tap.bind {
            self.navigationController?.popViewController(animated: true)
        }.disposed(by: disposeBag)
        
        searchDepartmentButton.rx.tap.bind {
//            reactor.toSearchDepartment(self.deparmtments)
        }
    }
}

