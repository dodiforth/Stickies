//
//  CoreDataManager.swift
//  Stickies
//
//  Created by Dowon Kim on 03/09/2023.
//

import UIKit
import CoreData

final class CoreDataManager {
    
    static let shared = CoreDataManager()
    private init() {}
    
    let appDelegate = UIApplication.shared.delegate as? AppDelegate
    
    lazy var context = appDelegate?.persistentContainer.viewContext
    
    let modelName: String = "TodoData"
    
    func getTodoListFromCoreData() -> [TodoData] {
        var todoList: [TodoData] = []
        if let context = context {
            let request = NSFetchRequest<NSManagedObject>(entityName: self.modelName)
            let dateOrder = NSSortDescriptor(key: "date", ascending: false)
            request.sortDescriptors = [dateOrder]
            
            do {
                if let fetchedTodoList = try context.fetch(request) as? [TodoData] {
                    todoList = fetchedTodoList
                }
            } catch {
                print("Get Datas Failed!!!")
            }
        }
        
        return todoList
    }
    
    func saveTodoData(todoText: String?, colorInt: Int64, completion: @escaping () -> Void) {
        if let context = context {
            if let entity = NSEntityDescription.entity(forEntityName: self.modelName, in: context) {
                
                if let todoData = NSManagedObject(entity: entity, insertInto: context) as? TodoData {
                    
                    todoData.memoText = todoText
                    todoData.date = Date()
                    todoData.colour = colorInt
                    
                    if context.hasChanges {
                        do {
                            try context.save()
                            completion()
                        } catch {
                            print(error)
                            completion()
                        }
                    }
                }
            }
        }
        completion()
    }
    
    func deleteTodo(data: TodoData, completion: @escaping () -> Void) {
        guard let date = data.date else {
            completion()
            return
        }
        
        if let context = context {
            let request = NSFetchRequest<NSManagedObject>(entityName: self.modelName)
            request.predicate = NSPredicate(format: "date = %@", date as CVarArg)
            
            do {
                if let fetchedTodoList = try context.fetch(request) as? [TodoData] {
                    
                    if let targetTodo = fetchedTodoList.first {
                        context.delete(targetTodo)
                        
                        if context.hasChanges {
                            do {
                                try context.save()
                                completion()
                            } catch {
                                print(error)
                                completion()
                            }
                        }
                    }
                }
                completion()
            } catch {
                print("Deleting Failed!")
                completion()
            }
        }
    }
    
    func updateTodo(newTodoData: TodoData, completion: @escaping () -> Void) {
        guard let date = newTodoData.date else {
            completion()
            return
        }
        
        if let context = context {
            let request = NSFetchRequest<NSManagedObject>(entityName: self.modelName)
            request.predicate = NSPredicate(format: "date = %@", date as CVarArg)
            
            do {
                if let fetchedTodoList = try context.fetch(request) as? [TodoData] {
                    if var targetTodo = fetchedTodoList.first {
                        
                        targetTodo = newTodoData
                        
                        if context.hasChanges {
                            do {
                                try context.save()
                                completion()
                            } catch {
                                print(error)
                                completion()
                            }
                        }
                    }
                }
                completion()
            } catch {
                print("Updating Failed!")
                completion()
            }
        }
    }
}


