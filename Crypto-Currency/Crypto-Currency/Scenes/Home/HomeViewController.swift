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
    @IBOutlet private weak var topMarketCapCollection: UICollectionView!
    
    private var topCoins = [Coin]()
    private var topChangeCoins = [Coin]()
    private var top24hVolumeCoins = [Coin]()
    private var topMarketCapCoins = [Coin]()
    
    private let repository = RepositoryAPI()
    
    private var nsCache = NSCache<NSString, UIImage>()
    
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
        
        dispatchGroup.enter()
        repository.getCoins(urlString: EndPoint.topCoin.rawValue) { [weak self] coins, error in
            guard let self = self else { return }
            if let error = error {
                print(error)
            }
            if let coins = coins {
                self.topCoins = coins
                dispatchGroup.leave()
            }
        }

        dispatchGroup.enter()
        repository.getCoins(urlString: EndPoint.topChange.rawValue) { [weak self] coins, error in
            guard let self = self else { return }
            if let error = error {
                print(error)
            }
            if let coins = coins {
                self.topChangeCoins = coins
                dispatchGroup.leave()
            }
        }

        dispatchGroup.enter()
        repository.getCoins(urlString: EndPoint.top24hVolume.rawValue) { [weak self] coins, error in
            guard let self = self else { return }
            if let error = error {
                print(error)
            }
            if let coins = coins {
                self.top24hVolumeCoins = coins
                dispatchGroup.leave()
            }
        }

        dispatchGroup.enter()
        repository.getCoins(urlString: EndPoint.topMarketCap.rawValue) { [weak self] coins, error in
            guard let self = self else { return }
            if let error = error {
                print(error)
            }
            if let coins = coins {
                self.topMarketCapCoins = coins
                dispatchGroup.leave()
            }
        }

        dispatchGroup.notify(queue: .main, execute: { [weak self] in
            guard let self = self else { return }
            self.topCoinCollection.reloadData()
            self.topChangeCollection.reloadData()
            self.top24hVolumeCollection.reloadData()
            self.topMarketCapCollection.reloadData()
        })
    }
    
    @IBAction func handleExchangeRatesButton(_ sender: UIButton) {
        let exchangeRatesScreen = ExchangeRatesViewController()
        navigationController?.pushViewController(exchangeRatesScreen, animated: true)
    }
    
    @IBAction func handleSearchBarButton(_ sender: UIBarButtonItem) {
        let searchScreen = SearchViewController()
        navigationController?.pushViewController(searchScreen, animated: true)
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
}
