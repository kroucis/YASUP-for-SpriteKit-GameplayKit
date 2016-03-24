//: Playground - noun: a place where people can play

import UIKit
import SpriteKit
import GameplayKit
import XCPlayground

let view = SKView(frame: CGRect(x: 0, y: 0, width: 200, height: 200))
let scene = SKScene(size: CGSize(width: 200, height: 200))

XCPlaygroundPage.currentPage.liveView = view
view.presentScene(scene)

let node = SKShapeNode(circleOfRadius: 10)
node.position = CGPoint(x: 100, y: 100)
let sn = NodeComponent(root: node)

scene.addChild(sn.node)

class BaseEntity : GKEntity, Updateable
{
    
}

let entity = BaseEntity()
if let ent = entity as? Updateable
{
    print("\(ent)")
}

let moveUp = SKAction.moveBy(CGVector(dx: 50, dy: 50), duration: 1.0)
let moveDown = SKAction.moveBy(CGVector(dx: -50, dy: -50), duration: 1.0)

node ! ((moveUp |> moveDown)>>)*+

debugPrint(GKRandomSource().randomVectorOnUnitCircle())
