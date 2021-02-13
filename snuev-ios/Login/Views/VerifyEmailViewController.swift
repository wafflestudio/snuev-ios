
//
//  VerifyEmailViewController.swift
//  snuev-ios
//
//  Created by 김동욱 on 10/04/2019.
//  Copyright © 2019 이동현. All rights reserved.
//

import SafariServices

import UIKit
import ObjectMapper
import RxCocoa
import RxSwift
import Moya
import ReactorKit

class VerifyEmailViewController: SNUEVBaseViewController, StoryboardView {
    @IBOutlet weak var myEmailLabel: UILabel!
    @IBOutlet weak var btnBack: UIButton!
    @IBOutlet weak var btnMySnu: UIButton!
    
    var username: String?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        myEmailLabel.text = "\(username!)@snu.ac.kr"
        btnMySnu.setTitleColor(Constants.COLOR_BLUE_WITH_A_HINT_OF_PURPLE, for: .normal)
    }
    
    func bind(reactor: VerifyEmailViewReactor) {
        btnBack.rx.tap.bind {
            self.navigationController?.popViewController(animated: true)
            }.disposed(by: disposeBag)
        
        btnMySnu.rx.tap.bind {
            guard let url = URL(string: "https://my.snu.ac.kr") else { return }
            let viewController = SFSafariViewController(url: url)
            self.navigationController?.present(viewController, animated: true, completion: nil)
            self.navigationController?.popViewController(animated: false)
            }.disposed(by: disposeBag)
    }
}
