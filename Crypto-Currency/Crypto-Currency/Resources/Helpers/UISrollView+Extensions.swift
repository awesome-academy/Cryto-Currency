//
//  UISrollView+Extensions.swift
//  Crypto-Currency
//
//  Created by namtrinh on 05/08/2021.
//

import UIKit

public extension UIScrollView {
    func edgeTo(view: UIView) {
        translatesAutoresizingMaskIntoConstraints = false
        topAnchor.constraint(equalTo: view.topAnchor).isActive = true
        leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
    }
    
    func scrollTo(horizontalPage: Int = 0, verticalPage: Int = 0, animated: Bool = true) {
        var frame = self.frame
        frame.origin.x = frame.size.width * CGFloat(horizontalPage)
        frame.origin.y = frame.size.height * CGFloat(verticalPage)
        self.scrollRectToVisible(frame, animated: animated)
    }
}
