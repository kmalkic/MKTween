//
//  Menu.Timing.ViewController.swift
//  MTweenDemo
//
//  Created by Kevin Malkic on 25/01/2016.
//  Copyright © 2016 Kevin Malkic. All rights reserved.
//

import UIKit
import MKTween

enum Menu {
    enum Timing { }
}

extension Menu.Timing {
    
    class ViewController: UIViewController {
        
        let cellHeight : CGFloat = 100
        let headerHeight : CGFloat = 200
        
        var myView : View? {
            get {
                return self.view as? View
            }
        }
        
        let headerView = HeaderView()
        let timingModes = Timing.all
        
        override func loadView() {
            view = View()
        }
        
        override func viewDidLoad() {
            
            super.viewDidLoad()
            
            myView?.tableView.register(Cell.self, forCellReuseIdentifier: "cell")
            myView?.tableView.separatorStyle = .none
            
            myView?.tableView.delegate = self
            myView?.tableView.dataSource = self
        }
    }
}

extension Menu.Timing.ViewController : UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        tableView.deselectRow(at: indexPath, animated: true)
        
        let newRect = CGRect(x: 40, y: 0, width: tableView.frame.width - 80, height: headerHeight)
        
        self.headerView.circleView.center = CGPoint(x: newRect.origin.x, y: (headerHeight/2))
        
        let timingMode = self.timingModes[indexPath.row]
        
        let tweenName = timingMode.name()
        
        if !Tween.shared.removePeriod(by: tweenName) {
            Tween.shared.removeAll()
            let headerHeight = self.headerHeight
            
            DispatchQueue.main.async(execute: { () -> Void in
                _ = Tween.shared.value(start: CGFloat(0), end: 1, duration: 2).set(updateBlock: { [weak self] period in
                    
                    self?.headerView.circleView.center = CGPoint(x: newRect.origin.x + (newRect.width * period.progress), y: (headerHeight/2))
                    
                }).set(timingMode: timingMode).set(name: tweenName).set(repeatType: .foreverPingPong)
            })
        }
    }
}

extension Menu.Timing.ViewController : UITableViewDataSource {
    
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
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for:indexPath) as? Menu.Timing.Cell else { return UITableViewCell() }
        cell.timingMode = self.timingModes[indexPath.row]
        cell.titleLabel.text = cell.timingMode.name()
        return cell
    }
}

