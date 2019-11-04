FDChessboardView
================

[![CI Status](http://img.shields.io/travis/fulldecent/FDChessboardView.svg?style=flat)](https://travis-ci.org/fulldecent/FDChessboardView)
[![Version](https://img.shields.io/cocoapods/v/FDChessboardView.svg?style=flat)](http://cocoadocs.org/docsets/FDChessboardView)
[![License](https://img.shields.io/cocoapods/l/FDChessboardView.svg?style=flat)](http://cocoadocs.org/docsets/FDChessboardView)
[![Platform](https://img.shields.io/cocoapods/p/FDChessboardView.svg?style=flat)](http://cocoadocs.org/docsets/FDChessboardView)
[![Carthage compatible](https://img.shields.io/badge/Carthage-compatible-4BC51D.svg?style=flat)](https://github.com/Carthage/Carthage)

<a href="http://imgur.com/kcBBESo"><img width=200 height=200 src="http://i.imgur.com/kcBBESo.png" title="Hosted by imgur.com" /></a>

Features
--------

 * High resolution graphics
 * Customizable themes and game graphics
 * Supports all single board chess variants: suicide, losers, atomic, etc.
 * Supports games with odd piece arrangement and non-standard castling (Fisher 960)
 * Very clean API, this is just a view
 * Supports a minimum deployment target of iOS 8 or OS X Mavericks (10.9)

Usage
-----

Import the project and implement a data source:

```swift
import FDChessboardView

public protocol FDChessboardViewDataSource: class {
    /// What piece is on the square?
    func chessboardView(_ board: FDChessboardView, pieceForSquare square: FDChessboardSquare) -> FDChessboardPiece?

    /// The last move
    func chessboardViewLastMove(_ board: FDChessboardView) -> (from:FDChessboardSquare, to:FDChessboardSquare)?

    /// The premove
    func chessboardViewPremove(_ board: FDChessboardView) -> (from:FDChessboardSquare, to:FDChessboardSquare)?
}
```

If your application will allow the pieces to be moved, implement a delegate:

```swift
public protocol FDChessboardViewDelegate: class {
    /// Where can this piece move to?
    func chessboardView(_ board: FDChessboardView, legalDestinationsForPieceAtSquare from: FDChessboardSquare) -> [FDChessboardSquare]

    /// Before a move happenes
    func chessboardView(_ board: FDChessboardView, canMoveFrom from: FDChessboardSquare, to: FDChessboardSquare, withPromotion promotion: FDChessboardPiece?) -> Bool

    /// After a move happened
    func chessboardView(_ board: FDChessboardView, didMoveFrom from: FDChessboardSquare, to: FDChessboardSquare, withPromotion promotion: FDChessboardPiece?)
}
```

Then you can customize the view or call certain actions:

```swift
/// The location of a square on a chess board
public struct FDChessboardSquare: Hashable {
    /// From 0...7 (a...h)
    public let file: Int
    
    /// From 0...7 (white king starting position to black king starting position)
    public let rank: Int
}

/// The pieces on a chess board
public enum FDChessboardPiece: String {
    case WhitePawn
    case BlackPawn
    case WhiteKnight
    case BlackKnight
    case WhiteBishop
    case BlackBishop
    case WhiteRook
    case BlackRook
    case WhiteQueen
    case BlackQueen
    case WhiteKing
    case BlackKing
}

/// Display for a chess board
@IBDesignable open class FDChessboardView: UIView {
    @IBInspectable open var lightBackgroundColor: UIColor
    @IBInspectable open var darkBackgroundColor: UIColor
    open var targetBackgroundColor: UIColor
    open var legalBackgroundColor: UIColor
    open var lastMoveColor: UIColor
    open var premoveColor: UIColor
    open weak var dataSource: FDChessboardViewDataSource?
    open weak var delegate: FDChessboardViewDelegate?
    open var doesAnimate: Bool
    open var doesShowLegalSquares: Bool
    open var doesShowLastMove: Bool
    open var doesShowPremove: Bool

    /// Add a piece onto the board
    open func setPiece(_ piece: FDChessboardPiece?, forSquare square: FDChessboardSquare)

    /// Repull all board information from data source
    open func reloadData()

    /// Move a piece on the board, clears any prior premove
    open func move(_ piece: FDChessboardPiece, from: FDChessboardSquare, to: FDChessboardSquare, promotedTo promoted: FDChessboardPiece?)
    
    /// Premove a piece on the board, clears any prior premove
    open func premove(_ piece: FDChessboardPiece, from: FDChessboardSquare, to: FDChessboardSquare, promotedTo promoted: FDChessboardPiece?)
    
    /// Removes any premove on the board
    open func clearPremove()
    
    /// Move a piece on the board, clears any prior premove
    open func unmove(_ piece: FDChessboardPiece, from: FDChessboardSquare, to: FDChessboardSquare, promotedTo promoted: FDChessboardPiece?, capturing: FDChessboardPiece)
}
```

## Installation

Add FDChessboardView to your project using Swift Package Manager. In Xcode that is simply: File > Swift Packages > Add Package Dependency... and you're done. Alternative installations options are shown below for legacy projects.

### CocoaPods

If you are already using [CocoaPods](http://cocoapods.org), just add 'FDChessboardView' to your `Podfile` then run `pod install`.

### Carthage

If you are already using [Carthage](https://github.com/Carthage/Carthage), just add to your `Cartfile`:

```ogdl
github "fulldecent/FDChessboardView" ~> 0.1
```

Then run `carthage update` to build the framework and drag the built FDChessboardView.framework into your Xcode project.


Upcoming features
-----------------

These following items are in the API for discussion and awaiting implementation:

 * Display for last move
 * Mutable game state (i.e. can move the pieces)
 * Animation for piece moves
 * Highlighting of legal squares for a piece after begin dragging
 * Premove


See also
-----------

See also Kibitz for Mac which is making a comeback https://github.com/fulldecent/kibitz


## License

FDChessboardView is available under the MIT license. See [the LICENSE file](LICENSE) for more information.
