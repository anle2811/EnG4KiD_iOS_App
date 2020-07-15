//
//  TopicCellTableViewCell.swift
//  EnG4KiD
//
//  Created by Lê An on 3/10/20.
//  Copyright © 2020 An Lê. All rights reserved.
//

import UIKit

protocol TopicCellTableViewCellDelegate {
    func tapVocabulary(cell: TopicCellTableViewCell, cellIndex: Int)
    func tapGamePlay(cell: TopicCellTableViewCell, cellIndex: Int)
}

class TopicCellTableViewCell: UITableViewCell {

    var delegate: TopicCellTableViewCellDelegate?
    var cellInSection: Int!
    
    @IBOutlet weak var stackViewCell: UIStackView!
    
    @IBOutlet weak var learnItemCell: UIView!
    
    @IBOutlet weak var gameItemCell: UIView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    func customInit(cellInSection: Int, delegate: TopicCellTableViewCellDelegate){
        self.learnItemCell.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(selectVocabulary)))
        self.gameItemCell.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(selectGamePlay)))
        self.cellInSection = cellInSection
        self.delegate = delegate
    }
    
    @objc func selectVocabulary(){
        delegate?.tapVocabulary(cell: self, cellIndex: self.cellInSection)
    }
    
    @objc func selectGamePlay(){
        delegate?.tapGamePlay(cell: self, cellIndex: self.cellInSection)
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    

}
