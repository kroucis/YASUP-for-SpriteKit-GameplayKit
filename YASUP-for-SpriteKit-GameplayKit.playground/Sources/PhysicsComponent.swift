// YASUP for SpriteKit and GameplayKit
// Copyright © Kyle Roucis 2015-2016

import SpriteKit
import GameplayKit

public class PhysicsComponent : GKComponent
{
    public let physicsBody: SKPhysicsBody
    init(physicsBody: SKPhysicsBody)
    {
        self.physicsBody = physicsBody
        super.init()
    }
    
    required public init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}
