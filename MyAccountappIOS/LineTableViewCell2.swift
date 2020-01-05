//
//  LineTableViewCell2.swift
//  MyAccountappIOS
//
//  Created by Ran FANG on 2020/1/5.
//  Copyright © 2020 Ran FANG. All rights reserved.
//

import UIKit

class LineTableViewCell2: UITableViewCell {

    static let reuseIdentifier = "LineCell2"
    
    @IBOutlet weak var exportTitleLabel: UILabel!
    @IBOutlet weak var exportAmountLabel: UILabel!
    
    
     override func awakeFromNib() {
          super.awakeFromNib()
          // Initialization code
      }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}

