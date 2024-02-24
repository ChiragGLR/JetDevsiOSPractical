//
//  ViewExtension.swift
//  JetDevsHomeWork
//
//  Created by Chirag on 23/2/2024.
//

import Foundation
import UIKit

extension UIView {
    //set Borderin View
    @IBInspectable var cornerRadius: CGFloat {
        get {
            layer.masksToBounds = true
            return layer.cornerRadius
        }
        set {
            layer.cornerRadius = newValue
        }
    }
    
    
    @IBInspectable
    var borderWidth : CGFloat {
        get {
            return layer.borderWidth
        }
        set {
            layer.borderWidth = newValue
        }
    }
    
    @IBInspectable
    var borderColor: UIColor? {
        get {
            if let color = layer.borderColor {
                return UIColor(cgColor: color)
            }
            return nil
        }
        set {
            if let color = newValue {
                layer.borderColor = color.cgColor
            } else {
                layer.borderColor = nil
            }
        }
    }
    
}
