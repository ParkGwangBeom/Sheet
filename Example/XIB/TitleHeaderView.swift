//
//  TitleHeaderView.swift
//  Sheeeeeeeeet
//
//  Created by Gwangbeom on 2018. 10. 1..
//  Copyright © 2018년 GwangBeom. All rights reserved.
//

import UIKit
import Sheet

class TitleHeaderView: UICollectionReusableView {
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var backgroundView: UIView!
    
    override func apply(_ layoutAttributes: UICollectionViewLayoutAttributes) {
        guard let attributes = layoutAttributes as? SheetLayoutAttributes else { return }
        
        UIView.animate(withDuration: 0.1, delay: 0, options: [.curveLinear, .beginFromCurrentState, .allowUserInteraction], animations: {
            self.backgroundView.alpha = attributes.contentOffset.y < 0 ? 0 : 1
        }, completion: nil)
    }
}
