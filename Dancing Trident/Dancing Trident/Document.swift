//
//  Document.swift
//  Dancing Trident
//
//  Created by Hal Mueller on 7/13/18.
//  Copyright © 2018 Hal Mueller. All rights reserved.
//

import Cocoa

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
        let windowController = storyboard.instantiateController(withIdentifier: NSStoryboard.SceneIdentifier("Document Window Controller")) as! NSWindowController
        self.addWindowController(windowController)
    }

    @IBAction func importDefaultSSV(_ sender: Any) {
        defaultSSVURL = URL(fileURLWithPath: "/Users/hal/DevelopmentSandbox/TridentTools/files/data/s_accdce0e-5efc-4db5-8f03-ed7031f78f7f.ssv")

        do {
            let contents = try String(contentsOf: defaultSSVURL!, encoding: String.Encoding.utf8)
            let lines = contents.split(separator: "\n")
            for line in lines {
                let fields = line.split(separator: " ")
                if let epochSeconds = Double(fields[0]) {
                    let timestamp = Date(timeIntervalSince1970: epochSeconds)
                    let name = fields[1]
                    let value = Double(fields[2]) ?? 0.0
                    if name == "depth" {
                        let depth = DepthReading(context: self.managedObjectContext!)
                        depth.timestamp = timestamp
                        depth.meters = value
                        Swift.print(depth)
                    }
                    else if name == "temp.water.temperature.temperature_" {
                        let temperature = WaterTemperatureReading(context: self.managedObjectContext!)
                        temperature.timestamp = timestamp
                        temperature.degreesCelsius = value
                        Swift.print(temperature)
                    }
                    else {
//                        Swift.print(timestamp, name, value)
                    }
                }
            }
        } catch {
            Swift.print("Didn't work")
        }

    }

}
