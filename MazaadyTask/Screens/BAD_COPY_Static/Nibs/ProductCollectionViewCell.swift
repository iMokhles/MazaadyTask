//
//  ProductCollectionViewCell.swift
//  MultiDropDown
//
//  Created by AhmedHD_SL on 18/12/2022.
//

import UIKit

class ProductCollectionViewCell: UICollectionViewCell {

    override func awakeFromNib() {
        super.awakeFromNib()
        self.layer.cornerRadius =  8
        self.layer.borderWidth = 1
        self.layer.borderColor = #colorLiteral(red: 0.8666666667, green: 0.8666666667, blue: 0.8666666667, alpha: 1)
    }

}
