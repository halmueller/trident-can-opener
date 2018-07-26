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

/*
     let animation = SCNAction.rotateTo(x: CGFloat(attitude.scenekitPitchRadians()),
     y: CGFloat(attitude.scenekitYawRadians()),
     z: 0.0, //CGFloat(attitude.scenekitRollRadians()),
 */

    class func scenekitPitchRadians(_ pitchDegrees: Double) -> Double {
        return -1.0 * pitchDegrees * Double.pi / 180.0
    }

    class func scenekitYawRadians(_ yawDegrees: Double) -> Double {
        return -1.0 * yawDegrees * Double.pi / 180.0
    }

    class func scenekitRollRadians(_ rollDegrees: Double) -> Double {
        return rollDegrees * Double.pi / 180.0
    }

    func scenekitPitchRadians() -> Double {
        return Attitude.scenekitPitchRadians(self.pitchDegrees)
    }

    func scenekitYawRadians() -> Double {
        return Attitude.scenekitYawRadians(self.yawDegrees)
    }

    func scenekitRollRadians() -> Double {
        return Attitude.scenekitRollRadians(self.rollDegrees)
    }
}
