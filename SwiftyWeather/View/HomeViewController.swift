//
//  HomeViewController.swift
//  SwiftyWeather
//
//  Created by lingzhao on 2019/6/15.
//  Copyright © 2019 apple. All rights reserved.
//

import UIKit

class HomeViewController: UIViewController {
    
    @IBOutlet weak var iconImage: UIImageView!
    @IBOutlet weak var currentSummaryLabel: UILabel!
    @IBOutlet weak var currentWindLabel: UILabel!
    @IBOutlet weak var currentVisibilityLabel: UILabel!
    @IBOutlet weak var currentHumidityLabel: UILabel!
    @IBOutlet weak var currentTemperatureLabel: UILabel!

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        let rightBarButtonItem = UIBarButtonItem(image: UIImage(named: "refresh"), style: .plain, target: self, action: #selector(rightClick))
        navigationItem.rightBarButtonItem = rightBarButtonItem
    }


    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */
    
    //MARK: actions
    
    @objc func rightClick() {
        NetworkManager.shared.fetchWeather(with: Coordinates(latitude: 37.8267, longitude: -122.4233)) { (result) in
            print(result)
        }
    }

}
