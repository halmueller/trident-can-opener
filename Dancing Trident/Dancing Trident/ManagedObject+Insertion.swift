//
//  ManagedObject+Insertion.swift
//  Dancing Trident
//
//  Created by Hal Mueller on 7/13/18.
//  Copyright © 2018 Hal Mueller. All rights reserved.
//

import CoreData
extension NSManagedObject {

        // Returns the unqualified class name, i.e. the last component.
        // Can be overridden in a subclass.
        class func entityName() -> NSEntityDescription {
            return self.entity()
        }

        convenience init(context: NSManagedObjectContext) {
            let eName = type(of: self).entityName()
//            let entity = NSEntityDescription.entityForName(eName, inManagedObjectContext: context)!
            self.init(entity: eName, insertInto: context)
        }
    }

