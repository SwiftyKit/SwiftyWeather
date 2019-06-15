//
//  NetworkConfig.swift
//  SwiftyWeather
//
//  Created by lingzhao on 2019/6/14.
//  Copyright © 2019 apple. All rights reserved.
//

enum NWResult<T> {
    case Success(T)
    case Failure(Error)
}


protocol NWURLProtocol {
    var baseURL: URL { get }
    var path: String { get }
}

