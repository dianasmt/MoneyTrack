//
//  AddSpendCategoryVC.swift
//  MoneyTrack
//
//  Created by Диана Смахтина on 23.02.22.
//

import UIKit
import CoreData

final class AddSpendCategoryVC: UIViewController, UITextFieldDelegate, NSFetchedResultsControllerDelegate, Alertable {
    
    // MARK: - Outlets
    @IBOutlet weak var spendPicker: UIPickerView!
    @IBOutlet private weak var nametf: UITextField!
    
    // MARK: - Properties
    private var stillTyping = false
    private var spendType = ["Products", "Transport", "Entertainment", "Car", "Sport", "Beauty", "Present", "House"]
    private var fetchedResulController: NSFetchedResultsController<SpendCategory>!
    private var currentSpendCategories = [SpendCategory]()
    
    // MARK: - Actions
    @IBAction func saveDidTap() {
        guard let name = nametf.text,
              let icon = nametf.text else { return }
        if isExist(name: name) {
            showAlert(message: "You already have \(name)")
        } else {
            let newSpendCategory = SpendCategory(context: MoneyTrackService.managedObjectContext)
            newSpendCategory.name = name
            newSpendCategory.amount = 0.0
            newSpendCategory.icon = icon
            
            MoneyTrackService.saveContext()
            self.dismiss(animated: true, completion: nil)
        }
    }
    
    // MARK: - Override
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpPicker()
        setUpFetchedResultController()
        loadSpendings()
        fetchedResulController.delegate = self
        
        setup()
    }
    
    // MARK: - Methods
    private func setUpPicker() {
        spendPicker.delegate = self
        spendPicker.dataSource = self
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
    
    private func setUpFetchedResultController() {
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
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        if textField == self.nametf {
            spendPicker.isHidden = false
            textField.endEditing(true)
        }
    }
}

extension AddSpendCategoryVC: UIPickerViewDelegate, UIPickerViewDataSource {
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        view.endEditing(true)
        return spendType[row]
    }

    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        nametf.text = spendType[row]
    }
    
    public func numberOfComponents(in pickerView: UIPickerView) -> Int{
        return 1
    }

    public func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int{
        return spendType.count
    }
}
