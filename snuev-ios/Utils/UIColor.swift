//
//  UIColorExtension.swift
//  snuev-ios
//
//  Created by 이동현 on 14/01/2019.
//  Copyright © 2019 이동현. All rights reserved.
//

import UIKit

extension UIColor {
    convenience init(hex hexInt: Int, _ alpha: CGFloat = 1.0) {
        self.init(red: CGFloat((Float((hexInt & 0xff0000) >> 16)) / 255.0), green: CGFloat((Float((hexInt & 0xff00) >> 8)) / 255.0), blue: CGFloat((Float(hexInt & 0xff)) / 255.0), alpha: alpha)
        //a
    }
}
