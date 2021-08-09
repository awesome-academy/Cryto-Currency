//
//  AlertController.swift
//  Crypto-Currency
//
//  Created by namtrinh on 10/08/2021.
//

import Foundation
import UIKit

class AlertController: UIAlertController {
    
    static func showAlert(title: String?, message: String?, actions: [UIAlertAction]) -> AlertController {
        let alert = AlertController(title: title, message: message, preferredStyle: .alert)
        actions.forEach { alert.addAction($0) }
        return alert
    }
    
    static func showAlertSingleButton(title: String?,
                                      message: String?,
                                      buttonTitle: String = "OK",
                                      completion: (() -> Void)? = nil) -> AlertController {
        let action = UIAlertAction(title: buttonTitle, style: .default) { (_) in
            DispatchQueue.main.async(execute: {
                completion?()
            })
        }
        return showAlert(title: title, message: message, actions: [action])
    }
    
    static func showAlertConfirm(title: String?,
                                 message: String?,
                                 buttonOK: String = "OK",
                                 buttonCancel: String = "Cancel",
                                 completion: (() -> Void)? = nil) -> AlertController {
        let action = UIAlertAction(title: buttonOK, style: .cancel) { (_) in
            DispatchQueue.main.async(execute: {
                completion?()
            })
        }
        
        let actionCancel = UIAlertAction(title: buttonCancel, style: .default, handler: nil)
        return showAlert(title: title, message: message, actions: [action, actionCancel])
    }
}

