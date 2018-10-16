/// Xorshift+ pseudorandom number generator.
/// - Note: Original paper.
///         http://vigna.di.unimi.it/ftp/papers/xorshiftplus.pdf
public struct XorshiftPlusGenerator: RandomNumberGenerator {
    public var x: UInt64
    public var y: UInt64
    
    /// Create `XorshiftPlusGenerator`.
    /// - precondition: At least one of seeds must be non-zero.
    public init(x: UInt64, y: UInt64) {
        precondition(x != 0 || y != 0, "Needs non-zero seeds.")
        self.x = x
        self.y = y
    }
    
    /// Create `XorshiftPlusGenerator` seeded with `generator`.
    public init<G: RandomNumberGenerator>(using generator: inout G) {
        var x, y: UInt64
        repeat {
            x = generator.next()
            y = generator.next()
        } while x == 0 && y == 0
        
        self.init(x: x, y: y)
    }
    
    /// Create `XorshiftPlusGenerator` seeded with `SystemRandomNumberGenerator`.
    public init() {
        var g = SystemRandomNumberGenerator()
        self.init(using: &g)
    }
    
    public mutating func next() -> UInt64 {
        let t1 = x ^ (x << 23)
        x = y
        y = t1 ^ x ^ (t1 >> 17) ^ (x >> 26)
        return x &+ y
    }
}
