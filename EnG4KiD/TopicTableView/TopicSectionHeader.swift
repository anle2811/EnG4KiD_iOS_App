//
//  TopicSectionHeader.swift
//  EnG4KiD
//
//  Created by Lê An on 3/10/20.
//  Copyright © 2020 An Lê. All rights reserved.
//

import UIKit

protocol TopicSectionHeaderDelegate {
    func expandSwitchSection(header: TopicSectionHeader, section: Int)
}

class TopicSectionHeader: UITableViewHeaderFooterView {

    var delegate: TopicSectionHeaderDelegate?
    var section: Int!
    
    @IBOutlet weak var viewTopicSection: UIView!
    
    @IBOutlet weak var imgTopicSection: UIImageView!
    
    @IBOutlet weak var lblTitleTopicSection: UILabel!
    
    @IBOutlet weak var viewBrightness: UIView!
    
    override init(reuseIdentifier: String?) {
        super.init(reuseIdentifier: reuseIdentifier)
        self.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(tapSection)))
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        self.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(tapSection)))
    }
    
    @objc func tapSection(gesture: UITapGestureRecognizer){
        guard let section = gesture.view as? TopicSectionHeader else {return}
        delegate?.expandSwitchSection(header: self, section: section.section)
    }
    
    func customInit(imgTopic: UIImage, titleTopic: String, section: Int, delegate: TopicSectionHeaderDelegate){
        self.imgTopicSection.image = imgTopic
        self.lblTitleTopicSection.text = titleTopic
        self.section = section
        self.delegate = delegate
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        self.layer.cornerRadius = 10
        self.viewTopicSection?.layer.cornerRadius = 10
        self.imgTopicSection?.layer.cornerRadius = 10
        self.viewBrightness?.layer.cornerRadius = 10
    }
    
    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */

}
