import Foundation
import ARKit

class PlanetUnitMapper {
    static func radiusScaleMapping(diameter: Float, anchor: ARPlaneAnchor) -> CGFloat {
        let solarSystemLength = Float(208.0)
        let skyPlaneMinimumLength = min(anchor.extent.x, anchor.extent.z)
        let percentageRadius = ((diameter/2) / solarSystemLength)
        print(percentageRadius)
        let totalRadius = percentageRadius * skyPlaneMinimumLength
        print(totalRadius)
        return CGFloat(totalRadius)
    }
    
    static func positionMapping(distanceToSun: Float, anchor: ARPlaneAnchor) -> SCNVector3 {
        let solarSystemLength = Float(208.0)
        let skyPlaneMinimumLength = min(anchor.extent.x, anchor.extent.z)
        let mappedDistanceToSun = (distanceToSun / solarSystemLength) * skyPlaneMinimumLength
        let xPosition = anchor.center.x + mappedDistanceToSun
        let yPosition = (((anchor.extent.x + anchor.extent.z)/2)/2)
        let zPosition = anchor.center.z
        return SCNVector3Make(xPosition, yPosition, zPosition)
    }
    
    func rotationMapping(planet: PlanetNode) {
        
    }
}
