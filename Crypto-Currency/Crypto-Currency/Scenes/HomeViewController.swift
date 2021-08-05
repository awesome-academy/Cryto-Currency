//
//  HomeViewController.swift
//  Crypto-Currency
//
//  Created by namtrinh on 04/08/2021.
//

import UIKit

final class HomeViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        showGetStartedScreen()
    }
    
    private func showGetStartedScreen() {
        if !UserDefaults.standard.bool(forKey: "didLaunchBefore") {
            UserDefaults.standard.set(true, forKey: "didLaunchBefore")
            guard let getstartedScreen = storyboard?.instantiateViewController(identifier: "GetStartedViewController") as? GetStartedViewController else {
                return
            }
            getstartedScreen.modalPresentationStyle = .fullScreen
            present(getstartedScreen, animated: true, completion: nil)
        }
    }
    
}
