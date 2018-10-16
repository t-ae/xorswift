/// Xorshift pseudorandom number generator.
/// - Note: Original paper.
///         https://www.jstatsoft.org/index.php/jss/article/view/v008i14/xorshift.pdf
public struct XorshiftGenerator: RandomNumberGenerator {
    public var x: UInt32
    public var y: UInt32
    public var z: UInt32
    public var w: UInt32
    
    /// Create `XorshiftGenerator`.
    /// - precondition: At least one of seeds must be non-zero.
    public init(x: UInt32, y: UInt32, z: UInt32, w: UInt32) {
        precondition(x != 0 || y != 0 || z != 0 || w != 0, "Needs non-zero seeds.")
        self.x = x
        self.y = y
        self.z = z
        self.w = w
    }
    
    /// Create `XorshiftGenerator` seeded with `generator`.
    public init<G: RandomNumberGenerator>(using generator: inout G) {
        var x, y, z, w: UInt32
        repeat {
            x = generator.next()
            y = generator.next()
            z = generator.next()
            w = generator.next()
        } while x == 0 && y == 0 && z == 0 && w == 0
        
        self.init(x: x, y: y, z: z, w: w)
    }
    
    /// Create `XorshiftGenerator` seeded with `SystemRandomNumberGenerator`.
    public init() {
        var g = SystemRandomNumberGenerator()
        self.init(using: &g)
    }
    
    /// Generate random UInt32 number.
    public mutating func next() -> UInt32 {
        let t = x ^ (x << 11)
        x = y; y = z; z = w;
        w = (w ^ (w >> 19)) ^ (t ^ (t >> 8))
        return w
    }
    
    /// Generate random UInt64 number.
    public mutating func next() -> UInt64 {
        let t1 = x ^ (x << 11)
        let t2 = y ^ (y << 11)
        x = z; y = w;
        z = (w ^ (w >> 19)) ^ (t1 ^ (t1 >> 8))
        w = (z ^ (z >> 19)) ^ (t2 ^ (t2 >> 8))
        return UInt64(z) << 32 | UInt64(w)
    }
}
