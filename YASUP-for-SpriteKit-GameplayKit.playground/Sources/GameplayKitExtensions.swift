//
//  GameplayKitExtensions.swift
//  YASUP-for-SpriteKit-GameplayKit
//
//  Created by Kyle Roucis on 15-9-25.
//  Copyright © 2015 Kyle Roucis. All rights reserved.
//

import CoreGraphics
import GameplayKit

public extension GKRandom
{
    func randomVectorOnUnitCircle() -> CGVector
    {
        let uniform = self.nextUniform()
        let piTimes2 = Float(M_PI * 2.0)
        let radians = uniform * piTimes2
        let x = cos(radians)
        let y = sin(radians)

        return CGVectorMake(CGFloat(x), CGFloat(y))
    }

    func randomPointInRect(rect: CGRect) -> CGPoint
    {
        let dx = rect.size.width * CGFloat(self.nextUniform())
        let dy = rect.size.height * CGFloat(self.nextUniform())

        let x = rect.origin.x + dx
        let y = rect.origin.y + dy

        return CGPoint(x: x, y: y)
    }

    func randomElementFromArray<T>(array: [ T ]) -> T
    {
        let idx = self.nextIntWithUpperBound(array.count)
        return array[idx]
    }
    
}
