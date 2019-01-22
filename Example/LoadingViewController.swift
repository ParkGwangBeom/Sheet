//
//  LoadingViewController.swift
//  Sheeeeeeeeet
//
//  Created by Gwangbeom on 2018. 10. 1..
//  Copyright © 2018년 GwangBeom. All rights reserved.
//

import UIKit
import Sheet

enum LoadingState {
    case loading
    case finish
}

class LoadingViewController: SheetContentsViewController {
    
    var items: [String] = [
        "Interactive (Organization)",
        "Windless",
        "TransitionableTab",
        "ISPageControl"
    ]

    var loaingState: LoadingState = .loading {
        didSet {
            let cell = collectionView?.cellForItem(at: IndexPath(item: 0, section: 0)) as? LaodingCell
            switch loaingState {
            case .loading:
                cell?.indicator.startAnimating()
            case .finish:
                cell?.indicator.stopAnimating()
                reload()
            }
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        self.loaingState = .loading
        DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
            self.loaingState = .finish
        }
    }
    
    override func registCollectionElement() {
        let nib = UINib(nibName: "TitleHeaderView", bundle: nil)
        collectionView?.register(nib, forSupplementaryViewOfKind: SheetLayoutElement.header.kind, withReuseIdentifier: SheetLayoutElement.header.id)
    }
    
    override func setupSheetLayout(_ layout: SheetContentsLayout) {
        layout.settings.itemSize = { [weak self] _ in
            let height: CGFloat = self?.loaingState == .loading ? 150 : 61
            return CGSize(width: UIScreen.main.bounds.width, height: height)
        }
        layout.settings.sectionHeaderSize = { _ in
            return CGSize(width: UIScreen.main.bounds.width, height: 30)
        }
        layout.sectionInset = UIEdgeInsets(top: 0, left: 0, bottom: 30, right: 0)
        layout.settings.headerSize = CGSize(width: UIScreen.main.bounds.width, height: 60)
    }
    
    override var visibleContentsHeight: CGFloat {
        return 350 + 41
    }
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return loaingState == .loading ? 1 : items.count
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if loaingState == .loading {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as? LaodingCell
            return cell ?? UICollectionViewCell()
        } else {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "text", for: indexPath) as? ReportCell
            cell?.reportLabel.text = items[indexPath.item]
            return cell ?? UICollectionViewCell()
        }
    }
    
    override func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        switch kind {
        case UICollectionView.elementKindSectionHeader:
            let headerView = collectionView.dequeueReusableSupplementaryView(
                ofKind: kind,
                withReuseIdentifier: "header",
                for: indexPath)
            return headerView
        case SheetLayoutElement.header.kind:
            let headerView = collectionView.dequeueReusableSupplementaryView(
                ofKind: kind,
                withReuseIdentifier: SheetLayoutElement.header.id,
                for: indexPath) as? TitleHeaderView
            headerView?.titleLabel.text = "LOADING"
            return headerView ?? UICollectionReusableView()
        default: return UICollectionReusableView()
        }
    }
    
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if indexPath.item == 0 {
            let url = URL(string: "https://github.com/Interactive-Studio")
            UIApplication.shared.open(url!, options: [:], completionHandler: nil)
        } else if indexPath.item == 1 {
            let url = URL(string: "https://github.com/Interactive-Studio/Windless")
            UIApplication.shared.open(url!, options: [:], completionHandler: nil)
            
        } else if indexPath.item == 2 {
            let url = URL(string: "https://github.com/Interactive-Studio/TransitionableTab")
            UIApplication.shared.open(url!, options: [:], completionHandler: nil)
        } else {
            let url = URL(string: "https://github.com/Interactive-Studio/ISPageControl")
            UIApplication.shared.open(url!, options: [:], completionHandler: nil)
        }
    }
}

class LaodingCell: UICollectionViewCell {
    @IBOutlet weak var indicator: UIActivityIndicatorView!
}
