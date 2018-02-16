//
//  View.swift
//  MTweenDemo
//
//  Created by Kevin Malkic on 26/01/2016.
//  Copyright © 2016 Kevin Malkic. All rights reserved.
//

import UIKit
import MKTween

class TimingCell: UITableViewCell {
	
	let tween = Tween(.none)
	
	lazy var titleLabel : UILabel = {
		
		let label = UILabel()
		label.textColor = UIColor.black
		label.autoresizingMask = [.flexibleWidth, .flexibleBottomMargin]
		label.font = UIFont.systemFont(ofSize: 11)
		self.addSubview(label)
		
		return label
	}()
	
	var timingFunction = Timing.Linear {
		
		didSet {
			
			setNeedsDisplay()
		}
	}
	
	override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
		
		super.init(style: style, reuseIdentifier: reuseIdentifier)
		
		self.titleLabel.frame = CGRect(x: 10, y: 0, width: bounds.size.width, height: 25)
	}

	required init?(coder aDecoder: NSCoder) {
	    fatalError("init(coder:) has not been implemented")
	}
	
	override func draw(_ rect: CGRect) {
		
		UIColor.white.setFill()
		UIRectFill(rect)
		
        let period = Period<CGFloat>(start: 0, end: 1)
		
        let operation = Operation(period: period, timingFunction: self.timingFunction).set(name: "cell curve drawing")
        
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
		
		let tweenValues = operation.tweenValues(UInt(count))
		
		for i in 0..<tweenValues.count {
		
			let xPos = ((newRect.width * CGFloat(i+1)) / count) + newRect.origin.x
			
			let progress = tweenValues[i]
			
			path.addLine(to: CGPoint( x: xPos, y: newRect.origin.y + ( newRect.height - ( progress * newRect.height ) ) ) )
		}
		
		UIColor(red: 255/255, green: 127/255, blue: 127/255, alpha: 1).setStroke()
		path.stroke()
        

	}
}
