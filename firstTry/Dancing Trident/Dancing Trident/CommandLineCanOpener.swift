//
//  CommandLineCanOpener.swift
//  Dancing Trident
//
//  Created by Hal Mueller on 7/11/18.
//  Copyright © 2018 Hal Mueller. All rights reserved.
//

import Cocoa

class CommandLineCanOpener: NSObject {

    func tryIt() {
        if let path = Bundle.main.path(forAuxiliaryExecutable: "bin/forestdb_dump") {
            print(path)
            let executableURL = URL(fileURLWithPath: path)
            let option = "--hex-body"
            let sampleDBFile = "/Users/hal/DevelopmentSandbox/TridentTools/files/data/s_da7b5973-9f0e-4ced-a138-b024eee51be7.cblite2/db.forest.0"
            let task = Process()
            task.executableURL = executableURL
            task.arguments = [option, sampleDBFile]

            let pipe = Pipe()
            task.standardOutput = pipe
            let outHandle = pipe.fileHandleForReading
            outHandle.waitForDataInBackgroundAndNotify()

            var allData = NSMutableData()
            var obs1 : NSObjectProtocol!
            obs1 = NotificationCenter.default.addObserver(forName: NSNotification.Name.NSFileHandleDataAvailable, object: outHandle, queue: nil) {  notification -> Void in
                let data = outHandle.availableData
                if data.count > 0 {
                    allData.append(data)
                    if let str = String(data: data, encoding: String.Encoding.utf8) {
//                        print("got output: \(str)")
                    }
                    outHandle.waitForDataInBackgroundAndNotify()
                } else {
                    print("EOF on stdout from process")
                    NotificationCenter.default.removeObserver(obs1)
                }
            }
            task.terminationHandler = {(proc: Process) in
                print(proc)
                let result = String(data: allData as Data, encoding: String.Encoding.utf8)
                print(result)
            }
            do { try
                task.run()
            } catch {
                print("oops")
            }
        }

    }
}
