//
//  UIViewExtension.swift
//  snuev-ios
//
//  Created by 이동현 on 14/01/2019.
//  Copyright © 2019 이동현. All rights reserved.
//
import Foundation
import UIKit

extension CALayer {
    func applySketchShadow(
        color: UIColor = .black,
        alpha: Float = 0.5,
        x: CGFloat = 0,
        y: CGFloat = 2,
        blur: CGFloat = 4,
        spread: CGFloat = 0) {
        shadowColor = color.cgColor
        shadowOpacity = alpha
        shadowOffset = CGSize(width: x, height: y)
        shadowRadius = blur / 2.0
        if spread == 0 {
            shadowPath = nil
        } else {
            let dx = -spread
            let rect = bounds.insetBy(dx: dx, dy: dx)
            shadowPath = UIBezierPath(rect: rect).cgPath
        }
    }
}

extension UIView {
    func addShadow(offset: CGPoint, color: UIColor, opacity: Float, blur: CGFloat = 20, spread: CGFloat = 0) {
        DispatchQueue.main.async {
            self.layer.applySketchShadow(color: color, alpha: opacity, x: offset.x, y: offset.y, blur: blur, spread: spread)
        }
    }
}
