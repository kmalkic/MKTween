//
//  ViewController.swift
//  MTweenDemo
//
//  Created by Kevin Malkic on 25/01/2016.
//  Copyright © 2016 Kevin Malkic. All rights reserved.
//

import UIKit
import MKTween

class ViewController: UIViewController {
	
	var myView : View! {
		get {
			return self.view as! View
		}
	}
	
	let headerView = HeaderView()
	var timingModes = [Timing]()

	override func loadView() {
		view = View()
	}
	
    override func viewDidLoad() {
        
        super.viewDidLoad()
		
		constructArray()
		
		self.myView.tableView.register(TimingCell.self, forCellReuseIdentifier: "cell")
		self.myView.tableView.separatorStyle = .none
		
		self.myView.tableView.delegate = self
		self.myView.tableView.dataSource = self
    }
	
	func constructArray() {
	
        timingModes.append(.linear)
        timingModes.append(.backOut)
        timingModes.append(.backIn)
        timingModes.append(.backInOut)
        timingModes.append(.bounceOut)
        timingModes.append(.bounceIn)
        timingModes.append(.bounceInOut)
        timingModes.append(.circleOut)
        timingModes.append(.circleIn)
        timingModes.append(.circleInOut)
        timingModes.append(.cubicOut)
        timingModes.append(.cubicIn)
        timingModes.append(.cubicInOut)
        timingModes.append(.elasticOut)
        timingModes.append(.elasticIn)
        timingModes.append(.elasticInOut)
        timingModes.append(.expoOut)
        timingModes.append(.expoIn)
        timingModes.append(.expoInOut)
        timingModes.append(.quadOut)
        timingModes.append(.quadIn)
        timingModes.append(.quadInOut)
        timingModes.append(.quartOut)
        timingModes.append(.quartIn)
        timingModes.append(.quartInOut)
        timingModes.append(.quintOut)
        timingModes.append(.quintIn)
        timingModes.append(.quintInOut)
        timingModes.append(.sineOut)
        timingModes.append(.sineIn)
        timingModes.append(.sineInOut)
	}
}


extension ViewController : UITableViewDelegate {
	
	func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
		
		tableView.deselectRow(at: indexPath, animated: true)
		
		let newRect = CGRect(x: 40, y: 0, width: tableView.frame.width - 80, height: headerHeight)
		
		self.headerView.circleView.center = CGPoint(x: newRect.origin.x, y: (headerHeight/2))
        
        let timingMode = self.timingModes[indexPath.row]
        
        DispatchQueue.main.async(execute: { () -> Void in

            let tweenName = "tween action"
            
            _ = Tween.shared.removeTweenOperationByName(tweenName)

            _ = Tween.shared.value(start: 0, end: 1, duration: 2).set(update: { (period) in
                
                self.headerView.circleView.center = CGPoint(x: newRect.origin.x + (newRect.width * period.progress), y: (headerHeight/2))
                
            }).set(timingMode: timingMode).set(name: tweenName)
        })
	}
}

private let cellHeight : CGFloat = 100
private let headerHeight : CGFloat = 200

extension ViewController : UITableViewDataSource {
	
	func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
		
		self.headerView.backgroundColor = .blue
		self.headerView.autoresizingMask = [.flexibleWidth, .flexibleHeight]

		let newRect = CGRect(x: 40, y: 0, width: tableView.frame.width - 80, height: headerHeight)
		
		self.headerView.circleView.center = CGPoint(x: newRect.origin.x, y: (headerHeight/2))
		
		return self.headerView
	}
	
	func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
		return headerHeight
	}
	
	func numberOfSections(in tableView: UITableView) -> Int {
		return 1
	}
	
	func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		return self.timingModes.count
	}
	
	func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
		return cellHeight
	}
	
	func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		
		let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for:indexPath) as! TimingCell
		cell.timingMode = self.timingModes[indexPath.row]
        cell.titleLabel.text = cell.timingMode.name()
		return cell
	}
}
