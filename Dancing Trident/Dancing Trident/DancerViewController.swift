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
import SpriteKit

class DancerViewController: NSViewController {

    var managedObjectContext: NSManagedObjectContext? = nil
    var depthFRC: NSFetchedResultsController<Depth>? = nil
    var attitudeFRC: NSFetchedResultsController<Attitude>? = nil
    var quaternionFRC: NSFetchedResultsController<Quaternion>? = nil
    var vehicleNode: SCNNode? = nil
    @objc var useGizmo = false {
        didSet {
            if useGizmo {
                vehicleNode = gizmoNode
            }
            else {
                vehicleNode = tridentNode
            }
        }
    }
    let gizmoNode = SCNNode.gizmoNode(0.5)
    let tridentNode = SCNNode.tridentNode()

    @IBOutlet weak var scnView: SCNView!

    @IBAction func beginReplay(_ sender: Any) {
        vehicleNode?.removeAllActions()
        
        print(self.managedObjectContext as Any)
        let depthFetchRequest = NSFetchRequest<Depth>(entityName: "Depth")
        let attitudeFetchRequest = NSFetchRequest<Attitude>(entityName: "Attitude")
        let quaternionFetchRequest = NSFetchRequest<Quaternion>(entityName: "Quaternion")
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

        quaternionFetchRequest.sortDescriptors = [timestampSD]
        quaternionFRC = NSFetchedResultsController(fetchRequest: quaternionFetchRequest, managedObjectContext: managedObjectContext!, sectionNameKeyPath: nil, cacheName: "DancerViewControllerQuaternion")
        do {
            try quaternionFRC?.performFetch()
        } catch  {
            print("quaternionFRC fetch failed")
        }

        var position = vehicleNode!.position
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

            let animation = SCNAction.rotateTo(x: CGFloat(attitude.scenekitPitchRadians()),
                                               y: CGFloat(attitude.scenekitYawRadians()),
                                               z: CGFloat(attitude.scenekitRollRadians()),
                                               duration: interval, usesShortestUnitArc: true)
            attitudeActions.append(animation)
        }
        let attitudesSequence = SCNAction.sequence(attitudeActions)

        currentSeconds = quaternionFRC!.fetchedObjects![0].timestamp!.timeIntervalSince1970
        var quaternionActions: [SCNAction] = []
        for quaternion in (quaternionFRC?.fetchedObjects)! {
            //            print(depth.meters, depth.timestamp)
            let newSeconds = quaternion.timestamp!.timeIntervalSince1970
            let interval = newSeconds - currentSeconds
            currentSeconds = newSeconds
            print(interval, quaternion)

//            let animation = SCNAction.quat
//                duration: interval, usesShortestUnitArc: true)
//            quaternionActions.append(animation)
        }
//        let quaternionsSequence = SCNAction.sequence(quaternionActions)

        let group = SCNAction.group([depthsSequence, attitudesSequence])
        vehicleNode?.runAction(group)
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do view setup here.

        let scene = SCNScene.standardScene()

        useGizmo = false

        scene.rootNode.addChildNode(vehicleNode!)

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
        scnView.backgroundColor = NSColor.clear

        let overlayScene = SKScene(fileNamed: "art.scnassets/InformationOverlayScene.sks")
//        scnView.overlaySKScene = overlayScene
    }
    
}
