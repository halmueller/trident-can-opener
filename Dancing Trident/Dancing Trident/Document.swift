//
//  Document.swift
//  Dancing Trident
//
//  Created by Hal Mueller on 7/13/18.
//  Copyright © 2018 Hal Mueller. All rights reserved.
//

import Cocoa
import CoreData

class Document: NSPersistentDocument {

    var defaultSSVURL: URL?

    override init() {
        super.init()
        // Add your subclass-specific initialization here.
    }

    override class var autosavesInPlace: Bool {
        return true
    }

    override func makeWindowControllers() {
        // Returns the Storyboard that contains your Document window.
        let storyboard = NSStoryboard(name: NSStoryboard.Name("Main"), bundle: nil)
        Swift.print("before", self.windowControllers)
        let windowController = storyboard.instantiateController(withIdentifier: NSStoryboard.SceneIdentifier("Document Window Controller")) as! NSWindowController
        self.addWindowController(windowController)
        Swift.print("after", self.windowControllers)
    }

     override func addWindowController(_ windowController: NSWindowController) {
        super.addWindowController(windowController)
        Swift.print(windowController.contentViewController!)
        for childVC in windowController.contentViewController!.childViewControllers {
            if let summaryVC = childVC as? SummaryViewController {
                summaryVC.managedObjectContext = self.managedObjectContext
            }
            else if let dataVC = childVC as? DataViewController {
                dataVC.managedObjectContext = self.managedObjectContext
            }
            else if let dancerVC = childVC as? DancerViewController {
                dancerVC.managedObjectContext = self.managedObjectContext
            }
            Swift.print(childVC)
        }
    }
    
    @IBAction func importDefaultSSV(_ sender: Any) {
        defaultSSVURL = URL(fileURLWithPath: "/Users/hal/DevelopmentSandbox/TridentTools/trident-hacks/samples/Trident-Jul-18-185925.ssv")

        if let moc = managedObjectContext {
            do {
                let undoer = moc.undoManager
                moc.undoManager = nil
                let contents = try String(contentsOf: defaultSSVURL!, encoding: String.Encoding.utf8)
                let lines = contents.split(separator: "\n")
                let dummyLog = TimestampedLogEntry(context: moc)
                dummyLog.timestamp = Date()
                var currentAttitude: Attitude? = nil
                var currentQuaternion: Quaternion? = nil
                for line in lines {
                    let fields = line.split(separator: " ")
                    if let epochSeconds = Double(fields[0]) {
                        let timestamp = Date(timeIntervalSince1970: epochSeconds)
                        let name = fields[1]
                        let value = Double(fields[2]) ?? 0.0
                        if name == "depth" {
                            let _ = Depth(timestamp: timestamp, meters: value, context: moc)
                        }
                        else if name == "temp.water.temperature.temperature_" {
                            let _ = Temperature(timestamp: timestamp, degreesCelsius: value, context: moc)
                        }
                        else if name.hasPrefix("attitude.calc.") {
                            if currentAttitude == nil ||
                                currentAttitude!.timestamp != timestamp {
                                currentAttitude = Attitude(timestamp: timestamp, context: moc)
                            }

                            // update
                            if name == "attitude.calc.pitch" {
                                currentAttitude!.pitchDegrees = value
                            }
                            else if name == "attitude.calc.roll" {
                                currentAttitude!.rollDegrees = value
                            }
                            else if name == "attitude.calc.yaw" {
                                currentAttitude!.yawDegrees = value
                            }
                        }
                        else if name.hasPrefix("attitude.orientation") {
                            if currentQuaternion == nil ||
                                currentQuaternion!.timestamp != timestamp {
                                currentQuaternion = Quaternion(timestamp: timestamp, context: moc)
                            }
                            if name == "attitude.orientation.w" {
                                currentQuaternion!.w = value
                            }
                            else if name == "attitude.orientation.x" {
                                currentQuaternion!.x = value
                            }
                            else if name == "attitude.orientation.y" {
                                currentQuaternion!.y = value
                            }
                            else if name == "attitude.orientation.z" {
                                currentQuaternion!.z = value
                            }

                        }
                        else {
                            //                        Swift.print(timestamp, name, value)
                        }
                    }
                }
                try self.managedObjectContext?.save()
                moc.undoManager = undoer
            } catch {
                Swift.print("Didn't work")
            }
        }
    }

}
