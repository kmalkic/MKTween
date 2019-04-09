//
//  Menu.Timing.Cell.swift
//  MKTweenDemo
//
//  Created by Kevin Malkic on 09/04/2019.
//  Copyright © 2019 Kevin Malkic. All rights reserved.
//

import UIKit
import MKTween

extension Menu.Timing {
    
    class Cell: UITableViewCell {
        
        let tween = Tween(.none)
        
        lazy var titleLabel : UILabel = {
            let label = UILabel()
            label.textColor = UIColor.black
            label.autoresizingMask = [.flexibleWidth, .flexibleBottomMargin]
            label.font = UIFont(name: "HelveticaNeue-Light", size: 12)
            self.addSubview(label)
            
            return label
        }()
        
        var timingMode = Timing.linear {
            didSet {
                setNeedsDisplay()
            }
        }
        
        var progressTime: CGFloat = 0 {
            didSet {
                setNeedsDisplay()
            }
        }
        
        override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
            
            super.init(style: style, reuseIdentifier: reuseIdentifier)
            
            self.titleLabel.frame = CGRect(x: 10, y: 0, width: bounds.size.width, height: 25)
        }
        
        required init?(coder aDecoder: NSCoder) {
            fatalError("init(coder:) has not been implemented")
        }
        
        override func draw(_ rect: CGRect) {
            
            UIColor.white.setFill()
            UIRectFill(rect)

            UIColor(red: 230/255, green: 230/255, blue: 230/255, alpha: 1).setStroke()
            
            let topMargins: CGFloat = 25
            
            let width: CGFloat = rect.width - 40
            
            let newRect = CGRect(x: (rect.width-width)/2, y: topMargins, width: width, height: rect.size.height-(topMargins*2))
            
            let lineTop = UIBezierPath()
            lineTop.move(to: CGPoint(x: newRect.origin.x-10, y: newRect.origin.y))
            lineTop.addLine(to: CGPoint(x: newRect.origin.x+newRect.width+10, y: newRect.origin.y))
            lineTop.lineWidth = 1
            lineTop.stroke()
            
            let lineBottom = UIBezierPath()
            lineBottom.move(to: CGPoint(x: newRect.origin.x-10, y: newRect.origin.y+newRect.height))
            lineBottom.addLine(to: CGPoint(x: newRect.origin.x+newRect.width+10, y: newRect.origin.y+newRect.height))
            lineBottom.lineWidth = 1
            lineBottom.stroke()
            
            let path = UIBezierPath()
            path.lineWidth = 2.0
            
            path.move(to: CGPoint(x: newRect.origin.x, y: newRect.origin.y + newRect.height))
            
            let count = width/2
            
            let period = Period<CGFloat>(start: 0, end: 1, duration: 1, timingMode: timingMode).set(name: "cell curve drawing")
            let tweenValues = period.tweenValues(UInt(count))
            
            let progressIndex = Int(round(CGFloat(tweenValues.count - 1) * progressTime))
            
            tweenValues.enumerated().forEach { index, progress in
                
                let xPos = ((newRect.width * CGFloat(index+1)) / count) + newRect.origin.x
                
                let point = CGPoint( x: xPos, y: newRect.origin.y + (newRect.height - (progress * newRect.height)))
                path.addLine(to: point)
                
                if index == progressIndex {
                    UIColor(red: 255/255, green: 127/255, blue: 127/255, alpha: 1).setFill()
                    UIBezierPath(arcCenter: point, radius: 3, startAngle: 0, endAngle: .pi * 2, clockwise: true).fill()
                }
            }
            
            UIColor(red: 255/255, green: 127/255, blue: 127/255, alpha: 1).setStroke()
            path.stroke()
        }
    }
}

