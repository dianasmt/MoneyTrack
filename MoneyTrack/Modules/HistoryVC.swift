//
//  HistoryVCViewController.swift
//  MoneyTrack
//
//  Created by Диана Смахтина on 22.02.22.
//

import UIKit
import CoreData

class HistoryVC: UIViewController, NSFetchedResultsControllerDelegate {
    
    @IBOutlet private weak var tableView: UITableView!
    @IBOutlet private weak var viewSpend: UIView!
    @IBOutlet private weak var viewEarn: UIView!
    @IBOutlet private weak var labelSpend: UILabel!
    @IBOutlet private weak var labelEarn: UILabel!
    @IBOutlet private weak var money: UILabel!
    @IBOutlet private weak var monthLabel: UILabel!
    
  
    
    private var fetchedResulController: NSFetchedResultsController<Spending>!
    private var fetchedResulControllerW: NSFetchedResultsController<Wallet>!
    private var fetchedResulControllerR: NSFetchedResultsController<Replenichment>!
    private var fetchedResulControllerSpendC: NSFetchedResultsController<SpendCategory>!
    
    var spending = [Spending]() {
        didSet {
            tableView.reloadData()
        }
    }
    var wallets = [Wallet]() {
        didSet {
            tableView.reloadData()
        }
    }
    var spendCategories = [SpendCategory]() {
        didSet {
            tableView.reloadData()
        }
    }
    var replenichments = [Replenichment]() {
        didSet {
            tableView.reloadData()
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setUpLabels()
        animatedTableView()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupFetchedResultControllerHistory()
        setupFetchedResultControllerHistoryW()
        setupFetchedResultControllerHistorySpCat()
        setupFetchedResultControllerReplenichment()
        loadSpendCategories()
        loadSpendings()
        loadWalletsForIncomes()
        loadReplenichments()
        
        roundingViews()
        setUpColors()
        setDateLabel()
        
        tableView.dataSource = self
        tableView.delegate = self
        
        fetchedResulControllerR.delegate = self
        fetchedResulController.delegate = self
        fetchedResulControllerW.delegate = self
        fetchedResulControllerSpendC.delegate = self
    }
    
    private func roundingViews() {
        viewSpend.layer.cornerRadius = 20.0
        viewEarn.layer.cornerRadius = 20.0
    }
    
    private func setUpLabels() {
        var sumTest = 0.0
        var sumOutcomes = 0.0
        replenichments.forEach {
            sumTest += $0.amount
        }
        spending.forEach({
            sumOutcomes += $0.amount
        })
        labelEarn.text = "+ \(String(sumTest)) Br"
        labelSpend.text = "- \(String(sumOutcomes)) Br"
        money.text = " \(String(format: "%.1f", sumTest - sumOutcomes)) Br"
    }
    
    private func setUpColors() {
        view.backgroundColor = UIColor(named: "BackgroundColor")
        tableView.backgroundColor = UIColor(named: "BackgroundColor")
        viewEarn.backgroundColor = UIColor(named: "CollectionColor")
        viewSpend.backgroundColor = UIColor(named: "CollectionColor")
    }
    
    private func setDateLabel() {
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MMMM yyyy"
        dateFormatter.locale = Locale(identifier: "En-en")
        
        monthLabel.text = dateFormatter.string(from: Date())
    }
    
    private func setupFetchedResultControllerHistory() {
        let request = Spending.fetchRequest()
        let sortDescriptor = NSSortDescriptor(key: "date", ascending: true)
        request.sortDescriptors = [sortDescriptor]
        fetchedResulController = NSFetchedResultsController<Spending>(fetchRequest: request, managedObjectContext: MoneyTrackService.managedObjectContext, sectionNameKeyPath: nil, cacheName: nil)
    }
    
    private func setupFetchedResultControllerHistoryW() {
        let request = Wallet.fetchRequest()
        let sortDescriptor = NSSortDescriptor(key: "amount", ascending: true)
        request.sortDescriptors = [sortDescriptor]
        fetchedResulControllerW = NSFetchedResultsController<Wallet>(fetchRequest: request, managedObjectContext: MoneyTrackService.managedObjectContext, sectionNameKeyPath: nil, cacheName: nil)
    }
    
    private func setupFetchedResultControllerHistorySpCat() {
        let request = SpendCategory.fetchRequest()
        let sortDescriptor = NSSortDescriptor(key: "name", ascending: true)
        request.sortDescriptors = [sortDescriptor]
        fetchedResulControllerSpendC = NSFetchedResultsController<SpendCategory>(fetchRequest: request, managedObjectContext: MoneyTrackService.managedObjectContext, sectionNameKeyPath: nil, cacheName: nil)
    }
    
    private func loadSpendings() {
        try? fetchedResulController.performFetch()
        if let results = fetchedResulController.fetchedObjects {
            spending = results
        }
    }
    private func loadWalletsForIncomes() {
        try? fetchedResulControllerW.performFetch()
        if let results = fetchedResulControllerW.fetchedObjects {
            wallets = results
        }
    }
    private func loadSpendCategories() {
        try? fetchedResulControllerSpendC.performFetch()
        if let results = fetchedResulControllerSpendC.fetchedObjects {
            spendCategories = results
        }
    }
    
    private func setupFetchedResultControllerReplenichment() {
        let request = Replenichment.fetchRequest()
        let sortDescriptor = NSSortDescriptor(key: "amount", ascending: true)
        request.sortDescriptors = [sortDescriptor]
        fetchedResulControllerR = NSFetchedResultsController<Replenichment>(fetchRequest: request, managedObjectContext: MoneyTrackService.managedObjectContext, sectionNameKeyPath: nil, cacheName: nil)
    }
    
    private func loadReplenichments() {
        try? fetchedResulControllerR.performFetch()
        if let results = fetchedResulControllerR.fetchedObjects {
            replenichments = results
        }
    }
   
    func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        loadSpendCategories()
        loadSpendings()
        loadWalletsForIncomes()
        loadReplenichments()
    }

}

extension HistoryVC: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return spending.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "\(HistoryViewCell.self)", for: indexPath) as? HistoryViewCell
        cell?.setup(spending: spending[indexPath.row])
        return cell ?? UITableViewCell()
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 70.0
    }
    
    func animatedTableView() {
        tableView.reloadData()
        
        let cells = tableView.visibleCells
        let tableViewHeight = tableView.bounds.height
        var delay = 0.0
        
        for cell in cells {
            cell.transform = CGAffineTransform(translationX: 0, y: tableViewHeight)

            UIView.animate(withDuration: 1.3,
                           delay: delay * 0.05,
                           options: .curveEaseInOut,
                           animations: {
                cell.transform = CGAffineTransform.identity
            })
            delay += 1
        }
                
    }
}
