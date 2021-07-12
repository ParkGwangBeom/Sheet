//
//  SheetContentsViewController.swift
//  Sheeeeeeeeet
//
//  Created by Gwangbeom on 2018. 9. 29..
//  Copyright © 2018년 GwangBeom. All rights reserved.
//

import UIKit

open class SheetContentsViewController: UICollectionViewController, SheetContent {
    
    private var options: SheetOptions {
        return SheetManager.shared.options
    }

    private var layout = SheetContentsLayout()
    
    public var topMargin: CGFloat = 0

    public var contentScrollView: UIScrollView {
        return collectionView
    }
    
    open var isFullScreenContent: Bool {
        return false
    }
    
    /// Sheet ToolBar hide property. Defaults to false
    open var isToolBarHidden: Bool {
        return options.isToolBarHidden
    }

    /// Sheet visible contents height. If contentSize height is less than visibleContentsHeight, contentSize height is applied.
    open var visibleContentsHeight: CGFloat {
        return SheetManager.shared.options.defaultVisibleContentHeight
    }
    
    open var sheetToolBar: UIView? {
        return nil
    }
    
    open override func viewDidLoad() {
        super.viewDidLoad()
        registCollectionElement()
        setupSheetLayout(layout)
        setupViews()
    }

    /// Give CollectionView a chance to regulate Supplementray Element
    open func registCollectionElement() {

    }
    
    /// Provide an opportunity to set default settings for collectionview custom layout
    open func setupSheetLayout(_ layout: SheetContentsLayout) {
        
    }

    open override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        fatalError("Implement with override as required")
    }
    
    open override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        fatalError("Implement with override as required")
    }

    open override func scrollViewDidScroll(_ scrollView: UIScrollView) {
        topMargin = max(layout.settings.topMargin - scrollView.contentOffset.y, 0)
    }
    
    open override func scrollViewWillEndDragging(_ scrollView: UIScrollView, withVelocity velocity: CGPoint, targetContentOffset: UnsafeMutablePointer<CGPoint>) {
        let velocity = scrollView.panGestureRecognizer.velocity(in: nil)
        if scrollView.contentOffset.y <= -10 && velocity.y >= 400 {
            let diff = UIScreen.main.bounds.height - topMargin
            let duration = min(0.3, diff / velocity.y)
            sheetNavigationController?.close(duration: TimeInterval(duration))
        }
    }
    
    open override func dismiss(animated flag: Bool, completion: (() -> Void)? = nil) {
        if sheetNavigationController == nil {
            super.dismiss(animated: flag, completion: completion)
        } else {
            sheetNavigationController?.close(completion: completion)
        }
    }
}

extension SheetContentsViewController {
    
    public var sheetNavigationController: SheetNavigationController? {
        return navigationController as? SheetNavigationController
    }
    
    public var isRootViewController: Bool {
        return self == navigationController?.viewControllers.first
    }
    
    public func reload() {
        let before = topMargin
        setupSheetLayout(layout)
        collectionView?.reloadData()
        updateTopMargin()
        collectionView?.collectionViewLayout.invalidateLayout()
        let after = topMargin
        let diff = before - after
        
        collectionView?.transform = CGAffineTransform(translationX: 0, y: diff)
        
        UIView.animate(withDuration: 0.4, delay: 0, usingSpringWithDamping: 0.8, initialSpringVelocity: 1, options: [.curveLinear], animations: {
            self.collectionView?.transform = .identity
        }, completion: nil)
    }
}

// MARK: Views
private extension SheetContentsViewController {

    func setupViews() {
        view.backgroundColor = .clear
        setupContainerView()
        setupDimmingView()
    }
    
    func setupContainerView() {
        let bottomToolBarHeight: CGFloat = isToolBarHidden ? UIEdgeInsets.safeAreaInsets.bottom : SheetManager.shared.options.sheetToolBarHeight + UIEdgeInsets.safeAreaInsets.bottom
        
        collectionView?.delaysContentTouches = true
        collectionView?.collectionViewLayout.invalidateLayout()
        collectionView?.setCollectionViewLayout(layout, animated: false)
        collectionView?.delegate = self
        collectionView?.dataSource = self
        collectionView?.alwaysBounceVertical = true
        collectionView?.showsVerticalScrollIndicator = false
        collectionView?.contentInset.bottom = bottomToolBarHeight
        collectionView?.backgroundColor = .clear
        if #available(iOS 11.0, *) {
            collectionView?.contentInsetAdjustmentBehavior = .never
        }
        updateTopMargin()
    }
    
    func updateTopMargin() {
        let bottomToolBarHeight: CGFloat = isToolBarHidden ? UIEdgeInsets.safeAreaInsets.bottom : SheetManager.shared.options.sheetToolBarHeight + UIEdgeInsets.safeAreaInsets.bottom
        collectionView?.layoutIfNeeded()
        
        let screenHeight = UIScreen.main.bounds.height
        let contentHeight = collectionView?.contentSize.height ?? 0
        let visibleHeight = min(contentHeight - layout.settings.topMargin, visibleContentsHeight)
        
        topMargin = isFullScreenContent ? 0 : max(screenHeight - layout.settings.minTopMargin - visibleHeight - bottomToolBarHeight, 0)
        layout.settings.topMargin = topMargin
    }

    func setupDimmingView() {
        let dimmingButton = UIButton(frame: CGRect(x: 0, y: 0, width: view.bounds.width, height: topMargin))
        dimmingButton.backgroundColor = .clear
        dimmingButton.addTarget(self, action: #selector(tappedBackground), for: .touchUpInside)
        collectionView?.insertSubview(dimmingButton, at: 0)
    }
}

// MARK: Events
private extension SheetContentsViewController {
    
    @objc
    func tappedBackground() {
        sheetNavigationController?.close()
    }
    
    @objc
    func tappedDefaultButton() {
        if isRootViewController {
            sheetNavigationController?.close()
        } else {
            navigationController?.popViewController(animated: true)
        }
    }
}

public protocol SheetContent {
    
    var topMargin: CGFloat { get set }
    
    var isToolBarHidden: Bool { get }

    var visibleContentsHeight: CGFloat { get }
    
    var sheetToolBar: UIView? { get }
}

public extension SheetContent {
    
    var topMargin: CGFloat {
        get { return 0 }
        set {}
    }
    
    var isToolBarHidden: Bool { return SheetManager.shared.options.isToolBarHidden }
    
    var sheetToolBar: UIView? { return nil }
    
    var visibleContentsHeight: CGFloat { return SheetManager.shared.options.defaultVisibleContentHeight }

}

extension SheetContent where Self: UIViewController {
    
    public func controlToolBar(isShow: Bool, animated: Bool) {
        let sheetNavi = navigationController as? SheetNavigationController
        sheetNavi?.controlToolBar(isShow: isShow, animated: animated)
    }
}
