//
//  VocabularyCollectionViewCell.swift
//  EnG4KiD
//
//  Created by Lê An on 3/11/20.
//  Copyright © 2020 An Lê. All rights reserved.
//

import UIKit

class VocabularyCollectionViewCell: UICollectionViewCell {
    
    
    @IBOutlet weak var imgViewVocabulary: UIImageView!
    @IBOutlet weak var lblWord: UILabel!
    @IBOutlet weak var imgViewCompleted: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    func customInit(imgWord: UIImage, engWord: String, isLearned: Bool,cornerRadius: CGFloat){
        self.imgViewVocabulary.image = imgWord
        self.lblWord.text = engWord
        if isLearned == true{
            self.imgViewCompleted.isHidden = false
        }else {
            self.imgViewCompleted.isHidden = true
        }
        
        self.imgViewVocabulary.layer.cornerRadius = cornerRadius
        self.imgViewVocabulary.layer.masksToBounds = true
        self.lblWord.adjustsFontSizeToFitWidth = true
    }
    
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
    }
    
}
