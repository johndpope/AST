import UIKit

struct PlanetViewModel {
    /// Name of the planet in English
    let name: String!
    /// Index of the planet to the sun, i.e sun is 0, mercury is 1...
    let index: Int!
    /// Distance to the sun in kilometers
    let distanceToSun: Float!
    /// Planet spins clockwise from top
    let clockwiseSpin: Bool!
    /// Number of hours the planet takes to do full rotation
    let spinTime: Double!
    /// Number of days the planet takes to do full orbit around the sun
    let orbitTime: Double!
    /// Diameter of the planet in kilometers
    let diameter: Float!
    /// Texture of the planet
    let texture: UIImage!
    /// Fun fact
    let funFact: String!
}
