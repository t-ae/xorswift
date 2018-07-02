public struct XorshiftGenerator: RandomNumberGenerator {
    
    public static var `default` = XorshiftGenerator()
    
    public var x: UInt32
    public var y: UInt32
    public var z: UInt32
    public var w: UInt32
    
    public init() {
        self.init(x: Random.default.next(),
                  y: Random.default.next(),
                  z: Random.default.next(),
                  w: Random.default.next())
    }
    
    public init(x: UInt32, y: UInt32, z: UInt32, w: UInt32) {
        self.x = x
        self.y = y
        self.z = z
        self.w = w
    }
    
    public mutating func next() -> UInt32 {
        let t = x ^ (x << 11)
        x = y; y = z; z = w;
        w = (w ^ (w >> 19)) ^ (t ^ (t >> 8))
        return w
    }
    
    public mutating func next<T>() -> T where T : FixedWidthInteger, T : UnsignedInteger {
        if T.bitWidth <= 32 {
            let uint32 = next() as UInt32
            return T(uint32 >> (32 - T.bitWidth))
        } else {
            let cnt = (T.bitWidth + 31) / 32
            var ret: T = 0
            for _ in 0..<cnt {
                ret <<= 32
                ret |= T(next() as UInt32)
            }
            return ret
        }
    }
    
    /// Fill array with random UInt32 numbers.
    public mutating func fill(_ array: inout Array<UInt32>) {
        array.withUnsafeMutableBufferPointer {
            fill($0)
        }
    }
    
    /// Generate random UInt32 numbers.
    public mutating func fill(_ buffer: UnsafeMutableBufferPointer<UInt32>) {
        buffer.baseAddress.map { fill(start: $0, count: buffer.count) }
    }
    
    /// Generate random UInt32 numbers.
    /// - Precondition:
    ///   - `count` >= 0
    public mutating func fill(start: UnsafeMutablePointer<UInt32>,
                              count: Int) {
        precondition(count >= 0, "Invalid argument: `count` must not be less than 0.")
        
        var p = start
        
        for _ in 0..<min(4, count) {
            let t = x ^ (x << 11)
            x = y; y = z; z = w;
            w = (w ^ (w >> 19)) ^ (t ^ (t >> 8))
            p.pointee = w
            p += 1
        }
        
        guard count > 4 else {
            return
        }
        
        var xp = p - 4
        var wp = p - 1
        for _ in 0..<count-4 {
            let t = xp.pointee ^ (xp.pointee << 11)
            p.pointee = (wp.pointee ^ (wp.pointee >> 19)) ^ (t ^ (t >> 8))
            
            p += 1
            wp += 1
            xp += 1
        }
        
        // write back
        x = xp.pointee
        xp += 1
        y = xp.pointee
        xp += 1
        z = xp.pointee
        xp += 1
        w = xp.pointee
    }
}
