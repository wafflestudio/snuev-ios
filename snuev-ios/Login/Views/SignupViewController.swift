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

    override func viewDidLoad() {
        super.viewDidLoad()
        reactor = SNUEVContainer.shared.resolve(Reactor.self)
        btnSignup.setButtonType(.Square)
        btnLogin.setButtonType(.withRoundImage)
    }
    
    func bind(reactor: SignupViewReactor) {
        // Action
        reactor.action.onNext(Reactor.Action.fetchDepartment)
        
        btnSignup.rx.tap
            .map { _ in Reactor.Action.signupRequest(username: self.inputUsername.text, nickname: self.inputNickname.text, password: self.inputPassword.text) }
            .bind(to: reactor.action)
            .disposed(by: disposeBag)
        

        // State
        reactor.state.map { $0.signupSuccess }
            .distinctUntilChanged()
            .filter { $0 }
            .subscribe(onNext: { [weak self] success in
                guard let self = self else {
                    return
                }
                self.showConfirm(message: "회원가입에 성공했습니다 :)").drive(onNext: {
                    self.navigationController?.popViewController(animated: true)
                })
                .disposed(by: self.disposeBag)
            }).disposed(by: disposeBag)
        
        reactor.state.map { $0.errorMessage }
            .filter { $0 != nil }
            .subscribe(onNext: { [weak self] error in
                if let error = error, !error.isEmpty {
                    self?.showToast(message: error)
                }
            }).disposed(by: disposeBag)
        
        reactor.state.map { $0.selectedDepartment?.name }
            .distinctUntilChanged()
            .asDriver(onErrorJustReturn: nil)
            .drive(onNext: { [weak self] department in
                self?.inputDepartment.text = department
            })
            .disposed(by: disposeBag)
        
        // View
        btnLogin.rx.tap.bind {
            self.navigationController?.popViewController(animated: true)
        }.disposed(by: disposeBag)
        
        searchDepartmentButton.rx.tap.bind { [weak self] in
            guard let `self` = self else {
                return
            }
            let departments = reactor.currentState.departments
            if let searchDepartmentVC = SNUEVContainer.shared.resolve(SearchDepartmentViewController.self, argument: departments) {
                searchDepartmentVC.selectedDepartment
                    .map{ Reactor.Action.setSelectedDepartment($0)}
                    .bind(to: reactor.action)
                    .disposed(by: self.disposeBag)
                self.navigationController?.pushViewController(searchDepartmentVC, animated: true)
            }
        }
        .disposed(by: disposeBag)
    }
}

