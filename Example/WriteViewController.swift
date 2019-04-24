//
//  WriteViewController.swift
//  Sheeeeeeeeet
//
//  Created by Gwangbeom on 2018. 9. 30..
//  Copyright © 2018년 GwangBeom. All rights reserved.
//

import UIKit
import Sheet

class WriteViewController: SheetContentsViewController {
    
    @IBOutlet weak var customToolBar: UIView!
    
    override var visibleContentsHeight: CGFloat {
        return 370
    }
    
    override var sheetToolBar: UIView? {
        return customToolBar
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        registNotifications()
    }

    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    override func setupSheetLayout(_ layout: SheetContentsLayout) {
        layout.settings.itemSize = { _ in
            return CGSize(width: UIScreen.main.bounds.width, height: 220)
        }
    }

    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 1
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath)
        return cell
    }
    
    @IBAction func tappedBackButton(_ sender: Any) {
        navigationController?.popViewController(animated: true)
    }
    
    @IBAction func tappedDoneButton(_ sender: Any) {
        dismiss(animated: true)
    }
}

extension WriteViewController {
    
    func registNotifications() {
        NotificationCenter.default.addObserver(self, selector: #selector(willShowKeyboard), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(willHideKeyboard), name: UIResponder.keyboardWillHideNotification, object: nil)
    }

    @objc
    func willShowKeyboard(notification: Notification) {
        notification.keyboardAnimation({ [weak self] size in
            self?.collectionView?.frame.origin.y = -size.height
            self?.sheetNavigationController?.toolBarBottomConstraint?.constant -= size.height
            self?.sheetNavigationController?.toolBarHeightConstraint?.constant = SheetManager.shared.options.sheetToolBarHeight
            self?.sheetNavigationController?.view.layoutIfNeeded()
        }, completion: nil)
    }
    
    @objc
    func willHideKeyboard(notification: Notification) {
        notification.keyboardAnimation({ [weak self] size in
            self?.collectionView?.frame.origin.y += size.height
            self?.sheetNavigationController?.toolBarBottomConstraint?.constant += size.height
            self?.sheetNavigationController?.toolBarHeightConstraint?.constant = self?.collectionView?.contentInset.bottom ?? 0
            self?.sheetNavigationController?.view.layoutIfNeeded()
        }, completion: nil)
    }
}

class WriteCell: UICollectionViewCell {
    @IBOutlet weak var textField: UITextField!
    @IBOutlet weak var userImageView: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        userImageView.layer.cornerRadius = 35 / 2
    }
}

extension Notification {
    
    func keyboardAnimation(_ animations: @escaping (CGSize) -> Void, completion: ((Bool, CGSize) -> Void)?) {
        let duration = userInfo?[UIResponder.keyboardAnimationDurationUserInfoKey] as? TimeInterval ?? 0
        let curve = userInfo?[UIResponder.keyboardAnimationCurveUserInfoKey] as? UInt ?? 0
        let keyboardRect = userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? CGRect ?? .zero
        
        UIView.animate(withDuration: duration, delay: 0, options: UIView.AnimationOptions(rawValue: curve), animations: {
            animations(keyboardRect.size)
        }, completion: { flag in
            completion?(flag, keyboardRect.size)
        })
    }
}
