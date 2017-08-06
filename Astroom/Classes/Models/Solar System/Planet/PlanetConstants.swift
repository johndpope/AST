import UIKit

class PlanetConstants {
    static let mercury = PlanetViewModel(name: "Mercury",
                                         index: 1,
                                         distanceToSun: 59223859,
                                         clockwiseSpin: false,
                                         spinTime: 1407,
                                         orbitTime: 88.0,
                                         diameter: 4880,
                                         texture: UIImage(named: "MercuryText.png"),
                                         funFact: "Mercury is the closest planet to the sun")
    
    static let venus = PlanetViewModel(name: "Venus",
                                         index: 2,
                                         distanceToSun: 108147916,
                                         clockwiseSpin: true,
                                         spinTime: -5832,
                                         orbitTime: 224.7,
                                         diameter: 12104,
                                         texture: UIImage(named: "VenusText.png"),
                                         funFact: "Venus is the hottest planet in the solar system")
    
    static let earth = PlanetViewModel(name: "Earth",
                                         index: 3,
                                         distanceToSun: 149668992,
                                         clockwiseSpin: false,
                                         spinTime: 24,
                                         orbitTime: 365.0,
                                         diameter: 12756,
                                         texture: UIImage(named: "EarthText.png"),
                                         funFact: "Earth has the largest mass of water")
    
    static let mars = PlanetViewModel(name: "Mars",
                                         index: 4,
                                         distanceToSun: 227883110,
                                         clockwiseSpin: false,
                                         spinTime: 25,
                                         orbitTime: 687.0,
                                         diameter: 6792,
                                         texture: UIImage(named: "MarsText.png"),
                                         funFact: "Mars is the closest planet to Earth")
    
    static let jupiter = PlanetViewModel(name: "Jupiter",
                                         index: 5,
                                         distanceToSun: 778278758,
                                         clockwiseSpin: false,
                                         spinTime: 10,
                                         orbitTime: 4331.0,
                                         diameter: 142984,
                                         texture: UIImage(named: "JupiterText.png"),
                                         funFact: "Jupiter is the largest planet in the solar system")
    
    static let saturn = PlanetViewModel(name: "Saturn",
                                         index: 6,
                                         distanceToSun: 1426683456,
                                         clockwiseSpin: false,
                                         spinTime: 11,
                                         orbitTime: 10747.0,
                                         diameter: 120536,
                                         texture: UIImage(named: "SaturnText.png"),
                                         funFact: "Saturn has many rings")
    
    static let uranus = PlanetViewModel(name: "Uranus",
                                         index: 7,
                                         distanceToSun: 2870586892,
                                         clockwiseSpin: true,
                                         spinTime: -17,
                                         orbitTime: 30589.0,
                                         diameter: 51118,
                                         texture: UIImage(named: "NeptuneText.png"),
                                         funFact: "Uranus also has rings")
    
    static let neptune = PlanetViewModel(name: "Neptune",
                                         index: 8,
                                         distanceToSun: 4498438348,
                                         clockwiseSpin: false,
                                         spinTime: 16,
                                         orbitTime: 59800.0,
                                         diameter: 49528,
                                         texture: UIImage(named: "NeptuneText.png"),
                                         funFact: "Neptune is a greek god")
    
    static let pluto = PlanetViewModel(name: "Pluto",
                                         index: 9,
                                         distanceToSun: 5906453414,
                                         clockwiseSpin: false,
                                         spinTime: -153,
                                         orbitTime: 90560.0,
                                         diameter: 2370,
                                         texture: UIImage(named: "PlutoText.png"),
                                         funFact: "Pluto is the furthest planet from the sun")
}
