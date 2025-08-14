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
public struct FDChessboardSquare: Hashable {
    /// From 0...63
    public let index: Int
    
    /// From 0...7 (a...h)
    public let file: Int
    
    /// From 0...7 (white king starting position to black king starting position)
    public let rank: Int
    
    /// Like a4
    public let algebraic: String

    public init(index newIndex: Int) {
        index = newIndex
        file = newIndex % 8
        rank = newIndex / 8
        algebraic = ["a","b","c","d","e","f","g","h"][file] + String(rank + 1)
    }
    
    public init(newRank: Int, newFile: Int) {
        rank = newRank
        file = newFile
        index = newRank * 8 + newFile
        algebraic = ["a","b","c","d","e","f","g","h"][file] + String(rank + 1)
    }
}

public protocol FDChessboardViewDataSource: AnyObject {
    /// What piece is on the square?
    func chessboardView(_ board: FDChessboardView, pieceForSquare square: FDChessboardSquare) -> FDChessboardPiece?

    /// The last move
    func chessboardViewLastMove(_ board: FDChessboardView) -> (from:FDChessboardSquare, to:FDChessboardSquare)?

    /// The premove
    func chessboardViewPremove(_ board: FDChessboardView) -> (from:FDChessboardSquare, to:FDChessboardSquare)?
}

public protocol FDChessboardViewDelegate: AnyObject {
    /// Where can this piece move to?
    func chessboardView(_ board: FDChessboardView, legalDestinationsForPieceAtSquare from: FDChessboardSquare) -> [FDChessboardSquare]

    /// Before a move happenes
    func chessboardView(_ board: FDChessboardView, canMoveFrom from: FDChessboardSquare, to: FDChessboardSquare, withPromotion promotion: FDChessboardPiece?) -> Bool

    /// After a move happened
    func chessboardView(_ board: FDChessboardView, didMoveFrom from: FDChessboardSquare, to: FDChessboardSquare, withPromotion promotion: FDChessboardPiece?)
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

    /// Should the last move be shown?
    open var doesShowLastMove: Bool = true

    /// Should premove be shown?
    open var doesShowPremove: Bool = true

    private lazy var tilesAtIndex = [UIView]()

    private var pieceImageViewAtIndex = [Int : UIImageView]()

    private var lastMoveArrow: UIView? = nil

    private var premoveArrow: UIView? = nil
    
    private var pieceImages = [FDChessboardPiece: UIImage]()

    /// UIView initializer
    public override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
        setupPiecesGraphics()
    }

    /// UIView initializer
    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setup()
        setupPiecesGraphics()
    }
    
    private func setupPiecesGraphics() {
        pieceImages[.WhitePawn] = UIImage(data: Data(base64Encoded: FDChessboardImageB64.WhitePawn.rawValue,
                                                     options: NSData.Base64DecodingOptions())!)
        pieceImages[.BlackPawn] = UIImage(data: Data(base64Encoded: FDChessboardImageB64.BlackPawn.rawValue,
                                                     options: NSData.Base64DecodingOptions())!)
        pieceImages[.WhiteKnight] = UIImage(data: Data(base64Encoded: FDChessboardImageB64.WhiteKnight.rawValue,
                                                       options: NSData.Base64DecodingOptions())!)
        pieceImages[.BlackKnight] = UIImage(data: Data(base64Encoded: FDChessboardImageB64.BlackKnight.rawValue,
                                                       options: NSData.Base64DecodingOptions())!)
        pieceImages[.WhiteBishop] = UIImage(data: Data(base64Encoded: FDChessboardImageB64.WhiteBishop.rawValue,
                                                       options: NSData.Base64DecodingOptions())!)
        pieceImages[.BlackBishop] = UIImage(data: Data(base64Encoded: FDChessboardImageB64.BlackBishop.rawValue,
                                                       options: NSData.Base64DecodingOptions())!)
        pieceImages[.WhiteRook] = UIImage(data: Data(base64Encoded: FDChessboardImageB64.WhiteRook.rawValue,
                                                     options: NSData.Base64DecodingOptions())!)
        pieceImages[.BlackRook] = UIImage(data: Data(base64Encoded: FDChessboardImageB64.BlackRook.rawValue,
                                                     options: NSData.Base64DecodingOptions())!)
        pieceImages[.WhiteQueen] = UIImage(data: Data(base64Encoded: FDChessboardImageB64.WhiteQueen.rawValue,
                                                      options: NSData.Base64DecodingOptions())!)
        pieceImages[.BlackQueen] = UIImage(data: Data(base64Encoded: FDChessboardImageB64.BlackQueen.rawValue,
                                                      options: NSData.Base64DecodingOptions())!)
        pieceImages[.WhiteKing] = UIImage(data: Data(base64Encoded: FDChessboardImageB64.WhiteKing.rawValue,
                                                     options: NSData.Base64DecodingOptions())!)
        pieceImages[.BlackKing] = UIImage(data: Data(base64Encoded: FDChessboardImageB64.BlackKing.rawValue,
                                                     options: NSData.Base64DecodingOptions())!)
    }

    private func setup() {
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
        self.pieceImageViewAtIndex[index]?.removeFromSuperview()
        self.pieceImageViewAtIndex.removeValue(forKey: index)
        guard let piece = piece else {
            return
        }

        let pieceImageView: UIImageView
        pieceImageView = UIImageView(image: pieceImages[piece])
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

    /// Move a piece on the board, clears any prior premove
    open func move(_ piece: FDChessboardPiece, from: FDChessboardSquare, to: FDChessboardSquare, promotedTo promoted: FDChessboardPiece?) {
        ///TODO: implement
    }
    
    /// Premove a piece on the board, clears any prior premove
    open func premove(_ piece: FDChessboardPiece, from: FDChessboardSquare, to: FDChessboardSquare, promotedTo promoted: FDChessboardPiece?) {
        ///TODO: implement
    }
    
    /// Removes any premove on the board
    open func clearPremove() {
    }
    
    /// Move a piece on the board, clears any prior premove
    open func unmove(_ piece: FDChessboardPiece, from: FDChessboardSquare, to: FDChessboardSquare, promotedTo promoted: FDChessboardPiece?, capturing: FDChessboardPiece) {
        ///TODO: implement
    }
}
