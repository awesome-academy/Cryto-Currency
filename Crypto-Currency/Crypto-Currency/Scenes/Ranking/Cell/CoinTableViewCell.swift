//
//  CoinTableViewCell.swift
//  Crypto-Currency
//
//  Created by namtrinh on 09/08/2021.
//

import UIKit

final class CoinTableViewCell: UITableViewCell, ReusableView {

    @IBOutlet private weak var iconImageView: UIImageView!
    @IBOutlet private weak var changeLabel: UILabel!
    @IBOutlet private weak var nameLabel: UILabel!
    @IBOutlet private weak var priceLabel: UILabel!
    @IBOutlet private weak var marketCapLabel: UILabel!
    @IBOutlet private weak var symbolLabel: UILabel!
    @IBOutlet private weak var rankLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        iconImageView.layer.cornerRadius = 25
    }

    override func prepareForReuse() {
        super.prepareForReuse()
        iconImageView.image = nil
    }
    
    func configureCell(coin: Coin) {
        nameLabel.text = coin.name
        symbolLabel.text = coin.symbol
        rankLabel.text = String(coin.rank)
        marketCapLabel.formatMarketCap(marketCap: coin.marketCap ?? "")
        changeLabel.formatChange(percentChange: coin.change)
        priceLabel.formatPrice(price: coin.price)
        let pngUrl = coin.iconUrl.replacingOccurrences(of: "svg", with: "png")
        if let url = URL(string: pngUrl) {
            iconImageView.setImage(from: url)
        }
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        selectionStyle = .none
    }
    
}
