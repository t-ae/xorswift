# Xorswift
Xorshift pseudorandom number generator library.  
Specialized to generate tons of random numbers.  

See original paper for details of RNG itself.

- [Xorshift RNGs](https://www.jstatsoft.org/index.php/jss/article/view/v008i14/xorshift.pdf)

## Comforms to `RandomNumberGenerator`

`XorshiftGenerator` conforms to `RandomNumberGenerator` of standard library.
You can use Random APIs with `XorshiftGenerator`.

```swift
var gen = XorshiftGenerator()
Int.random(in: 0..<10, using: &gen)
UInt.random(in: 0..<10, using: &gen)
Float.random(in: 0..<10, using: &gen)
Double.random(in: 0..<10, using: &gen)

let array = [0, 1, 2, 3]
array.randomElement(using: &gen)
```

## Filling `UInt32` area
`XorshiftGenerator` has method `fill` which fills given area with random `UInt32`s.
It is faster than `arc4random_buf`.

```swift
func testPerformance_arc4random() {
    let count = 1_000_000
    var a = [UInt32](repeating: 0, count: count)
    measure {
        for _ in 0..<100 {
            arc4random_buf(&a, MemoryLayout<UInt32>.size * a.count)
        }
    } // 0.136sec
}

func testPerformance_xorshift() {
    let count = 1_000_000
    var a = [UInt32](repeating: 0, count: count)
    measure {
        var gen = XorshiftGenerator()
        for _ in 0..<100 {
            gen.fill(start: &a, count: a.count)
        }
    } // 0.067sec
}
```

## Float/Double utility to sample from uniform/normal distributions

`XorshiftGenerator` also has several methods to sample multiple floating point random numbers from uniform/normal distributions.  
See [Uniform.swift](https://github.com/t-ae/xorswift/blob/master/Sources/Xorswift/Uniform.swift) and [Normal.swift](https://github.com/t-ae/xorswift/blob/master/Sources/Xorswift/Normal.swift) for detail.
