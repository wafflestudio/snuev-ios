//
//  CommonButtons.swift
//  snuev-ios
//
//  Created by 이동현 on 14/01/2019.
//  Copyright © 2019 이동현. All rights reserved.
//

import UIKit

enum SNUEVButtonType: Int {
    case Round = 0
    case RoundBlue
    case RoundSmall
    case Square
    case SquareWhite
    case withRoundImage
}

class SNUEVButton: UIButton {
    private var type: SNUEVButtonType = .Round

    public func setButtonType(_ type: SNUEVButtonType) {
        self.type = type
        backgroundColor = getBackgroundColors(for: state)
        setTitleColor(getTextColor(), for: .normal)
        setBorder()
        if type == .withRoundImage {
            setImage(UIImage.circle(diameter: 10, color: Constants.COLOR_BLUE_WITH_A_HINT_OF_PURPLE), for: .normal)
            titleEdgeInsets = UIEdgeInsets(top: 0, left: 10, bottom: 0, right: 0)
        } else {
            dropShadow()
        }
    }
    
    public func getBackgroundColors(for state: UIControl.State) -> UIColor {
        switch state {
        case .highlighted:
            switch type {
            case .RoundBlue:
                return Constants.COLOR_BLUE_WITH_A_HINT_OF_PURPLE_TWO
            case .Square:
                return Constants.COLOR_BLUE_WITH_A_HINT_OF_PURPLE_TWO
            default:
                return Constants.COLOR_BLUE_WITH_A_HINT_OF_PURPLE_8
            }
        case .selected:
            switch type {
            case .RoundBlue:
                return Constants.COLOR_SAPPHIRE
            case .Square:
                return Constants.COLOR_SAPPHIRE
            default:
                return Constants.COLOR_BLUE_WITH_A_HINT_OF_PURPLE_24
            }
        default:
            switch type {
            case .RoundBlue:
                return Constants.COLOR_BLUE_WITH_A_HINT_OF_PURPLE
            case .Square:
                return Constants.COLOR_BLUE_WITH_A_HINT_OF_PURPLE
            default:
                return Constants.COLOR_WHITE
            }
        }
    }
    
    public func getTextColor() -> UIColor {
        switch type {
        case .RoundBlue:
            return Constants.COLOR_WHITE
        case .Square:
            return Constants.COLOR_WHITE
        default:
            return Constants.COLOR_BLUE_WITH_A_HINT_OF_PURPLE
        }
    }
    
    public func setBorder() {
        switch type {
        case .Square:
            break
        case .SquareWhite:
            layer.borderWidth = 1
            layer.borderColor = Constants.COLOR_BLUE_WITH_A_HINT_OF_PURPLE as! CGColor
        default:
            layer.cornerRadius = frame.width / 2
        }
    }
    
    @IBInspectable
    public var btnType: NSInteger = 0 {
        didSet {
            self.setButtonType(SNUEVButtonType(rawValue: btnType) ?? .Round)
        }
    }
    
    override open var isHighlighted: Bool {
        didSet {
            backgroundColor = getBackgroundColors(for: state)
        }
    }
    
    override open var isSelected: Bool {
        didSet {
            backgroundColor = getBackgroundColors(for: state)
        }
    }
    
    func createGradientImage(colors: [UIColor], size: CGSize, cornerRadius: CGFloat) -> UIImage {
        let rect = CGRect(origin: CGPoint(x: 0, y: 0), size: size)
        
        // Create a non-rounded image
        UIGraphicsBeginImageContextWithOptions(size, false, 0)
        let context = UIGraphicsGetCurrentContext()
        let colorSpace = CGColorSpaceCreateDeviceRGB()
        let colorLocations: [CGFloat] = [0.0, 1.0]
        let cgColors = colors.map { (color) -> CGColor in
            return color.cgColor
        }
        let gradient = CGGradient(colorsSpace: colorSpace,
                                  colors: cgColors as CFArray,
                                  locations: colorLocations)!
        
        let startPoint = CGPoint.zero
        let endPoint = CGPoint(x: size.width, y: size.height)
        context?.drawLinearGradient(gradient, start: startPoint, end: endPoint, options: [])
        let nonRoundedImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        // Clip it with a bezier path
        UIGraphicsBeginImageContextWithOptions(size, false, 0)
        UIBezierPath(
            roundedRect: rect,
            cornerRadius: cornerRadius
            ).addClip()
        nonRoundedImage?.draw(in: rect)
        
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        return image ?? UIImage()
    }
}

