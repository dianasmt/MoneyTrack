//
//  Alertable.swift
//  MoneyTrack
//
//  Created by Диана Смахтина on 17.11.22.
//

import UIKit
protocol Alertable {}
extension Alertable where Self: UIViewController {
    func showAlert(title: String = "Error", message: String, preferredStyle: UIAlertController.Style = .alert, completion: (() -> Void)? = nil) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Ok", style: UIAlertAction.Style.default, handler: nil))
        self.present(alert, animated: true, completion: completion)
    }
    
    func showAlertBeforeDeleting(title: String, message: String, action: UIAlertAction) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Cancel", style: UIAlertAction.Style.default, handler: nil))
        alert.addAction(action)
        self.present(alert, animated: true)
    }
}
