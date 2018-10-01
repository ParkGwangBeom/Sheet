//
//  SheetContentsViewController.swift
//  Sheeeeeeeeet
//
//  Created by NAVER on 2018. 9. 29..
//  Copyright © 2018년 GwangBeom. All rights reserved.
//

import UIKit

open class SheetContentsViewController: UICollectionViewController {

    private var options: SheetOptions {
        return SheetManager.shared.options
    }
    
    public var topMargin: CGFloat = 0
    
    public lazy var sheetToolBar: UIView = {
        let closeButton = UIButton(type: .system)
        let title = isRootViewController ? "Close" : "Back"
        closeButton.setTitle(title, for: .normal)
        closeButton.titleLabel?.font = options.defaultToolBarItem.font
        closeButton.setTitleColor(options.defaultToolBarItem.titleColor, for: .normal)
        closeButton.addTarget(self, action: #selector(tappedClose), for: .touchUpInside)
        return closeButton
    }()

    public var layout: SheetContentsLayout = SheetContentsLayout()
    
    open var visibleContentsHeight: CGFloat {
        return SheetManager.shared.options.defaultVisibleContentHeight
    }
    
    open override func viewDidLoad() {
        super.viewDidLoad()
        registCollectionElement()
        setupSheetLayout()
        setupViews()
    }

    /// Exists to regist the Elements of CollectionView
    open func registCollectionElement() {

    }
    
    /// Layout settings
    open func setupSheetLayout() {
        
    }

    @objc
    public func close(completion: (() -> Void)? = nil) {
        sheetNavigationController?.close(completion: completion)
    }
    
    @objc
    func tappedClose() {
        if isRootViewController {
            sheetNavigationController?.close()
        } else {
            navigationController?.popViewController(animated: true)
        }
    }
    
    open override func dismiss(animated flag: Bool, completion: (() -> Void)? = nil) {
        fatalError("Use close(duration:completion:)")
    }
    
    open override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        fatalError("Implement with override as required")
    }
    
    open override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        fatalError("Implement with override as required")
    }

    open override func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if let layout = collectionView?.collectionViewLayout as? SheetContentsLayout {
            topMargin = max(layout.settings.topMargin - scrollView.contentOffset.y, 0)
        }
    }
    
    open override func scrollViewWillEndDragging(_ scrollView: UIScrollView, withVelocity velocity: CGPoint, targetContentOffset: UnsafeMutablePointer<CGPoint>) {
        let velocity = scrollView.panGestureRecognizer.velocity(in: nil)
        if scrollView.contentOffset.y <= -10 && velocity.y >= 400 {
            let diff = UIScreen.main.bounds.height - topMargin
            let duration = diff / velocity.y
            sheetNavigationController?.close(duration: TimeInterval(duration))
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
        collectionView?.reloadData()
        updateTopMargin()
        collectionView?.performBatchUpdates({
            self.collectionView?.collectionViewLayout.invalidateLayout()
        }, completion: nil)
    }
}

private extension SheetContentsViewController {

    func setupViews() {
        view.backgroundColor = .clear
        setupContainerView()
        setupDimmingView()
    }
    
    func setupContainerView() {
        let bottomToolBarHeight: CGFloat = SheetManager.shared.options.isSheetToolBarHidden ? UIEdgeInsets.safeAreaInsets.bottom : SheetManager.shared.options.sheetToolBarHeight + UIEdgeInsets.safeAreaInsets.bottom
        
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
        let bottomToolBarHeight: CGFloat = SheetManager.shared.options.isSheetToolBarHidden ? UIEdgeInsets.safeAreaInsets.bottom : SheetManager.shared.options.sheetToolBarHeight + UIEdgeInsets.safeAreaInsets.bottom
        collectionView?.layoutIfNeeded()
        
        let screenHeight = UIScreen.main.bounds.height
        let contentHeight = collectionView?.contentSize.height ?? 0
        let visibleHeight = min(contentHeight - layout.settings.topMargin, visibleContentsHeight)
        
        var headerViewRect: CGRect = .zero
        headerViewRect.size.height = screenHeight - visibleHeight - bottomToolBarHeight
        layout.settings.topMargin = headerViewRect.size.height
        topMargin = headerViewRect.size.height
    }

    func setupDimmingView() {
        let dimmingButton = UIButton(frame: CGRect(x: 0, y: 0, width: view.bounds.width, height: topMargin))
        dimmingButton.backgroundColor = .clear
        dimmingButton.addTarget(self, action: #selector(tappedBackgroundView), for: .touchUpInside)
        collectionView?.addSubview(dimmingButton)
    }
    
    @objc
    func tappedBackgroundView() {
        sheetNavigationController?.close()
    }
}
