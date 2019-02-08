//
//  ProductCell.swift
//  Rakusale
//
//  Created by 戸澤涼 on 2019/02/09.
//  Copyright © 2019 Ryo.Tozawa. All rights reserved.
//

import Foundation

import UIKit

import MaterialComponents

//TODO: Change from a UICollectionViewCell to an MDCCardCollectionCell
class ProductCell: MDCCardCollectionCell {
    
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var priceLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        //TODO: Configure the cell properties
        self.backgroundColor = .white
        
        //TODO: Configure the MDCCardCollectionCell specific properties
        self.cornerRadius = 4.0;
        self.setBorderWidth(1.0, for:.normal)
        self.setBorderColor(.lightGray, for: .normal)
    }
}
