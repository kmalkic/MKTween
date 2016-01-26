//
//  HeaderView.swift
//  MTweenDemo
//
//  Created by Kevin Malkic on 26/01/2016.
//  Copyright © 2016 Kevin Malkic. All rights reserved.
//

import UIKit

class HeaderView: UIView {

	lazy var circleView : UIView = {
		
		let circleView = UIView(frame: CGRectMake(0,0,40,40))
		circleView.backgroundColor = .redColor()
		circleView.layer.cornerRadius = 40/2
		circleView.layer.masksToBounds = true
		self.addSubview(circleView)
		
		return circleView
	}()

}
