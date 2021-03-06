//
//  PizzeriaDetailsModels.swift
//  Pizzarello
//
//  Created by Oleksandr Nechet on 25.07.17.
//  Copyright (c) 2017 Oleksandr Nechet. All rights reserved.
//
//  This file was generated by the Clean Swift Xcode Templates so
//  you can apply clean architecture to your iOS and Mac projects,
//  see http://clean-swift.com
//

import UIKit

enum PizzeriaDetails
{
    struct ViewModel
    {
        struct DisplayedItem
        {
            var title: String
            var value: String
        }
        
        var displayedItems: [DisplayedItem]
    }
}
