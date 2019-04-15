//
//  Menu.Timing.ViewController.swift
//  MKTweenDemo
//
//  Created by Kevin Malkic on 09/04/2019.
//  Copyright © 2019 Kevin Malkic. All rights reserved.
//

import UIKit
import MKTween
import Cartography

extension Menu.Timing {
    
    class ViewController: UIViewController, Menuable {
        
        static let title = "Timing"
        
        let cellHeight : CGFloat = 100
        let headerHeight : CGFloat = 100
        
        let headerView = HeaderView()
        let timingModes = Timing.all
        let tableView = UITableView()
        
        required init() {
            super.init(nibName: nil, bundle: nil)
            setup()
        }
        
        required init?(coder aDecoder: NSCoder) {
            fatalError("init(coder:) has not been implemented")
        }
        
        override func viewDidLoad() {
            
            super.viewDidLoad()
            
            title = ViewController.title
            tableView.register(Cell.self, forCellReuseIdentifier: "cell")
            tableView.separatorStyle = .none
            
            tableView.delegate = self
            tableView.dataSource = self
        }
        
        override func viewDidDisappear(_ animated: Bool) {
            super.viewDidDisappear(animated)
            Tween.shared.removeAll()
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
        let selectedCell = tableView.cellForRow(at: indexPath) as? Menu.Timing.Cell
        
        if !Tween.shared.removePeriod(by: tweenName) {
            Tween.shared.removeAll()
            let headerHeight = self.headerHeight
            
            Tween.shared.value(start: CGFloat(0), end: 1, duration: 2).set(update: { [weak self] period in
                
                self?.headerView.circleView.center = CGPoint(x: newRect.origin.x + (newRect.width * period.progress), y: (headerHeight/2))
                selectedCell?.progressTime = CGFloat(period.timePassed / period.duration)
                
            }).set(timingMode: timingMode).set(name: tweenName).set(repeatType: .foreverPingPong)
            
        } else {
            selectedCell?.progressTime = 0
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
        cell.progressTime = 0
        return cell
    }
}

extension Menu.Timing.ViewController : Subviewable {
    
    func setupSubviews() {
        
    }
    
    func setupStyles() {
        
    }
    
    func setupHierarchy() {
        view.addSubview(tableView)
    }
    
    func setupAutoLayout() {
        constrain(tableView, view) { tableView, view in
            tableView.edges == view.edges
        }
    }
}
