//
//  ForecastCollectionViewCell.swift
//  SwiftyWeather
//
//  Created by lingzhao on 2019/6/15.
//  Copyright © 2019 apple. All rights reserved.
//

import UIKit

class ForecastCollectionViewCell: UICollectionViewCell {
    
    static let cellReuseID = "ForecastCollectionViewCell"

    /// date label
    @IBOutlet weak var dayLabel: UILabel!
    /// weather icon
    @IBOutlet weak var iconView: UIImageView!
    /// temprature
    @IBOutlet weak var tempLabel: UILabel!
    /// model
    var model: DailyWeather? {
        didSet {
            self.updateCell()
        }
    }
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    

    func updateCell() {
        
        guard let model = model else { return }
        
        dayLabel.text = model.weekDayString ?? ""
        let low = model.temperatureLow?.roundString ?? ""
        let high = model.temperatureHigh?.roundString ?? ""
        tempLabel.text = "\(low)° - \(high)°"
        
       
        iconView.kf.setImage(with: model.iconImageURL)
    }

}
