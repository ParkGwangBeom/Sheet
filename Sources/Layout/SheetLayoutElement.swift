//
//  LayoutElement.swift
//  Example
//
//  Created by NAVER on 2018. 10. 1..
//  Copyright © 2018년 Interactive. All rights reserved.
//

import Foundation

/**ㅇ
 ContentsView layout elements
 */
public enum SheetLayoutElement: String {
    case header
    case footer
    case cell
    case sectionHeader
    case sectionFooter
    
    public var id: String {
        return self.rawValue
    }
    
    public var kind: String {
        return "Kind\(self.rawValue.capitalized)"
    }
}
