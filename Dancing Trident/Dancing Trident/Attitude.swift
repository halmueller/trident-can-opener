//
//  Attitude.swift
//  Dancing Trident
//
//  Created by Hal Mueller on 7/17/18.
//  Copyright © 2018 Hal Mueller. All rights reserved.
//

import CoreData

extension Attitude {
    convenience init(timestamp: Date, pitch: Double, roll: Double, yaw: Double, context: NSManagedObjectContext) {
        self.init(context: context)
        self.timestamp = timestamp
        self.pitch = pitch
        self.roll = roll
        self.yaw = yaw
    }
    convenience init(timestamp: Date, context: NSManagedObjectContext) {
        self.init(context: context)
        self.timestamp = timestamp
    }
}
