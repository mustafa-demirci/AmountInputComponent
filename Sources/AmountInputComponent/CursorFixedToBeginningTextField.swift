//
//  CursorFixedToBeginningTextField.swift
//  
//  Created by Mustafa Demirci
//

import UIKit

final class CursorFixedToBeginningTextField : UITextField {
    public override func closestPosition(to point: CGPoint) -> UITextPosition? {
        return self.position(from: self.beginningOfDocument, offset: 0)
    }
}
