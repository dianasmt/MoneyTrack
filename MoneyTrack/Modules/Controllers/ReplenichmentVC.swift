//
//  ReplenichmentVC.swift
//  MoneyTrack
//
//  Created by Диана Смахтина on 1.03.22.
//

import UIKit
import CoreData

final class ReplenichmentVC: UIViewController, UITextFieldDelegate, NSFetchedResultsControllerDelegate {
    
    // MARK: - Outlets
    @IBOutlet private weak var sum: UILabel!
    @IBOutlet private weak var walletPicker: UIPickerView!
    
    // MARK: - Properties
    private var stillTyping = false
    private var walletName: String? = ""
    private var wallets: [Wallet] = []
    private var fetchedResulController: NSFetchedResultsController<Wallet>!
    private var wallet: Wallet?
    
    // MARK: - Actions
    @IBAction func saveDidTap() {
        guard let moneyStr = sum.text,
              let money = Double(moneyStr) else { return }
        
        wallets.forEach {
            if $0.name == walletName {
                $0.amount += Double(sum.text!)!
            }
        }
        let newReplenichment = Replenichment(context: MoneyTrackService.managedObjectContext)
        newReplenichment.amount = money
        newReplenichment.wallet = wallet
        
        MoneyTrackService.saveContext()
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func numberDidTap(_ sender: UIButton) {
        guard let number = sender.titleLabel?.text, let safeSum = sum.text else { return }
        
        if stillTyping {
            if safeSum.count < 12 {
                sum.text = sum.text! + number
            }
        } else {
            sum.text = number
            stillTyping = true
        }
    }
    
    @IBAction func resetButton(_ sender: UIButton) {
        sum.text = "0"
        stillTyping = false
    }
    
    @IBAction func closeButton() {
        dismiss(animated: true)
    }
    
    // MARK: - Override
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpPicker()
        setupFetchedResultController()
        load()
        
        fetchedResulController.delegate = self
        setUpWallet()
    }
    
    // MARK: - Methods
    private func setUpPicker() {
        walletPicker.delegate = self
        walletPicker.dataSource = self
    }
    
    private func setupFetchedResultController() {
        let request = Wallet.fetchRequest()
        let sortDescriptor = NSSortDescriptor(key: "amount", ascending: true)
        request.sortDescriptors = [sortDescriptor]
        fetchedResulController = NSFetchedResultsController<Wallet>(fetchRequest: request, managedObjectContext: MoneyTrackService.managedObjectContext, sectionNameKeyPath: nil, cacheName: nil)
    }
    
    private func load() {
        try? fetchedResulController.performFetch()
        if let results = fetchedResulController.fetchedObjects {
            wallets = results
        }
    }
    
    private func setUpWallet() {
        self.wallet = wallets[0]
        self.walletName = wallets[0].name
    }
}

extension ReplenichmentVC: UIPickerViewDelegate, UIPickerViewDataSource {
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return wallets.count
        
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        self.view.endEditing(true)
        return wallets[row].name
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        self.wallet = wallets[row]
        self.walletName = wallets[row].name
    }
}
