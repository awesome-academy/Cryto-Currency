//
//  CoinCollectionViewCell.swift
//  Crypto-Currency
//
//  Created by namtrinh on 05/08/2021.
//

import UIKit

final class CoinCollectionViewCell: UICollectionViewCell, ReusableView {

    @IBOutlet private weak var iconImageView: UIImageView!
    @IBOutlet private weak var changeLabel: UILabel!
    @IBOutlet private weak var nameLabel: UILabel!
    @IBOutlet private weak var priceLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        contentView.layer.cornerRadius = 16
        contentView.layer.borderWidth = 1.0
        contentView.layer.borderColor = UIColor.clear.cgColor
        contentView.layer.masksToBounds = true

        layer.shadowColor = UIColor.lightGray.cgColor
        layer.shadowOffset = CGSize(width: 0, height: 2.0)
        layer.shadowRadius = 2.0
        layer.shadowOpacity = 0.5
        layer.masksToBounds = false
        layer.shadowPath = UIBezierPath(roundedRect: self.bounds, cornerRadius: contentView.layer.cornerRadius).cgPath
        
        iconImageView.layer.cornerRadius = 25
    }

    override func prepareForReuse() {
        super.prepareForReuse()
        iconImageView.image = nil
    }
    
    func configureCell(coin: Coin) {
        nameLabel.text = coin.name
        changeLabel.formatChange(percentChange: coin.change)
        priceLabel.formatPrice(price: coin.price)
        let pngUrl = coin.iconUrl.replacingOccurrences(of: "svg", with: "png")
        if let url = URL(string: pngUrl) {
            iconImageView.setImage(from: url)
        }
    }
}
