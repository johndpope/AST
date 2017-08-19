import Foundation
import ARKit

class PlanetUnitMapper {
    static func radiusScaleMapping(diameter: Float, anchor: ARPlaneAnchor) -> CGFloat {
        let solarSystemLength = Float(208.0)
        let skyPlaneMinimumLength = min(anchor.extent.x, anchor.extent.z)
        let percentageRadius = ((diameter/2) / solarSystemLength)
        let totalRadius = percentageRadius * skyPlaneMinimumLength
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
    
    static func orbitRotationMapping(orbitTime: Double) -> CFTimeInterval {
        return CFTimeInterval(orbitTime/50.0)
    }
    
    static func axisRotationMapping(spinTime: Double) -> CFTimeInterval {
        return CFTimeInterval(spinTime/24.0)
    }
}
