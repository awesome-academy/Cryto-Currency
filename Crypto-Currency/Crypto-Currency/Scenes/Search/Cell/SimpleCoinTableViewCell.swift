//
//  SimpleCoinTableViewCell.swift
//  Crypto-Currency
//
//  Created by namtrinh on 10/08/2021.
//

import UIKit

final class SimpleCoinTableViewCell: UITableViewCell, ReusableView {

    @IBOutlet private weak var iconImageView: UIImageView!
    @IBOutlet private weak var nameLabel: UILabel!
    @IBOutlet private weak var symbolLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        selectionStyle = .none
    }
    
    func configureCell(coin: SimpleCoin) {
        nameLabel.text = coin.name
        symbolLabel.text = coin.symbol
        let pngUrl = coin.iconUrl.replacingOccurrences(of: "svg", with: "png")
        if let url = URL(string: pngUrl) {
            iconImageView.setImage(from: url)
        }
    }
}
