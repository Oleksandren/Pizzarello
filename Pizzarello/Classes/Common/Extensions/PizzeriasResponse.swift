//
//  PizzeriasInteractorResponse.swift
//  Pizzarello
//
//  Created by Oleksandr Nechet on 24.07.17.
//  Copyright © 2017 Oleksandr Nechet. All rights reserved.
//

import Foundation

enum PizzeriasResponse<T>
{
    case success(result: T)
    case failure(errorMessage: String)
}
