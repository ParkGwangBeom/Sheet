//
//  SheetContentsLayout.swift
//  VibeMusic
//
//  Created by Naver on 2018. 6. 29..
//  Copyright © 2018년 VIBE. All rights reserved.
//

import UIKit

// https://www.raywenderlich.com/527-custom-uicollectionviewlayout-tutorial-with-parallax
public class SheetContentsLayout: UICollectionViewFlowLayout {
    
    public var settings = SheetLayoutSettings()
    private var oldBounds: CGRect = .zero
    private var contentHeight: CGFloat = 0
    private var cache: [SheetLayoutElement: [IndexPath: SheetLayoutAttributes]] = [:]
    private var visibleLayoutAttributes: [SheetLayoutAttributes] = []
    
    private var collectionViewHeight: CGFloat {
        return collectionView?.frame.height ?? 0
    }
    
    private var collectionViewWidth: CGFloat {
        return collectionView?.frame.width ?? 0
    }
    
    private var contentOffset: CGPoint {
        return collectionView?.contentOffset ?? .zero
    }

    public override var collectionViewContentSize: CGSize {
        return CGSize(width: collectionViewWidth, height: contentHeight)
    }
    
    public override init() {
        super.init()
        minimumLineSpacing = 0
        minimumInteritemSpacing = 0
        sectionInset = .zero
        scrollDirection = .vertical
        register(SheetDecorationView.self, forDecorationViewOfKind: SheetDecorationView.KIND)
    }
    
    public required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension SheetContentsLayout {
    
    public override func prepare() {
        guard let collectionView = collectionView else {
            return
        }

        prepareCache()
        contentHeight = settings.topMargin
        oldBounds = collectionView.bounds
        
        if let headerSize = settings.headerSize {
            let headerAttributes = SheetLayoutAttributes(forSupplementaryViewOfKind: SheetLayoutElement.header.kind, with: IndexPath(item: 0, section: 0))
            prepareSupplementrayElement(size: headerSize, type: .header, attributes: headerAttributes)
        }
        
        for section in 0..<collectionView.numberOfSections {
            if let sectionHeaderSize = settings.sectionHeaderSize?(IndexPath(item: 0, section: section)) {
                let sectionHeaderAttributes = SheetLayoutAttributes(forSupplementaryViewOfKind: UICollectionElementKindSectionHeader, with: IndexPath(item: 0, section: section))
                prepareSupplementrayElement(size: sectionHeaderSize, type: .sectionHeader, attributes: sectionHeaderAttributes)
            }
            
            var x: CGFloat = sectionInset.left
            var y: CGFloat = sectionInset.top + contentHeight
            
            for item in 0..<collectionView.numberOfItems(inSection: section) {
                let cellIndexPath = IndexPath(item: item, section: section)
                let attributes = SheetLayoutAttributes(forCellWith: cellIndexPath)

                var rect = attributes.frame
                rect.origin = CGPoint(x: x, y: y)
                
                let itemSize = settings.itemSize?(cellIndexPath) ?? .zero
                x += itemSize.width + minimumInteritemSpacing
                
                if x + sectionInset.right >= collectionView.bounds.width {
                    x = sectionInset.left
                    y += itemSize.height + minimumLineSpacing
                }
                
                rect.size = itemSize
                attributes.frame = rect
                
                attributes.zIndex = 0
                contentHeight = attributes.frame.maxY
                cache[.cell]?[cellIndexPath] = attributes
            }
            
            if let sectionFooterSize = settings.sectionFooterSize?(IndexPath(item: 1, section: section)) {
                let sectionFooterAttributes = SheetLayoutAttributes(forSupplementaryViewOfKind: UICollectionElementKindSectionFooter, with: IndexPath(item: 1, section: section))
                prepareSupplementrayElement(size: sectionFooterSize, type: .sectionFooter, attributes: sectionFooterAttributes)
            }
        }
        
        if let footerSize = settings.footerSize {
            let footerAttributes = SheetLayoutAttributes(forSupplementaryViewOfKind: SheetLayoutElement.footer.kind, with: IndexPath(item: 0, section: 0))
            prepareSupplementrayElement(size: footerSize, type: .footer, attributes: footerAttributes)
        }
        
        contentHeight += sectionInset.bottom
    }
    
    private func prepareCache() {
        cache.removeAll(keepingCapacity: true)
        cache[.cell] = [:]
        cache[.header] = [:]
        cache[.footer] = [:]
        cache[.sectionHeader] = [:]
        cache[.sectionFooter] = [:]
    }
    
    private func prepareSupplementrayElement(size: CGSize, type: SheetLayoutElement, attributes: SheetLayoutAttributes) {
        guard size != .zero else { return }
        attributes.initialOrigin = CGPoint(x: 0, y: contentHeight)
        attributes.frame = CGRect(origin: attributes.initialOrigin, size: size)
        attributes.zIndex = type == .header ? 2 : 1
        contentHeight += size.height
        cache[type]?[attributes.indexPath] = attributes
    }
}

extension SheetContentsLayout {
    
    public override func shouldInvalidateLayout(forBoundsChange newBounds: CGRect) -> Bool {
        if oldBounds.size != newBounds.size {
            cache.removeAll(keepingCapacity: true)
        }
        return true
    }
    
    public override func layoutAttributesForSupplementaryView(ofKind elementKind: String, at indexPath: IndexPath) -> UICollectionViewLayoutAttributes? {
        switch elementKind {
        case UICollectionElementKindSectionHeader:
            return cache[.sectionHeader]?[indexPath]
        case UICollectionElementKindSectionFooter:
            return cache[.sectionFooter]?[indexPath]
        case SheetLayoutElement.header.kind:
            return cache[.header]?[indexPath]
        case SheetLayoutElement.footer.kind:
            return cache[.footer]?[indexPath]
        default:
            return super.layoutAttributesForSupplementaryView(ofKind: elementKind, at: indexPath)
        }
    }

    public override func layoutAttributesForItem(at indexPath: IndexPath) -> UICollectionViewLayoutAttributes? {
        return cache[.cell]?[indexPath]
    }
    
    public override func layoutAttributesForElements(in rect: CGRect) -> [UICollectionViewLayoutAttributes]? {
        guard let collectionView = collectionView else {
            return nil
        }
        visibleLayoutAttributes.removeAll(keepingCapacity: true)

        for (type, elementInfos) in cache {
            for (indexPath, attributes) in elementInfos {
                attributes.transform = .identity
                updateSupplementaryViews(type, attributes: attributes, collectionView: collectionView, indexPath: indexPath)
                if attributes.frame.intersects(rect) {
                    visibleLayoutAttributes.append(attributes)
                }
            }
        }
        
        for section in 0..<collectionView.numberOfSections {
            let indexPath = IndexPath(row: 0, section: section)
            let decorator = SheetLayoutAttributes(forDecorationViewOfKind: SheetDecorationView.KIND, with: indexPath)
            var rect = CGRect.zero
            rect.origin = CGPoint(x: 0, y: settings.topMargin)
            rect.size = collectionViewContentSize
            decorator.frame = rect
            decorator.zIndex = -1
            visibleLayoutAttributes.append(decorator)
        }
        
        return visibleLayoutAttributes
    }
    
    private func updateSupplementaryViews(_ type: SheetLayoutElement, attributes: SheetLayoutAttributes, collectionView: UICollectionView, indexPath: IndexPath) {
        if type == .sectionHeader, settings.isSectionHeaderStretchy {
            let cellHeight = settings.itemSize?(indexPath).height ?? 0
            let upperLimit = CGFloat(collectionView.numberOfItems(inSection: indexPath.section)) * (cellHeight + 0)
            attributes.transform =  CGAffineTransform(
                translationX: 0,
                y: min(upperLimit, max(0, contentOffset.y - attributes.initialOrigin.y)))
        } else if type == .header, settings.isHeaderStretchy {
            attributes.transform = CGAffineTransform(translationX: 0, y: max(0, contentOffset.y - attributes.initialOrigin.y))
        }
    }
}

