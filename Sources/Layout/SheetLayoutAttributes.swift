//
//  SheetLayoutAttributes.swift
//  Sheeeeeeeeet
//
//  Created by Gwangbeom on 2018. 10. 1..
//  Copyright © 2018년 GwangBeom. All rights reserved.
//

import UIKit

public class SheetLayoutAttributes: UICollectionViewLayoutAttributes {

    public var initialOrigin: CGPoint = .zero
    public var contentOffset: CGPoint = .zero
    
    public override func copy(with zone: NSZone?) -> Any {
        guard let copiedAttributes = super.copy(with: zone) as? SheetLayoutAttributes else {
            return super.copy(with: zone)
        }
        copiedAttributes.initialOrigin = initialOrigin
        copiedAttributes.contentOffset = contentOffset
        return copiedAttributes
    }
    
    public override func isEqual(_ object: Any?) -> Bool {
        guard let otherAttributes = object as? SheetLayoutAttributes else {
            return false
        }
        if otherAttributes.initialOrigin != initialOrigin || otherAttributes.contentOffset != contentOffset {
            return false
        }
        
        return super.isEqual(object)
    }
}

