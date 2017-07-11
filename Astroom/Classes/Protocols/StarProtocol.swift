import Foundation

protocol StarProtocol {
    /// Name of the star in English
    var name: String {get}
    /// Star spins clockwise from top
    var clockwiseSpin: Bool {get}
    /// Number of hours the star takes to do full rotation
    var spinTime: Int {get}
    /// Diameter of the star in kilometers
    var diameter: Int {get}
    /// Fun fact
    var funFact: String {get}
}
