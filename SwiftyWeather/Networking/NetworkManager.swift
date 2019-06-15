//
//  ServiceConfig.swift
//  SwiftyWeather
//
//  Created by lingzhao on 2019/6/14.
//  Copyright © 2019 apple. All rights reserved.
//

import Alamofire

struct Coordinates {
    let latitude: Double
    let longitude: Double
}


enum ForecastURL: NWURLProtocol {
    case DarkSky(apiKey: String, coordinates: Coordinates)
    var baseURL: URL {
        return URL(string: "https://api.darksky.net")!
    }
    var path: String {
        switch self {
        case .DarkSky(let apiKey, let coordinates):
            return "/forecast/\(apiKey)/\(coordinates.latitude),\(coordinates.longitude)"
        }
    }
}


final class NetworkManager {
    
    private static let instance = NetworkManager()
    let apiKey: String = "595a1df1e1ba2b82bcf927c2f5cb4bfd"
    
    // Singleton network manager
    public static var shared: NetworkManager {
        return self.instance
    }
    
    func fetchWeather(with coordinates: Coordinates, completionHandler: @escaping (NwResult<CurrentWeather>) -> Void) {
        
    }
    
}
