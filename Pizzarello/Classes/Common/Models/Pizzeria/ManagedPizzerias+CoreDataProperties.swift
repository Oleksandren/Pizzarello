//
//  ManagedPizzerias+CoreDataProperties.swift
//  Pizzarello
//
//  Created by Oleksandr Nechet on 24.07.17.
//  Copyright © 2017 Oleksandr Nechet. All rights reserved.
//

import Foundation
import CoreData

extension ManagedPizzeria
{
    @NSManaged var id: String?
    @NSManaged var name: String?
    @NSManaged var distance: NSNumber?
}
