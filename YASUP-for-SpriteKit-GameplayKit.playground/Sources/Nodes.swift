//
//  NodeComponent.swift
//  YASUP-for-SpriteKit-GameplayKit
//
//  Created by Kyle Roucis on 15-9-15.
//  Copyright © 2015 Kyle Roucis. All rights reserved.
//

import SpriteKit
import GameplayKit

public protocol ReferencesEntity
{
    var entity: GKEntity! { get set }
    
}

public class SpriteEntityNode : SKSpriteNode, ReferencesEntity
{
    public var entity: GKEntity!

}

public class ShapeEntityNode : SKShapeNode, ReferencesEntity
{
    public var entity: GKEntity!

}

public class EntityNode : SKNode, ReferencesEntity
{
    public var entity: GKEntity!
    
}
