//
//  PhysicsComponent.swift
//  YASUP-for-SpriteKit-GameplayKit
//
//  Created by Kyle Roucis on 15-9-15.
//  Copyright © 2015 Kyle Roucis. All rights reserved.
//

import SpriteKit
import GameplayKit

public class PhysicsComponent : GKComponent
{
    public let physicsBody: SKPhysicsBody
    init(physicsBody: SKPhysicsBody)
    {
        self.physicsBody = physicsBody
    }

}
