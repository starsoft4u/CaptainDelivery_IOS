//
//  ProductCell.swift
//  CaptainDelivery
//
//  Created by Eliot Gravett on 2018/12/11.
//  Copyright © 2018 Eliot Gravett. All rights reserved.
//

import UIKit

class ProductCell: UITableViewCell {
    @IBOutlet weak var iconView: UIImageView!
    @IBOutlet weak var nameView: UILabel!
    @IBOutlet weak var descView: UILabel!
    @IBOutlet weak var button: UIButton!

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        iconView.superview?.backgroundColor = .orange
    }

    override func setHighlighted(_ highlighted: Bool, animated: Bool) {
        super.setHighlighted(highlighted, animated: animated)
        iconView.superview?.backgroundColor = .orange
        descView.textColor = highlighted ? UIColor(rgb: 0x1C252A) : UIColor(rgb: 0xC3CFD5)
    }
}
