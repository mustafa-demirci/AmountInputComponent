import XCTest
@testable import AmountInputComponent

final class AmountInputComponentTests: XCTestCase {
    func testCreateComponent() {
        let amountInputView = AmountInputView()
    }
    func testExample() throws {

        XCTAssertEqual(AmountInputComponent().text, "Hello, World!")
    }
}
