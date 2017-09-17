import UIKit

class PlanetConstants {
    static let mercury = PlanetViewModel(name: "Mercury",
                                         index: 1,
                                         distanceToSun: 18,
                                         clockwiseSpin: false,
                                         spinTime: 1407,
                                         orbitTime: 88.0,
                                         diameter: 2,
                                         texture: #imageLiteral(resourceName: "MercuryText"),
                                         funFact: "Mercury is the closest planet to the sun")
    
    static let venus = PlanetViewModel(name: "Venus",
                                         index: 2,
                                         distanceToSun: 26,
                                         clockwiseSpin: true,
                                         spinTime: -5832,
                                         orbitTime: 224.7,
                                         diameter: 4,
                                         texture: #imageLiteral(resourceName: "VenusText"),
                                         funFact: "Venus is the hottest planet in the solar system")
    
    static let earth = PlanetViewModel(name: "Earth",
                                         index: 3,
                                         distanceToSun: 32,
                                         clockwiseSpin: false,
                                         spinTime: 24,
                                         orbitTime: 365.0,
                                         diameter: 4,
                                         texture: #imageLiteral(resourceName: "EarthText.jpg"),
                                         funFact: "Earth has the largest mass of water")
    
    static let mars = PlanetViewModel(name: "Mars",
                                         index: 4,
                                         distanceToSun: 38,
                                         clockwiseSpin: false,
                                         spinTime: 25,
                                         orbitTime: 687.0,
                                         diameter: 3,
                                         texture: #imageLiteral(resourceName: "MarsText"),
                                         funFact: "Mars is the closest planet to Earth")
    
    static let jupiter = PlanetViewModel(name: "Jupiter",
                                         index: 5,
                                         distanceToSun: 48,
                                         clockwiseSpin: false,
                                         spinTime: 10,
                                         orbitTime: 4331.0,
                                         diameter: 10,
                                         texture: #imageLiteral(resourceName: "JupiterText"),
                                         funFact: "Jupiter is the largest planet in the solar system")
    
    static let saturn = PlanetViewModel(name: "Saturn",
                                         index: 6,
                                         distanceToSun: 64,
                                         clockwiseSpin: false,
                                         spinTime: 11,
                                         orbitTime: 10747.0,
                                         diameter: 8,
                                         texture: #imageLiteral(resourceName: "SaturnText"),
                                         funFact: "Saturn has many rings")
    
    static let uranus = PlanetViewModel(name: "Uranus",
                                         index: 7,
                                         distanceToSun: 80,
                                         clockwiseSpin: true,
                                         spinTime: -17,
                                         orbitTime: 30589.0,
                                         diameter: 6,
                                         texture: UIImage.from(color: #colorLiteral(red: 0.5294117647, green: 0.8078431373, blue: 0.9215686275, alpha: 1)),
                                         funFact: "Uranus also has rings")
    
    static let neptune = PlanetViewModel(name: "Neptune",
                                         index: 8,
                                         distanceToSun: 90,
                                         clockwiseSpin: false,
                                         spinTime: 16,
                                         orbitTime: 59800.0,
                                         diameter: 5,
                                         texture: #imageLiteral(resourceName: "NeptuneText"),
                                         funFact: "Neptune is a greek god")
    
    static let pluto = PlanetViewModel(name: "Pluto",
                                         index: 9,
                                         distanceToSun: 96,
                                         clockwiseSpin: false,
                                         spinTime: -153,
                                         orbitTime: 90560.0,
                                         diameter: 1,
                                         texture: #imageLiteral(resourceName: "PlutoText"),
                                         funFact: "Pluto is the furthest planet from the sun")
}
