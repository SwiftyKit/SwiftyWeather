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

    /// 日期
    @IBOutlet weak var dayLabel: UILabel!
    /// 天气图标
    @IBOutlet weak var iconView: UIImageView!
    /// 气温
    @IBOutlet weak var tempLabel: UILabel!
    /// 数据
    var model: DailyWeather? {
        didSet {
            dayLabel.text = model?.dateString ?? ""
            let low = model?.temperatureLow?.roundString ?? ""
            let high = model?.temperatureHigh?.roundString ?? ""
            tempLabel.text = "\(low)° - \(high)°"
            
            // FIXME: 只是传了白天的天气，需进行判断 时间 为 早间/晚间
            iconView.kf.setImage(with: model?.iconImageURL)
        }
    }
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    


}
