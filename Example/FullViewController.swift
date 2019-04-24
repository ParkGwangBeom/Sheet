//
//  FullViewController.swift
//  Example
//
//  Created by ArLupin on 24/04/2019.
//  Copyright © 2019 Interactive. All rights reserved.
//

import UIKit
import Sheet

class FullViewController: UIViewController, SheetContent {

    @IBOutlet weak var scrollView: UIScrollView!
    
    var topMargin: CGFloat = 0
    
    var isToolBarHidden: Bool {
        return false
    }
    
    var visibleContentsHeight: CGFloat {
        return UIScreen.main.bounds.height
    }
    
    var contentScrollView: UIScrollView {
        return scrollView
    }
}
