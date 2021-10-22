//
//  ProtocolBasedComponentView.swift
//
//  Created by Mustafa Demirci
//

import UIKit

open class ProtocolBasedComponentView<T>: BaseView {
    
    private weak var _delegate: AnyObject?
    
    public var delegate: T? {
        get {
            return _delegate as? T
        }
        set {
            _delegate = newValue as AnyObject
        }
    }
    
    public init(frame: CGRect = .zero, delegate: T) {
        super.init(frame: frame)
        self.delegate = delegate
    }
    
    required public init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    /// Description: Delegation Setter. It's used when component is added by using interface builder
    /// - Parameter delegate: There is no need for further explanation :)
    public func setDelegate(delegate: T) {
        self.delegate = delegate
        
    }
    
}
