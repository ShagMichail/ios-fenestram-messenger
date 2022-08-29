//
//  Weak.swift
//  FenestramMessanger
//
//  Created by Михаил Беленко on 29.08.2022.
//

import Foundation

struct Weak<T> {
    private weak var _value: AnyObject?
    
    public var value: T? {
        return _value as? T
    }
    
    public init (value: T) {
        self._value = value as AnyObject
    }
}
