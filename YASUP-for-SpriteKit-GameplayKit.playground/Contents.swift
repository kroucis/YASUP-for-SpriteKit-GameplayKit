// YASUP for SpriteKit and GameplayKit v1.1.0
// Copyright © Kyle Roucis 2015-2016

import UIKit
import SpriteKit
import GameplayKit
import XCPlayground
import PlaygroundSupport

let view = SKView(frame: CGRect(x: 0, y: 0, width: 200, height: 200))
let scene = SKScene(size: CGSize(width: 256, height: 256))

PlaygroundPage.current.liveView = view
view.presentScene(scene)

let node = SKShapeNode(circleOfRadius: 10)
node.position = CGPoint(x: 100, y: 100)
let nodeComp = GKSKNodeComponent(node: node)

scene.addChild(node)

let moveUp = SKAction.move(by: CGVector(dx: 50, dy: 50), duration: 1.0)
let moveDown = SKAction.move(by: CGVector(dx: -50, dy: -50), duration: 1.0)

node ! ((moveUp |> moveDown)>>)*+

debugPrint(GKRandomSource().randomVectorOnUnitCircle())

let roundedRect = SKShapeNode(rect: CGRect(x: 10, y: 10, width: 100, height: 100), cornerRadius: 15)
scene.addChild(roundedRect)

roundedRect !>> (SKAction.rotate(toAngle: CGFloat(M_PI_4), duration: 2.0) |> SKAction.removeFromParent())
