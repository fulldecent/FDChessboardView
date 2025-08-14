import XCTest
@testable import FDChessboardView

final class FDChessboardViewTests: XCTestCase {
    func testExample() {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct
        // results.
        XCTAssertEqual(5, 5)
    }
    
    func testFDChessboardSquareInit() {
        // Test square initialization by index
        let square = FDChessboardSquare(index: 0)
        XCTAssertEqual(square.index, 0)
        XCTAssertEqual(square.file, 0)
        XCTAssertEqual(square.rank, 0)
        XCTAssertEqual(square.algebraic, "a1")
        
        // Test square initialization by rank and file
        let square2 = FDChessboardSquare(newRank: 7, newFile: 7)
        XCTAssertEqual(square2.index, 63)
        XCTAssertEqual(square2.file, 7)
        XCTAssertEqual(square2.rank, 7)
        XCTAssertEqual(square2.algebraic, "h8")
    }
}
