//
//  MainVC.swift
//  MoneyTrack
//
//  Created by Диана Смахтина on 21.02.22.
//

import UIKit
import CoreData

final class MainVC: UIViewController, NSFetchedResultsControllerDelegate, Alertable {
    // MARK: - Consts
    enum Const {
        static let backgroundColor = "BackgroundColor"
        static let collectionColor = "CollectionColor"
        static let textColor = "TextColor"
    }
    
    // MARK: - Outlets
    @IBOutlet private weak var walletCollectionView: UICollectionView!
    @IBOutlet private weak var spendingCollectionView: UICollectionView!
    @IBOutlet private var text: [UILabel]!
    @IBOutlet private var addWallet: UIButton!
    @IBOutlet private var addSpendCategory: UIButton!
    @IBOutlet private var addSpending: UIButton!
    
    // MARK: - Properties
    private var fetchedResulController: NSFetchedResultsController<Wallet>!
    private var fetchedResulControllerSpend: NSFetchedResultsController<SpendCategory>!
    
    var wallets: [Wallet] = [] {
        didSet {
            walletCollectionView.reloadData()
        }
    }
    var spends: [SpendCategory] = [] {
        didSet {
            spendingCollectionView.reloadData()
        }
    }
    
    // MARK: - Actions
    @IBAction func addWalletTap() {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let nextVC = storyboard.instantiateViewController(withIdentifier: "\(AddWalletVC.self)") as? AddWalletVC
        present(nextVC!, animated: true, completion: nil)
    }
    
    @IBAction func addSpendCategoryTap() {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let nextVC = storyboard.instantiateViewController(withIdentifier: "\(AddSpendCategoryVC.self)") as? AddSpendCategoryVC
        present(nextVC!, animated: true, completion: nil)
    }
    
    @IBAction func addSpendingMTap() {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let nextVC = storyboard.instantiateViewController(withIdentifier: "\(CalculateVC.self)") as? CalculateVC
        present(nextVC!, animated: true, completion: nil)
    }
    
    @IBAction private func longPressForDeleting(recognizer: UILongPressGestureRecognizer) {
        let point = recognizer.location(in: self.walletCollectionView)
        guard let indexPath = self.walletCollectionView.indexPathForItem(at: point) else { return }
      
        let delete = UIAlertAction(title: "Delete", style: .destructive) { _ in
            
            let context = MoneyTrackService.persistentContainer.viewContext
            let request = Wallet.fetchRequest()
            
            if let wallets = try? context.fetch(request) {
                context.delete(wallets[indexPath.row])
                self.walletCollectionView.reloadData()
                
                MoneyTrackService.saveContext()
            }
        }
        showAlertBeforeDeleting(title: "Delete", message: "Do you want to delete this wallet?", action: delete)
    }
    
    // MARK: - Override
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpCollectionViews()
        setupFetchedResultController()
        setupFetchedResultControllerSpend()
        setUpStyle()
        loadWallets()
        loadSpendCategories()
        
        fetchedResulController.delegate = self
        fetchedResulControllerSpend.delegate = self
    }
    
    // MARK: - Methods
    private func setUpCollectionViews() {
        walletCollectionView.dataSource = self
        walletCollectionView.delegate = self
        
        spendingCollectionView.dataSource = self
        spendingCollectionView.delegate = self
        
        walletCollectionView.dragDelegate = self
        walletCollectionView.dropDelegate = self
        walletCollectionView.dragInteractionEnabled = true
        
        spendingCollectionView.dragDelegate = self
        spendingCollectionView.dropDelegate = self
        spendingCollectionView.dragInteractionEnabled = true
    }
    
    private func setupFetchedResultController() {
        let request = Wallet.fetchRequest()
        let sortDescriptor = NSSortDescriptor(key: "name", ascending: true)
        request.sortDescriptors = [sortDescriptor]
        fetchedResulController = NSFetchedResultsController<Wallet>(fetchRequest: request, managedObjectContext: MoneyTrackService.managedObjectContext, sectionNameKeyPath: nil, cacheName: nil)
    }
    
    private func setupFetchedResultControllerSpend() {
        let request = SpendCategory.fetchRequest()
        let sortDescriptor = NSSortDescriptor(key: "name", ascending: true)
        request.sortDescriptors = [sortDescriptor]
        fetchedResulControllerSpend = NSFetchedResultsController<SpendCategory>(fetchRequest: request, managedObjectContext: MoneyTrackService.managedObjectContext, sectionNameKeyPath: nil, cacheName: nil)
    }
    
    private func loadWallets() {
        try? fetchedResulController.performFetch()
        if let results = fetchedResulController.fetchedObjects {
            wallets = results
        }
    }
    
    private func loadSpendCategories() {
        try? fetchedResulControllerSpend.performFetch()
        if let results = fetchedResulControllerSpend.fetchedObjects {
            spends = results
        }
    }
    
    internal func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        loadWallets()
        loadSpendCategories()
    }
    
    private func setUpStyle() {
        view.backgroundColor = UIColor(named: Const.backgroundColor)
        addSpending.tintColor = UIColor(named: Const.textColor)
        for word in text {
            word.textColor = UIColor(named: Const.textColor)
        }
        
        [walletCollectionView, spendingCollectionView, addSpending].forEach { $0?.backgroundColor = UIColor(named: Const.collectionColor) }
        [walletCollectionView, spendingCollectionView].forEach{ $0.layer.cornerRadius = 20.0 }
        [addWallet, addSpendCategory, addSpending].forEach{ $0.layer.cornerRadius = $0.bounds.height / 2 }
    }
}

extension MainVC: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if collectionView == walletCollectionView {
            let nextVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "\(ReplenichmentVC.self)") as? ReplenichmentVC
            present(nextVC!, animated: true, completion: nil)
        }
        if collectionView == spendingCollectionView {
            let nextVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "\(CalculateVC.self)") as? CalculateVC
            present(nextVC!, animated: true, completion: nil)
        }
    }
}

extension MainVC: UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if collectionView == walletCollectionView {
            return wallets.count
        } else {
            return spends.count
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if collectionView == walletCollectionView {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "\(IconCVC.self)", for: indexPath) as? IconCVC
            cell?.setup(icon: wallets[indexPath.row])
            return cell ?? UICollectionViewCell()
        } else {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "\(SpendIconCVC.self)", for: indexPath) as? SpendIconCVC
            cell?.setup(item: spends[indexPath.row])
            return cell ?? UICollectionViewCell()
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: spendingCollectionView.bounds.width / 3, height: walletCollectionView.bounds.height - 5)
    }
}

extension MainVC: UICollectionViewDragDelegate {
    func collectionView(_ collectionView: UICollectionView, itemsForBeginning session: UIDragSession, at indexPath: IndexPath) -> [UIDragItem] {
        if collectionView == walletCollectionView {
            let item = self.wallets[indexPath.row]
            let itemProvider = NSItemProvider(object: item.icon! as NSString)
            let dragItem  = UIDragItem(itemProvider: itemProvider)
            dragItem.localObject = item
            return [dragItem]
        } else {
            let item = self.spends[indexPath.row]
            let itemProvider = NSItemProvider(object: item.icon! as NSString)
            let dragItem  = UIDragItem(itemProvider: itemProvider)
            dragItem.localObject = item
            return [dragItem]
        }
    }
}

extension MainVC: UICollectionViewDropDelegate {
    func collectionView(_ collectionView: UICollectionView, dropSessionDidUpdate session: UIDropSession, withDestinationIndexPath destinationIndexPath: IndexPath?) -> UICollectionViewDropProposal {
        if collectionView.hasActiveDrag {
            return UICollectionViewDropProposal(operation: .move, intent: .insertAtDestinationIndexPath)
        }
        return UICollectionViewDropProposal(operation: .forbidden)
    }
    
    func collectionView(_ collectionView: UICollectionView, performDropWith coordinator: UICollectionViewDropCoordinator) {
        var destinarionIndexPath: IndexPath
        if let indexPath = coordinator.destinationIndexPath {
            destinarionIndexPath = indexPath
        } else {
            let row = collectionView.numberOfItems(inSection: 0)
            destinarionIndexPath = IndexPath(item: row - 1, section: 0)
        }
        if coordinator.proposal.operation == .move {
            self.reorderItems(coordinator: coordinator, destinationIndexPath: destinarionIndexPath, collectionView: collectionView)
        }
    }
    
    fileprivate func reorderItems(coordinator: UICollectionViewDropCoordinator, destinationIndexPath: IndexPath, collectionView: UICollectionView) {
        if let item = coordinator.items.first,
           let sourceIndexPath = item.sourceIndexPath {
            
            collectionView.performBatchUpdates ({
                if collectionView == walletCollectionView {
                    self.wallets.remove(at: sourceIndexPath.item)
                    self.wallets.insert(item.dragItem.localObject as! Wallet, at: destinationIndexPath.item)
                } else {
                    self.spends.remove(at: sourceIndexPath.item)
                    self.spends.insert(item.dragItem.localObject as! SpendCategory, at: destinationIndexPath.item)
                }
                collectionView.deleteItems(at: [sourceIndexPath])
                collectionView.insertItems(at: [destinationIndexPath])
            }, completion: nil )
            coordinator.drop(item.dragItem, toItemAt: destinationIndexPath)
        }
    }
}
