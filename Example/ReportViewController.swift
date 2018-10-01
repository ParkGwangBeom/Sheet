//
//  ReportViewController.swift
//  Sheeeeeeeeet
//
//  Created by NAVER on 2018. 10. 1..
//  Copyright © 2018년 GwangBeom. All rights reserved.
//

import UIKit
import Sheet

class ReportViewController: SheetContentsViewController {
    
    var items: [String] = [
        "This is off list",
        "This list has intrusive advertising",
        "This infringes on intellectual property rights",
        "This is offensive or abusive",
        "This is sexually explicit",
        "This is otherwise objectionable"
    ]

    override var visibleContentsHeight: CGFloat {
        return 1000
    }
    
    override func setupSheetLayout() {
        layout.settings.itemSize = { indexPath in
            let height: CGFloat = indexPath.section == 0 ? 90 : 50
            return CGSize(width: UIScreen.main.bounds.width, height: height)
        }
        layout.sectionInset.bottom = 15
    }
    
    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 2
    }
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if section == 0 {
            return 1
        }
        return items.count
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if indexPath.section == 0 {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "title", for: indexPath)
            return cell
        }
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as? ReportCell
        cell?.reportLabel.text = items[indexPath.item]
        return cell ?? UICollectionViewCell()
    }
    
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        close()
    }
    
    @IBAction func tappedBackButton(_ sender: Any) {
        navigationController?.popViewController(animated: true)
    }
    
    @IBAction func tappedDoneButton(_ sender: Any) {
        close()
    }
}

class ReportCell: UICollectionViewCell {
    @IBOutlet weak var reportLabel: UILabel!
}
