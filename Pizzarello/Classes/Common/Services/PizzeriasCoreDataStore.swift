//
//  PizzeriasCoreDataStore.swift
//  Pizzarello
//
//  Created by Oleksandr Nechet on 24.07.17.
//  Copyright © 2017 Oleksandr Nechet. All rights reserved.
//

import CoreData

class PizzeriasCoreDataStore: NSObject, PizzeriasStoreProtocol
{
    var fetchedPizeriasDidChanged: (([Pizzeria])-> Void)?
    private var mainManagedObjectContext: NSManagedObjectContext
    private var privateManagedObjectContext: NSManagedObjectContext
    fileprivate var frc: NSFetchedResultsController<ManagedPizzeria>
    
    
    // MARK: - Object lifecycle
    
    override init()
    {
        guard let modelURL = Bundle.main.url(forResource: "Pizzarello", withExtension: "momd") else {
            fatalError("Error loading model from bundle")
        }
        
        guard let mom = NSManagedObjectModel(contentsOf: modelURL) else {
            fatalError("Error initializing mom from: \(modelURL)")
        }
        
        let psc = NSPersistentStoreCoordinator(managedObjectModel: mom)
        mainManagedObjectContext = NSManagedObjectContext(concurrencyType: .mainQueueConcurrencyType)
        mainManagedObjectContext.persistentStoreCoordinator = psc
        
        let urls = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        let docURL = urls.last!
        
        let storeURL = docURL.appendingPathComponent("Pizzarello.sqlite")
        do {
            try psc.addPersistentStore(ofType: NSSQLiteStoreType, configurationName: nil, at: storeURL, options: nil)
        } catch {
            fatalError("Error migrating store: \(error)")
        }
        
        privateManagedObjectContext = NSManagedObjectContext(concurrencyType: .privateQueueConcurrencyType)
        privateManagedObjectContext.parent = mainManagedObjectContext
        
        
        
        let fetchRequest = NSFetchRequest<ManagedPizzeria>(entityName: "ManagedPizzeria")
        
        
        
        fetchRequest.sortDescriptors = [NSSortDescriptor(key: "distance", ascending: true)]
        
        frc = NSFetchedResultsController(fetchRequest: fetchRequest ,
                                         managedObjectContext: mainManagedObjectContext,
                                         sectionNameKeyPath: nil,
                                         cacheName: nil)
        
        
        
        super.init()
        
        frc.delegate = self
    }
    
    deinit
    {
        do {
            try self.mainManagedObjectContext.save()
        } catch {
            fatalError("Error deinitializing main managed object context")
        }
    }
    
    // MARK: - CRUD operations
    
    func fetchPizzerias(completionHandler: @escaping PizzeriasStoreFetchPizzeriasCompletionHandler)
    {
        privateManagedObjectContext.perform {
            do {
                let fetchRequest = NSFetchRequest<ManagedPizzeria>(entityName: "ManagedPizzeria")
                let results = try self.privateManagedObjectContext.fetch(fetchRequest)
                let pizzerias = results.map { $0.toPizzeria() }
                completionHandler(PizzeriasStoreResult.success(result: pizzerias))
            } catch {
                completionHandler(PizzeriasStoreResult.failure(error: PizzeriasStoreError.cannotFetch("Cannot fetch pizzerias")))
            }
        }
    }
    
    func fetchPizzeria(id: String, completionHandler: @escaping PizzeriasStoreFetchPizzeriaCompletionHandler)
    {
        privateManagedObjectContext.perform {
            do {
                let fetchRequest = NSFetchRequest<ManagedPizzeria>(entityName: "ManagedPizzeria")
                fetchRequest.predicate = NSPredicate(format: "id == %@", id)
                let results = try self.privateManagedObjectContext.fetch(fetchRequest)
                if let pizzeria = results.first?.toPizzeria() {
                    completionHandler(PizzeriasStoreResult.success(result: pizzeria))
                } else {
                    completionHandler(PizzeriasStoreResult.failure(error: PizzeriasStoreError.cannotFetch("Cannot fetch pizzeria with id \(id)")))
                }
            } catch {
                completionHandler(PizzeriasStoreResult.failure(error: PizzeriasStoreError.cannotFetch("Cannot fetch pizzeria with id \(id)")))
            }
        }
    }
    
    func createPizzeria(pizzeriaToCreate: Pizzeria, completionHandler: @escaping PizzeriasStoreCreatePizzeriaCompletionHandler)
    {
        privateManagedObjectContext.perform {
            do {
                let managedPizzeria = NSEntityDescription.insertNewObject(forEntityName: "ManagedPizzeria", into: self.privateManagedObjectContext) as! ManagedPizzeria
                let pizzeria = pizzeriaToCreate
                managedPizzeria.fromPizzeria(pizzeria: pizzeria)
                try self.privateManagedObjectContext.save()
                try self.mainManagedObjectContext.save()
                completionHandler(PizzeriasStoreResult.success(result: pizzeria))
            } catch {
                let error = PizzeriasStoreError.cannotCreate("Cannot create pizzeria with id \(String(describing: pizzeriaToCreate.id))")
                completionHandler(PizzeriasStoreResult.failure(error: error))
            }
        }
    }
    
    func createPizzerias(pizzeriasToCreate: [Pizzeria],
                         completionHandler: @escaping PizzeriasStoreCreatePizzeriasCompletionHandler)
    {
        privateManagedObjectContext.perform {
            do {
                var createdPizzeras: [Pizzeria] = []
                
                for pizzeriaToCreate in pizzeriasToCreate {
                    let managedPizzeria = NSEntityDescription.insertNewObject(forEntityName: "ManagedPizzeria",
                                                                              into: self.privateManagedObjectContext) as! ManagedPizzeria
                    let pizzeria = pizzeriaToCreate
                    managedPizzeria.fromPizzeria(pizzeria: pizzeriaToCreate)
                    createdPizzeras.append(pizzeria)
                    
                }
                
                try self.privateManagedObjectContext.save()
                try self.mainManagedObjectContext.save()
                
                completionHandler(PizzeriasStoreResult.success(result: createdPizzeras))
            } catch {
                let error = PizzeriasStoreError.cannotCreate("Cannot create pizzerias")
                completionHandler(PizzeriasStoreResult.failure(error: error))
            }
        }
    }
    
    func updatePizzeria(pizzeriaToUpdate: Pizzeria, completionHandler: @escaping PizzeriasStoreUpdatePizzeriaCompletionHandler)
    {
        privateManagedObjectContext.perform {
            do {
                let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "ManagedPizzeria")
                fetchRequest.predicate = NSPredicate(format: "id == %@", pizzeriaToUpdate.id)
                let results = try self.privateManagedObjectContext.fetch(fetchRequest) as! [ManagedPizzeria]
                if let managedPizzeria = results.first {
                    do {
                        managedPizzeria.fromPizzeria(pizzeria: pizzeriaToUpdate)
                        let pizzeria = managedPizzeria.toPizzeria()
                        try self.privateManagedObjectContext.save()
                        try self.mainManagedObjectContext.save()
                        completionHandler(PizzeriasStoreResult.success(result: pizzeria))
                    } catch {
                        completionHandler(PizzeriasStoreResult.failure(error: PizzeriasStoreError.cannotUpdate("Cannot update pizzeria with id \(String(describing: pizzeriaToUpdate.id))")))
                    }
                }
            } catch {
                completionHandler(PizzeriasStoreResult.failure(error: PizzeriasStoreError.cannotUpdate("Cannot fetch pizzeria with id \(String(describing: pizzeriaToUpdate.id)) to update")))
            }
        }
    }
    
    func deletePizzeria(id: String, completionHandler: @escaping PizzeriasStoreDeletePizzeriaCompletionHandler)
    {
        privateManagedObjectContext.perform {
            do {
                let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "ManagedPizzeria")
                fetchRequest.predicate = NSPredicate(format: "id == %@", id)
                let results = try self.privateManagedObjectContext.fetch(fetchRequest) as! [ManagedPizzeria]
                if let managedPizzeria = results.first {
                    let pizzeria = managedPizzeria.toPizzeria()
                    self.privateManagedObjectContext.delete(managedPizzeria)
                    do {
                        try self.privateManagedObjectContext.save()
                        try self.mainManagedObjectContext.save()
                        completionHandler(PizzeriasStoreResult.success(result: pizzeria))
                    } catch {
                        completionHandler(PizzeriasStoreResult.failure(error: PizzeriasStoreError.cannotDelete("Cannot delete pizzeria with id \(id)")))
                    }
                } else {
                    completionHandler(PizzeriasStoreResult.failure(error: PizzeriasStoreError.cannotDelete("Cannot fetch pizzeria with id \(id) to delete")))
                }
            } catch {
                completionHandler(PizzeriasStoreResult.failure(error: PizzeriasStoreError.cannotDelete("Cannot fetch pizzeria with id \(id) to delete")))
            }
        }
    }
    
    func fetchPizzeriasWithChangesObserving(completionHandler: @escaping PizzeriasStoreFetchPizzeriasCompletionHandler)
    {
        do {
            try frc.performFetch()
            
            var pizzerias: [Pizzeria] = []
            if let fetchedObjects = frc.fetchedObjects {
                pizzerias = fetchedObjects.map { $0.toPizzeria() }
            }
            
            completionHandler(PizzeriasStoreResult.success(result: pizzerias))
            
        } catch let error {
            completionHandler(PizzeriasStoreResult.failure(error: PizzeriasStoreError.cannotFetch(error.localizedDescription)))
        }
    }
    
    
}

extension PizzeriasCoreDataStore: NSFetchedResultsControllerDelegate
{
    func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>)
    {
        var pizzerias: [Pizzeria] = []
        if let fetchedObjects = frc.fetchedObjects {
            pizzerias = fetchedObjects.map { $0.toPizzeria() }
        }
        
        fetchedPizeriasDidChanged?(pizzerias)
    }
}
