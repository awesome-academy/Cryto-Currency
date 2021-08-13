//
//  HomeViewController.swift
//  Crypto-Currency
//
//  Created by namtrinh on 04/08/2021.
//

import UIKit

final class HomeViewController: UIViewController {
    
    @IBOutlet private weak var topCoinCollection: UICollectionView!
    @IBOutlet private weak var topChangeCollection: UICollectionView!
    @IBOutlet private weak var top24hVolumeCollection: UICollectionView!
    @IBOutlet private weak var scrollView: UIScrollView!
    @IBOutlet private weak var topMarketCapCollection: UICollectionView!
    
    private var topCoins = [Coin]()
    private var topChangeCoins = [Coin]()
    private var top24hVolumeCoins = [Coin]()
    private var topMarketCapCoins = [Coin]()
    
    private let repository = RepositoryAPI()
    
    private var isLoading = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        showGetStartedScreen()
        configureCollection()
        loadAPI()
    }
    
    private func configureCollection() {
        topCoinCollection.delegate = self
        topCoinCollection.dataSource = self
        topCoinCollection.register(CoinCollectionViewCell.nib,
                                   forCellWithReuseIdentifier: CoinCollectionViewCell.reuseIdentifier)
        topChangeCollection.delegate = self
        topChangeCollection.dataSource = self
        topChangeCollection.register(CoinCollectionViewCell.nib,
                                     forCellWithReuseIdentifier: CoinCollectionViewCell.reuseIdentifier)
        top24hVolumeCollection.delegate = self
        top24hVolumeCollection.dataSource = self
        top24hVolumeCollection.register(CoinCollectionViewCell.nib,
                                        forCellWithReuseIdentifier: CoinCollectionViewCell.reuseIdentifier)
        topMarketCapCollection.delegate = self
        topMarketCapCollection.dataSource = self
        topMarketCapCollection.register(CoinCollectionViewCell.nib,
                                        forCellWithReuseIdentifier: CoinCollectionViewCell.reuseIdentifier)
        
        scrollView.refreshControl = UIRefreshControl()
        scrollView.refreshControl?.addTarget(self,
                                             action: #selector(handleRefreshControl),
                                             for: .valueChanged)
    }
    
    @objc private func handleRefreshControl() {
        if !isLoading {
            isLoading = true
            loadAPI()
            DispatchQueue.main.async { [weak self] in
                guard let self = self else { return }
                self.scrollView.refreshControl?.endRefreshing()
            }
        }
        
    }
    
    private func showGetStartedScreen() {
        if !UserDefaults.standard.bool(forKey: "didLaunchBefore") {
            UserDefaults.standard.set(true, forKey: "didLaunchBefore")
            guard let getstartedScreen = storyboard?.instantiateViewController(identifier: "GetStartedViewController")
                    as? GetStartedViewController else {
                return
            }
            getstartedScreen.modalPresentationStyle = .fullScreen
            present(getstartedScreen, animated: true, completion: nil)
        }
    }
    
    private func loadAPI() {
        let dispatchGroup = DispatchGroup()
        var urlResquest = Network.shared.getCoinsURL(path: Path.topCoin)
        
        dispatchGroup.enter()
        repository.getCoins(urlString: urlResquest) { [weak self] coins, error in
            guard let self = self else { return }
            if let error = error {
                self.isLoading = false
                print(error)
            }
            if let coins = coins {
                self.topCoins = coins
                dispatchGroup.leave()
            }
        }
        
        dispatchGroup.enter()
        urlResquest = Network.shared.getCoinsURL(path: Path.topChange)
        repository.getCoins(urlString: urlResquest) { [weak self] coins, error in
            guard let self = self else { return }
            if let error = error {
                self.isLoading = false
                print(error)
            }
            if let coins = coins {
                self.topChangeCoins = coins
                dispatchGroup.leave()
            }
        }
        
        dispatchGroup.enter()
        urlResquest = Network.shared.getCoinsURL(path: Path.top24Volume)
        repository.getCoins(urlString: urlResquest) { [weak self] coins, error in
            guard let self = self else { return }
            if let error = error {
                self.isLoading = false
                print(error)
            }
            if let coins = coins {
                self.top24hVolumeCoins = coins
                dispatchGroup.leave()
            }
        }
        
        dispatchGroup.enter()
        urlResquest = Network.shared.getCoinsURL(path: Path.topMarketCap)
        repository.getCoins(urlString: urlResquest) { [weak self] coins, error in
            guard let self = self else { return }
            if let error = error {
                self.isLoading = false
                print(error)
            }
            if let coins = coins {
                self.topMarketCapCoins = coins
                dispatchGroup.leave()
            }
        }
        
        dispatchGroup.notify(queue: .main, execute: { [weak self] in
            guard let self = self else { return }
            self.isLoading = false
            self.topCoinCollection.reloadData()
            self.topChangeCollection.reloadData()
            self.top24hVolumeCollection.reloadData()
            self.topMarketCapCollection.reloadData()
        })
    }
    
    @IBAction func handleExchangeRatesButton(_ sender: UIButton) {
        guard let topMarketCap = topMarketCapCoins.first else {
            return
        }
        
        let exchangeRatesScreen = ExchangeRatesViewController()
        exchangeRatesScreen.modalPresentationStyle = .fullScreen
        exchangeRatesScreen.defaultCurrency = topMarketCap.name
        present(exchangeRatesScreen, animated: true, completion: nil)
    }
    
    @IBAction func handleSearchBarButton(_ sender: UIBarButtonItem) {
        let searchScreen = SearchViewController()
        searchScreen.modalPresentationStyle = .fullScreen
        present(searchScreen, animated: true, completion: nil)
    }
}

extension HomeViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        switch collectionView {
        case topCoinCollection:
            return topCoins.count
        case topChangeCollection:
            return topChangeCoins.count
        case top24hVolumeCollection:
            return top24hVolumeCoins.count
        case topMarketCapCollection:
            return topMarketCapCoins.count
        default:
            return 0
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = topMarketCapCollection.dequeueReusableCell(withReuseIdentifier: CoinCollectionViewCell.reuseIdentifier, for: indexPath)
                as? CoinCollectionViewCell else {
            return UICollectionViewCell()
        }
        
        switch collectionView {
        case topCoinCollection:
            cell.configureCell(coin: topCoins[indexPath.item])
            return cell
        case topChangeCollection:
            cell.configureCell(coin: topChangeCoins[indexPath.item])
            return cell
        case top24hVolumeCollection:
            cell.configureCell(coin: top24hVolumeCoins[indexPath.item])
            return cell
        case topMarketCapCollection:
            cell.configureCell(coin: topMarketCapCoins[indexPath.item])
            return cell
        default:
            return UICollectionViewCell()
        }
    }
    
}

extension HomeViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 150, height: 150)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 24
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 5
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 0, left: 10, bottom: 0, right: 10)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let detailScreen = DetailViewController()
        switch collectionView {
        case topCoinCollection:
            detailScreen.uuid = topCoins[indexPath.item].uuid
        case topChangeCollection:
            detailScreen.uuid = topChangeCoins[indexPath.item].uuid
        case top24hVolumeCollection:
            detailScreen.uuid = top24hVolumeCoins[indexPath.item].uuid
        case topMarketCapCollection:
            detailScreen.uuid = topMarketCapCoins[indexPath.item].uuid
        default:
            return detailScreen.uuid = ""
        }
        detailScreen.modalPresentationStyle = .fullScreen
        present(detailScreen, animated: true, completion: nil)
    }
}
