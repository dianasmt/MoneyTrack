//
//  AddWalletVC.swift
//  MoneyTrack
//
//  Created by Диана Смахтина on 23.02.22.
//

import UIKit
import CoreData

final class AddWalletVC: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource, UITextFieldDelegate {
    
    // MARK: - Outlets
    @IBOutlet private var walletPicker: UIPickerView!
    @IBOutlet private weak var nametf: UITextField!
    
    // MARK: - Properties
    private var walletType = ["Cash", "Card"]
    private var wallet: Wallet?
    
    // MARK: - Actions
    @IBAction func saveDidTap() {
        guard let name = nametf.text,
              let icon = nametf.text else { return }
        let newWallet = Wallet(context: MoneyTrackService.managedObjectContext)
        newWallet.name = name
        newWallet.icon = icon
        newWallet.amount = 0.0

        MoneyTrackService.saveContext()
        
        self.dismiss(animated: true, completion: nil)
    }

    // MARK: - Override
    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
        setUpPicker()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    // MARK: - Methods
    private func setup() {
        nametf.text = walletType.first
    }
    
    private func setUpPicker() {
        walletPicker.delegate = self
        walletPicker.dataSource = self
    }
    
    public func numberOfComponents(in pickerView: UIPickerView) -> Int{
        return 1
    }

    public func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int{
        return walletType.count
    }

    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        self.view.endEditing(true)
        return walletType[row]
    }

    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        self.wallet?.name = walletType[row]
        nametf.text = walletType[row]
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        if textField == self.nametf {
            walletPicker.isHidden = false
        }
    }
}
