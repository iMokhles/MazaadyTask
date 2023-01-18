//
//  ProductCell.swift
//  Mazaady
//
//  Created by sameh mohammed on 04/01/2023.
//

import UIKit

class ProductCell: UICollectionViewCell {

    @IBOutlet weak var imageProduct: UIImageView!
    @IBOutlet weak var favBu: UIButton!
    @IBOutlet weak var statusORderLable: UILabel!
    @IBOutlet weak var descProductLable: UILabel!
    @IBOutlet weak var priceStartLable: UILabel!
    @IBOutlet weak var timeStartLable: UILabel!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()

    }

 
    
}
