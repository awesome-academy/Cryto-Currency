//
//  SearchViewController.swift
//  Crypto-Currency
//
//  Created by namtrinh on 10/08/2021.
//

import UIKit

final class SearchViewController: UIViewController {

    @IBOutlet private weak var listCoinTableView: UITableView!
    @IBOutlet private weak var searchBar: UISearchBar!
    
    private var coins = [SimpleCoin]()
    private let repository = RepositoryAPI()
    private let refreshControl = UIRefreshControl()
    
    private var isLoading = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        dismissKeyboard()
        setUp()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        searchBar.becomeFirstResponder()
    }
    
    private func setUp() {
        searchBar.delegate = self
        
        listCoinTableView.delegate = self
        listCoinTableView.dataSource = self
        listCoinTableView.register(SimpleCoinTableViewCell.nib,
                                   forCellReuseIdentifier: SimpleCoinTableViewCell.reuseIdentifier)
        
        refreshControl.attributedTitle = NSAttributedString()
        refreshControl.addTarget(self, action: #selector(refresh(_:)), for: .valueChanged)
        listCoinTableView.addSubview(refreshControl)
    }
    
    @objc private func refresh(_ sender: AnyObject) {
        guard let name = searchBar.searchTextField.text else {
            return
        }
        
        if !isLoading {
            isLoading = true
            loadAPI(name: name)
            refreshControl.endRefreshing()
        }
    }
    
    private func loadAPI(name: String) {
        repository.getSimpleCoin(name: name) { [weak self] coins, error in
            guard let self = self else { return }
            guard let coins = coins else {
                if let error = error {
                    print(error.localizedDescription)
                    self.isLoading = false
                    self.coins = []
                    DispatchQueue.main.async {
                        self.listCoinTableView.reloadData()
                    }
                }
                return
            }
            self.coins = coins
            self.isLoading = false
            DispatchQueue.main.async {
                self.listCoinTableView.reloadData()
            }
        }
    }
    
    @IBAction func handleCancelButton(_ sender: UIButton) {
        dismiss(animated: true, completion: nil)
    }
}

extension SearchViewController: UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        guard let name = searchBar.searchTextField.text else {
            return
        }
        loadAPI(name: name)
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchBar.endEditing(true)
        guard let name = searchBar.searchTextField.text else {
            return
        }
        
        if !isLoading {
            isLoading = true
            loadAPI(name: name)
        }
    }
}

extension SearchViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return coins.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = listCoinTableView.dequeueReusableCell(withIdentifier: SimpleCoinTableViewCell.reuseIdentifier)
                as? SimpleCoinTableViewCell else {
            return UITableViewCell()
        }
        cell.configureCell(coin: coins[indexPath.row])
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 70
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let detailScreen = DetailViewController()
        detailScreen.uuid = coins[indexPath.row].uuid
        detailScreen.modalPresentationStyle = .fullScreen
        present(detailScreen, animated: true, completion: nil)
    }
}
