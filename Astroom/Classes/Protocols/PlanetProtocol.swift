import Foundation

protocol PlanetProtocol {
    /// Name of the planet in English
    var name: String {get}
    /// Index of the planet to the sun, i.e sun is 0, mercury is 1...
    var index: Int {get}
    /// Planet spins clockwise from top
    var clockwiseSpin: Bool {get}
    /// Number of hours the planet takes to do full rotation
    var spinTime: Int {get}
    /// Number of days the planet takes to do full orbit around the sun
    var orbitTime: Double {get}
    /// Diameter of the planet in kilometers
    var diameter: Int {get}
    /// Fun fact
    var funFact: String {get}
}
