//
//  DancerViewController.swift
//  Dancing Trident
//
//  Created by Hal Mueller on 7/16/18.
//  Copyright © 2018 Hal Mueller. All rights reserved.
//

import Cocoa
import SceneKit

class DancerViewController: NSViewController {

    var managedObjectContext: NSManagedObjectContext? = nil

    @IBOutlet weak var scnView: SCNView!
    
    @IBAction func beginReplay(_ sender: Any) {
        print(self.managedObjectContext as Any)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do view setup here.

        let scene = SCNScene()

        // create and add a camera to the scene
        let cameraNode = SCNNode()
        cameraNode.camera = SCNCamera()
        scene.rootNode.addChildNode(cameraNode)
        cameraNode.camera?.automaticallyAdjustsZRange = true
        cameraNode.camera?.usesOrthographicProjection = true

        // place the camera
        cameraNode.position = SCNVector3(x: 0, y: 0, z: 15)

        // create and add a light to the scene
        let lightNode = SCNNode()
        lightNode.light = SCNLight()
        lightNode.light!.type = .omni
        lightNode.position = SCNVector3(x: 0, y: 10, z: 10)
        scene.rootNode.addChildNode(lightNode)

        // create and add an ambient light to the scene
        let ambientLightNode = SCNNode()
        ambientLightNode.light = SCNLight()
        ambientLightNode.light!.type = .ambient
        ambientLightNode.light!.color = NSColor.darkGray
        scene.rootNode.addChildNode(ambientLightNode)

        let tridentABCURL = Bundle.main.url(forResource: "art.scnassets/Trident", withExtension: "abc")
        let tridentABC =  SCNSceneSource(url: tridentABCURL!)
        let abcscene = tridentABC?.scene(options: [.convertToYUp: true, .convertUnitsToMeters: true])
        let tridentNode = (abcscene?.rootNode.childNodes[0])!
        // Looks like the units are millimeters? Convert to meters.
        tridentNode.simdScale = simd_float3(0.001)
        scene.rootNode.addChildNode(tridentNode)

        // set the scene to the view
        scnView.scene = scene

        // allows the user to manipulate the camera
        scnView.allowsCameraControl = true

        // show statistics such as fps and timing information
        scnView.showsStatistics = true

        //        let boxNode = SCNNode(geometry: SCNBox(width: 1.0, height: 1.0, length: 1.0, chamferRadius: 0.0))
        //        scene.rootNode.addChildNode(boxNode)
        //        scnView.debugOptions = [SCNDebugOptions.renderAsWireframe]

        // configure the view
        scnView.backgroundColor = NSColor.black
    }
    
}
