
import Cxorswift


public func xorshift(start: UnsafeMutablePointer<UInt32>, count: Int) {
    xorshift(start, Int32(count))
}

public func xorshift_uniform(start: UnsafeMutablePointer<Float>, count: Int, low: Float, high: Float) {
    xorshift_uniform(start, Int32(count), low, high)
}

#if os(macOS) || os(iOS) || os(watchOS) || os(tvOS)
    import Accelerate
    
    public func xorshift_normal(start: UnsafeMutablePointer<Float>, count: Int, mu: Float, sigma: Float) {
        
        var _count = Int32(count)
        let __count = vDSP_Length(count)
        
        let buf1 = UnsafeMutablePointer<UInt32>.allocate(capacity: count)
        defer { buf1.deallocate(capacity: count) }
        xorshift(buf1, _count);
        vDSP_vfltu32(buf1, 1, start, 1, __count);
        
        let buf2 = UnsafeMutablePointer<Float>.allocate(capacity: count)
        defer { buf2.deallocate(capacity: count) }
        xorshift(buf1, _count);
        vDSP_vfltu32(buf1, 1, buf2, 1, __count);
        
        // X, Y in (0, 1)
        var divisor: Float = Float(UInt64(UInt32.max) + 1)
        var flt_min = Float.leastNonzeroMagnitude
        vDSP_vsdiv(start, 1, &divisor, start, 1, __count);
        vDSP_vsadd(start, 1, &flt_min, start, 1, __count);
        vDSP_vsdiv(buf2, 1, &divisor, buf2, 1, __count);
        vDSP_vsadd(buf2, 1, &flt_min, buf2, 1, __count);
        
        // sigma*sqrt(-2*log(X))
        vvlogf(start, start, &_count);
        var minus2sigma2 = -2 * sigma * sigma;
        vDSP_vsmul(start, 1, &minus2sigma2, start, 1, __count);
        vvsqrtf(start, start, &_count);
        
        // cos(2*pi*Y)
        var pi2 = 2 * Float.pi;
        vDSP_vsmul(buf2, 1, &pi2, buf2, 1, __count);
        vvcosf(buf2, buf2, &_count);
        
        vDSP_vmul(start, 1, buf2, 1, start, 1, __count);
        
        if(mu != 0) {
            var mu = mu
            vDSP_vsadd(start, 1, &mu, start, 1, __count);
        }
    }
#else
    public func xorshift_normal(start: UnsafeMutablePointer<Float>, count: Int, mu: Float, sigma: Float) {
        _xorshift_normal(start, Int32(count), mu, sigma)
    }
#endif

public func _xorshift_normal(start: UnsafeMutablePointer<Float>, count: Int, mu: Float, sigma: Float) {
    _xorshift_normal(start, Int32(count), mu, sigma)
}
