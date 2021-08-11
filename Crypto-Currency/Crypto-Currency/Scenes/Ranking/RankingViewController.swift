//
//  RankingViewController.swift
//  Crypto-Currency
//
//  Created by namtrinh on 04/08/2021.
//

import UIKit

final class RankingViewController: UIViewController {
    
    @IBOutlet private weak var rankingTableView: UITableView!
    
    private let refreshControl = UIRefreshControl()
    
    private var coins = [Coin]()
    private let repository = RepositoryAPI()
    private var offset = 30
    private var isLoading = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureTableView()
        loadAPI()
    }
    
    private func configureTableView() {
        rankingTableView.delegate = self
        rankingTableView.dataSource = self
        rankingTableView.register(CoinTableViewCell.nib,
                                  forCellReuseIdentifier: CoinTableViewCell.reuseIdentifier)
        rankingTableView.register(LoadingTableViewCell.nib,
                                  forCellReuseIdentifier: LoadingTableViewCell.reuseIdentifier)
        
        refreshControl.attributedTitle = NSAttributedString()
        refreshControl.addTarget(self, action: #selector(refresh(_:)), for: .valueChanged)
        rankingTableView.addSubview(refreshControl)
    }
    
    @objc private func refresh(_ sender: AnyObject) {
        loadAPI()
        rankingTableView.reloadData()
        refreshControl.endRefreshing()
    }
    
    private func loadAPI() {
        repository.getCoins(
            urlString: Network.shared.getRankingURL()) { [weak self] coins, error in
            guard let self = self else { return }
            if let error = error {
                print(error.localizedDescription)
            }
            if let coins = coins {
                self.coins = coins
                DispatchQueue.main.async {
                    self.rankingTableView.reloadData()
                }
            }
        }
    }
    
    private func loadMore() {
        if !isLoading {
            isLoading = true
            repository.getMore(offset: String(offset)) { [weak self] coins, error in
                guard let self = self else { return }
                if let error = error {
                    self.isLoading = false
                    print(error.localizedDescription)
                }
                if let coins = coins {
                    self.coins.append(contentsOf: coins)
                    self.isLoading = false
                    self.offset += 10
                    DispatchQueue.main.async {
                        self.rankingTableView.reloadData()
                    }
                }
            }
        }
    }
    
    @IBAction func handleSearchBarButton(_ sender: UIBarButtonItem) {
        let searchScreen = SearchViewController()
        searchScreen.modalPresentationStyle = .fullScreen
        present(searchScreen, animated: true, completion: nil)
    }
}

extension RankingViewController: UITableViewDelegate, UITableViewDataSource, UIScrollViewDelegate {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch section {
        case 0:
            return coins.count
        case 1:
            return 1
        default:
            return coins.count
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch indexPath.section {
        case 0:
            guard let cell = rankingTableView.dequeueReusableCell(withIdentifier: CoinTableViewCell.reuseIdentifier) as? CoinTableViewCell else {
                return UITableViewCell()
            }
            cell.configureCell(coin: coins[indexPath.row])
            return cell
        case 1:
            guard let cell = rankingTableView.dequeueReusableCell(withIdentifier: LoadingTableViewCell.reuseIdentifier) as? LoadingTableViewCell else {
                return UITableViewCell()
            }
            return cell
        default:
            return UITableViewCell()
        }
        
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        let lastItem = coins.count - 1
        if indexPath.row == lastItem {
            if !isLoading {
                loadMore()
            }
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let detailScreen = DetailViewController()
        detailScreen.uuid = coins[indexPath.row].uuid
        detailScreen.modalPresentationStyle = .fullScreen
        present(detailScreen, animated: true, completion: nil)
    }
    
}
