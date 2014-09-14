//
//  FDChessboardView.h
//  FDChessboardView
//
//  Created by William Entriken on 9/12/14.
//  Copyright (c) 2014 William Entriken. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef enum FDChessboardPiece {
    FDChessboardPieceEmpty,
    FDChessboardPieceWhitePawn,
    FDChessboardPieceBlackPawn,
    FDChessboardPieceWhiteKnight,
    FDChessboardPieceBlackKnight,
    FDChessboardPieceWhiteBishop,
    FDChessboardPieceBlackBishop,
    FDChessboardPieceWhiteRook,
    FDChessboardPieceBlackRook,
    FDChessboardPieceWhiteQueen,
    FDChessboardPieceBlackQueen,
    FDChessboardPieceWhiteKing,
    FDChessboardPieceBlackKing
} FDChessboardPiece;

typedef enum FDChessboardStatus {
    FDChessboardStatusReadOnly,
    FDChessboardStatusMoving,
    FDChessboardStatusPremoving
} FDChessboardStatus;

@class FDChessboardView;

@protocol FDChessboardViewDataSource <NSObject>
/// CGPoint is x = 0..7 for rank and y = 0..7 for file
- (FDChessboardPiece)chessboardView:(FDChessboardView *)board pieceForCoordinate:(CGPoint)coordinate;
- (BOOL)chessboardViewHasLastMove:(FDChessboardView *)board;
- (CGRect)chessboardViewLastMoveOrigin:(FDChessboardView *)board;
- (CGRect)chessboardViewLastMoveDestination:(FDChessboardView *)board;
- (BOOL)chessboardViewHasPremove:(FDChessboardView *)board;
- (CGRect)chessboardViewPremoveOrigin:(FDChessboardView *)board;
- (CGRect)chessboardViewPremoveDestination:(FDChessboardView *)board;
@end

@protocol FDChessboardViewDelegate <NSObject>
- (BOOL)chessboardView:(FDChessboardView *)board canMovePieceAtCoordinate:(CGPoint)from;
- (BOOL)chessboardView:(FDChessboardView *)board canMovePieceAtCoordinate:(CGPoint)from toCoordinate:(CGPoint)to;
@optional
- (void)chessboardView:(FDChessboardView *)board willMoveFrom:(CGPoint)from to:(CGPoint)to;
- (void)chessboardView:(FDChessboardView *)board didMoveFrom:(CGPoint)from to:(CGPoint)to;
- (void)chessboardView:(FDChessboardView *)board willMoveFrom:(CGPoint)from to:(CGPoint)to withPromotion:(FDChessboardPiece)promotion;
- (void)chessboardView:(FDChessboardView *)board didMoveFrom:(CGPoint)from to:(CGPoint)to withPromotion:(FDChessboardPiece)promotion;
@end

@interface FDChessboardView : UIView
@property (strong, nonatomic) UIColor *lightBackgroundColor;
@property (strong, nonatomic) UIColor *darkBackgroundColor;
@property (strong, nonatomic) UIColor *targetBackgroundColor;
@property (strong, nonatomic) UIColor *legalBackgroundColor;
@property (strong, nonatomic) UIColor *lastMoveColor;
@property (strong, nonatomic) UIColor *premoveColor;
@property (strong, nonatomic) NSString *pieceGraphicsDirectoryPath;
@property FDChessboardStatus status;
@property BOOL doesAnimate;
@property BOOL doesShowLegalSquares;
@property BOOL doesShowLastMove;
@property BOOL doesShowPremove;
- (void)reloadData;
- (BOOL)movePieceAtCoordinate:(CGPoint)from toCoordinate:(CGPoint)to;
- (BOOL)movePieceAtCoordinate:(CGPoint)from toCoordinate:(CGPoint)to andPromoteAs:(FDChessboardPiece)as;
- (BOOL)premovePieceAtCoordinate:(CGPoint)from toCoordinate:(CGPoint)to;
- (BOOL)premovePieceAtCoordinate:(CGPoint)from toCoordinate:(CGPoint)to andPromoteAs:(FDChessboardPiece)as;
// Castling will be handled by parent calling reloadData in didMoveFrom
@end
