//
//  CircularProgress.swift
//  EnG4KiD
//
//  Created by MacPro An Lê on 3/22/20.
//  Copyright © 2020 An Lê. All rights reserved.
//

import UIKit

class CircularProgressView: UIView {
    
    var progressLayer:CAShapeLayer = CAShapeLayer()
    fileprivate var trackLayer:CAShapeLayer = CAShapeLayer()
    
//    override init(frame: CGRect) {
//        super.init(frame: frame)
//        //createCircularPath()
//    }
//    
//    required init?(coder: NSCoder) {
//        super.init(coder: coder)
//        //createCircularPath()
//    }
    
    var trackColor:UIColor = UIColor.white{
        didSet{
            trackLayer.strokeColor = trackColor.cgColor
        }
    }
    
    var progressColor:UIColor = UIColor.white{
        didSet{
            progressLayer.strokeColor = progressColor.cgColor
        }
    }
    
    func createCircularPath(radius: CGFloat){
        self.backgroundColor = UIColor.clear
        let circlePath = UIBezierPath(arcCenter: CGPoint(x: self.frame.size.width/2, y: self.frame.size.height/2), radius: radius, startAngle: -(.pi*1/2), endAngle: .pi*3/2, clockwise: true)
        
        self.trackLayer.path = circlePath.cgPath
        self.trackLayer.fillColor = UIColor.clear.cgColor
        self.trackLayer.strokeColor = trackColor.cgColor
        self.trackLayer.lineWidth = 8
        self.trackLayer.strokeEnd = 1
        self.layer.addSublayer(self.trackLayer)
        
        self.progressLayer.path = circlePath.cgPath
        self.progressLayer.fillColor = UIColor.clear.cgColor
        self.progressLayer.strokeColor = progressColor.cgColor
        self.progressLayer.lineWidth = 8
        self.progressLayer.strokeEnd = 0
        self.progressLayer.lineCap = .round
        self.layer.addSublayer(self.progressLayer)
    }

}
