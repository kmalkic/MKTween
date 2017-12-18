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
	
	var timingFunctions = [MKTweenTimingFunction]()
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
	
		timingFunctions.append(MKTweenTiming.Linear); self.timingFunctionTitles.append("Linear")
		timingFunctions.append(MKTweenTiming.BackOut); self.timingFunctionTitles.append("BackOut")
		timingFunctions.append(MKTweenTiming.BackIn); self.timingFunctionTitles.append("BackIn")
		timingFunctions.append(MKTweenTiming.BackInOut); self.timingFunctionTitles.append("BackInOut")
		timingFunctions.append(MKTweenTiming.BounceOut); self.timingFunctionTitles.append("BounceOut")
		timingFunctions.append(MKTweenTiming.BounceIn); self.timingFunctionTitles.append("BounceIn")
		timingFunctions.append(MKTweenTiming.BounceInOut); self.timingFunctionTitles.append("BounceInOut")
		timingFunctions.append(MKTweenTiming.CircleOut); self.timingFunctionTitles.append("CircleOut")
		timingFunctions.append(MKTweenTiming.CircleIn); self.timingFunctionTitles.append("CircleIn")
		timingFunctions.append(MKTweenTiming.CircleInOut); self.timingFunctionTitles.append("CircleInOut")
		timingFunctions.append(MKTweenTiming.CubicOut); self.timingFunctionTitles.append("CubicOut")
		timingFunctions.append(MKTweenTiming.CubicIn); self.timingFunctionTitles.append("CubicIn")
		timingFunctions.append(MKTweenTiming.CubicInOut); self.timingFunctionTitles.append("CubicInOut")
		timingFunctions.append(MKTweenTiming.ElasticOut); self.timingFunctionTitles.append("ElasticOut")
		timingFunctions.append(MKTweenTiming.ElasticIn); self.timingFunctionTitles.append("ElasticIn")
		timingFunctions.append(MKTweenTiming.ElasticInOut); self.timingFunctionTitles.append("ElasticInOut")
		timingFunctions.append(MKTweenTiming.ExpoOut); self.timingFunctionTitles.append("ExpoOut")
		timingFunctions.append(MKTweenTiming.ExpoIn); self.timingFunctionTitles.append("ExpoIn")
		timingFunctions.append(MKTweenTiming.ExpoInOut); self.timingFunctionTitles.append("ExpoInOut")
		timingFunctions.append(MKTweenTiming.QuadOut); self.timingFunctionTitles.append("QuadOut")
		timingFunctions.append(MKTweenTiming.QuadIn); self.timingFunctionTitles.append("QuadIn")
		timingFunctions.append(MKTweenTiming.QuadInOut); self.timingFunctionTitles.append("QuadInOut")
		timingFunctions.append(MKTweenTiming.QuartOut); self.timingFunctionTitles.append("QuartOut")
		timingFunctions.append(MKTweenTiming.QuartIn); self.timingFunctionTitles.append("QuartIn")
		timingFunctions.append(MKTweenTiming.QuartInOut); self.timingFunctionTitles.append("QuartInOut")
		timingFunctions.append(MKTweenTiming.QuintOut); self.timingFunctionTitles.append("QuintOut")
		timingFunctions.append(MKTweenTiming.QuintIn); self.timingFunctionTitles.append("QuintIn")
		timingFunctions.append(MKTweenTiming.QuintInOut); self.timingFunctionTitles.append("QuintInOut")
		timingFunctions.append(MKTweenTiming.SineOut); self.timingFunctionTitles.append("SineOut")
		timingFunctions.append(MKTweenTiming.SineIn); self.timingFunctionTitles.append("SineIn")
		timingFunctions.append(MKTweenTiming.SineInOut); self.timingFunctionTitles.append("SineInOut")
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
            
            _ = MKTween.shared.removeTweenOperationByName(tweenName)

            _ = MKTween.shared.value(duration: 2, startValue: 0, endValue: 1).setUpdateBlock({ (period) in
                
                self.headerView.circleView.center = CGPoint(x: newRect.origin.x + (newRect.width * period.progress), y: (headerHeight/2))
                
            }).setTimingFunction(timingFunction).setName(tweenName)
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
