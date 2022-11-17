//
//  AnimationVC.swift
//  MoneyTrack
//
//  Created by Диана Смахтина on 21.02.22.
//

import UIKit

final class AnimationVC: UIViewController {
    
    // MARK: - Consts
    enum Const {
        static let backgroundColor = "BackgroundColor"
        static let textColor = "TextColor"
    }

    // MARK: - Outlets
    @IBOutlet private var moneyTrackText: [UILabel]!
    @IBOutlet private weak var ellipse: UIImageView!
    @IBOutlet private weak var vector: UIImageView!
  
    // MARK: - Override
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        animationOfStartScreen()
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        setupColor()
    }
    
    // MARK: - Methods
    private func animationOfStartScreen() {
        let startPosition: CGFloat = 18.0
        let endPosition: CGFloat = 170.0
        let endPositionVecor: CGFloat = UIScreen.main.bounds.height
        
        ellipse.frame.origin.y = startPosition
        
        let startHeight: CGFloat = 266.0
        let endHeight = startHeight * 2
        let startWidth: CGFloat = 221.0
        let endWidth = startWidth * 2
    
        UIView.animate(withDuration: 2.0) {
            self.ellipse.frame.origin.y = endPosition
            self.vector.frame.origin.y = endPositionVecor
            
            self.ellipse.frame.size.width = endWidth
            self.ellipse.frame.size.height = endHeight
            self.ellipse.frame.origin.x = 30     } completion: { _ in
                self.openMainScreen()
            }
    }
    
    private func openMainScreen() {
        let nextVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "\(TabBarVC.self)")
        nextVC.modalPresentationStyle = .fullScreen
        present(nextVC, animated: true)
    }
    
    private func setupColor() {
        view.backgroundColor = UIColor(named: Const.backgroundColor)
        moneyTrackText.forEach { $0.textColor = UIColor(named: Const.textColor) }
    }
}
