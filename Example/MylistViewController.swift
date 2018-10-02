//
//  MylistViewController.swift
//  Sheeeeeeeeet
//
//  Created by Gwangbeom on 2018. 9. 29..
//  Copyright © 2018년 GwangBeom. All rights reserved.
//

import UIKit
import Sheet

struct MyListItem {
    let iamge: UIImage?
    let title: String
    let isPrivacy: Bool
}

class MylistViewController: SheetContentsViewController {
    
    var items: [MyListItem] = [
        MyListItem(iamge: nil, title: "Trevi", isPrivacy: true),
        MyListItem(iamge: nil, title: "Moomin Love", isPrivacy: false),
        MyListItem(iamge: nil, title: "Sheet", isPrivacy: false)
    ]
    
    override func registCollectionElement() {
        let nib = UINib(nibName: "TitleHeaderView", bundle: nil)
        collectionView?.register(nib, forSupplementaryViewOfKind: SheetLayoutElement.header.kind, withReuseIdentifier: SheetLayoutElement.header.id)
    }

    override func setupSheetLayout() {
        layout.settings.itemSize = { indexPath in
            let height: CGFloat = indexPath.section == 0 ? 30 : 60
            return CGSize(width: UIScreen.main.bounds.width, height: height)
        }
        layout.sectionInset = UIEdgeInsets(top: 0, left: 0, bottom: 15, right: 0)
        layout.settings.headerSize = CGSize(width: UIScreen.main.bounds.width, height: 60)
        layout.settings.isHeaderStretchy = true
    }

    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 3
    }
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if section == 0 {
            return 1
        } else if section == 1 {
            return items.count
        } else {
            return 1
        }
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if indexPath.section == 0 {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "title", for: indexPath)
            return cell
        } else if indexPath.section == 1 {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as? MylistCell
            let item = items[indexPath.item]
            cell?.listTitleLabel.text = item.title
            cell?.privacyLabel.text = item.isPrivacy ? "Privacy" : "Public"
            return cell ?? UICollectionViewCell()
        }
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "create", for: indexPath)
        return cell
    }

    override func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        switch kind {
        case SheetLayoutElement.header.kind:
            let headerView = collectionView.dequeueReusableSupplementaryView(
                ofKind: kind,
                withReuseIdentifier: SheetLayoutElement.header.id,
                for: indexPath) as? TitleHeaderView
            headerView?.titleLabel.text = "ADD TO MYLIST"
            return headerView ?? UICollectionReusableView()
        default: return UICollectionReusableView()
        }
    }
    
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if indexPath.section == 1 {
            let vc = UIStoryboard.init(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "WriteViewController")
            navigationController?.pushViewController(vc, animated: true)
        } else if indexPath.section == 2 {
            let vc = UIStoryboard.init(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "CteateListViewController")
            navigationController?.pushViewController(vc, animated: true)   
        }
    }
    
    @IBAction func tappedBackButton(_ sender: Any) {
        navigationController?.popViewController(animated: true)
    }
}

class MylistCell: UICollectionViewCell {
    
    @IBOutlet weak var listTitleLabel: UILabel!
    @IBOutlet weak var privacyLabel: UILabel!
}
