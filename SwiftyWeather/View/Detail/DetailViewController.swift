//
//  DetailViewController.swift
//  SwiftyWeather
//
//  Created by lingzhao on 2019/6/15.
//  Copyright © 2019 apple. All rights reserved.
//

import UIKit

class DetailViewController: UIViewController {
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var iconImageView: UIImageView!
    @IBOutlet weak var summaryLabel: UILabel!
    
    var dailyWeather: DailyWeather? 
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.title = "Detail"
        self.updateUI()
    }


    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */
    
    func updateUI() {
        dateLabel.text = "\(dailyWeather?.weekDayString ?? ""), \(dailyWeather?.dateString ?? "")"
        iconImageView.kf.setImage(with: dailyWeather?.iconImageURL)
        summaryLabel.text = dailyWeather?.summary ?? ""
    }

}
