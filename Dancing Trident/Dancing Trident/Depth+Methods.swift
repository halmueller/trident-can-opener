//
//  DepthReading+Methods.swift
//  Dancing Trident
//
//  Created by Hal Mueller on 7/16/18.
//  Copyright © 2018 Hal Mueller. All rights reserved.
//

import CoreData

extension Depth {
    convenience init(timestamp: Date, meters: Double, context: NSManagedObjectContext) {
        self.init(context: context)
        self.timestamp = timestamp
        self.meters = meters
    }
}
