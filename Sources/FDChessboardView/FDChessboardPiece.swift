//
//  FDChessboardPiece.swift
//  FDChessboardView
//
//  Created by William Entriken on 2019-10-27.
//  Copyright © 2019 William Entriken. All rights reserved.
//

/// The pieces on a chess board
public enum FDChessboardPiece: String {
    /// A white pawn
    case WhitePawn

    /// A black pawn
    case BlackPawn

    /// A white knight
    case WhiteKnight

    /// A black knight
    case BlackKnight

    /// A white bishop
    case WhiteBishop

    /// A black bishop
    case BlackBishop

    /// A white rook
    case WhiteRook

    /// A black rook
    case BlackRook

    /// A white queen
    case WhiteQueen

    /// A black queen
    case BlackQueen

    /// A white king
    case WhiteKing

    /// A black king
    case BlackKing
    
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
