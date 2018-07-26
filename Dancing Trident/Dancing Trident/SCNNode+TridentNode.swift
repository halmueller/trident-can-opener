//
//  Trident+SCNNode.swift
//  Dancing Trident
//
//  Created by Hal Mueller on 7/25/18.
//  Copyright © 2018 Hal Mueller. All rights reserved.
//

import SceneKit

extension SCNNode {
    class func tridentNode() -> SCNNode {
        let tridentNode: SCNNode
        let tridentABCURL = Bundle.main.url(forResource: "art.scnassets/Trident", withExtension: "abc")
        let tridentABC =  SCNSceneSource(url: tridentABCURL!)
        let abcscene = tridentABC?.scene(options: [.convertToYUp: true, .convertUnitsToMeters: true])
        tridentNode = (abcscene?.rootNode.childNodes[0])!
        // Looks like the units are millimeters? Convert to meters.
        tridentNode.simdScale = simd_float3(0.001)

        // as built, the ABC file has the pivot point at the extreme bow
        tridentNode.pivot = SCNMatrix4MakeTranslation(0.0, 0.0, -200.0)

        return tridentNode
    }
}
