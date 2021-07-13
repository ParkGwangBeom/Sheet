//
//  SheetLayoutSettings.swift
//  Sheeeeeeeeet
//
//  Created by Gwangbeom on 2018. 10. 1..
//  Copyright © 2018년 GwangBeom. All rights reserved.
//

import UIKit

public struct SheetLayoutSettings {

    var topMargin: CGFloat = 0

    public var minTopMargin: CGFloat = 0
    
    /// Whether the header view is stiky. Defaults to true
    public var isHeaderStretchy = true
    
    /// Whether the section header view is stiky. Defaults to false
    public var isSectionHeaderStretchy = false
    
    /// header view size
    public var headerSize: CGSize?
    
    /// footer view size
    public var footerSize: CGSize?
    
    /// cell size
    public var itemSize: ((IndexPath) -> CGSize)?
    
    /// section header size
    public var sectionHeaderSize: ((IndexPath) -> CGSize)?
    
    /// section footer size
    public var sectionFooterSize: ((IndexPath) -> CGSize)?
}

//protocol SheetLayoutDelegate: AnyObject {
//
//    func sheetLayout(_ layout: SheetContentsLayout, sizeForItemAt indexPath: IndexPath) -> CGSize
//
//    func sheetLayoutHeaderSize(_ layout: SheetContentsLayout) -> CGSize?
//
//    func sheetLayoutFooterSize(_ layout: SheetContentsLayout) -> CGSize?
//
//    func sheetLayout(_ layout: SheetContentsLayout, referenceSizeForHeaderInSection section: Int) -> CGSize?
//
//    func sheetLayout(_ layout: SheetContentsLayout, referenceSizeForFooterInSection section: Int) -> CGSize?
//}
//
//extension SheetLayoutDelegate {
//
//    func sheetLayoutHeaderSize(_ layout: SheetContentsLayout) -> CGSize? {
//        return nil
//    }
//
//    func sheetLayoutFooterSize(_ layout: SheetContentsLayout) -> CGSize? {
//        return nil
//    }
//
//    func sheetLayout(_ layout: SheetContentsLayout, referenceSizeForHeaderInSection section: Int) -> CGSize? {
//        return nil
//    }
//
//    func sheetLayout(_ layout: SheetContentsLayout, referenceSizeForFooterInSection section: Int) -> CGSize? {
//        return nil
//    }
//}
