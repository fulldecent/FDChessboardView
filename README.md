NOTICE: Development on this project is on pause until CocoaPods releases full support for Swift. Then we will work to upgrade this project. See https://github.com/CocoaPods/CocoaPods/pull/2835

FDChessboardView
================

<a href="http://imgur.com/hjqp7p4"><img width=200 height=200 src="http://i.imgur.com/hjqp7p4.png" title="Hosted by imgur.com" /></a>

Features
========

 * Full vector graphics, fully scalable
 * Customizable themes and game graphics
 * Supports all single board chess variants: suicide, losers, atomic, etc.
 * Supports games with odd piece arrangement and non-standard castling (Fisher 960)
 * Very clean API, this is a view not a controller

Usage
=====

Import, add the view to your storyboard and then set it up with:

    #import "FDChessboardView.h"
    ...
    self.chessboard.dataSource = self;

Then implement the data source:

    - (FDChessboardPiece)chessboardView:(FDChessboardView *)board pieceForCoordinate:(CGPoint)coordinate
    {
        return FDChessboardPieceEmpty; // or whatever piece should be at this square
    }


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
