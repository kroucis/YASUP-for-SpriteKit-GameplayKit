// YASUP for SpriteKit and GameplayKit
// Copyright © Kyle Roucis 2015-2016

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

    func translated(by t: CGVector) -> CGVector
    {
        return CGVector(dx: self.dx + t.dx, dy: self.dy + t.dy)
    }

    mutating func scale(s: CGFloat) -> Void
    {
        self.dx *= s
        self.dy *= s
    }

    func scaled(by s: CGFloat) -> CGVector
    {
        return CGVector(dx: self.dx * s, dy: self.dy * s)
    }

    mutating func rotate(θ: CGFloat) -> Void
    {
        let xp = self.dx * cos(θ) - self.dy * sin(θ)
        let yp = self.dx * sin(θ) + self.dy * cos(θ)
        self.dx = xp
        self.dy = yp
    }

    func rotated(by θ: CGFloat) -> CGVector
    {
        return CGVector(dx: self.dx * cos(θ) - self.dy * sin(θ), dy: self.dx * sin(θ) + self.dy * cos(θ))
    }

    func degrees(to vector: CGVector) -> CGFloat
    {
        return degreesBetween(self, and: vector)
    }

    func radians(to vector: CGVector) -> CGFloat
    {
        return radiansBetween(self, and: vector)
    }

}

public extension CGPoint
{
    func degrees(to point: CGPoint) -> CGFloat
    {
        return degreesBetween(self, and: point)
    }

    func radians(to point: CGPoint) -> CGFloat
    {
        return radiansBetween(self, and: point)
    }

    static func midpoint(left: CGPoint, right: CGPoint) -> CGPoint
    {
        return CGPoint(x: (left.x + right.x) / 2.0, y: (left.y + right.y) / 2.0)
    }

    static func distance(from point: CGPoint, to dest: CGPoint) -> CGFloat
    {
        let dist = point.distanceVector(to: dest)
        return dist.magnitude
    }

    func distanceVector(to point: CGPoint) -> CGVector
    {
        return CGVector(dx: point.x - self.x, dy: point.y - self.y)
    }

    func directionVectorToPoint(other: CGPoint) -> CGVector
    {
        let dist = self.distanceVector(to: other)
        return dist.normalized
    }

    func distance(to point: CGPoint) -> CGFloat
    {
        let dist = self.distanceVector(to: point)
        return dist.magnitude
    }

    func translated(by delta: CGVector) -> CGPoint
    {
        return CGPoint(x: self.x + delta.dx, y: self.y + delta.dy)
    }

    mutating func translate(delta: CGVector) -> Void
    {
        self.x += delta.dx
        self.y += delta.dy
    }

    func scaled(by delta: CGVector) -> CGPoint
    {
        return CGPoint(x: self.x * delta.dx, y: self.y * delta.dy)
    }

    mutating func scale(delta: CGVector) -> Void
    {
        self.x *= delta.dx
        self.y *= delta.dy
    }

}

public func toDegrees(radians: CGFloat) -> CGFloat
{
    return radians * CGFloat(180.0 / M_PI)
}

public func toRadians(degrees: CGFloat) -> CGFloat
{
    return degrees * CGFloat(M_PI / 180.0)
}

public func degreesBetween(_ point: CGPoint, and dest: CGPoint) -> CGFloat
{
    return toDegrees(radians: radiansBetween(point, and: dest))
}

public func radiansBetween(_ point: CGPoint, and dest: CGPoint) -> CGFloat
{
    let distVec = CGVector(dx: dest.x - point.x, dy: dest.y - point.y)
    return distVec.radians(to: CGVector.unitX)
}

public func degreesBetween(_ vector: CGVector, and dest: CGVector) -> CGFloat
{
    return toDegrees(radians: radiansBetween(vector, and: dest))
}

public func radiansBetween(_ vector: CGVector, and dest: CGVector) -> CGFloat
{
    return atan2(dest.dy - vector.dy, dest.dx - vector.dx)
}

public func *(vec: CGVector, scale: CGFloat) -> CGVector
{
    return vec.scaled(by: scale)
}

public func *(size: CGSize, scale: CGFloat) -> CGSize
{
    return CGSize(width: size.width * scale, height: size.height * scale)
}

public func +(p: CGPoint, d: CGVector) -> CGPoint
{
    return p.translated(by: d)
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

precedencegroup PipePrecedence
{
    associativity: right
    higherThan: RepeatedActionPrecedence
}

precedencegroup ActionCollectionPrecedence
{

}

precedencegroup RepeatedActionPrecedence
{
    higherThan: ActionCollectionPrecedence
}

precedencegroup RunActionPrecendence
{
    associativity: left
    higherThan: ActionCollectionPrecedence
}

infix operator |> : PipePrecedence
infix operator ! : RunActionPrecendence
infix operator !>> : ActionCollectionPrecedence
infix operator !|| : ActionCollectionPrecedence
infix operator *+ : RepeatedActionPrecedence
postfix operator >>
postfix operator ||
postfix operator *+

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
    node.run(action)
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
    return SKAction.repeatForever(action)
}

public func *+(action: SKAction, times: Int) -> SKAction
{
    return SKAction.repeat(action, count: times)
}
