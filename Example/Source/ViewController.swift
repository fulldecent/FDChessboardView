//
//  ViewController.swift
//  FDChessboardView
//
//  Created by William Entriken on 2/3/16.
//  Copyright © 2016 William Entriken. All rights reserved.
//

import UIKit
import FDChessboardView

class ViewController: UIViewController {
    @IBOutlet var chessboard: FDChessboardView!
    
    var piecesByIndex = [Int : FDChessboardPiece]()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.chessboard.dataSource = FDFENChessboardDataSource("rnbqkbnr/pp1ppppp/8/2p5/4P3/5N2/PPPP1PPP/RNBQKB1R b KQkq - 1 2")
    }
}

