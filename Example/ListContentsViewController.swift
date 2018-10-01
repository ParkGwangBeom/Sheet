//
//  ListContentsViewController.swift
//  Sheeeeeeeeet
//
//  Created by NAVER on 2018. 9. 29..
//  Copyright © 2018년 GwangBeom. All rights reserved.
//

import UIKit
import Sheet

struct ListItem {
    let image: UIImage?
    let title: String
}

class ListContentsViewController: SheetContentsViewController {
    
    var items: [ListItem] = [
        ListItem(image: nil, title: "Like"),
        ListItem(image: nil, title: "Add to mylist"),
        ListItem(image: nil, title: "Send to Firends"),
        ListItem(image: nil, title: "Report"),
        ListItem(image: nil, title: "Move"),
        ListItem(image: nil, title: "Login"),
        ListItem(image: nil, title: "Loading")
    ]
    
    override var visibleContentsHeight: CGFloat {
        return 320
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // default toolbar custom
        // (sheetToolBar as? UIButton)?.setTitleColor(.green, for: .normal)
    }
    
    override func setupSheetLayout() {
        layout.settings.itemSize = { _ in
            return CGSize(width: UIScreen.main.bounds.width, height: 55)
        }
        layout.sectionInset = UIEdgeInsets(top: 15, left: 0, bottom: 15, right: 0)
    }

    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return items.count
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as? ListCell
        let item = items[indexPath.item]
        cell?.titleLabel.text = item.title
        cell?.itemImageView.image = item.image
        return cell ?? UICollectionViewCell()
    }
    
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if indexPath.item == 1 {
            let vc = UIStoryboard.init(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "MylistViewController")
            navigationController?.pushViewController(vc, animated: true)
        } else if indexPath.item == 2 {
            let vc = UIStoryboard.init(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "SendViewController")
            navigationController?.pushViewController(vc, animated: true)
        } else if indexPath.item == 3 {
            let vc = UIStoryboard.init(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "ReportViewController")
            navigationController?.pushViewController(vc, animated: true)
        } else if indexPath.item == 4 {
            let vc = UIStoryboard.init(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "MoveItemViewController")
            navigationController?.pushViewController(vc, animated: true)
        } else if indexPath.item == 5 {
            let vc = UIStoryboard.init(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "LoginViewController")
            navigationController?.pushViewController(vc, animated: true)
        } else if indexPath.item == 6 {
            let vc = UIStoryboard.init(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "LoadingViewController")
            navigationController?.pushViewController(vc, animated: true)
        } else {
            let item = items[indexPath.item]
            close {
                let alertView = UIAlertView(title: nil, message: "Tapped \(item.title)", delegate: nil, cancelButtonTitle: "Done")
                alertView.show()
            }
        }
    }
}

class ListCell: UICollectionViewCell {
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var itemImageView: UIImageView!
}
