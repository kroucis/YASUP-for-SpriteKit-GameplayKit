//
//  SpriteKitExtensions.swift
//  YASUP-for-SpriteKit-GameplayKit
//
//  Created by Kyle Roucis on 15-9-15.
//  Copyright © 2015 Big Byte Studios. All rights reserved.
//

import SpriteKit

extension SKNode
{
    class func fromFileNamed<T>(file: String) -> T?
    {
        let scene = SKScene(fileNamed: file)
        return scene?.children[0] as? T
    }

}

extension CGVector
{
    static let unitX = CGVector(dx: 1, dy: 0)
    static let unitY = CGVector(dx: 0, dy: 1)

    var magnitude: CGFloat
    {
        get
        {
            return sqrt((self.dx * self.dx) + (self.dy * self.dy))
        }
    }

    var squaredMagnitude: CGFloat
    {
        get
        {
            return ((self.dx * self.dx) + (self.dy * self.dy))
        }
    }

    var normalized: CGVector
    {
        get
        {
            let mag = self.magnitude
            return CGVector(dx: self.dx / mag, dy: self.dy / mag)
        }
    }

    mutating func normalize() -> Void
    {
        let mag = self.magnitude
        self.dx /= mag
        self.dy /= mag
    }

    mutating func translate(t: CGVector) -> Void
    {
        self.dx += t.dx
        self.dy += t.dy
    }

    func translated(t: CGVector) -> CGVector
    {
        return CGVector(dx: self.dx + t.dx, dy: self.dy + t.dy)
    }

    mutating func scale(s: CGFloat) -> Void
    {
        self.dx *= s
        self.dy *= s
    }

    func scaled(s: CGFloat) -> CGVector
    {
        return CGVector(dx: self.dx * s, dy: self.dy * s)
    }

    func degreesToVector(other: CGVector) -> CGFloat
    {
        return degreesBetweenVector(self, andVector: other)
    }

    func radiansToVector(other: CGVector) -> CGFloat
    {
        return radiansBetweenVector(self, andVector: other)
    }

}

public extension CGPoint
{
    func degreesToPoint(other: CGPoint) -> CGFloat
    {
        return degreesBetweenPoint(self, andPoint: other)
    }

    func radiansToPoint(other: CGPoint) -> CGFloat
    {
        return radiansBetweenPoint(self, andPoint: other)
    }

    static func midpoint(left: CGPoint, right: CGPoint) -> CGPoint
    {
        return CGPoint(x: (left.x + right.x) / 2.0, y: (left.y + right.y) / 2.0)
    }

    static func distanceFromPoint(origin: CGPoint, toPoint dest: CGPoint) -> CGFloat
    {
        let dist = origin.distanceVectorToPoint(dest)
        return dist.magnitude
    }

    func distanceVectorToPoint(other: CGPoint) -> CGVector
    {
        return CGVector(dx: other.x - self.x, dy: other.y - self.y)
    }

    func directionVectorToPoint(other: CGPoint) -> CGVector
    {
        let dist = self.distanceVectorToPoint(other)
        return dist.normalized
    }

    func distanceToPoint(other: CGPoint) -> CGFloat
    {
        let dist = self.distanceVectorToPoint(other)
        return dist.magnitude
    }

    func translated(delta: CGVector) -> CGPoint
    {
        return CGPoint(x: self.x + delta.dx, y: self.y + delta.dy)
    }

    mutating func translate(delta: CGVector) -> Void
    {
        self.x += delta.dx
        self.y += delta.dy
    }

    func scaled(delta: CGVector) -> CGPoint
    {
        return CGPoint(x: self.x * delta.dx, y: self.y * delta.dy)
    }

    mutating func scale(delta: CGVector) -> Void
    {
        self.x *= delta.dx
        self.y *= delta.dy
    }
    
}

public func radiansToDegrees(radians: CGFloat) -> CGFloat
{
    return radians * CGFloat(180.0 / M_PI)
}

public func degreesToRadians(degrees: CGFloat) -> CGFloat
{
    return degrees * CGFloat(M_PI / 180.0)
}

public func degreesBetweenPoint(ref: CGPoint, andPoint dest: CGPoint) -> CGFloat
{
    return radiansToDegrees(radiansBetweenPoint(ref, andPoint: dest))
}

public func radiansBetweenPoint(ref: CGPoint, andPoint dest: CGPoint) -> CGFloat
{
    let distVec = CGVector(dx: dest.x - ref.x, dy: dest.y - ref.y)
    return distVec.radiansToVector(CGVector.unitX)
}

public func degreesBetweenVector(ref: CGVector, andVector dest: CGVector) -> CGFloat
{
    return radiansToDegrees(radiansBetweenVector(ref, andVector: dest))
}

public func radiansBetweenVector(ref: CGVector, andVector dest: CGVector) -> CGFloat
{
    return atan2(dest.dy - ref.dy, dest.dx - ref.dx)
}

public func *(vec: CGVector, scale: CGFloat) -> CGVector
{
    return vec.scaled(scale)
}

public func *(size: CGSize, scale: CGFloat) -> CGSize
{
    return CGSize(width: size.width * scale, height: size.height * scale)
}

public func +(p: CGPoint, d: CGVector) -> CGPoint
{
    return p.translated(d)
}

public func -(left: CGVector, right: CGVector) -> CGVector
{
    return CGVector(dx: left.dx - right.dx, dy: left.dy - right.dy)
}

public func -(left: CGPoint, right: CGPoint) -> CGPoint
{
    return CGPoint(x: left.x - right.x, y: left.y - right.y)
}

public func +(left: CGPoint, right: CGPoint) -> CGPoint
{
    return CGPoint(x: left.x + right.x, y: left.y + right.y)
}

////////////////////////////////////////////////////////////////////////////////////////////////////
//          == Custom SKAction Operator Semantics ==
//
//  SKAction |> SKAction == Creates an array of actions, which can then be transformed into sequence
//      or group actions.
//  [ SKAction ]>> == Creates a SKSequenceAction with the array of SKActions.
//  [ SKAction ]|| == Creates a SKGroupAction with the array of SKActions.
//  SKNode ! SKAction == Runs the SKAction on the SKNode
//  SKNode !>> [ SKAction ] == Creates a SKSequenceAction with the array of SKActions, then runs the
//      resulting sequence action on the SKNode.
//  SKNode !|| [ SKAction ] == Creates a SKGroupAction with the array of SKActions, then runs the 
//      resulting group action on the SKNode.
//  SKAction*+ == Creates an action to repeat the SKAction forever.
//  SKAction *+ N == Creates an action to repeat the SKAction N times.
//
//  EXAMPLES:
//  node ! SKAction.removeFromParent()
//  node !>> SKAction.playSound
//  node ! SKAction.animateWithTextures(anim, timePerFrame: 0.06)*+
//  node !>> SKAction.playSoundFileNamed(soundToPlay, waitForCompletion: false) |> 
//      SKAction.waitForDuration(1.5) |> SKAction.removeFromParent()
//  node ! ((SKAction.scaleTo(1.5, duration: 0.25) |> SKAction.scaleTo(0.5, duration: 0.25))>>)*+
//
////////////////////////////////////////////////////////////////////////////////////////////////////

infix operator |> { associativity left precedence 160 }
infix operator ! { }
infix operator !>> { precedence 80 }
infix operator !|| { precedence 80 }
postfix operator >> { }
postfix operator || { }
postfix operator *+ { }
infix operator *+ { precedence 140 }

public func |>(first: SKAction, second: SKAction) -> [ SKAction ]
{
    return [ first, second ]
}

public func |>(actions: [ SKAction ], next: SKAction) -> [ SKAction ]
{
    var acts = actions
    acts.append(next)
    return acts
}

public postfix func >>(actions: [ SKAction ]) -> SKAction
{
    return SKAction.sequence(actions)
}

public postfix func ||(actions: [ SKAction ]) -> SKAction
{
    return SKAction.group(actions)
}

public func !(node: SKNode, action: SKAction) -> Void
{
    node.runAction(action)
}

public func !>>(node: SKNode, actions: [ SKAction ]) -> Void
{
    node ! actions>>
}

public func !||(node: SKNode, actions: [ SKAction ]) -> Void
{
    node ! actions||
}

public postfix func *+(action: SKAction) -> SKAction
{
    return SKAction.repeatActionForever(action)
}

public func *+(action: SKAction, times: Int) -> SKAction
{
    return SKAction.repeatAction(action, count: times)
}
