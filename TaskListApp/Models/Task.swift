//
//  Task.swift
//  TaskListApp
//
//  Created by Victor Zerefos on 23/03/19.
//  Copyright © 2019 Victor Zerefos 🦁. All rights reserved.
//

import Foundation
import RealmSwift


class RealmDataBase {
    
    static var realm: Realm? {
        
        get {
            
            do {
                
                let realm = try Realm()
                return realm
                
            }catch let erro as NSError {
                
                print("Error " + erro.localizedDescription)
                return nil
            }
        }
    }
}// end of class RealmDataBase


class Task: Object {
    
    @objc dynamic var id = 0
    
    override static func primaryKey() -> String {
        return "id"
    }
    
    @objc dynamic var title = ""
    @objc dynamic var dateCreated = NSDate()
    @objc dynamic var isDone = false
    
}
