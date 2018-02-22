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
	var timingFunctions = [TimingFunction]()
	var timingFunctionTitles = [String]()
	
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
	
		timingFunctions.append(Timing.Linear); self.timingFunctionTitles.append("Linear")
		timingFunctions.append(Timing.BackOut); self.timingFunctionTitles.append("BackOut")
		timingFunctions.append(Timing.BackIn); self.timingFunctionTitles.append("BackIn")
		timingFunctions.append(Timing.BackInOut); self.timingFunctionTitles.append("BackInOut")
		timingFunctions.append(Timing.BounceOut); self.timingFunctionTitles.append("BounceOut")
		timingFunctions.append(Timing.BounceIn); self.timingFunctionTitles.append("BounceIn")
		timingFunctions.append(Timing.BounceInOut); self.timingFunctionTitles.append("BounceInOut")
		timingFunctions.append(Timing.CircleOut); self.timingFunctionTitles.append("CircleOut")
		timingFunctions.append(Timing.CircleIn); self.timingFunctionTitles.append("CircleIn")
		timingFunctions.append(Timing.CircleInOut); self.timingFunctionTitles.append("CircleInOut")
		timingFunctions.append(Timing.CubicOut); self.timingFunctionTitles.append("CubicOut")
		timingFunctions.append(Timing.CubicIn); self.timingFunctionTitles.append("CubicIn")
		timingFunctions.append(Timing.CubicInOut); self.timingFunctionTitles.append("CubicInOut")
		timingFunctions.append(Timing.ElasticOut); self.timingFunctionTitles.append("ElasticOut")
		timingFunctions.append(Timing.ElasticIn); self.timingFunctionTitles.append("ElasticIn")
		timingFunctions.append(Timing.ElasticInOut); self.timingFunctionTitles.append("ElasticInOut")
		timingFunctions.append(Timing.ExpoOut); self.timingFunctionTitles.append("ExpoOut")
		timingFunctions.append(Timing.ExpoIn); self.timingFunctionTitles.append("ExpoIn")
		timingFunctions.append(Timing.ExpoInOut); self.timingFunctionTitles.append("ExpoInOut")
		timingFunctions.append(Timing.QuadOut); self.timingFunctionTitles.append("QuadOut")
		timingFunctions.append(Timing.QuadIn); self.timingFunctionTitles.append("QuadIn")
		timingFunctions.append(Timing.QuadInOut); self.timingFunctionTitles.append("QuadInOut")
		timingFunctions.append(Timing.QuartOut); self.timingFunctionTitles.append("QuartOut")
		timingFunctions.append(Timing.QuartIn); self.timingFunctionTitles.append("QuartIn")
		timingFunctions.append(Timing.QuartInOut); self.timingFunctionTitles.append("QuartInOut")
		timingFunctions.append(Timing.QuintOut); self.timingFunctionTitles.append("QuintOut")
		timingFunctions.append(Timing.QuintIn); self.timingFunctionTitles.append("QuintIn")
		timingFunctions.append(Timing.QuintInOut); self.timingFunctionTitles.append("QuintInOut")
		timingFunctions.append(Timing.SineOut); self.timingFunctionTitles.append("SineOut")
		timingFunctions.append(Timing.SineIn); self.timingFunctionTitles.append("SineIn")
		timingFunctions.append(Timing.SineInOut); self.timingFunctionTitles.append("SineInOut")
	}
}


extension ViewController : UITableViewDelegate {
	
	func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
		
		tableView.deselectRow(at: indexPath, animated: true)
		
		let newRect = CGRect(x: 40, y: 0, width: tableView.frame.width - 80, height: headerHeight)
		
		self.headerView.circleView.center = CGPoint(x: newRect.origin.x, y: (headerHeight/2))
        
        let timingFunction = self.timingFunctions[indexPath.row]
        
        DispatchQueue.main.async(execute: { () -> Void in

            let tweenName = "tween action"
            
            _ = Tween.shared.removeTweenOperationByName(tweenName)

            _ = Tween.shared.value(start: 0, end: 1, duration: 2).set(update: { (period) in
                
                self.headerView.circleView.center = CGPoint(x: newRect.origin.x + (newRect.width * period.progress), y: (headerHeight/2))
                
            }).set(timingFunction: timingFunction).set(name: tweenName)
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
		return self.timingFunctions.count
	}
	
	func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
		return cellHeight
	}
	
	func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		
		let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for:indexPath) as! TimingCell
		cell.titleLabel.text = self.timingFunctionTitles[indexPath.row]
		cell.timingFunction = self.timingFunctions[indexPath.row]
		return cell
	}
}
