//
//  ManagedPizzeria.swift
//  Pizzarello
//
//  Created by Oleksandr Nechet on 24.07.17.
//  Copyright © 2017 Oleksandr Nechet. All rights reserved.
//

import Foundation
import CoreData

class ManagedPizzeria: NSManagedObject
{
    func toPizzeria() -> Pizzeria
    {
        return Pizzeria(id: id!,
                        name: name!,
                        distance: distance!.intValue)
    }
    
    func fromPizzeria(pizzeria: Pizzeria)
    {
        id = pizzeria.id
        name = pizzeria.name
        distance = pizzeria.distance as NSNumber
    }
}
