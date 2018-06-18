import Foundation

func nextafter<T: FloatingPoint>(_ lhs: T, _ rhs: T) -> T {
    switch(T.self) {
    case is Float.Type:
        return nextafterf(lhs as! Float, rhs as! Float) as! T
    case is Double.Type:
        return nextafter(lhs as! Double, rhs as! Double) as! T
    default:
        fatalError("Unsupported type: \(T.self)")
    }
}
