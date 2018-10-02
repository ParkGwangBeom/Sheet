//
//  LoginViewController.swift
//  Sheeeeeeeeet
//
//  Created by Gwangbeom on 2018. 10. 1..
//  Copyright © 2018년 GwangBeom. All rights reserved.
//

import UIKit
import Sheet

struct LoginMenu {
    let image: UIImage?
    let color: UIColor
}

class LoginViewController: SheetContentsViewController {
    
    var items: [LoginMenu] = [
        LoginMenu(image: #imageLiteral(resourceName: "twitter"), color: #colorLiteral(red: 0.2588235438, green: 0.7568627596, blue: 0.9686274529, alpha: 1)),
        LoginMenu(image: #imageLiteral(resourceName: "facebook"), color: #colorLiteral(red: 0.2196078449, green: 0.007843137719, blue: 0.8549019694, alpha: 1)),
        LoginMenu(image: #imageLiteral(resourceName: "google"), color: #colorLiteral(red: 0.9372549057, green: 0.3490196168, blue: 0.1921568662, alpha: 1)),
        LoginMenu(image: #imageLiteral(resourceName: "email"), color: #colorLiteral(red: 0.7450980544, green: 0.1568627506, blue: 0.07450980693, alpha: 1))
    ]
    
    override var visibleContentsHeight: CGFloat {
        return 600
    }
    
    override func registCollectionElement() {
        let nib = UINib(nibName: "DescriptionFooterView", bundle: nil)
        collectionView?.register(nib, forSupplementaryViewOfKind: SheetLayoutElement.footer.kind, withReuseIdentifier: SheetLayoutElement.footer.id)
    }
    
    override func setupSheetLayout() {
        layout.settings.itemSize = { _ in
            return CGSize(width: UIScreen.main.bounds.width, height: 60)
        }
        layout.sectionInset = UIEdgeInsets(top: 35, left: 0, bottom: 15, right: 0)
        layout.minimumLineSpacing = 7
        layout.settings.footerSize = CGSize(width: UIScreen.main.bounds.width, height: 45)
    }

    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return items.count
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as? LoginMenuCell
        let item = items[indexPath.item]
        cell?.loginButton.setImage(item.image, for: .normal)
        cell?.loginButton.backgroundColor = item.color
        return cell ?? UICollectionViewCell()
    }
    
    override func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        switch kind {
        case SheetLayoutElement.footer.kind:
            let footerView = collectionView.dequeueReusableSupplementaryView(
                ofKind: kind,
                withReuseIdentifier: SheetLayoutElement.footer.id,
                for: indexPath) as? DescriptionFooterView
            return footerView ?? UICollectionReusableView()
        default: return UICollectionReusableView()
        }
    }
    
    @IBAction func tappedLogin(_ sender: Any) {
        close()
    }
}

class LoginMenuCell: UICollectionViewCell {
    @IBOutlet weak var loginButton: UIButton!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        loginButton.layer.cornerRadius = 3
    }
}
