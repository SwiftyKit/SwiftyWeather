//
//  HomeViewModel.swift
//  SwiftyWeather
//
//  Created by lingzhao on 2019/6/15.
//  Copyright © 2019 apple. All rights reserved.
//

import UIKit

class HomeViewModel: NSObject {

    func fetchWeather(with coordinates: Coordinates, completionHandler: @escaping (WeatherReport?) -> Void) {
        
        NetworkManager.shared.fetchWeather(with: coordinates) { (result) in
            switch result {
            case .Success(let value):
                completionHandler(value)
            case .Failure(let error):
                completionHandler(nil)
                print(error)
            }
        }
    }
}
