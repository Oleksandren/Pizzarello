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
import CoreLocation

class PizzeriasNetworkProvider
{
    struct Parameters
    {
        private init() {}
        
        internal static let urlString = "https://api.foursquare.com/v2/venues/explore"
        internal static let clientId = "Z41AFEJHN1MBGJYFBL0OGH4PWEZWSLV4MJZMHDR5KDYEWNAJ"
        internal static let clientSecret = "YLSEZM2JFSKHOCSCUGVQCUGQFQYB0CRW54LMGG42UKKQJPO0"
        internal static let version = "20170720"
        internal static let limit = "10"
        internal static let categoryIdPizza = "4bf58dd8d48988d1ca941735"
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
            internal static let categoryId = "categoryId"
        }
        
        struct Response
        {
            private init() {}
            
            internal static let response = "response"
            internal static let groups = "groups"
            internal static let items = "items"
            internal static let venue = "venue"
        }
    }
    
    
    private let manager = AFHTTPSessionManager()
    
    //MARK: - 
    
    func fetchChunkPizzerias(location: CLLocationCoordinate2D,
                             withOffset offset: Int,
                             completionHandler: @escaping (PizzeriasResponse<[Pizzeria]>) -> Void)
    {
        let locationParam = "\(location.latitude),\(location.longitude)"
        
        let parameters = [Keys.Request.location: locationParam,
                          Keys.Request.clientId: Parameters.clientId,
                          Keys.Request.clientSecret: Parameters.clientSecret,
                          Keys.Request.version: Parameters.version,
                          Keys.Request.categoryId: Parameters.categoryIdPizza,
                          Keys.Request.limit: Parameters.limit,
                          Keys.Request.offset: String(offset)]
        
        manager.get(Parameters.urlString,
                    parameters: parameters,
                    progress: nil,
                    success: { (task, response) in
                        let responseJSON = JSON(response!)[Keys.Response.response]
                        let groupsJSON = responseJSON[Keys.Response.groups].arrayValue
                        let itemsJSON = groupsJSON[0][Keys.Response.items].arrayValue
                        
                        let pizzerias = itemsJSON.flatMap { itemJSON -> Pizzeria? in
                            let venueJSON = itemJSON[Keys.Response.venue].object
                            let pizzeria = Mapper<Pizzeria>().map(JSONObject: venueJSON)
                            
                            return pizzeria
                        }
                        
                        completionHandler(PizzeriasResponse.success(result: pizzerias))
                        
        }) { (task, error) in
            completionHandler(PizzeriasResponse.failure(errorMessage: error.localizedDescription))
        }
    }
}
