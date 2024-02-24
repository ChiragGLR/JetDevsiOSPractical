//
//  AlertManager.swift
//  JetDevsHomeWork
//
//  Created by Chirag on 23/2/2024.
//

import Foundation
import UIKit

class AlertManager {
    static let shared = AlertManager()
    
    func showAlert(title: String?, message: String?, from viewController: UIViewController) {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let okAction = UIAlertAction(title: "OK", style: .default, handler: nil)
        alertController.addAction(okAction)
        viewController.present(alertController, animated: true, completion: nil)
    }
}
