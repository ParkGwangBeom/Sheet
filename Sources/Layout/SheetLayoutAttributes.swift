//
//  SheetLayoutAttributes.swift
//  Sheeeeeeeeet
//
//  Created by Gwangbeom on 2018. 10. 1..
//  Copyright © 2018년 GwangBeom. All rights reserved.
//

import UIKit

class SheetLayoutAttributes: UICollectionViewLayoutAttributes {

    var initialOrigin: CGPoint = .zero
    
    override func copy(with zone: NSZone?) -> Any {
        guard let copiedAttributes = super.copy(with: zone) as? SheetLayoutAttributes else {
            return super.copy(with: zone)
        }
        copiedAttributes.initialOrigin = initialOrigin
        return copiedAttributes
    }
    
    override func isEqual(_ object: Any?) -> Bool {
        guard let otherAttributes = object as? SheetLayoutAttributes else {
            return false
        }
        if otherAttributes.initialOrigin != initialOrigin {
            return false
        }
        
        return super.isEqual(object)
    }
}

