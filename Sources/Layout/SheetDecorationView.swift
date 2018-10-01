//
//  SheetDecorationView.swift
//  Sheeeeeeeeet
//
//  Created by NAVER on 2018. 9. 29..
//  Copyright © 2018년 GwangBeom. All rights reserved.
//

import UIKit

class SheetDecorationView : UICollectionReusableView {
    
    static var KIND = "SheetDecorationView"
    static var REUSE_ID = "SheetDecorationView"
    
    override var reuseIdentifier: String? {
        return SheetDecorationView.REUSE_ID
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        prepare()
    }
    
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)!
        prepare()
    }
    
    private func prepare() {
        clipsToBounds = true
        backgroundColor = SheetManager.shared.options.sheetBackgroundColor
        layer.cornerRadius = SheetManager.shared.options.cornerRadius
    }
}
