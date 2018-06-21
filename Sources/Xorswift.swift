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
