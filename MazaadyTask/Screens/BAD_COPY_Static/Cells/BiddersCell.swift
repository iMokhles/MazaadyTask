//
//  BiddersCell.swift
//  Mazaady
//
//  Created by sameh mohammed on 04/01/2023.
//

import UIKit

class BiddersCell: UITableViewCell {

    @IBOutlet weak var userNameLable: UILabel!
    @IBOutlet weak var imageUser: UIImageView!
    @IBOutlet weak var numberLable: UILabel!
    @IBOutlet weak var timerLable: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.selectionStyle  = .none
    }

  
    
}
