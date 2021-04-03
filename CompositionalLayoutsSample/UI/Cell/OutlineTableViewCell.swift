//
//  OutlineTableViewCell.swift
//  CompositionalLayoutsSample
//
//  Created by branch10480 on 2021/04/03.
//

import UIKit

struct OutlineTableViewCellViewData {
    var title: String
}

class OutlineTableViewCell: UITableViewCell {

    @IBOutlet weak var menuTitleLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    func configure(_ data: OutlineTableViewCellViewData) {
        menuTitleLabel.text = data.title
    }
    
}
