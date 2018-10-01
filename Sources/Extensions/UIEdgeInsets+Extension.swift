//
//  UIEdgeInsets+Extension.swift
//  Example
//
//  Created by NAVER on 2018. 10. 1..
//  Copyright © 2018년 Interactive. All rights reserved.
//

import UIKit

extension UIEdgeInsets {
    
    static var safeAreaInsets: UIEdgeInsets {
        guard #available(iOS 11.0, *) else {
            return .zero
        }
        return UIApplication.shared.delegate?.window?.value?.safeAreaInsets ?? .zero
    }
}
