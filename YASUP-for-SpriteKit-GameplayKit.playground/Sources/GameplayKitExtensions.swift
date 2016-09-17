// YASUP for SpriteKit and GameplayKit
// Copyright © Kyle Roucis 2015-2016

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

        return CGVector(dx: CGFloat(x), dy: CGFloat(y))
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
        let idx = self.nextInt(upperBound: array.count)
        return array[idx]
    }
    
}
