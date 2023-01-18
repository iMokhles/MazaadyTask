//
//  CoreAPI.swift
//  MazaadyTask
//
//  Created by iMokhles on 16/01/2023.
//

import Alamofire
import Foundation

open class CoreAPI {
    struct Shared {
        static var instance: CoreAPI?
    }

    open class var sharedInstance: CoreAPI {
        if Shared.instance == nil {
            Shared.instance = CoreAPI()
        }
        return Shared.instance!
    }

    let manager: Alamofire.Session = {
        let configuration = URLSessionConfiguration.default
        configuration.timeoutIntervalForResource = APIConstants.Network.timeoutInterval
        configuration.timeoutIntervalForRequest = APIConstants.Network.timeoutInterval
        configuration.requestCachePolicy = .reloadIgnoringLocalCacheData
        return Alamofire.Session(configuration: configuration, serverTrustManager: nil)
    }()
}
