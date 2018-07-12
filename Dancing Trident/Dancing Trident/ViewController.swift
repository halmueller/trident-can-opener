//
//  ViewController.swift
//  Dancing Trident
//
//  Created by Hal Mueller on 7/11/18.
//  Copyright © 2018 Hal Mueller. All rights reserved.
//

import Cocoa

class ViewController: NSViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    @IBAction func tryIt(_ sender: Any) {
        if let path = Bundle.main.path(forAuxiliaryExecutable: "bin/forestdb_dump") {
            print(path)
            let executableURL = URL(fileURLWithPath: path)
            let option = "--hex-body"
            let sampleDBFile = "/Users/hal/DevelopmentSandbox/TridentTools/files/data/s_da7b5973-9f0e-4ced-a138-b024eee51be7.cblite2/db.forest.0"
            do { try
                Process.run(executableURL, arguments: [option, sampleDBFile]) { (proc) in
                    print(proc)
                }
            } catch {
                print("oops")
            }
        }
    }

    override var representedObject: Any? {
        didSet {
        // Update the view, if already loaded.
        }
    }


}

