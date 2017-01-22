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
		
		let circleView = UIView(frame: CGRect(x: 0,y: 0,width: 40,height: 40))
		circleView.backgroundColor = .red
		circleView.layer.cornerRadius = 40/2
		circleView.layer.masksToBounds = true
		self.addSubview(circleView)
		
		return circleView
	}()

}
