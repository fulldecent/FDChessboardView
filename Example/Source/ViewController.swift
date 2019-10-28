//
//  ViewController.swift
//  FDChessboardView
//
//  Created by William Entriken on 2/3/16.
//  Copyright © 2016 William Entriken. All rights reserved.
//

import UIKit
import FDChessboardView

class SimpleChessDataSource: FDChessboardViewDataSource {
    var board = [FDChessboardSquare: FDChessboardPiece?]()
    var lastMove: (from: FDChessboardSquare, to: FDChessboardSquare)? = nil
    var premove: (from: FDChessboardSquare, to: FDChessboardSquare)? = nil

    func loadFen(fenPosition: String) {
        var rank = 7
        var file = 0
        for letter in fenPosition {
            if let piece = FDChessboardPiece(fromCharacter: letter) {
                board[.init(newRank: rank, newFile: file)] = piece
                file = file + 1
            } else if CharacterSet.decimalDigits.contains(letter.unicodeScalars.first!) {
                file = file + Int(letter.unicodeScalars.first!.value) - 48
            } else if letter == "/" {
                rank = rank - 1
                file = 0
            } else if letter == " " {
                break
            }
        }
    }
    
    func chessboardView(_ board: FDChessboardView, pieceForSquare square: FDChessboardSquare) -> FDChessboardPiece? {
        return self.board[square] ?? nil
    }
    
    func chessboardViewLastMove(_ board: FDChessboardView) -> (from: FDChessboardSquare, to: FDChessboardSquare)? {
        return lastMove
    }
    
    func chessboardViewPremove(_ board: FDChessboardView) -> (from: FDChessboardSquare, to: FDChessboardSquare)? {
        return premove
    }
    
}

class SimpleChessDelegate: FDChessboardViewDelegate {
    
    var didMoveCallback: ((_ board: FDChessboardView, _ from: FDChessboardSquare, _ to: FDChessboardSquare, _ promotion: FDChessboardPiece?) -> ())? = nil

    
    func chessboardView(_ board: FDChessboardView, legalDestinationsForPieceAtSquare from: FDChessboardSquare) -> [FDChessboardSquare] {
        var retval = [FDChessboardSquare]()
        if from.file > 0 {
            retval.append(FDChessboardSquare(index: from.index - 8))
        }
        if from.file < 8 {
            retval.append(FDChessboardSquare(index: from.index + 8))
        }
        if from.rank > 0 {
            retval.append(FDChessboardSquare(index: from.index - 1))
        }
        if from.rank < 8 {
            retval.append(FDChessboardSquare(index: from.index + 1))
        }
        return retval
    }

    func chessboardView(_ board: FDChessboardView, didMoveFrom from: FDChessboardSquare, to: FDChessboardSquare, withPromotion promotion: FDChessboardPiece?) {
        if let callback = didMoveCallback {
            callback(board, from, to, promotion)
        }
    }
}

class ViewController: UIViewController {
    @IBOutlet var chessboard: FDChessboardView!
    
    let dataSource = SimpleChessDataSource()
    let delegate = SimpleChessDelegate()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        dataSource.loadFen(fenPosition: "rnbqkbnr/pp1ppppp/8/2p5/4P3/5N2/PPPP1PPP/RNBQKB1R b KQkq - 1 2")
        chessboard.dataSource = dataSource
        chessboard.delegate = delegate
    }
}

