//
//  FDFENChessboardViewDataSource.swift
//  FDChessboardView
//
//  Created by David Airapetyan on 01/04/18.
//  Copyright © 2018 Google LLC. All rights reserved.
//

import Foundation

public class FDFENChessboardDataSource : FDChessboardViewDataSource {

  var piecesByIndex = [Int : FDChessboardPiece]()

  func getPiece(letter : Character) -> FDChessboardPiece? {
    switch letter {
    case "K":
      return .WhiteKing
    case "k":
      return .BlackKing
    case "Q":
      return .WhiteQueen
    case "q":
      return .BlackQueen
    case "R":
      return .WhiteRook
    case "r":
      return .BlackRook
    case "B":
      return .WhiteBishop
    case "b":
      return .BlackBishop
    case "N":
      return .WhiteKnight
    case "n":
      return .BlackKnight
    case "P":
      return .WhitePawn
    case "p":
      return .BlackPawn
    default:
      return nil
    }
  }

  public init(_ fenPosition : String) {
    var row = 7
    var column = 0

    for letter in fenPosition {
      if let piece = getPiece(letter: letter) {
        piecesByIndex[row * 8 + column] = piece
        column = column + 1
      } else if CharacterSet.decimalDigits.contains(letter.unicodeScalars.first!) {
        column = column + Int(letter.unicodeScalars.first!.value) - 48
      } else if letter == "/" {
        row = row - 1
        column = 0
      } else if letter == " " {
        break
      }
    }
  }

  public func chessboardView(_ board: FDChessboardView, pieceForSquare square: FDChessboardSquare) -> FDChessboardPiece? {
    return piecesByIndex[square.index]
  }

  public func chessboardViewLastMove(_ board: FDChessboardView) -> (from: FDChessboardSquare, to: FDChessboardSquare)? {
    return nil
  }

  public func chessboardViewPremove(_ board: FDChessboardView) -> (from: FDChessboardSquare, to: FDChessboardSquare)? {
    return nil
  }
}
