//
//  AddSpendCategoryVC.swift
//  MoneyTrack
//
//  Created by Диана Смахтина on 23.02.22.
//

import UIKit
import CoreData

class AddSpendCategoryVC: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource, UITextFieldDelegate, NSFetchedResultsControllerDelegate {
    
    @IBOutlet weak var spendPicker: UIPickerView!
    @IBOutlet private weak var nametf: UITextField!
    var stillTyping = false
    var spendType = ["Products", "Transport", "Entertainment", "Car", "Sport", "Beauty", "Present", "House"]
    
    private var fetchedResulController: NSFetchedResultsController<SpendCategory>!
    var currentSpendCategories = [SpendCategory]()
    
    @IBAction func saveDidTap() {
        guard let name = nametf.text,
              let icon = nametf.text else { return }
        if isExist(name: name) {
            creatingAlert(name: name)
        } else {
            let newSpendCategory = SpendCategory(context: MoneyTrackService.managedObjectContext)
            newSpendCategory.name = name
            newSpendCategory.amount = 0.0
            newSpendCategory.icon = icon
            
            MoneyTrackService.saveContext()
            self.dismiss(animated: true, completion: nil)
        }
    }
    
    private func isExist(name: String) -> Bool {
        var isAlreadyExist = false
        currentSpendCategories.forEach {
            if $0.name == name {
                isAlreadyExist = true
            }
        }
        return isAlreadyExist
    }
    
    private func creatingAlert(name: String) {
        let alert = UIAlertController(title: "Error", message: "You already have \(name)", preferredStyle: .alert)
        let cancel = UIAlertAction(title: "Ok", style: .default)
        alert.addAction(cancel)
        present(alert, animated: true)
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        spendPicker.delegate = self
        spendPicker.dataSource = self
        
        setupFetchedResultController()
        loadSpendings()
        fetchedResulController.delegate = self
        
        setup()
    }
    
    
    private func setupFetchedResultController() {
        let request = SpendCategory.fetchRequest()
        let sortDescriptor = NSSortDescriptor(key: "name", ascending: true)
        request.sortDescriptors = [sortDescriptor]
        fetchedResulController = NSFetchedResultsController<SpendCategory>(fetchRequest: request, managedObjectContext: MoneyTrackService.managedObjectContext, sectionNameKeyPath: nil, cacheName: nil)
    }
    
    private func loadSpendings() {
        try? fetchedResulController.performFetch()
        if let results = fetchedResulController.fetchedObjects {
            currentSpendCategories = results
        }
    }
    
    private func setup() {
        nametf.text = spendType.first
    }
    
    public func numberOfComponents(in pickerView: UIPickerView) -> Int{
        return 1
    }

    public func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int{
        return spendType.count
    }

    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        view.endEditing(true)
        return spendType[row]
      
    }

    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        nametf.text = spendType[row]
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        if textField == self.nametf {
            spendPicker.isHidden = false
            textField.endEditing(true)
        }
    }
}
