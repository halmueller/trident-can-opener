//
//  ManagedObject+Insertion.swift
//  Dancing Trident
//
//  Created by Hal Mueller on 7/13/18.
//  Copyright © 2018 Hal Mueller. All rights reserved.
//

import CoreData
extension NSManagedObject {

// updated from https://briancoyner.github.io/2015/08/01/coredata-swift2.html
    public class func entityName() -> String {
        // If the data model is in a framework, then
        // the module name needs to be stripped off.
        //
        // Example:
        //   FooBar.Engine
        //   Engine
        let name = NSStringFromClass(self)
        let result = name.components(separatedBy: ".").last!
        return result
    }

    convenience init(context: NSManagedObjectContext) {
            let eName = type(of: self).entityName()
            let entity = NSEntityDescription.entity(forEntityName: eName, in: context)!
            self.init(entity: entity, insertInto: context)
        }
    }

