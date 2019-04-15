//
//  Menu.Group.ViewController.swift
//  MKTweenDemo
//
//  Created by Kevin Malkic on 09/04/2019.
//  Copyright © 2019 Kevin Malkic. All rights reserved.
//

import UIKit
import MKTween
import Cartography

extension Menu.Group {
    
    class ViewController: UIViewController, Menuable {
        
        static let title = "Group"
        let button = UIButton()
        lazy var circleView : UIView = {
            let circleView = UIView(frame: CGRect(x: 0,y: 0,width: 40,height: 40))
            circleView.backgroundColor = .red
            circleView.layer.cornerRadius = 40/2
            circleView.layer.masksToBounds = true
            return circleView
        }()
        
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
            button.addTarget(self, action: #selector(didTap), for: .touchUpInside)
        }
        
        override func viewDidDisappear(_ animated: Bool) {
            super.viewDidDisappear(animated)
            Tween.shared.removeAll()
        }
        
        @objc func didTap() {
            Tween.shared.removeAll()
            // Define Periods
            let periods: [BasePeriod] = [
                Period<CGFloat>(start: 0, end: 200, duration: 1).set(update: { [weak self] period in
                    if let circleView = self?.circleView {
                        var origin = circleView.center
                        origin.x = 20 + (period.progress)
                        circleView.center = origin
                    }
                }).set(timingMode: .linear),
                Period<CGFloat>(start: 0, end: 200, duration: 1).set(update: { [weak self] period in
                    if let circleView = self?.circleView {
                        var origin = circleView.center
                        origin.y = 160 + (period.progress)
                        circleView.center = origin
                    }
                }).set(timingMode: .quadInOut)
            ]
            let group = Group(periods: periods)
                .set(update: { group in
                    print("\(group.periodFinished.filter { $0 }.count) finished on \(group.periodFinished.count)")
                }) {
                    print("complete")
            }
            Tween.shared.add(period: group)
        }
    }
}

extension Menu.Group.ViewController : Subviewable {
    
    func setupSubviews() {
        button.backgroundColor = .red
        button.setTitle("Start", for: .normal)
        
        circleView.center = CGPoint(x: 20, y: 160)
    }
    
    func setupStyles() {
        view.backgroundColor = .white
    }
    
    func setupHierarchy() {
        view.addSubview(button)
        view.addSubview(circleView)
    }
    
    func setupAutoLayout() {
        constrain(button, view) { button, view in
            button.top == view.safeAreaLayoutGuide.top + 20
            button.leading == view.leading + 20
            button.width == 60
            button.height == 44
        }
    }
}
