//
//  FDChessboardViewTests.swift
//  FDChessboardViewTests
//
//  Created by William Entriken on 4/25/16.
//  Copyright © 2016 William Entriken. All rights reserved.
//

import XCTest
@testable import FDChessboardView

class FDChessboardViewTests: XCTestCase {

    var chessboard: FDChessboardView?
    let squares = (FDChessboardSquare(index: 0), FDChessboardSquare(index: 1))
    
    override func setUp() {
        super.setUp()
        chessboard = FDChessboardView()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func testExample() {
        XCTAssert(true)
    }

    func testChessboard() {
        XCTAssert(chessboard != nil)
    }

    func testResizing() {
        XCTAssert(chessboard?.translatesAutoresizingMaskIntoConstraints == false)
    }

    func testBooleans() {
        XCTAssert(chessboard?.doesAnimate == true)
        XCTAssert(chessboard?.doesShowLegalSquares == true)
        XCTAssert(chessboard?.doesShowLastMove == true)
        XCTAssert(chessboard?.doesShowPremove == true)
    }

    func testMovePiece() {
        let val = chessboard?.movePieceAtCoordinate(squares.0, toCoordinate: squares.1)
        XCTAssert(val == true)
    }

    func testMoveAndPromotePiece() {
        let val = chessboard?.movePieceAtCoordinate(squares.0, toCoordinate: squares.1, andPromoteTo: .WhiteQueen)
        XCTAssert(val == true)
    }

    func testPremovePiece() {
        let val = chessboard?.premovePieceAtCoordinate(squares.0, toCoordinate: squares.1)
        XCTAssert(val == true)
    }

    func testPremoveAndPromotePiece() {
        let val = chessboard?.premovePieceAtCoordinate(squares.0, toCoordinate: squares.1, andPromoteTo: .WhiteQueen)
        XCTAssert(val == true)
    }

}
