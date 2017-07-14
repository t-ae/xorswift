# Xorswift
Xorshift pseudorandom number generator library.  
Specialized to generate many random numbers.  

## Faster than `arc4random_buf`

7x faster than `arc4random_buf`.

```swift
func testPerformance_arc4random() {
    let count = 1_000_000
    var a = [UInt32](repeating: 0, count: count)
    measure {
        for _ in 0..<100 {
            arc4random_buf(&a, MemoryLayout<UInt32>.size * a.count)
        }
    } // 1.108 sec
}
func testPerformance_xorshift() {
    let count = 1_000_000
    var a = [UInt32](repeating: 0, count: count)
    measure {
        for _ in 0..<100 {
            xorshift(start: &a, count: a.count)
        }
    } // 0.156 sec
}
```

## Two `Float` utilities

- `xorshift_uniform(start: UnsafeMutablePointer<Float>, count: Int, low: Float, high: Float)`
- `xorshift_normal(start: UnsafeMutablePointer<Float>, count: Int, mu: Float, sigma: Float)`
