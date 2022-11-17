//
//  CalculateVC.swift
//  MoneyTrack
//
//  Created by Диана Смахтина on 21.02.22.
//

import UIKit
import CoreData

final class CalculateVC: UIViewController, UITextFieldDelegate, NSFetchedResultsControllerDelegate {
    
    // MARK: - Outlets
    @IBOutlet private weak var walletPicker: UIPickerView!
    @IBOutlet private weak var spendCategoryPicker: UIPickerView!
    @IBOutlet private weak var sum: UILabel!
    @IBOutlet private weak var tfDate: UITextField!
    private var stillTyping = false
    
    // MARK: - Properties
    private var fetchedResulController: NSFetchedResultsController<SpendCategory>!
    private var fetchedResulControllerW: NSFetchedResultsController<Wallet>!
    private var wallets = [Wallet]()
    private var spendCategories = [SpendCategory]()
    private var spendingCategory: SpendCategory?
    private var wallet: Wallet?
    
    // MARK: - Actions
    @IBAction func saveDidTap() {
        guard let moneyStr = sum.text,
              let money = Double(moneyStr) else { return }
        let newSpending = Spending(context: MoneyTrackService.managedObjectContext)
        
        newSpending.amount = money
        newSpending.date = tfDate.text
        
        newSpending.spendCategory = spendingCategory
        newSpending.wallet = wallet
        newSpending.wallet?.amount -= money

        MoneyTrackService.saveContext()
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func numberDidTap(_ sender: UIButton) {
        let number = sender.titleLabel?.text
        
        if stillTyping {
            if sum.text!.count < 12 {
                sum.text = sum.text! + number!
            }
        } else {
            sum.text = number!
            stillTyping = true
        }
    }
    
    @IBAction func resetButton(_ sender: UIButton) {
        sum.text = "0"
        stillTyping = false
    }
    @IBAction func closeButton(_ sender: UIButton) {
        dismiss(animated: true)
    }
    
    // MARK: - Override
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpPickers()
        setupFetchedResultControllerHistory()
        setupFetchedResultControllerHistoryW()
        loadSpendings()
        loadWalletsForIncomes()
        
        tfDate.delegate = self
        setUpTextField()
        setupDate()
        setUpSpend()
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
 
    // MARK: - Methods
    private func setUpPickers() {
        walletPicker.delegate = self
        walletPicker.dataSource = self
        
        spendCategoryPicker.delegate = self
        spendCategoryPicker.dataSource = self
    }
    
    private func setupFetchedResultControllerHistory() {
        let request = SpendCategory.fetchRequest()
        let sortDescriptor = NSSortDescriptor(key: "name", ascending: true)
        request.sortDescriptors = [sortDescriptor]
        fetchedResulController = NSFetchedResultsController<SpendCategory>(fetchRequest: request, managedObjectContext: MoneyTrackService.managedObjectContext, sectionNameKeyPath: nil, cacheName: nil)
    }
    
    private func setupFetchedResultControllerHistoryW() {
        let request = Wallet.fetchRequest()
        let sortDescriptor = NSSortDescriptor(key: "name", ascending: true)
        request.sortDescriptors = [sortDescriptor]
        fetchedResulControllerW = NSFetchedResultsController<Wallet>(fetchRequest: request, managedObjectContext: MoneyTrackService.managedObjectContext, sectionNameKeyPath: nil, cacheName: nil)
    }
    
    private func loadSpendings() {
        try? fetchedResulController.performFetch()
        if let results = fetchedResulController.fetchedObjects {
            spendCategories = results
        }
    }

    private func loadWalletsForIncomes() {
        try? fetchedResulControllerW.performFetch()
        if let results = fetchedResulControllerW.fetchedObjects {
            wallets = results
        }
    }
    
    private func setUpSpend() {
        self.wallet = wallets[0]
        self.spendingCategory = spendCategories[0]
    }
    
    private func setUpTextField() {
        let datePicker = UIDatePicker()
        datePicker.datePickerMode = .date
        
        if #available(iOS 13.4, *) {
            datePicker.preferredDatePickerStyle = .wheels
        }
        tfDate.inputView = datePicker
        datePicker.addTarget(self,
                             action: #selector(datePickerDidChange(sender:)),
                             for: .allEvents)
    }
    let dateFormatter = DateFormatter()
    
    @objc func datePickerDidChange(sender: UIDatePicker) {
        let selectedDate = sender.date
        dateFormatter.dateFormat = "d MMM yyyy"
        dateFormatter.locale = Locale(identifier: "En-en")
        
        tfDate.text = dateFormatter.string(from: selectedDate)
    }
    
    private func setupDate() {
        dateFormatter.dateFormat = "d MMM yyyy"
        dateFormatter.locale = Locale(identifier: "En-en")
        tfDate.text = dateFormatter.string(from: Date())
    }
}

extension CalculateVC: UIPickerViewDelegate, UIPickerViewDataSource {
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        if pickerView == walletPicker {
            return wallets.count
        } else {
            return spendCategories.count
        }
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        self.view.endEditing(true)
        
        if pickerView == walletPicker {
            return wallets[row].name
        } else {
            return spendCategories[row].name
        }
    }

    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        if pickerView == walletPicker {
            self.wallet = wallets[row]
        } else {
            self.spendingCategory = spendCategories[row]
        }
    }
}
