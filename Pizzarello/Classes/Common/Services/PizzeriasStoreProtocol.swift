//
//  PizzeriasStoreProtocol.swift
//  Pizzarello
//
//  Created by Oleksandr Nechet on 24.07.17.
//  Copyright © 2017 Oleksandr Nechet. All rights reserved.
//

import Foundation

protocol PizzeriasStoreProtocol
{
    // MARK: - CRUD operations
    
    func fetchPizzerias(completionHandler: @escaping PizzeriasStoreFetchPizzeriasCompletionHandler)
    func fetchPizzeria(id: String, completionHandler: @escaping PizzeriasStoreFetchPizzeriaCompletionHandler)
    func createPizzerias(pizzeriasToCreate: [Pizzeria], completionHandler: @escaping PizzeriasStoreCreatePizzeriasCompletionHandler)
    func updatePizzeria(pizzeriaToUpdate: Pizzeria, completionHandler: @escaping PizzeriasStoreUpdatePizzeriaCompletionHandler)
    func deletePizzeria(id: String, completionHandler: @escaping PizzeriasStoreDeletePizzeriaCompletionHandler)
    
    
    //MARK: - 
    var fetchedPizeriasDidChanged: (([Pizzeria])-> Void)? { get set }
    func fetchPizzeriasWithChangesObserving(completionHandler: @escaping PizzeriasStoreFetchPizzeriasCompletionHandler)
}

// MARK: - Pizzerias store CRUD operation results

typealias PizzeriasStoreFetchPizzeriasCompletionHandler = (PizzeriasStoreResult<[Pizzeria]>) -> Void
typealias PizzeriasStoreFetchPizzeriaCompletionHandler = (PizzeriasStoreResult<Pizzeria>) -> Void
typealias PizzeriasStoreCreatePizzeriasCompletionHandler = (PizzeriasStoreResult<[Pizzeria]>) -> Void
typealias PizzeriasStoreUpdatePizzeriaCompletionHandler = (PizzeriasStoreResult<Pizzeria>) -> Void
typealias PizzeriasStoreDeletePizzeriaCompletionHandler = (PizzeriasStoreResult<Pizzeria>) -> Void

enum PizzeriasStoreResult<U>
{
    case success(result: U)
    case failure(error: PizzeriasStoreError)
}

// MARK: - Pizzerias store CRUD operation errors

enum PizzeriasStoreError: Equatable, Error
{
    case cannotFetch(String)
    case cannotCreate(String)
    case cannotUpdate(String)
    case cannotDelete(String)
}

func ==(lhs: PizzeriasStoreError, rhs: PizzeriasStoreError) -> Bool
{
    switch (lhs, rhs) {
    case (.cannotFetch(let a), .cannotFetch(let b)) where a == b: return true
    case (.cannotCreate(let a), .cannotCreate(let b)) where a == b: return true
    case (.cannotUpdate(let a), .cannotUpdate(let b)) where a == b: return true
    case (.cannotDelete(let a), .cannotDelete(let b)) where a == b: return true
    default: return false
    }
}
