//
//  DancerViewController.swift
//  Dancing Trident
//
//  Created by Hal Mueller on 7/16/18.
//  Copyright © 2018 Hal Mueller. All rights reserved.
//

import Cocoa
import SceneKit
import CoreData

class DancerViewController: NSViewController {

    var managedObjectContext: NSManagedObjectContext? = nil
    var depthFRC: NSFetchedResultsController<Depth>? = nil
    var attitudeFRC: NSFetchedResultsController<Attitude>? = nil
    var tridentNode: SCNNode? = nil

    @IBOutlet weak var scnView: SCNView!

    @IBAction func beginReplay(_ sender: Any) {
        print(self.managedObjectContext as Any)
        let depthFetchRequest = NSFetchRequest<Depth>(entityName: "Depth")
        let attitudeFetchRequest = NSFetchRequest<Attitude>(entityName: "Attitude")
        let timestampSD = NSSortDescriptor(key: "timestamp", ascending: true)

        depthFetchRequest.sortDescriptors = [timestampSD]
        depthFRC = NSFetchedResultsController(fetchRequest: depthFetchRequest, managedObjectContext: managedObjectContext!, sectionNameKeyPath: nil, cacheName: "DancerViewControllerDepth")
        do {
            try depthFRC?.performFetch()
        } catch  {
            print("depthFRC fetch failed")
        }

        attitudeFetchRequest.sortDescriptors = [timestampSD]
        attitudeFRC = NSFetchedResultsController(fetchRequest: attitudeFetchRequest, managedObjectContext: managedObjectContext!, sectionNameKeyPath: nil, cacheName: "DancerViewControllerAttitude")
        do {
            try attitudeFRC?.performFetch()
        } catch  {
            print("attitudeFRC fetch failed")
        }

        var position = tridentNode!.position
        var currentSeconds = depthFRC!.fetchedObjects![0].timestamp!.timeIntervalSince1970
        var depthActions: [SCNAction] = []
        for depth in (depthFRC?.fetchedObjects)! {
            //            print(depth.meters, depth.timestamp)
            let newSeconds = depth.timestamp!.timeIntervalSince1970
            let interval = newSeconds - currentSeconds
            currentSeconds = newSeconds
            position.y = -1.0 * CGFloat(depth.meters)
            print(interval, position)
            let animation = SCNAction.move(to: position, duration: interval)
            depthActions.append(animation)
        }
        let depthsSequence = SCNAction.sequence(depthActions)

        currentSeconds = attitudeFRC!.fetchedObjects![0].timestamp!.timeIntervalSince1970
        var attitudeActions: [SCNAction] = []
        for attitude in (attitudeFRC?.fetchedObjects)! {
            //            print(depth.meters, depth.timestamp)
            let newSeconds = attitude.timestamp!.timeIntervalSince1970
            let interval = newSeconds - currentSeconds
            currentSeconds = newSeconds
            print(interval, attitude)
            let animation = SCNAction.rotateTo(x: CGFloat(attitude.roll), y: CGFloat(attitude.yaw), z: CGFloat(attitude.pitch), duration: interval, usesShortestUnitArc: true)
            attitudeActions.append(animation)
        }
        let attitudesSequence = SCNAction.sequence(attitudeActions)

        let group = SCNAction.group([depthsSequence, attitudesSequence])
        tridentNode?.runAction(group)
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
        tridentNode = (abcscene?.rootNode.childNodes[0])!
        // Looks like the units are millimeters? Convert to meters.
        tridentNode!.simdScale = simd_float3(0.001)
        scene.rootNode.addChildNode(tridentNode!)

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
