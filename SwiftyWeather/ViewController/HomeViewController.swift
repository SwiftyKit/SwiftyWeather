//
//  ViewController.swift
//  SwiftyWeather
//
//  Created by lingzhao on 2019/6/14.
//  Copyright © 2019 apple. All rights reserved.
//

import UIKit

class HomeViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        let rightBarButtonItem = UIBarButtonItem(title: "登录", style: .plain, target: self, action: #selector(rightClick))
        navigationItem.rightBarButtonItem = rightBarButtonItem
    }
    
    @objc func rightClick() {
        NetworkManager.shared.fetchWeather(with: Coordinates(latitude: 37.8267, longitude: -122.4233)) { (result) in
            print(result)
        }
    }
    
}

