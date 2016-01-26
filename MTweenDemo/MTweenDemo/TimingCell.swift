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
	
	let tween = MKTween(.None)
	
	lazy var titleLabel : UILabel = {
		
		let label = UILabel()
		label.textColor = UIColor.blackColor()
		label.autoresizingMask = [.FlexibleWidth, .FlexibleBottomMargin]
		label.font = UIFont.systemFontOfSize(11)
		self.addSubview(label)
		
		return label
	}()
	
	var timingFunction = MKTweenTiming.Linear {
		
		didSet {
			
			setNeedsDisplay()
		}
	}
	
	override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
		
		super.init(style: style, reuseIdentifier: reuseIdentifier)
		
		titleLabel.frame = CGRectMake(10, 0, bounds.size.width, 25)
	}

	required init?(coder aDecoder: NSCoder) {
	    fatalError("init(coder:) has not been implemented")
	}
	
	override func drawRect(rect: CGRect) {
		
		UIColor.whiteColor().setFill()
		UIRectFill(rect)
		
		let period = MKTweenPeriod(duration:1, startValue: 0, endValue: 1)
		
		let operation = MKTweenOperation(period: period, timingFunction: timingFunction)
		
		UIColor(red: 230/255, green: 230/255, blue: 230/255, alpha: 1).setStroke()
		
		let topMargins: CGFloat = 25
		
		let width: CGFloat = rect.width - 40
		
		let newRect = CGRectMake((rect.width-width)/2, topMargins, width, rect.size.height-(topMargins*2))
		
		let lineTop = UIBezierPath()
		lineTop.moveToPoint(CGPointMake(newRect.origin.x-10, newRect.origin.y))
		lineTop.addLineToPoint(CGPointMake(newRect.origin.x+newRect.width+10, newRect.origin.y))
		lineTop.lineWidth = 1
		lineTop.stroke()
		
		let lineBottom = UIBezierPath()
		lineBottom.moveToPoint(CGPointMake(newRect.origin.x-10, newRect.origin.y+newRect.height))
		lineBottom.addLineToPoint(CGPointMake(newRect.origin.x+newRect.width+10, newRect.origin.y+newRect.height))
		lineBottom.lineWidth = 1
		lineBottom.stroke()
		
		let path = UIBezierPath()
		path.lineWidth = 2.0
		
		path.moveToPoint(CGPointMake(newRect.origin.x, newRect.origin.y + newRect.height))
		
		let count = width/2
		
		let tweenValues = operation.tweenValues(UInt(count))
		
		for i in 0..<tweenValues.count {
		
			let xPos = ((newRect.width * CGFloat(i+1)) / count) + newRect.origin.x
			
			let progress = tweenValues[i]
			
			path.addLineToPoint(CGPointMake( xPos, newRect.origin.y + ( newRect.height - ( CGFloat(progress) * newRect.height ) ) ) )
		}
		
		UIColor(red: 255/255, green: 127/255, blue: 127/255, alpha: 1).setStroke()
		path.stroke()
		

	}

}
