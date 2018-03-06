//
//  View.swift
//  MTweenDemo
//
//  Created by Kevin Malkic on 26/01/2016.
//  Copyright © 2016 Kevin Malkic. All rights reserved.
//

import UIKit

class View: UIView {

	lazy var tableView : UITableView = {
		
		let tableView = UITableView()
		return tableView
	}()
	
	override init(frame: CGRect) {
		
		super.init(frame: frame)
		
		setupViews()
	}

	required init?(coder aDecoder: NSCoder) {
	    fatalError("init(coder:) has not been implemented")
	}
	
	func setupViews() {
	
		tableView.frame = bounds
		tableView.autoresizingMask = [.flexibleHeight, .flexibleWidth]
		addSubview(tableView)
	}
}
