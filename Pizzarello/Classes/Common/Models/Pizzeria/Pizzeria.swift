//
//  DTOPizzeria.swift
//  Pizzarello
//
//  Created by Oleksandr Nechet on 24.07.17.
//  Copyright © 2017 Oleksandr Nechet. All rights reserved.
//

import Foundation
import ObjectMapper

class Pizzeria: Equatable, Mappable
{
    var id: String = ""
    var name: String = ""
    var distance: Int = -1
    
    init() {}
    
    convenience init(id: String,
         name: String,
         distance: Int)
    {
        self.init()

        self.id = id
        self.name = name
        self.distance = distance
    }
    
    //MARK: - Mappable
    
    private struct Keys {
        static let id = "id"
        static let name = "name"
        static let distance = "location.distance"
    }
    
    required convenience init?(map: Map)
    {
        self.init()
    }
    
    func mapping(map: Map) {
        id <- map[Keys.id]
        name <- map[Keys.name]
        distance <- map[Keys.distance]
    }
}

func ==(lhs: Pizzeria, rhs: Pizzeria) -> Bool
{
    return lhs.id == rhs.id
        && lhs.name == rhs.name
        && lhs.distance == rhs.distance
}


