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
        let canOpener = CommandLineCanOpener()
        canOpener.tryIt()
    }

    override var representedObject: Any? {
        didSet {
        // Update the view, if already loaded.
        }
    }


}

