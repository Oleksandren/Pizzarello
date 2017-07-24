//
//  PizzeriasNetworkProvider.swift
//  Pizzarello
//
//  Created by Oleksandr Nechet on 24.07.17.
//  Copyright © 2017 Oleksandr Nechet. All rights reserved.
//

import Foundation
import AFNetworking
import SwiftyJSON
import ObjectMapper

class PizzeriasNetworkProvider
{
    struct Parameters
    {
        private init() {}
        
        internal static let urlString = "https://api.foursquare.com/v2/venues/search"
        internal static let location = "40.7,-74"
        internal static let clientId = "Z41AFEJHN1MBGJYFBL0OGH4PWEZWSLV4MJZMHDR5KDYEWNAJ"
        internal static let clientSecret = "YLSEZM2JFSKHOCSCUGVQCUGQFQYB0CRW54LMGG42UKKQJPO0"
        internal static let version = "20170720"
        internal static let limit = "10"
    }
    
    struct Keys
    {
        private init() {}
        
        struct Request
        {
            private init() {}
            
            internal static let location = "ll"
            internal static let clientId = "client_id"
            internal static let clientSecret = "client_secret"
            internal static let version = "v"
            internal static let offset = "offset"
            internal static let limit = "limit"
        }
        
        struct Response
        {
            private init() {}
            
            internal static let response = "response"
            internal static let venues = "venues"
        }
    }
    
    
    private let manager = AFHTTPSessionManager()
    
    //MARK: - 
    
    func fetchPizzerias(completionHandler: @escaping (PizzeriasResponse<[Pizzeria]>) -> Void)
    {
        let parameters = [Keys.Request.location: Parameters.location,
                          Keys.Request.clientId: Parameters.clientId,
                          Keys.Request.clientSecret: Parameters.clientSecret,
                          Keys.Request.version: Parameters.version,
                          Keys.Request.limit: Parameters.limit]
        
        manager.get(Parameters.urlString,
                    parameters: parameters,
                    progress: nil,
                    success: { (task, response) in
                        let responseJSON = JSON(response!)
                        let venuesJSON = responseJSON[Keys.Response.response][Keys.Response.venues].arrayObject
                        guard let pizzerias = Mapper<Pizzeria>().mapArray(JSONObject: venuesJSON) else
                        {
                            fatalError()
                        }
                        
                        completionHandler(PizzeriasResponse.success(result: pizzerias))
                        
        }) { (task, error) in
            completionHandler(PizzeriasResponse.failure(errorMessage: error.localizedDescription))
        }
    }
}
