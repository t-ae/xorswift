# Xorswift
Xorshift pseudorandom number generator library.  
Specialized to generate tons of random numbers.  

Xorshift is 
- one of the fastest RNGs
- non-cryptographically-secure

See original paper for more details of Xorshift itself.

- [Xorshift RNGs](https://www.jstatsoft.org/index.php/jss/article/view/v008i14/xorshift.pdf)

## XorshiftGenerator

```swift
struct XorshiftGenerator: RandomNumberGenerator {
    /// Create `XorshiftGenerator`.
    /// - precondition: At least one of seeds must be non-zero.
    public init(x: UInt32, y: UInt32, z: UInt32, w: UInt32)

    /// Create `XorshiftGenerator` seeded with another `generator`.
    public init<G: RandomNumberGenerator>(using generator: inout G)

    /// Create `XorshiftGenerator` seeded with `SystemRandomNumberGenerator`.
    public init()
}
```

## Random API available

`XorshiftGenerator` conforms to `RandomNumberGenerator` of standard library.  
You can use [Random APIs](https://github.com/apple/swift-evolution/blob/master/proposals/0202-random-unification.md#random-api) with `XorshiftGenerator`.

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
