//
//  SNUEVBaseViewController.swift
//  snuev-ios
//
//  Created by 이동현 on 19/01/2019.
//  Copyright © 2019 이동현. All rights reserved.
//
import SafariServices

import UIKit
import ObjectMapper
import RxCocoa
import RxSwift
import Moya
import ReactorKit
import SnapKit

class SNUEVBaseViewController: UIViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    func showToast(message: String) {
        DispatchQueue.main.async {
            let toastView = UIView()
            let toastLabel = UILabel()
            
            // Set label
            toastLabel.numberOfLines = 0
            toastLabel.clipsToBounds = true
            toastLabel.textColor = Constants.COLOR_BLUE_WITH_A_HINT_OF_PURPLE
            toastLabel.text = message
            
            // Set view
            toastView.backgroundColor = .white
            toastView.alpha = 1.0
            toastView.addShadow(offset: .zero, color: .black, opacity: 0.2)
            
            toastView.addSubview(toastLabel)
            self.view.addSubview(toastView)
            
            toastView.snp.makeConstraints { make in
                make.left.equalTo(self.view).offset(50)
                make.right.equalTo(self.view).offset(-50)
                make.bottom.equalTo(self.view).offset(-100)
                make.height.greaterThanOrEqualTo(52)
            }
            toastLabel.snp.makeConstraints { make in
                make.left.equalTo(toastView).offset(15)
                make.right.equalTo(toastView).offset(-15)
                make.bottom.equalTo(toastView).offset(-10)
                make.top.equalTo(toastView).offset(10)
            }
            UIView.animate(withDuration: 1.0, delay: 1.5, options: .curveEaseOut, animations: {
                toastView.alpha = 0.0
            }, completion: {(isCompleted) in
                toastView.removeFromSuperview()
            })
        }
    }
}

