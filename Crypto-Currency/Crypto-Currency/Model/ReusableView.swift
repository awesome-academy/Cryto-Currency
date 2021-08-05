//
//  ReusableView.swift
//  Crypto-Currency
//
//  Created by namtrinh on 06/08/2021.
//

import UIKit

protocol ReusableView {
    static var reuseIdentifier: String { get }
    static var nib: UINib { get }
}

extension ReusableView {
    static var reuseIdentifier: String {
            return String(describing: self)
        }
    
    static var nib: UINib {
        return UINib(nibName: reuseIdentifier, bundle: nil)
    }
}
