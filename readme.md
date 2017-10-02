# Xorswift
Xorshift pseudorandom number generator library.  
Specialized to generate many random numbers.  

## Faster than `arc4random_buf`

9x faster than `arc4random_buf`.

```swift
func testPerformance_arc4random() {
    let count = 1_000_000
    var a = [UInt32](repeating: 0, count: count)
    measure {
        for _ in 0..<100 {
            arc4random_buf(&a, MemoryLayout<UInt32>.size * a.count)
        }
    } // 1.129 sec
}
func testPerformance_xorshift() {
    let count = 1_000_000
    var a = [UInt32](repeating: 0, count: count)
    measure {
        for _ in 0..<100 {
            xorshift(start: &a, count: a.count)
        }
    } // 0.129 sec
}
```

## Sample from uniform/normal distribution

`xorshift_uniform`/`xorshift_normal` for `Float`/`Double`.