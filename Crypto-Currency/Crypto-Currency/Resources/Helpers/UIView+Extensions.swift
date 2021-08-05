//
//  UIView+Extensions.swift
//  Crypto-Currency
//
//  Created by namtrinh on 05/08/2021.
//

import UIKit

public extension UIView {
    func pinTo(_ view: UIView, height: CGFloat = 50, leading: CGFloat = 0, trailing: CGFloat = 0, bottom: CGFloat = -12) {
        translatesAutoresizingMaskIntoConstraints = false
        heightAnchor.constraint(equalToConstant: height).isActive = true
        leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: leading).isActive = true
        trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: trailing).isActive = true
        bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: bottom).isActive = true
    }
}
