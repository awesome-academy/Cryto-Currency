//
//  FavoriteViewController.swift
//  Crypto-Currency
//
//  Created by namtrinh on 04/08/2021.
//

import UIKit

final class FavoriteViewController: UIViewController {
    
    @IBOutlet private weak var coinsTableView: UITableView!
    
    private var coins = [SimpleCoin]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUp()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        fetchCoins()
    }
    
    private func setUp() {
        coinsTableView.delegate = self
        coinsTableView.dataSource = self
        coinsTableView.register(SimpleCoinTableViewCell.nib,
                                forCellReuseIdentifier: SimpleCoinTableViewCell.reuseIdentifier)
    }
    
    private func fetchCoins() {
        async { [weak self] in
            guard let self = self else { return }
            
            let coins = await SimpleCoinManager.shared.fetchCoins()
            self.coins = coins
            self.coinsTableView.reloadData()
        }
    }
    
}

extension FavoriteViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        coins.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = coinsTableView.dequeueReusableCell(withIdentifier: SimpleCoinTableViewCell.reuseIdentifier)
                as? SimpleCoinTableViewCell else {
                    return UITableViewCell()
                }
        cell.configureCell(coin: coins[indexPath.row])
        return cell
    }
    
    func tableView(_ tableView: UITableView, editingStyleForRowAt indexPath: IndexPath) -> UITableViewCell.EditingStyle {
        return .delete
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            tableView.beginUpdates()
            SimpleCoinManager.shared.deleteCoin(uuid: coins[indexPath.row].uuid)
            coins.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .automatic)
            tableView.endUpdates()
        }
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
