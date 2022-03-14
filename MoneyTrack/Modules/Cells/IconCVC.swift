//
//  IconCVC.swift
//  MoneyTrack
//
//  Created by Диана Смахтина on 21.02.22.
//

import UIKit

class IconCVC: UICollectionViewCell {
    
    @IBOutlet private weak var iconImage: UIImageView!
    @IBOutlet private weak var nameLabel: UILabel!
    @IBOutlet private weak var moneySpendLabel: UILabel!
    
    func setup(icon: Wallet) {
        guard let safeIconImage = icon.icon else { return }
        
        iconImage.image = UIImage(named: safeIconImage)
        nameLabel.text = icon.name
        moneySpendLabel.text = String(icon.amount) + " Br"
        
        moneySpendLabel.textColor = UIColor(named: "TextColor")
    }
}
