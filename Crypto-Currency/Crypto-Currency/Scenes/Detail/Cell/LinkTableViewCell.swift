//
//  LinkTableViewCell.swift
//  Crypto-Currency
//
//  Created by namtrinh on 10/08/2021.
//

import UIKit

final class LinkTableViewCell: UITableViewCell, ReusableView {

    @IBOutlet private weak var titleLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        selectionStyle = .none
    }
    
    func configureCell(link: Link) {
        titleLabel.text = link.name
    }
    
}
