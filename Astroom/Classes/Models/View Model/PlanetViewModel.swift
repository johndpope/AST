import UIKit

struct PlanetViewModel {
    /// Name of the planet in English
    let name: String!
    /// Index of the planet to the sun, i.e sun is 0, mercury is 1...
    let index: Int!
    /// Planet spins clockwise from top
    let clockwiseSpin: Bool!
    /// Number of hours the planet takes to do full rotation
    let spinTime: Int!
    /// Number of days the planet takes to do full orbit around the sun
    let orbitTime: Double!
    /// Diameter of the planet in kilometers
    let diameter: Int!
    /// Texture of the planet
    let texture: UIImage!
    /// Fun fact
    let funFact: String!
}

