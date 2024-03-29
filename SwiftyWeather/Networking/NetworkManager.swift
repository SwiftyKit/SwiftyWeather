//
//  ServiceConfig.swift
//  SwiftyWeather
//
//  Created by lingzhao on 2019/6/14.
//  Copyright © 2019 apple. All rights reserved.
//
import UIKit
import Alamofire
import ObjectMapper
import SwiftyJSON

struct Coordinates {
    let latitude: Double
    let longitude: Double
}


enum ForecastProvider: NWURLProtocol {
    case DarkSky(apiKey: String, coordinates: Coordinates)
    var baseURL: String {
        return "https://api.darksky.net"
    }
    var requestURL: String {
        switch self {
        case .DarkSky(let apiKey, let coordinates):
            return baseURL + "/forecast/\(apiKey)/\(coordinates.latitude),\(coordinates.longitude)"
        }
    }
}


final class NetworkManager {
    
    private static let instance = NetworkManager()
    let apiKey: String = ""
    
    // Singleton network manager
    public static var shared: NetworkManager {
        return self.instance
    }
    
    // data request based on Alamofire
    private func requestData<T: Mappable>(URLString : String, parameters : [String : Any]? = nil, completionHandler: @escaping (NWResult<T>) -> Void) {
 
        // send http request
        
        Alamofire.request(URLString, method: .get, parameters: parameters).validate().responseJSON { (response) in
            switch response.result {
            case .success(let json):
                print(json)
                let rspJson = JSON(json as Any)
                if let value = T(JSON: rspJson.dictionaryObject ?? [:]) {
                    completionHandler(.Success(value))
                }
            case .failure(let error):
                completionHandler(.Failure(error))
                
            }
        }
    }
    
    func fetchWeather(with coordinates: Coordinates, completionHandler: @escaping (NWResult<WeatherReport>) -> Void) {
        
        let urlString = ForecastProvider.DarkSky(apiKey: apiKey, coordinates: coordinates).requestURL
        
        requestData(URLString: urlString, parameters: nil) { (result: NWResult<WeatherReport>) in
            switch result {
            case .Success(let value):
                // success response.
                print(value)
            case.Failure(let error):
                // show error alert etc.
                print(error)
            }
            
            completionHandler(result)
        }
        
        
    }
    
}
