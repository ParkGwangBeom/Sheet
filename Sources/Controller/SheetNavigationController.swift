//
//  SheetNavigationController.swift
//  Sheeeeeeeeet
//
//  Created by Gwangbeom on 2018. 9. 27..
//  Copyright © 2018년 GwangBeom. All rights reserved.
//

import UIKit

public class SheetNavigationController: UINavigationController {
    
    private var options: SheetOptions {
        return SheetManager.shared.options
    }
    
    private var animationItem: AnimationItem {
        return SheetManager.shared.animationOption.presentAnimationItem
    }

    /// Height constraints of the Sheet Toolbar
    public var toolBarHeightConstraint: NSLayoutConstraint?
    
    /// Bottom constraints of the Sheet Toolbar
    public var toolBarBottomConstraint: NSLayoutConstraint?
    
    /// A block that will be run after the `SheetNavigationController` has been dismissed
    public var onDismissed: (() -> Void)?
    
    private var backgroundView: UIView?
    var sheetToolBarContainerView: UIView?
    private var topMargins: [CGFloat] = []
    
    public override init(rootViewController: UIViewController) {
        guard let rootViewController = rootViewController as? SheetContentsViewController else {
            fatalError("rootViewController is not a SheetContentsViewController")
        }
        super.init(rootViewController: rootViewController)
    }
    
    public override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
    }
    
    required public init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    public override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
    }

    
    private var isFirstCall: Bool = false
    public override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        let rootViewController = viewControllers.first as? SheetContentsViewController
        rootViewController?.reload()
        let contentSize = rootViewController?.collectionView?.contentSize ?? .zero
        let visibleContentsHeight = rootViewController?.visibleContentsHeight ?? 0
        let visibleHeight = min(contentSize.height, visibleContentsHeight)
        rootViewController?.collectionView?.transform = CGAffineTransform(translationX: 0, y: visibleHeight + options.sheetToolBarHeight)
        sheetToolBarContainerView?.transform = CGAffineTransform(translationX: 0, y: SheetManager.shared.options.sheetToolBarHeight + UIEdgeInsets.safeAreaInsets.bottom)
        
        
        UIView.animate(withDuration: animationItem.duration, delay: 0, usingSpringWithDamping: animationItem.springDumping, initialSpringVelocity: animationItem.initialSpringVelocity, options: animationItem.options, animations: {
            rootViewController?.collectionView?.transform = .identity
        }, completion: nil)
        
        UIView.animate(withDuration: 0.3, animations: {
            self.backgroundView?.alpha = 1
            self.sheetToolBarContainerView?.transform = .identity
        }) { _ in
            self.isFirstCall = true
        }
    }

    public override var prefersStatusBarHidden: Bool {
        return presentingViewController?.prefersStatusBarHidden ?? false
    }
    
    public override func pushViewController(_ viewController: UIViewController, animated: Bool) {
        guard viewController is SheetContent else {
            fatalError("viewController is not a SheetContentsViewController")
        }
        super.pushViewController(viewController, animated: animated)
    }
    
    public override func popViewController(animated: Bool) -> UIViewController? {
        if let contentsViewController = currentContentsViewController {
            let originY = contentsViewController.collectionView?.frame.origin.y ?? 0
            contentsViewController.topMargin = max(contentsViewController.topMargin + originY, 0)
        }
        return super.popViewController(animated: animated)
    }

    func close(duration: TimeInterval = 0.2, completion: (() -> Void)? = nil) {
        let contentsViewController = viewControllers.last
        contentsViewController?.view.isHidden = true
        
        let topMargin = (contentsViewController as? SheetContent)?.topMargin ?? 0
        let snapShot = contentsViewController?.view.snapshotView(afterScreenUpdates: false) ?? UIView()
        snapShot.frame = view.bounds
        
        view.insertSubview(snapShot, at: 2)

        UIView.animateKeyframes(withDuration: duration, delay: 0, options: [.calculationModeLinear], animations: {
            UIView.addKeyframe(withRelativeStartTime: 0, relativeDuration: 1) {
                let diff = UIScreen.main.bounds.height - topMargin
                snapShot.transform = CGAffineTransform(translationX: 0, y: diff)
                self.backgroundView?.alpha = 0
                self.presentingViewController?.view.transform = .identity
            }
            
            UIView.addKeyframe(withRelativeStartTime: 0.6, relativeDuration: 0.4) {
                self.sheetToolBarContainerView?.transform = CGAffineTransform(translationX: 0, y: self.options.sheetToolBarHeight + UIEdgeInsets.safeAreaInsets.bottom)
            }
        }) { _ in
            snapShot.removeFromSuperview()
            self.dismiss(animated: false) {
                self.onDismissed?()
                completion?()
            }
        }
    }
    
    func controlToolBar(isShow: Bool, animated: Bool) {
        let bottomConstraint = isShow ? 0 : SheetManager.shared.options.sheetToolBarHeight + UIEdgeInsets.safeAreaInsets.bottom
        if animated {
            UIView.animate(withDuration: 0.4, delay: 0, usingSpringWithDamping: 0.75, initialSpringVelocity: 1, options: [.curveEaseOut], animations: {
                self.toolBarBottomConstraint?.constant = bottomConstraint
                self.view.layoutIfNeeded()
            }) { _ in
            }
        } else {
            self.toolBarBottomConstraint?.constant = bottomConstraint
        }
    }
}

extension SheetNavigationController {
    
    public var currentContentsViewController: SheetContentsViewController? {
        return viewControllers.last as? SheetContentsViewController
    }
}

private extension SheetNavigationController {

    func setupViews() {
        view.backgroundColor = .clear
        setupNavigation()
        setupBackgroundView()
        setupSheetToolBarContainerView()
    }
    
    func setupNavigation() {
        delegate = self
        transitioningDelegate = self
        isNavigationBarHidden = true
        modalPresentationStyle = .overFullScreen
    }
    
    func setupBackgroundView() {
        let backgroundView = UIView(frame: UIScreen.main.bounds)
        backgroundView.alpha = 0
        backgroundView.backgroundColor = options.dimmingViewBackgroundColor
        view.insertSubview(backgroundView, at: 0)
        self.backgroundView = backgroundView
    }

    func setupSheetToolBarContainerView() {
        guard !options.isToolBarHidden else {
            return
        }
        let containerView = UIView()
        containerView.backgroundColor = options.defaultToolBarBackgroundColor
        containerView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(containerView)
        containerView.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        containerView.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        toolBarHeightConstraint = containerView.heightAnchor.constraint(equalToConstant: UIEdgeInsets.safeAreaInsets.bottom + options.sheetToolBarHeight)
        toolBarHeightConstraint?.isActive = true
        toolBarBottomConstraint = containerView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        toolBarBottomConstraint?.isActive = true
        self.sheetToolBarContainerView = containerView
    }
    
    @objc
    func tappedDefaultButton() {
        if viewControllers.count == 1 {
            close()
        } else {
            _ = popViewController(animated: true)
        }
    }
    
    func updateSheetToolBar(toolBarView: UIView?) {
        var toolBarTemp = toolBarView
        if toolBarTemp == nil {
            let closeButton = UIButton(type: .system)
            let title = viewControllers.count == 1 ? options.defaultToolBarItem.defaultCloseTitle : options.defaultToolBarItem.defaultBackTitle
            closeButton.setTitle(title, for: .normal)
            closeButton.titleLabel?.font = options.defaultToolBarItem.font
            closeButton.setTitleColor(options.defaultToolBarItem.titleColor, for: .normal)
            closeButton.addTarget(self, action: #selector(tappedDefaultButton), for: .touchUpInside)
            
            if !options.defaultToolBarItem.isLineHidden {
                let border = CALayer()
                border.backgroundColor = options.defaultToolBarItem.lineColor.cgColor
                border.frame = CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: 0.5)
                closeButton.layer.addSublayer(border)
            }
            
            toolBarTemp = closeButton
        }
        
        guard let containerView = sheetToolBarContainerView, let toolBar = toolBarTemp else {
            return
        }
        
        // TODO: Custom Transition...
        toolBar.backgroundColor = options.defaultToolBarBackgroundColor
        toolBar.translatesAutoresizingMaskIntoConstraints = false
        toolBar.alpha = 0
        containerView.addSubview(toolBar)
        toolBar.heightAnchor.constraint(equalToConstant: options.sheetToolBarHeight).isActive = true
        toolBar.topAnchor.constraint(equalTo: containerView.topAnchor).isActive = true
        toolBar.leadingAnchor.constraint(equalTo: containerView.leadingAnchor).isActive = true
        toolBar.trailingAnchor.constraint(equalTo: containerView.trailingAnchor).isActive = true
        
        UIView.animate(withDuration: 0.25, animations: {
            toolBar.alpha = 1
        }) { _ in
            if containerView.subviews.count > 1 {
                containerView.subviews.first?.removeFromSuperview()
            }
        }
    }
}

extension SheetNavigationController: UIViewControllerTransitioningDelegate {
    
    open func animationController(forPresented presented: UIViewController, presenting: UIViewController, source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        return options.presentTransitionType.animator(present: true)
    }
    
    open func animationController(forDismissed dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        return nil
    }
}

extension SheetNavigationController: UINavigationControllerDelegate {
    
    public func navigationController(_ navigationController: UINavigationController, willShow viewController: UIViewController, animated: Bool) {
        let sheetContent = viewController as? SheetContent
        if sheetContent?.isToolBarHidden ?? false {
            let isRootViewController = viewController == viewControllers.first
            if isRootViewController  {
                self.toolBarBottomConstraint?.constant = SheetManager.shared.options.sheetToolBarHeight + UIEdgeInsets.safeAreaInsets.bottom
                self.view.layoutIfNeeded()
            } else {
                controlToolBar(isShow: false, animated: true)
//                UIView.animate(withDuration: 0.4, delay: 0, usingSpringWithDamping: 0.75, initialSpringVelocity: 1, options: [.curveEaseOut], animations: {
//                    self.toolBarBottomConstraint?.constant = SheetManager.shared.options.sheetToolBarHeight + UIEdgeInsets.safeAreaInsets.bottom
//                    self.view.layoutIfNeeded()
//                }) { _ in
//
//                }
            }
        } else {
            updateSheetToolBar(toolBarView: sheetContent?.sheetToolBar)
            if isFirstCall {
                controlToolBar(isShow: true, animated: true)
//                UIView.animate(withDuration: 0.4, delay: 0, usingSpringWithDamping: 0.75, initialSpringVelocity: 1, options: [.curveEaseOut], animations: {
//                    self.toolBarBottomConstraint?.constant = 0
//                    self.view.layoutIfNeeded()
//                }) { _ in
//
//                }
            }
        }
    }

    public func navigationController(_ navigationController: UINavigationController, animationControllerFor operation: UINavigationController.Operation, from fromVC: UIViewController, to toVC: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        
        toVC.view.layoutIfNeeded()

        let fromTopMargin: CGFloat = (fromVC as? SheetContent)?.topMargin ?? 0
        var toTopMargin: CGFloat = (toVC as? SheetContent)?.topMargin ?? 0

        if operation == .push {
            topMargins.append(fromTopMargin)
        } else {
            toTopMargin = topMargins.removeLast()
        }

        let animator = SheetFadeAnimator(to: toTopMargin, from: fromTopMargin)
        animator.isPush = operation == .push
        animator.onReady = { }
        animator.onComplete = {
            fromVC.view.alpha = 1
        }
        return animator
    }
}
