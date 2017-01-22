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
		
		myView.tableView.register(TimingCell.self, forCellReuseIdentifier: "cell")
		myView.tableView.separatorStyle = .none
		
		myView.tableView.delegate = self
		myView.tableView.dataSource = self
    }
	
	func constructArray() {
	
		timingFunctions.append(MKTweenTiming.Linear); timingFunctionTitles.append("Linear")
		timingFunctions.append(MKTweenTiming.BackOut); timingFunctionTitles.append("BackOut")
		timingFunctions.append(MKTweenTiming.BackIn); timingFunctionTitles.append("BackIn")
		timingFunctions.append(MKTweenTiming.BackInOut); timingFunctionTitles.append("BackInOut")
		timingFunctions.append(MKTweenTiming.BounceOut); timingFunctionTitles.append("BounceOut")
		timingFunctions.append(MKTweenTiming.BounceIn); timingFunctionTitles.append("BounceIn")
		timingFunctions.append(MKTweenTiming.BounceInOut); timingFunctionTitles.append("BounceInOut")
		timingFunctions.append(MKTweenTiming.CircleOut); timingFunctionTitles.append("CircleOut")
		timingFunctions.append(MKTweenTiming.CircleIn); timingFunctionTitles.append("CircleIn")
		timingFunctions.append(MKTweenTiming.CircleInOut); timingFunctionTitles.append("CircleInOut")
		timingFunctions.append(MKTweenTiming.CubicOut); timingFunctionTitles.append("CubicOut")
		timingFunctions.append(MKTweenTiming.CubicIn); timingFunctionTitles.append("CubicIn")
		timingFunctions.append(MKTweenTiming.CubicInOut); timingFunctionTitles.append("CubicInOut")
		timingFunctions.append(MKTweenTiming.ElasticOut); timingFunctionTitles.append("ElasticOut")
		timingFunctions.append(MKTweenTiming.ElasticIn); timingFunctionTitles.append("ElasticIn")
		timingFunctions.append(MKTweenTiming.ElasticInOut); timingFunctionTitles.append("ElasticInOut")
		timingFunctions.append(MKTweenTiming.ExpoOut); timingFunctionTitles.append("ExpoOut")
		timingFunctions.append(MKTweenTiming.ExpoIn); timingFunctionTitles.append("ExpoIn")
		timingFunctions.append(MKTweenTiming.ExpoInOut); timingFunctionTitles.append("ExpoInOut")
		timingFunctions.append(MKTweenTiming.QuadOut); timingFunctionTitles.append("QuadOut")
		timingFunctions.append(MKTweenTiming.QuadIn); timingFunctionTitles.append("QuadIn")
		timingFunctions.append(MKTweenTiming.QuadInOut); timingFunctionTitles.append("QuadInOut")
		timingFunctions.append(MKTweenTiming.QuartOut); timingFunctionTitles.append("QuartOut")
		timingFunctions.append(MKTweenTiming.QuartIn); timingFunctionTitles.append("QuartIn")
		timingFunctions.append(MKTweenTiming.QuartInOut); timingFunctionTitles.append("QuartInOut")
		timingFunctions.append(MKTweenTiming.QuintOut); timingFunctionTitles.append("QuintOut")
		timingFunctions.append(MKTweenTiming.QuintIn); timingFunctionTitles.append("QuintIn")
		timingFunctions.append(MKTweenTiming.QuintInOut); timingFunctionTitles.append("QuintInOut")
		timingFunctions.append(MKTweenTiming.SineOut); timingFunctionTitles.append("SineOut")
		timingFunctions.append(MKTweenTiming.SineIn); timingFunctionTitles.append("SineIn")
		timingFunctions.append(MKTweenTiming.SineInOut); timingFunctionTitles.append("SineInOut")
	}
}


extension ViewController : UITableViewDelegate {
	
	func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
		
		tableView.deselectRow(at: indexPath, animated: true)
		
		let newRect = CGRect(x: 40, y: 0, width: tableView.frame.width - 80, height: headerHeight)
		
		headerView.circleView.center = CGPoint(x: newRect.origin.x, y: (headerHeight/2))
        
        let timingFunction = timingFunctions[indexPath.row]
        
        let period = MKTweenPeriod(duration: 2, delay: 0, startValue: 0, endValue: 1)
        
        DispatchQueue.main.async(execute: { () -> Void in
            
            let operation = MKTweenOperation(period: period, updateBlock: { (period) -> () in
                
                self.headerView.circleView.center = CGPoint(x: newRect.origin.x + (newRect.width * CGFloat(period.progress)), y: (headerHeight/2))
                
            }, completeBlock: { () -> () in
                
                
            }, timingFunction: timingFunction)
            
            MKTween.shared.removeAllOperations()
            MKTween.shared.addTweenOperation(operation)
        })
	}
}

private let cellHeight : CGFloat = 100
private let headerHeight : CGFloat = 200

extension ViewController : UITableViewDataSource {
	
	func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
		
		headerView.backgroundColor = .blue
		headerView.autoresizingMask = [.flexibleWidth, .flexibleHeight]

		let newRect = CGRect(x: 40, y: 0, width: tableView.frame.width - 80, height: headerHeight)
		
		headerView.circleView.center = CGPoint(x: newRect.origin.x, y: (headerHeight/2))
		
		return headerView
	}
	
	func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
		
		return headerHeight
	}
	
	func numberOfSections(in tableView: UITableView) -> Int {
		
		return 1
	}
	
	func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		
		return timingFunctions.count
	}
	
	func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
		
		return cellHeight
	}
	
	func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		
		let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for:indexPath) as! TimingCell
		
		cell.titleLabel.text = timingFunctionTitles[indexPath.row]
		cell.timingFunction = timingFunctions[indexPath.row]
		
		return cell
	}
}
