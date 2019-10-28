//
//  FDChessboardPiece.swift
//  FDChessboardView
//
//  Created by William Entriken on 2019-10-27.
//  Copyright © 2019 William Entriken. All rights reserved.
//

public enum FDChessboardPiece: String {
    /// A white pawn
    case WhitePawn = "wp"

    /// A black pawn
    case BlackPawn = "bp"

    /// A white knight
    case WhiteKnight = "wn"

    /// A black knight
    case BlackKnight = "bn"

    /// A white bishop
    case WhiteBishop = "wb"

    /// A black bishop
    case BlackBishop = "bb"

    /// A white rook
    case WhiteRook = "wr"

    /// A black rook
    case BlackRook = "br"

    /// A white queen
    case WhiteQueen = "wq"

    /// A black queen
    case BlackQueen = "bq"

    /// A white king
    case WhiteKing = "wk"

    /// A black king
    case BlackKing = "bk"
    
    public init?(fromCharacter character: Character) {
        switch character {
        case "K":
            self = .WhiteKing
        case "k":
            self = .BlackKing
        case "Q":
            self = .WhiteQueen
        case "q":
            self = .BlackQueen
        case "R":
            self = .WhiteRook
        case "r":
            self = .BlackRook
        case "B":
            self = .WhiteBishop
        case "b":
            self = .BlackBishop
        case "N":
            self = .WhiteKnight
        case "n":
            self = .BlackKnight
        case "P":
            self = .WhitePawn
        case "p":
            self = .BlackPawn
        default:
            return nil
        }
    }
}
