//
//  PizzeriasListRouter.swift
//  Pizzarello
//
//  Created by Oleksandr Nechet on 23.07.17.
//  Copyright (c) 2017 Oleksandr Nechet. All rights reserved.
//
//  This file was generated by the Clean Swift Xcode Templates so
//  you can apply clean architecture to your iOS and Mac projects,
//  see http://clean-swift.com
//

import UIKit

@objc protocol PizzeriasListRoutingLogic
{
    //func routeToSomewhere(segue: UIStoryboardSegue?)
}

protocol PizzeriasListDataPassing
{
    var dataStore: PizzeriasListDataStore? { get }
}

class PizzeriasListRouter: NSObject, PizzeriasListRoutingLogic, PizzeriasListDataPassing
{
    weak var viewController: PizzeriasListViewController?
    var dataStore: PizzeriasListDataStore?
}
