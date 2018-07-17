//
//  WaterTemperature+Methods.swift
//  Dancing Trident
//
//  Created by Hal Mueller on 7/16/18.
//  Copyright © 2018 Hal Mueller. All rights reserved.
//

import CoreData

extension Temperature {
    convenience init(timestamp: Date, degreesCelsius: Double, context: NSManagedObjectContext) {
        self.init(context: context)
        self.timestamp = timestamp
        self.degreesCelsius = degreesCelsius
    }

}

