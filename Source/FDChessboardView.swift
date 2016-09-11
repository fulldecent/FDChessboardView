//
//  FDChessboardView.swift
//  FDChessboardView
//
//  Created by William Entriken on 2/2/16.
//  Copyright © 2016 William Entriken. All rights reserved.
//

import Foundation
import UIKit

/// The location of a square on a chess board
public struct FDChessboardSquare {
    /// From 0...7
    public var file: Int

    /// From 0...7
    public var rank: Int

    /// A format like a4
    public var algebriac: String {
        get {
            return String(describing: UnicodeScalar(96 + file)) + String(rank + 1)
        }
    }

    public var index: Int {
        get {
            return rank * 8 + file
        }
        set {
            file = index % 8
            rank = index / 8
        }
    }

    public init(index newIndex: Int) {
        file = newIndex % 8
        rank = newIndex / 8
    }
}

/// The pieces on a chess board
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
}

public protocol FDChessboardViewDataSource: class {
    /// What piece is on the square?
    func chessboardView(_ board: FDChessboardView, pieceForSquare square: FDChessboardSquare) -> FDChessboardPiece?

    /// The last move
    func chessboardViewLastMove(_ board: FDChessboardView) -> (from:FDChessboardSquare, to:FDChessboardSquare)?

    /// The premove
    func chessboardViewPremove(_ board: FDChessboardView) -> (from:FDChessboardSquare, to:FDChessboardSquare)?
}

public protocol FDChessboardViewDelegate: class {
    /// Where can this piece move to?
    func chessboardView(_ board: FDChessboardView, legalDestinationsForPieceAtSquare from: FDChessboardSquare) -> [FDChessboardSquare]

    /// Before a move happens (cannot be stopped)
    func chessboardView(_ board: FDChessboardView, willMoveFrom from: FDChessboardSquare, to: FDChessboardSquare)

    /// After a move happened
    func chessboardView(_ board: FDChessboardView, didMoveFrom from: FDChessboardSquare, to: FDChessboardSquare)

    /// Before a move happens (cannot be stopped)
    func chessboardView(_ board: FDChessboardView, willMoveFrom from: FDChessboardSquare, to: FDChessboardSquare, withPromotion promotion: FDChessboardPiece)

    /// After a move happened
    func chessboardView(_ board: FDChessboardView, didMoveFrom from: FDChessboardSquare, to: FDChessboardSquare, withPromotion promotion: FDChessboardPiece)
}

/// Display for a chess board
@IBDesignable open class FDChessboardView: UIView {
    /// Color for "white" board squares
    @IBInspectable open var lightBackgroundColor: UIColor = UIColor(red: 222.0/255, green:196.0/255, blue:160.0/255, alpha:1)

    /// Color for "black" board squares
    @IBInspectable open var darkBackgroundColor: UIColor = UIColor(red: 160.0/255, green:120.0/255, blue:55.0/255, alpha:1)

    /// Color for where a piece is moving to
    open var targetBackgroundColor = UIColor(hue: 0.75, saturation:0.5, brightness:0.5, alpha:1.0)

    /// Color for a legal square target
    open var legalBackgroundColor = UIColor(hue: 0.25, saturation:0.5, brightness:0.5, alpha:1.0)

    /// Color for the last move square
    open var lastMoveColor = UIColor(hue: 0.35, saturation:0.5, brightness:0.5, alpha:1.0)

    /// Color for a premove square
    open var premoveColor = UIColor(hue: 0.15, saturation:0.5, brightness:0.5, alpha:1.0)

    /// Path for custom piece graphics
    open var pieceGraphicsDirectoryPath: String? = nil

    /// Datasource to say which pieces are on each square
    open weak var dataSource: FDChessboardViewDataSource? = nil {
        didSet {
            reloadData()
        }
    }

    /// Handler for user interaction with the view
    open weak var delegate: FDChessboardViewDelegate? = nil

    /// Should piece moves be animated?
    open var doesAnimate: Bool = true

    /// Should legal squares be shown when a piece is selected?
    open var doesShowLegalSquares: Bool = true

    /// Should the lash move be shown?
    open var doesShowLastMove: Bool = true

    /// Should premove be shown?
    open var doesShowPremove: Bool = true

    fileprivate lazy var tilesAtIndex = [UIView]()

    fileprivate var pieceAtIndex = [Int : FDChessboardPiece]()

    fileprivate var pieceImageViewAtIndex = [Int : UIImageView]()

    fileprivate var lastMoveArrow: UIView? = nil

    fileprivate var premoveArrow: UIView? = nil

    /// UIView initializer
    public override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }

    /// UIView initializer
    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setup()
    }

    fileprivate func setup() {
        self.translatesAutoresizingMaskIntoConstraints = false

        for index in 0..<64 {
            let square = FDChessboardSquare(index: index)
            let tile = UIView()
            tile.backgroundColor = (index + index/8) % 2 == 0 ? darkBackgroundColor : lightBackgroundColor
            tile.translatesAutoresizingMaskIntoConstraints = false
            addSubview(tile)
            tilesAtIndex.append(tile)

            switch square.rank {
            case 0:
                addConstraint(NSLayoutConstraint(item: tile, attribute: .bottom, relatedBy: .equal, toItem: self, attribute: .bottom, multiplier: 1, constant: 0))
            case 7:
                addConstraint(NSLayoutConstraint(item: tile, attribute: .bottom, relatedBy: .equal, toItem: tilesAtIndex[index - 8], attribute: .top, multiplier: 1, constant: 0))
                addConstraint(NSLayoutConstraint(item: tile, attribute: .top, relatedBy: .equal, toItem: self, attribute: .top, multiplier: 1, constant: 0))
                addConstraint(NSLayoutConstraint(item: tile, attribute: .height, relatedBy: .equal, toItem: tilesAtIndex[index - 8], attribute: .height, multiplier: 1, constant: 0))
            default:
                addConstraint(NSLayoutConstraint(item: tile, attribute: .bottom, relatedBy: .equal, toItem: tilesAtIndex[index - 8], attribute: .top, multiplier: 1, constant: 0))
                addConstraint(NSLayoutConstraint(item: tile, attribute: .height, relatedBy: .equal, toItem: tilesAtIndex[index - 8], attribute: .height, multiplier: 1, constant: 0))
            }
            switch square.file {
            case 0:
                addConstraint(NSLayoutConstraint(item: tile, attribute: .left, relatedBy: .equal, toItem: self, attribute: .left, multiplier: 1, constant: 0))
            case 7:
                addConstraint(NSLayoutConstraint(item: tile, attribute: .left, relatedBy: .equal, toItem: tilesAtIndex[index - 1], attribute: .right, multiplier: 1, constant: 0))
                addConstraint(NSLayoutConstraint(item: tile, attribute: .right, relatedBy: .equal, toItem: self, attribute: .right, multiplier: 1, constant: 0))
                addConstraint(NSLayoutConstraint(item: tile, attribute: .width, relatedBy: .equal, toItem: tilesAtIndex[index - 1], attribute: .width, multiplier: 1, constant: 0))
            default:
                addConstraint(NSLayoutConstraint(item: tile, attribute: .left, relatedBy: .equal, toItem: tilesAtIndex[index - 1], attribute: .right, multiplier: 1, constant: 0))
                addConstraint(NSLayoutConstraint(item: tile, attribute: .width, relatedBy: .equal, toItem: tilesAtIndex[index - 1], attribute: .width, multiplier: 1, constant: 0))
            }
        }
        self.layoutIfNeeded()
    }

    /*
- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
UITouch *touch = [touches anyObject];
CGPoint point = [touch locationInView:self];
NSInteger x = point.x*8/self.frame.size.width;
NSInteger y = 8-point.y*8/self.frame.size.height;
UIView *tile = self.tilesPerSquare[y*8+x];
tile.backgroundColor = self.targetBackgroundColor;
}

- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event
{
UITouch *touch = [touches anyObject];
CGPoint point = [touch locationInView:self];
if (![self pointInside:point withEvent:event])
return;
NSInteger x = point.x*8/self.frame.size.width;
NSInteger y = 8-point.y*8/self.frame.size.height;
UIView *tile = self.tilesPerSquare[y*8+x];
tile.backgroundColor = self.legalBackgroundColor;
}
*/

    /// Add a piece onto the board
    open func setPiece(_ piece: FDChessboardPiece?, forSquare square: FDChessboardSquare){
        let index = square.index
        pieceAtIndex[index] = piece
        self.pieceImageViewAtIndex[index]?.removeFromSuperview()
        self.pieceImageViewAtIndex.removeValue(forKey: index)
        guard let piece = piece else {
            return
        }

        let pieceImageView: UIImageView
        let fileName = piece.rawValue
        let bundle = Bundle(for: type(of: self))
        let image = UIImage(named: fileName, in: bundle, compatibleWith: nil)
        pieceImageView = UIImageView(image: image)
        pieceImageView.translatesAutoresizingMaskIntoConstraints = false
        self.pieceImageViewAtIndex[index] = pieceImageView
        self.addSubview(pieceImageView)

        let squareOne = self.tilesAtIndex.first!
        self.addConstraint(NSLayoutConstraint(item: pieceImageView, attribute: .width, relatedBy: .equal, toItem: squareOne, attribute: .width, multiplier: 1, constant: 0))
        self.addConstraint(NSLayoutConstraint(item: pieceImageView, attribute: .height, relatedBy: .equal, toItem: squareOne, attribute: .height, multiplier: 1, constant: 0))
        self.addConstraint(NSLayoutConstraint(item: pieceImageView, attribute: .top, relatedBy: .equal, toItem: self.tilesAtIndex[index], attribute: .top, multiplier: 1, constant: 0))
        self.addConstraint(NSLayoutConstraint(item: pieceImageView, attribute: .leading, relatedBy: .equal, toItem: self.tilesAtIndex[index], attribute: .leading, multiplier: 1, constant: 0))
        self.layoutIfNeeded()
    }

    /// Repull all board information from data source
    open func reloadData() {
        for index in 0 ..< 64 {
            let square = FDChessboardSquare(index: index)
            let newPiece = dataSource?.chessboardView(self, pieceForSquare:square)
            setPiece(newPiece, forSquare: square)
        }
        self.layoutIfNeeded()
    }

    /// Move a piece on the board
    open func movePieceAtCoordinate(_ from: FDChessboardSquare, toCoordinate to: FDChessboardSquare) -> Bool {
        return true
    }

    /// Move a piece on the board
    open func movePieceAtCoordinate(_ from: FDChessboardSquare, toCoordinate to: FDChessboardSquare, andPromoteTo piece: FDChessboardPiece) -> Bool {
        return true
    }

    /// Premove a piece on the board
    open func premovePieceAtCoordinate(_ from: FDChessboardSquare, toCoordinate to: FDChessboardSquare) -> Bool {
        return true
    }

    /// Premove a piece on the board
    open func premovePieceAtCoordinate(_ from: FDChessboardSquare, toCoordinate to: FDChessboardSquare, andPromoteTo piece: FDChessboardPiece) -> Bool {
        return true
    }

}
