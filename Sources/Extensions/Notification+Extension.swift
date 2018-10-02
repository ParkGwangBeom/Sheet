//
//  Notification+Extension.swift
//  Example
//
//  Created by Gwangbeom on 2018. 10. 1..
//  Copyright © 2018년 Interactive. All rights reserved.
//

import UIKit

extension Notification {
    
    func keyboardAnimation(_ animations: @escaping (CGSize) -> Void, completion: @escaping (Bool, CGSize) -> Void) {
        let duration = userInfo?[UIKeyboardAnimationDurationUserInfoKey] as? TimeInterval ?? 0
        let curve = userInfo?[UIKeyboardAnimationCurveUserInfoKey] as? UInt ?? 0
        let keyboardRect = userInfo?[UIKeyboardFrameEndUserInfoKey] as? CGRect ?? .zero
        
        UIView.animate(withDuration: duration, delay: 0, options: UIViewAnimationOptions(rawValue: curve), animations: {
            animations(keyboardRect.size)
        }, completion: { flag in
            completion(flag, keyboardRect.size)
        })
    }
}
