//
//  PickerTextField.swift
//  Reciper Keeper
//
//  Created by Alice Mai Tu on 3/6/18.
//  Copyright © 2018 Alice Mai Tu. All rights reserved.
//

import UIKit

class PickerTextField: UITextField {

    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */
    
    /*https://blog.apoorvmote.com/remove-cursor-and-disable-copypaste-for-uitextfield/
     */
 
    override func caretRect(for position: UITextPosition) -> CGRect {
        return CGRect.zero
    }
    
    override func selectionRects(for range: UITextRange) -> [Any] {
        return []
    }
    
    override func canPerformAction(_ action: Selector, withSender sender: Any?) -> Bool {
    
        if action == #selector(copy(_:)) || action == #selector(selectAll(_:)) || action == #selector(paste(_:)) {
            return false
    }
        return super.canPerformAction(action, withSender: sender)
    }
}
