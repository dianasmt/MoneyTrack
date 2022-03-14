//
//  SpendIconCVC.swift
//  MoneyTrack
//
//  Created by Диана Смахтина on 23.02.22.
//

import UIKit

class SpendIconCVC: UICollectionViewCell {
    @IBOutlet private weak var iconImage: UIImageView!
    @IBOutlet private weak var nameLabel: UILabel!
    @IBOutlet private weak var moneySpendLabel: UILabel!
    
    func setUpSum(itemSpendCategory: SpendCategory, nameCategory: String) -> Double {
        var sum = 0.0
        (itemSpendCategory.spending as? Set<Spending>)?.forEach({ spending in
            if spending.spendCategory?.name == nameCategory {
                sum += spending.amount
            }
        })
        return sum
    }

    func setup(item: SpendCategory) {
        guard let safeIconImage = item.icon,
              let safeIconName = item.name else { return }
        
        iconImage.image = UIImage(named: safeIconImage)
        nameLabel.text = item.name
        moneySpendLabel.text = String(setUpSum(itemSpendCategory: item, nameCategory: safeIconName)) + " Br"
        
        moneySpendLabel.textColor = UIColor(named: "TextColor")
    }
}
