//
//  NetworkConfig.swift
//  SwiftyWeather
//
//  Created by lingzhao on 2019/6/14.
//  Copyright © 2019 apple. All rights reserved.
//

import Foundation

enum NWResult<T> {
    case Success(T)
    case Failure(Error)
}


protocol NWURLProtocol {
    var baseURL: String { get }
    var requestURL: String { get }
}

