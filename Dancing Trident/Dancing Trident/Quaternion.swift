//
//  Quaternion.swift
//  Dancing Trident
//
//  Created by Hal Mueller on 7/24/18.
//  Copyright © 2018 Hal Mueller. All rights reserved.
//

import Cocoa

extension Quaternion {
    convenience init(timestamp: Date, context: NSManagedObjectContext) {
        self.init(context: context)
        self.timestamp = timestamp
    }
}
