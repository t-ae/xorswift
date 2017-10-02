
import Foundation

/// Generate single random UInt32 number.
public func xorshift() -> UInt32 {
    var ret: UInt32 = 0
    xorshift(start: &ret, count: 1)
    return ret
}

/// Generate random UInt32 numbers.
/// - Precondition:
///   - `count` >= 0
public func xorshift(count: Int) -> [UInt32] {
    precondition(count >= 0, "Invalid argument: `count` must not be less than 0.")
    var ret = [UInt32](repeating: 0, count: count)
    ret.withUnsafeMutableBufferPointer {
        xorshift($0)
    }
    return ret
}

/// Generate random UInt32 numbers.
public func xorshift(_ buffer: UnsafeMutableBufferPointer<UInt32>) {
    buffer.baseAddress.map {
        xorshift(start: $0, count: buffer.count)
    }
}

/// Generate random UInt32 numbers.
/// - Precondition: 
///   - `count` >= 0
public func xorshift(start: UnsafeMutablePointer<UInt32>, count: Int) {
    precondition(count >= 0, "Invalid argument: `count` must not be less than 0.")
    
    var p = start
    
    for _ in 0..<count%4 {
        let t = x ^ (x << 11)
        x = y; y = z; z = w;
        w = (w ^ (w >> 19)) ^ (t ^ (t >> 8))
        p.pointee = w
        p += 1
    }
    
    for _ in 0..<count/4 {
        let t1 = x ^ (x << 11)
        let t2 = y ^ (y << 11)
        let t3 = z ^ (z << 11)
        let t4 = w ^ (w << 11)
        x = (w ^ (w >> 19)) ^ (t1 ^ (t1 >> 8))
        y = (x ^ (x >> 19)) ^ (t2 ^ (t2 >> 8))
        z = (y ^ (y >> 19)) ^ (t3 ^ (t3 >> 8))
        w = (z ^ (z >> 19)) ^ (t4 ^ (t4 >> 8))
        p.pointee = x
        p += 1
        p.pointee = y
        p += 1
        p.pointee = z
        p += 1
        p.pointee = w
        p += 1
    }
}

