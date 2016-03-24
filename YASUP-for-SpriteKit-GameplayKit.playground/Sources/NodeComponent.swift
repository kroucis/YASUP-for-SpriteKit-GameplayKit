//
//  NodeComponent.swift
//  YASUP-for-SpriteKit-GameplayKit
//
//  Created by Kyle Roucis on 15-9-15.
//  Copyright © 2015 Kyle Roucis. All rights reserved.
//

import SpriteKit
import GameplayKit

public class NodeComponent : GKComponent
{
    public let node: SKNode

    public init(root: SKNode)
    {
        self.node = root
        super.init()
    }
    
}
