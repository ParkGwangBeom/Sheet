//
//  SendViewController.swift
//  Sheeeeeeeeet
//
//  Created by Gwangbeom on 2018. 9. 29..
//  Copyright © 2018년 GwangBeom. All rights reserved.
//

import UIKit
import Sheet

struct Frined {
    let image: UIImage?
    let name: String
}

class SendViewController: SheetContentsViewController, FristsListContainerCellDelegate {
    
    var frinesLsit: [Frined] = [
        Frined(image: nil, name: "John"),
        Frined(image: nil, name: "Mark"),
        Frined(image: nil, name: "Steve"),
        Frined(image: nil, name: "Apple")
    ]
    
    @IBOutlet weak var customToolBar: UIView!
    @IBOutlet weak var doneButton: UIButton!

    override var visibleContentsHeight: CGFloat {
        return 500
    }

    override var sheetToolBar: UIView? {
        return customToolBar
    }
    
    override func registCollectionElement() {
        let nib = UINib(nibName: "TitleHeaderView", bundle: nil)
        collectionView?.register(nib, forSupplementaryViewOfKind: SheetLayoutElement.header.kind, withReuseIdentifier: SheetLayoutElement.header.id)
    }
    
    override func setupSheetLayout(_ layout: SheetContentsLayout) {
        layout.settings.itemSize = { indexPath in
            let height: CGFloat = indexPath.item == 0 ? 30 : 170
            return CGSize(width: UIScreen.main.bounds.width, height: height)
        }
        layout.settings.headerSize = CGSize(width: UIScreen.main.bounds.width, height: 60)
        layout.settings.isHeaderStretchy = true
    }

    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 2
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if indexPath.item == 0 {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "title", for: indexPath)
            return cell
        }
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as? FristsListContainerCell
        cell?.frinesLsit = frinesLsit
        cell?.delegate = self
        return cell ?? UICollectionViewCell()
    }
    
    override func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        switch kind {
        case SheetLayoutElement.header.kind:
            let headerView = collectionView.dequeueReusableSupplementaryView(
                ofKind: kind,
                withReuseIdentifier: SheetLayoutElement.header.id,
                for: indexPath) as? TitleHeaderView
            headerView?.titleLabel.text = "SEND"
            return headerView ?? UICollectionReusableView()
        default: return UICollectionReusableView()
        }
    }
    
    @IBAction func tappedBackButton(_ sender: Any) {
        navigationController?.popViewController(animated: true)
    }
    
    @IBAction func tappedDone(_ sender: Any) {
        dismiss(animated: true)
    }
    
    func tappedFriend(isSelected: Bool) {
        doneButton.isEnabled = isSelected
    }
}

class FriendCell: UICollectionViewCell {
    @IBOutlet weak var userImageView: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        userImageView.layer.cornerRadius = userImageView.bounds.width / 2
    }
}

protocol FristsListContainerCellDelegate: AnyObject {
    
    func tappedFriend(isSelected: Bool)
}

class FristsListContainerCell: UICollectionViewCell {
    
    @IBOutlet weak var collectionView: UICollectionView!
    weak var delegate: FristsListContainerCellDelegate?
    
    var frinesLsit: [Frined] = [] {
        didSet {
            collectionView.reloadData()
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        collectionView.dataSource = self
        collectionView.delegate = self
    }
}

extension FristsListContainerCell: UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return frinesLsit.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as? FriendCell
        let friend = frinesLsit[indexPath.item]
        cell?.nameLabel.text = friend.name
        return cell ?? UICollectionViewCell()
    }
}

extension FristsListContainerCell: UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        delegate?.tappedFriend(isSelected: true) 
    }
}
