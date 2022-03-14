//
//  CurrencyVC.swift
//  MoneyTrack
//
//  Created by Диана Смахтина on 1.03.22.
//

import UIKit

class CurrencyVC: UIViewController {
  
    
    
    @IBOutlet weak var currencyPicker: UIPickerView!
    @IBOutlet weak var textField: UITextField!
    @IBOutlet weak var priceLabel: UILabel!
    
    var currencyCode: [String] = []
    var values: [Double] = []
    var activeCurrency = 0.0
    var currency = ""

    override func viewDidLoad() {
        super.viewDidLoad()
        setUpStyle()
        currencyPicker.delegate = self
        currencyPicker.dataSource = self
        fetchJSON()
        textField.addTarget(self, action: #selector(updateViews(input:)), for: .editingChanged)
    }
    
    @objc func updateViews(input: Double) {
        guard let amountText = textField.text,
              let amount = Double(amountText) else { return }
        if
            textField.text != ""
        {
            let total = amount * activeCurrency
            priceLabel.text = "\(amountText) $ = \(String(format: "%.2f", total)) \(currency)"
        }
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    
    func fetchJSON() {
        guard let url = URL(string: "https://v6.exchangerate-api.com/v6/2ee59ae071bdd9d87e2e9309/latest/USD") else { return }
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        
        URLSession.shared.dataTask(with: url) { data, response, error in
            if let error = error {
                print(error.localizedDescription)
                return
            }
            guard let safeData = data else { return }
                do {
                    let results = try JSONDecoder().decode(ExchangeRates.self, from: safeData)
                    self.currencyCode.append(contentsOf: results.conversion_rates.keys)
                    self.values.append(contentsOf: results.conversion_rates.values)
                    DispatchQueue.main.async {
                        self.currencyPicker.reloadAllComponents()
                    }
                } catch {
                    print(error)
                }
        }.resume()
    }
    
    private func setUpStyle() {
        view.backgroundColor = UIColor(named: "BackgroundColor")
        priceLabel.textColor = UIColor(named: "TextColor")
    }
    
}
extension CurrencyVC: UIPickerViewDelegate, UIPickerViewDataSource {
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        currencyCode.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
       
        return currencyCode[row]
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        currency = currencyCode[row]
        activeCurrency = values[row]
        updateViews(input: activeCurrency)
    }

   
    
    
}

