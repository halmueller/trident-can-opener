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
        self.pitchDegrees = pitch
        self.rollDegrees = roll
        self.yawDegrees = yaw
    }
    convenience init(timestamp: Date, context: NSManagedObjectContext) {
        self.init(context: context)
        self.timestamp = timestamp
    }

    func scenekitPitchRadians() -> Double {
        return pitchDegrees * Double.pi / 180.0
    }

    func scenekitYawRadians() -> Double {
        return yawDegrees * Double.pi / 180.0
    }

    func scenekitRollRadians() -> Double {
        return rollDegrees * Double.pi / 180.0
    }
}
