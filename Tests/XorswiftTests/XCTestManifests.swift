import XCTest

#if !os(macOS)
public func allTests() -> [XCTestCaseEntry] {
    return [
        testCase(OtherTests.allTests),
        testCase(XorshiftGeneratorTests.allTests),
        testCase(XorshiftTests.allTests),
    ]
}
#endif
