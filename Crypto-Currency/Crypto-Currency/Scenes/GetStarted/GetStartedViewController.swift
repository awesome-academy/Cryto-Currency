//
//  GetStartedViewController.swift
//  Crypto-Currency
//
//  Created by namtrinh on 05/08/2021.
//

import UIKit

final class GetStartedViewController: UIViewController {

    lazy var welcomeUIView: UIView = {
        let view = UIView()
        view.backgroundColor = .white
        let label = UILabel()
        label.text = "Welcome to Crypto Currency"
        label.textAlignment = .center
        label.font = UIFont(name: "Helvetica-Bold", size: 32)
        label.numberOfLines = 0
        view.addSubview(label)
        label.edgeTo(view: view)
        return view
    }()
    
    lazy var tradingUIView: UIView = {
        let view = UIView()
        view.backgroundColor = .white
        let label = UILabel()
        label.text = "CryptoCurrency trading"
        label.textAlignment = .center
        label.font = UIFont(name: "Helvetica-Bold", size: 32)
        label.numberOfLines = 0
        view.addSubview(label)
        label.edgeTo(view: view)
        return view
    }()
    
    lazy var exchangeUIView: UIView = {
        let view = UIView()
        view.backgroundColor = .white
        let label = UILabel()
        label.text = "CryptoCurrency exchange"
        label.textAlignment = .center
        label.font = UIFont(name: "Helvetica-Bold", size: 32)
        label.numberOfLines = 0
        view.addSubview(label)
        label.edgeTo(view: view)
        return view
    }()
    
    lazy var views = [welcomeUIView, tradingUIView, exchangeUIView]
    
    lazy var scrollView: UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.showsHorizontalScrollIndicator = false
        scrollView.isPagingEnabled = true
        scrollView.contentSize = CGSize(width: view.frame.width * CGFloat(views.count), height: view.frame.height)
        
        for index in 0..<views.count {
            scrollView.addSubview(views[index])
            views[index].frame = CGRect(x: view.frame.width * CGFloat(index), y: 0, width: view.frame.width, height: view.frame.height)
        }
        scrollView.delegate = self
        return scrollView
    }()
    
    lazy var pageControl: UIPageControl = {
        let pageControl = UIPageControl()
        pageControl.numberOfPages = views.count
        pageControl.currentPageIndicatorTintColor = .black
        pageControl.pageIndicatorTintColor =  .gray
        pageControl.addTarget(self, action: #selector(handlePageControl(sender:)), for: .touchUpInside)
        return pageControl
    }()
    
    lazy var getStartedButton: UIButton = {
        let button = UIButton()
        button.frame = CGRect(x: 10, y: view.frame.size.height - 100, width: view.frame.size.width - 20, height: 50)
        button.layer.cornerRadius = 10
        button.setTitleColor(.white, for: .normal)
        button.backgroundColor = .black
        button.setTitle("Continue", for: .normal)
        button.addTarget(self, action: #selector(handleGetStartedButton(sender:)), for: .touchUpInside)
        return button
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.addSubview(scrollView)
        scrollView.edgeTo(view: view)
        
        view.addSubview(pageControl)
        pageControl.pinTo(view)
        
        view.addSubview(getStartedButton)
    }
    
    @objc
    func handlePageControl(sender: UIPageControl) {
        scrollView.scrollTo(horizontalPage: sender.currentPage, animated: true)
    }
    
    @objc
    func handleGetStartedButton(sender: UIButton) {
        
    }
    
}

extension GetStartedViewController: UIScrollViewDelegate {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let pageIndex = round(scrollView.contentOffset.x / view.frame.width)
        pageControl.currentPage = Int(pageIndex)
        
        if pageIndex == 2 {
            getStartedButton.setTitle("Get Started", for: .normal)
        } else {
            getStartedButton.setTitle("Continue", for: .normal)
        }
    }
}
