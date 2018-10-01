//
//  SheetNavigationController.swift
//  Sheeeeeeeeet
//
//  Created by NAVER on 2018. 9. 27..
//  Copyright © 2018년 GwangBeom. All rights reserved.
//

import UIKit

public class SheetNavigationController: UINavigationController {
    
    private var options: SheetOptions {
        return SheetManager.shared.options
    }

    /// Height constraints of the Sheet Toolbar
    public var toolBarHeightConstraint: NSLayoutConstraint?
    
    /// Bottom constraints of the Sheet Toolbar
    public var toolBarBottomConstraint: NSLayoutConstraint?
    
    private var backgroundView: UIView?
    private var sheetToolBarContainerView: UIView?
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

    public override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        let rootViewController = viewControllers.first as? SheetContentsViewController
        let visibleHeight = min(rootViewController?.collectionView?.contentSize.height ?? 0, rootViewController?.visibleContentsHeight ?? 0)
        rootViewController?.collectionView?.transform = CGAffineTransform(translationX: 0, y: visibleHeight + options.sheetToolBarHeight)
        sheetToolBarContainerView?.transform = CGAffineTransform(translationX: 0, y: SheetManager.shared.options.sheetToolBarHeight + UIEdgeInsets.safeAreaInsets.bottom)
        
        UIView.animate(withDuration: 0.4, delay: 0, usingSpringWithDamping: 0.8, initialSpringVelocity: 1, options: [.curveEaseOut], animations: {
            rootViewController?.collectionView?.transform = .identity
        }, completion: nil)
        
        UIView.animate(withDuration: 0.2) {
            self.backgroundView?.alpha = 1
            self.sheetToolBarContainerView?.transform = .identity
        }
    }

    public override var prefersStatusBarHidden: Bool {
        return presentingViewController?.prefersStatusBarHidden ?? false
    }
    
    public override func pushViewController(_ viewController: UIViewController, animated: Bool) {
        guard viewController is SheetContentsViewController else {
            fatalError("viewController is not a SheetContentsViewController")
        }
        super.pushViewController(viewController, animated: animated)
    }
    
    public override func dismiss(animated flag: Bool, completion: (() -> Void)? = nil) {
        fatalError("Use close(duration:completion:)")
    }
    
    public func close(duration: TimeInterval = 0.2, completion: (() -> Void)? = nil) {
        let contentsViewController = viewControllers.last as? SheetContentsViewController
        contentsViewController?.view.isHidden = true
        
        let topMargin = contentsViewController?.topMargin ?? 0
        let snapShot = contentsViewController?.view.snapshotView(afterScreenUpdates: false) ?? UIView()
        snapShot.frame = view.bounds
        
        view.insertSubview(snapShot, at: 2)
        
        UIView.animate(withDuration: duration, animations: {
            let diff = UIScreen.main.bounds.height - topMargin
            snapShot.transform = CGAffineTransform(translationX: 0, y: diff)
            self.backgroundView?.alpha = 0
            self.sheetToolBarContainerView?.transform = CGAffineTransform(translationX: 0, y: self.options.sheetToolBarHeight + UIEdgeInsets.safeAreaInsets.bottom)
            self.presentingViewController?.view.transform = .identity
        }) { _ in
            snapShot.removeFromSuperview()
            self.dismiss(animated: false, completion: completion)
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
        modalTransitionStyle = .crossDissolve
    }
    
    func setupBackgroundView() {
        let backgroundView = UIView(frame: UIScreen.main.bounds)
        backgroundView.alpha = 0
        backgroundView.backgroundColor = options.dimmingViewBackgroundColor
        view.insertSubview(backgroundView, at: 0)
        self.backgroundView = backgroundView
    }

    func setupSheetToolBarContainerView() {
        guard !options.isSheetToolBarHidden else {
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
    
    func updateSheetToolBar(toolBar: UIView?) {
        guard let containerView = sheetToolBarContainerView, let toolBar = toolBar else {
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
        let viewController = viewController as? SheetContentsViewController
        updateSheetToolBar(toolBar: viewController?.sheetToolBar)
    }

    public func navigationController(_ navigationController: UINavigationController, animationControllerFor operation: UINavigationControllerOperation, from fromVC: UIViewController, to toVC: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        
        let from = fromVC as? SheetContentsViewController
        let to = toVC as? SheetContentsViewController
        to?.view.layoutIfNeeded()

        let fromTopMargin: CGFloat = from?.topMargin ?? 0
        var toTopMargin: CGFloat = to?.topMargin ?? 0

        if operation == .push {
            topMargins.append(fromTopMargin)
        } else {
            toTopMargin = topMargins.removeLast()
        }
       
        let animator = SheetFadeAnimator(to: toTopMargin, from: fromTopMargin)
        animator.isPush = operation == .push
        animator.onReady = { }
        animator.onComplete = {
            from?.collectionView?.alpha = 1
        }
        return animator
    }
}
