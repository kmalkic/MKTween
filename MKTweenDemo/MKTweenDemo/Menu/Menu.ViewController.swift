//
//  Menu.ViewController.swift
//  MKTweenDemo
//
//  Created by Kevin Malkic on 08/04/2019.
//  Copyright © 2024 Kevin Malkic. All rights reserved.
//

import UIKit
import Cartography

protocol Menuable {
    init()
    static var title: String { get }
}

enum Menu {
    enum Timing { }
    enum Group { }
    enum Sequence { }
}

extension Menu {
    
    class ViewController: UIViewController {
        
        let tableView = UITableView()
        let data: [(Menuable & UIViewController).Type] = [Menu.Timing.ViewController.self,
                                                          Menu.Group.ViewController.self,
                                                          Menu.Sequence.ViewController.self]
        
        init() {
            super.init(nibName: nil, bundle: nil)
            setup()
        }
        
        required init?(coder aDecoder: NSCoder) {
            fatalError("init(coder:) has not been implemented")
        }
        
        override func viewDidLoad() {
            super.viewDidLoad()
            title = "Examples"
            tableView.dataSource = self
            tableView.delegate = self
        }
    }
}

extension Menu.ViewController: Subviewable {
    
    func setupSubviews() {
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "Cell")
        tableView.rowHeight = 60
    }
    
    func setupStyles() {

    }
    
    func setupHierarchy() {
        view.addSubview(tableView)
    }
    
    func setupAutoLayout() {
        constrain(tableView, self.view) { tableView, view in
            tableView.edges == view.edges
        }
    }
}

extension Menu.ViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return data.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        cell.textLabel?.text = data[indexPath.row].title
        cell.textLabel?.font = UIFont(name: "HelveticaNeue-Light", size: 16)
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        navigationController?.pushViewController(data[indexPath.row].init(), animated: true)
    }
}
