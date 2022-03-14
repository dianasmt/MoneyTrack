//
//  HistoryViewCell.swift
//  MoneyTrack
//
//  Created by Диана Смахтина on 22.02.22.
//

import UIKit

class HistoryViewCell: UITableViewCell {
    
    @IBOutlet weak var icon: UIImageView!
    @IBOutlet weak var title: UILabel!
    @IBOutlet weak var expense: UILabel!
    @IBOutlet weak var payment: UILabel!
    @IBOutlet weak var date: UILabel!
    
    func setup(spending: Spending) {
        
        guard let safeNameImage = spending.spendCategory?.icon else { return }
        
        title.text = spending.spendCategory?.name
        expense.text = "- \(String(spending.amount)) Br"
        payment.text = spending.wallet?.name
        date.text = spending.date
        icon.image = UIImage(named: safeNameImage)

        title.textColor = UIColor(named: "TextColor")
        backgroundColor = UIColor(named: "BackgroundColor")
    }
    
}
