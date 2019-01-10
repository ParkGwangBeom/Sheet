//
//  MoveItemViewController.swift
//  Example
//
//  Created by Gwangbeom on 2018. 10. 1..
//  Copyright © 2018년 Interactive. All rights reserved.
//

import UIKit
import Sheet

class MoveItemViewController: SheetContentsViewController {
    
    var items: [UIColor] = [
        #colorLiteral(red: 0.9254902005, green: 0.2352941185, blue: 0.1019607857, alpha: 1), #colorLiteral(red: 0.09019608051, green: 0, blue: 0.3019607961, alpha: 1), #colorLiteral(red: 0.3098039329, green: 0.2039215714, blue: 0.03921568766, alpha: 1), #colorLiteral(red: 0.9098039269, green: 0.4784313738, blue: 0.6431372762, alpha: 1), #colorLiteral(red: 0.721568644, green: 0.8862745166, blue: 0.5921568871, alpha: 1), #colorLiteral(red: 0.2745098174, green: 0.4862745106, blue: 0.1411764771, alpha: 1)
    ]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let longPressGesture = UILongPressGestureRecognizer(target: self, action: #selector(handleLongPressGesture))
        collectionView?.addGestureRecognizer(longPressGesture)
    }
    
    @objc
    func handleLongPressGesture(recognizer: UILongPressGestureRecognizer) {
        switch recognizer.state {
        case .began:
            guard let selectedIndexPath = collectionView?.indexPathForItem(at: recognizer.location(in: collectionView)) else {
                break
            }
            collectionView?.beginInteractiveMovementForItem(at: selectedIndexPath)
        case .changed:
            collectionView?.updateInteractiveMovementTargetPosition(recognizer.location(in: recognizer.view))
        case .ended:
            collectionView?.endInteractiveMovement()
        default:
            collectionView?.cancelInteractiveMovement()
        }
    }
    
    override func registCollectionElement() {
        let nib = UINib(nibName: "TitleHeaderView", bundle: nil)
        collectionView?.register(nib, forSupplementaryViewOfKind: SheetLayoutElement.header.kind, withReuseIdentifier: SheetLayoutElement.header.id)
    }
    
    override func setupSheetLayout(_ layout: SheetContentsLayout) {
        layout.settings.itemSize = { indexPath in
            let width = (UIScreen.main.bounds.width - 30) / 2
            return CGSize(width: width, height: width)
        }
        layout.settings.headerSize = CGSize(width: UIScreen.main.bounds.width, height: 60)
        layout.minimumLineSpacing = 10
        layout.minimumInteritemSpacing = 10
        layout.sectionInset = UIEdgeInsets(top: 20, left: 10, bottom: 20, right: 10)
    }
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return items.count
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath)
        cell.contentView.backgroundColor = items[indexPath.item]
        return cell
    }
    
    override func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        switch kind {
        case SheetLayoutElement.header.kind:
            let headerView = collectionView.dequeueReusableSupplementaryView(
                ofKind: kind,
                withReuseIdentifier: SheetLayoutElement.header.id,
                for: indexPath) as? TitleHeaderView
            headerView?.titleLabel.text = "MOVE ITEM"
            return headerView ?? UICollectionReusableView()
        default: return UICollectionReusableView()
        }
    }
    
    override func collectionView(_ collectionView: UICollectionView, canMoveItemAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    override func collectionView(_ collectionView: UICollectionView, moveItemAt sourceIndexPath: IndexPath, to destinationIndexPath: IndexPath) {
        
    }
}
