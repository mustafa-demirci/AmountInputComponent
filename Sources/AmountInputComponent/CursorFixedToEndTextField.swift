//
//  CursorFixedToEndTextField.swift
//
//  Created by Mustafa Demirci
//

import UIKit

final class CursorFixedToEndTextField : UITextField {
    public override func closestPosition(to point: CGPoint) -> UITextPosition? {
        return self.position(from: self.endOfDocument, offset: 0)
    }
}
