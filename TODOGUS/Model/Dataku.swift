//
//  Dataku.swift
//  TODOGUS
//
//  Created by Agus Cahyono on 2/4/16.
//  Copyright © 2016 Agus Cahyono. All rights reserved.
//


import RealmSwift

class Dataku: Object {
    
    /// Define tables
    dynamic var id = 1
    dynamic var name = ""
    dynamic var email = ""
    dynamic var age = 0
    dynamic var createdAt = NSDate()
    
    /**
     Primary key
     
     - returns: primary key id
     */
    override static func primaryKey() -> String? {
        return "id"
    }
    
    
    /**
     Create increents id for realm
     
     - returns: increments id
     */
    func IncrementID() -> Int{
        let realm = try! Realm()
        let RetNext: NSArray = Array(realm.objects(Dataku).sorted("id"))
        let last = RetNext.lastObject
        if RetNext.count > 0 {
            let valor = last?.valueForKey("id") as? Int
            return valor! + 1
        } else {
            return 1
        }
    }
    
}
