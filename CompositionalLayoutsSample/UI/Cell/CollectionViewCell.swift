//
//  GridCollectionViewCell.swift
//  CompositionalLayoutsSample
//
//  Created by branch10480 on 2021/04/04.
//

import UIKit

class CollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var textLabel: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
        layer.borderWidth = 0.5
        layer.borderColor = UIColor.systemPink.cgColor
        backgroundColor = .systemGroupedBackground
    }
    
    func configure(_ text: String) {
        textLabel.text = text
    }

}
