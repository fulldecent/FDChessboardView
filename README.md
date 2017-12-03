FDChessboardView
================

[![CI Status](http://img.shields.io/travis/fulldecent/FDChessboardView.svg?style=flat)](https://travis-ci.org/fulldecent/FDChessboardView)
[![Version](https://img.shields.io/cocoapods/v/FDChessboardView.svg?style=flat)](http://cocoadocs.org/docsets/FDChessboardView)
[![License](https://img.shields.io/cocoapods/l/FDChessboardView.svg?style=flat)](http://cocoadocs.org/docsets/FDChessboardView)
[![Platform](https://img.shields.io/cocoapods/p/FDChessboardView.svg?style=flat)](http://cocoadocs.org/docsets/FDChessboardView)
[![Carthage compatible](https://img.shields.io/badge/Carthage-compatible-4BC51D.svg?style=flat)](https://github.com/Carthage/Carthage)

<a href="http://imgur.com/kcBBESo"><img width=200 height=200 src="http://i.imgur.com/kcBBESo.png" title="Hosted by imgur.com" /></a>

**:hamburger: Virtual tip jar: https://amazon.com/hz/wishlist/ls/EE78A23EEGQB**

Features
========

 * High resolution graphics
 * Customizable themes and game graphics
 * Supports all single board chess variants: suicide, losers, atomic, etc.
 * Supports games with odd piece arrangement and non-standard castling (Fisher 960)
 * Very clean API, this is just a view
 * Supports a minimum deployment target of iOS 8 or OS X Mavericks (10.9)

Usage
=====

Import, add the view to your storyboard and then set it up with:

```swift
import FDChessboardView
...
self.chessboard.dataSource = self
```

Then implement the data source:

```swift
func chessboardView(board: FDChessboardView, pieceForSquare square: FDChessboardSquare) -> FDChessboardPiece? {
    return piecesByIndex[square.index] // you figure out which piece to show
}
```

Here is the full API:

```swift
/// The location of a square on a chess board
public struct FDChessboardSquare {

    /// From 0...7
    public var file: Int

    /// From 0...7
    public var rank: Int

    /// A format like a4
    public var algebriac: String { get }

    public var index: Int { get set }

    public init(index newIndex: Int)
}

/// The pieces on a chess board
public enum FDChessboardPiece : String {

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

public protocol FDChessboardViewDataSource : class {

    /// What piece is on the square?
    public func chessboardView(board: FDChessboardView, pieceForSquare square: FDChessboardSquare) -> FDChessboardView.FDChessboardPiece?

    /// The last move
    public func chessboardViewLastMove(board: FDChessboardView) -> (from: FDChessboardView.FDChessboardSquare, to: FDChessboardView.FDChessboardSquare)?

    /// The premove
    public func chessboardViewPremove(board: FDChessboardView) -> (from: FDChessboardView.FDChessboardSquare, to: FDChessboardView.FDChessboardSquare)?
}

public protocol FDChessboardViewDelegate : class {

    /// Where can this piece move to?
    public func chessboardView(board: FDChessboardView, legalDestinationsForPieceAtSquare from: FDChessboardSquare) -> [FDChessboardView.FDChessboardSquare]

    /// Before a move happens (cannot be stopped)
    public func chessboardView(board: FDChessboardView, willMoveFrom from: FDChessboardSquare, to: FDChessboardSquare)

    /// After a move happened
    public func chessboardView(board: FDChessboardView, didMoveFrom from: FDChessboardSquare, to: FDChessboardSquare)

    /// Before a move happens (cannot be stopped)
    public func chessboardView(board: FDChessboardView, willMoveFrom from: FDChessboardSquare, to: FDChessboardSquare, withPromotion promotion: FDChessboardPiece)

    /// After a move happened
    public func chessboardView(board: FDChessboardView, didMoveFrom from: FDChessboardSquare, to: FDChessboardSquare, withPromotion promotion: FDChessboardPiece)
}

/// Display for a chess board
public class FDChessboardView : UIView {

    /// Color for "white" board squares
    public var lightBackgroundColor: UIColor

    /// Color for "black" board squares
    public var darkBackgroundColor: UIColor

    /// Color for where a piece is moving to
    public var targetBackgroundColor: UIColor

    /// Color for a legal square target
    public var legalBackgroundColor: UIColor

    /// Color for the last move square
    public var lastMoveColor: UIColor

    /// Color for a premove square
    public var premoveColor: UIColor

    /// Path for custom piece graphics
    public var pieceGraphicsDirectoryPath: String?

    /// Datasource to say which pieces are on each square
    public weak var dataSource: FDChessboardViewDataSource? { get set }

    /// Handler for user interaction with the view
    public weak var delegate: FDChessboardViewDelegate?

    /// Should piece moves be animated?
    public var doesAnimate: Bool

    /// Should legal squares be shown when a piece is selected?
    public var doesShowLegalSquares: Bool

    /// Should the lash move be shown?
    public var doesShowLastMove: Bool

    /// Should premove be shown?
    public var doesShowPremove: Bool

    /// UIView initializer
    public override init(frame: CGRect)

    /// UIView initializer
    required public init?(coder aDecoder: NSCoder)

    /// Add a piece onto the board
    public func setPiece(piece: FDChessboardPiece?, forSquare square: FDChessboardSquare)

    /// Repull all board information from data source
    public func reloadData()

    /// Move a piece on the board
    public func movePieceAtCoordinate(from: FDChessboardSquare, toCoordinate to: FDChessboardSquare) -> Bool

    /// Move a piece on the board
    public func movePieceAtCoordinate(from: FDChessboardSquare, toCoordinate to: FDChessboardSquare, andPromoteTo piece: FDChessboardPiece) -> Bool

    /// Premove a piece on the board
    public func premovePieceAtCoordinate(from: FDChessboardSquare, toCoordinate to: FDChessboardSquare) -> Bool

    /// Premove a piece on the board
    public func premovePieceAtCoordinate(from: FDChessboardSquare, toCoordinate to: FDChessboardSquare, andPromoteTo piece: FDChessboardPiece) -> Bool
}
```

Installation
============

## Installation

### CocoaPods

[CocoaPods](http://cocoapods.org) is a dependency manager for Cocoa projects. You can install it with the following command:

```bash
$ gem install cocoapods
```

> CocoaPods 0.39.0+ is required to build FDChessboardView 0.1.0+.

To integrate FDChessboardView into your Xcode project using CocoaPods, specify it in your `Podfile`:

```ruby
source 'https://github.com/CocoaPods/Specs.git'
platform :ios, '9.0'
use_frameworks!

pod 'FDChessboardView', '~> 0.1'
```

Then, run the following command:

```bash
$ pod install
```

### Carthage

[Carthage](https://github.com/Carthage/Carthage) is a decentralized dependency manager that builds your dependencies and provides you with binary frameworks.

You can install Carthage with [Homebrew](http://brew.sh/) using the following command:

```bash
$ brew update
$ brew install carthage
```

To integrate FDChessboardView into your Xcode project using Carthage, specify it in your `Cartfile`:

```ogdl
github "fulldecent/FDChessboardView" ~> 0.1
```

Run `carthage update` to build the framework and drag the built `FDChessboardView.framework` into your Xcode project.


Upcoming Features
=================

These following items are in the API for discussion and awaiting implementation:

 * Display for last move
 * Mutable game state (i.e. can move the pieces)
 * Animation for piece moves
 * Highlighting of legal squares for a piece after begin dragging
 * Premove


See Also
===========

See also Kibitz for Mac which is making a comeback https://github.com/fulldecent/kibitz
