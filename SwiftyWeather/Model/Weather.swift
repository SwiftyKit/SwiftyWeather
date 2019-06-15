//
//  Weather.swift
//  SwiftyWeather
//
//  Created by lingzhao on 2019/6/15.
//  Copyright © 2019 apple. All rights reserved.
//

import UIKit
import ObjectMapper


class BaseModel: NSObject, Mappable{
    override init() {}
    required init?(map: Map){}
    func mapping(map: Map) {}
}

class DailyWeather: BaseModel {
    // MARK: -members
    var summary: String?
    var icon: String?
    var time: Date?
    var temperature: String?
    var apparentTemperature: String?
    var humidity: String?
    var windSpeed: String?
    var windGust: String?
    var windBearing: String?
    var precipProbability: String?
    var visibility: String?
    var temperatureHigh: String?
    var temperatureHighTime: String?
    var temperatureLow: String?
    var temperatureLowTime: String?
    var dewPoint: String?
    var cloudCover: String?
    var sunriseTime: String?
    var sunsetTime: String?
    
    override func mapping(map: Map) {
        
        let stringTransform = TransformOf<String, Double>(fromJSON: { (value: Double?) -> String? in
            // transform value from Float? to String?
            if let value = value {
                return String(value)
            }
            return nil
        }, toJSON: { (value: String?) -> Double? in
            // transform value from String? to Float?
            return Double(value!)
        })

        
        summary <- map["summary"]
        icon <- map["icon"]
        time <- (map["time"], DateTransform())
        temperature <- (map["temperature"], stringTransform)
        apparentTemperature <- (map["apparentTemperature"], stringTransform)
        humidity <- (map["humidity"], stringTransform)
        windSpeed <- (map["windSpeed"], stringTransform)
        windGust <- (map["windGust"], stringTransform)
        windBearing <- (map["windBearing"], stringTransform)
        precipProbability <- (map["precipProbability"], stringTransform)
        visibility <- (map["visibility"], stringTransform)
        temperatureHigh <- (map["temperatureHigh"], stringTransform)
        temperatureHighTime <- (map["temperatureHighTime"], stringTransform)
        temperatureLow <- (map["temperatureLow"], stringTransform)
        temperatureLowTime <- (map["temperatureLowTime"], stringTransform)
        dewPoint <- (map["dewPoint"], stringTransform)
        cloudCover <- (map["cloudCover"], stringTransform)
        sunriseTime <- (map["sunriseTime"], stringTransform)
        sunsetTime <- (map["sunsetTime"], stringTransform)
    }
    
    var iconImageURL:URL? {
        if let icon = icon {
            return  URL(string: "https://darksky.net/images/weather-icons/\(icon).png")
        }
        return nil
    }
}


class WeatherReport: BaseModel {
    
    var currently: DailyWeather?
    var daily: [DailyWeather]?
    
    override func mapping(map: Map) {
        currently <- map["currently"]
        daily <- map["daily.data"]
    }
}
