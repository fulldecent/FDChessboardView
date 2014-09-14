//
//  FDChessboardView.m
//  FDChessboardView
//
//  Created by William Entriken on 9/12/14.
//  Copyright (c) 2014 William Entriken. All rights reserved.
//

#import "FDChessboardView.h"
#import <UIImage+SVG/UIImage+SVG.h>

@interface FDChessboardView()
// These arrays use index i=0..63 from white queen rook to king rook, then ranks up to black pieces
@property (strong, nonatomic) NSMutableArray *tilesPerSquare;
@property (strong, nonatomic) NSMutableArray *piecesPerSquare;
@property (strong, nonatomic) NSMutableArray *pieceImageViewsPerSquare;
@property (strong, nonatomic) UIView *lastMoveArrow;
@property (strong, nonatomic) UIView *premoveArrow;
@property (strong, nonatomic) UIColor *lightPieceColor; // temporary until SVG is fixed
@property (strong, nonatomic) UIColor *darkPieceColor; // temporary until SVG is fixed
@end

@implementation FDChessboardView

#pragma mark - FDChessboardView properties

- (UIColor *)lightBackgroundColor
{
    if (!_lightBackgroundColor)
        _lightBackgroundColor = [UIColor colorWithRed:222.0/255 green:196.0/255 blue:160.0/255 alpha:1];
    return _lightBackgroundColor;
}

- (UIColor *)darkBackgroundColor
{
    if (!_darkBackgroundColor)
        _darkBackgroundColor = [UIColor colorWithRed:160.0/255 green:120.0/255 blue:55.0/255 alpha:1];
    return _darkBackgroundColor;
}

- (UIColor *)targetBackgroundColor
{
    if (!_targetBackgroundColor)
        _targetBackgroundColor = [UIColor colorWithHue:0.75 saturation:0.5 brightness:0.5 alpha:1.0];
    return _targetBackgroundColor;
}

- (UIColor *)legalBackgroundColor
{
    if (!_legalBackgroundColor)
        _legalBackgroundColor = [UIColor colorWithHue:0.25 saturation:0.5 brightness:0.5 alpha:1.0];
    return _legalBackgroundColor;
}

- (UIColor *)lightPieceColor
{
    if (!_lightPieceColor)
        _lightPieceColor = [UIColor whiteColor];
    return _lightPieceColor;
}

- (UIColor *)darkPieceColor
{
    if (!_darkPieceColor)
        _darkPieceColor = [UIColor blackColor];
    return _darkPieceColor;
}

- (UIColor *)lastMoveColor
{
    if (!_lastMoveColor)
        _lastMoveColor = [UIColor colorWithHue:0.35 saturation:0.5 brightness:0.5 alpha:1.0];
    return _lastMoveColor;
}

- (UIColor *)premoveColor
{
    if (!_premoveColor)
        _premoveColor = [UIColor colorWithHue:0.15 saturation:0.5 brightness:0.5 alpha:1.0];
    return _premoveColor;
}

- (void)setDataSource:(id<FDChessboardViewDataSource>)dataSource
{
    _dataSource = dataSource;
    [self reloadData];
}

#pragma mark - FDChessboardView private properties

- (NSMutableArray *)tilesPerSquare
{
    if (!_tilesPerSquare) {
        _tilesPerSquare = [NSMutableArray array];
        [self resetConstraintsAndSetTiles];
    }
    return _tilesPerSquare;
}

- (NSMutableArray *)piecesPerSquare
{
    if (!_piecesPerSquare) {
        _piecesPerSquare = [NSMutableArray array];
    }
    return _piecesPerSquare;
}

- (NSMutableArray *)pieceImageViewsPerSquare
{
    if (!_pieceImageViewsPerSquare) {
        _pieceImageViewsPerSquare = [NSMutableArray array];
    }
    return _pieceImageViewsPerSquare;
}

#pragma mark - UIView Initializers

- (void)setup
{
    [self resetConstraintsAndSetTiles];
//    [self insertPiece];
}

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    [self setup];
    return self;
}

- (instancetype)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    [self setup];
    return self;
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

#pragma mark - Drawing helpers

- (void)resetConstraintsAndSetTiles
{
    self.translatesAutoresizingMaskIntoConstraints = NO;
    self.tilesPerSquare = [NSMutableArray array];
    for (int i=0; i<64; i++) {
        UIView *view = [[UIView alloc] init];
        view.translatesAutoresizingMaskIntoConstraints = NO;
        view.tag = i;
        view.backgroundColor = !(i%2) ^ ((i/8)%2) ? self.darkBackgroundColor : self.lightBackgroundColor;
        [self addSubview:view];
        [self.tilesPerSquare addObject:view];
    }
    for (int i=0; i<64; i++) {
        NSLayoutConstraint *constraint;
        if (i<8) {
            constraint = [NSLayoutConstraint constraintWithItem:self.tilesPerSquare[i]
                                                      attribute:NSLayoutAttributeBottom
                                                      relatedBy:NSLayoutRelationEqual
                                                         toItem:self
                                                      attribute:NSLayoutAttributeBottom
                                                     multiplier:1
                                                       constant:0];
            [self addConstraint:constraint];
        } else {
            constraint = [NSLayoutConstraint constraintWithItem:self.tilesPerSquare[i]
                                                      attribute:NSLayoutAttributeBottom
                                                      relatedBy:NSLayoutRelationEqual
                                                         toItem:self.tilesPerSquare[i-8]
                                                      attribute:NSLayoutAttributeTop
                                                     multiplier:1
                                                       constant:0];
            [self addConstraint:constraint];
            constraint = [NSLayoutConstraint constraintWithItem:self.tilesPerSquare[i]
                                                      attribute:NSLayoutAttributeHeight
                                                      relatedBy:NSLayoutRelationEqual
                                                         toItem:self.tilesPerSquare[i-8]
                                                      attribute:NSLayoutAttributeHeight
                                                     multiplier:1
                                                       constant:0];
            [self addConstraint:constraint];
        }
        if (i%8==0) {
            constraint = [NSLayoutConstraint constraintWithItem:self.tilesPerSquare[i]
                                                      attribute:NSLayoutAttributeLeft
                                                      relatedBy:NSLayoutRelationEqual
                                                         toItem:self
                                                      attribute:NSLayoutAttributeLeft
                                                     multiplier:1
                                                       constant:0];
            [self addConstraint:constraint];
        } else {
            constraint = [NSLayoutConstraint constraintWithItem:self.tilesPerSquare[i]
                                                      attribute:NSLayoutAttributeLeft
                                                      relatedBy:NSLayoutRelationEqual
                                                         toItem:self.tilesPerSquare[i-1]
                                                      attribute:NSLayoutAttributeRight
                                                     multiplier:1
                                                       constant:0];
            [self addConstraint:constraint];
            constraint = [NSLayoutConstraint constraintWithItem:self.tilesPerSquare[i]
                                                      attribute:NSLayoutAttributeWidth
                                                      relatedBy:NSLayoutRelationEqual
                                                         toItem:self.tilesPerSquare[i-1]
                                                      attribute:NSLayoutAttributeWidth
                                                     multiplier:1
                                                       constant:0];
            [self addConstraint:constraint];
        }
        if (i>=64-8) {
            constraint = [NSLayoutConstraint constraintWithItem:self.tilesPerSquare[i]
                                                      attribute:NSLayoutAttributeTop
                                                      relatedBy:NSLayoutRelationEqual
                                                         toItem:self
                                                      attribute:NSLayoutAttributeTop
                                                     multiplier:1
                                                       constant:0];
            [self addConstraint:constraint];
        }
        if (i%8==7) {
            constraint = [NSLayoutConstraint constraintWithItem:self.tilesPerSquare[i]
                                                      attribute:NSLayoutAttributeRight
                                                      relatedBy:NSLayoutRelationEqual
                                                         toItem:self
                                                      attribute:NSLayoutAttributeRight
                                                     multiplier:1
                                                       constant:0];
            [self addConstraint:constraint];
        }
    }
    [self layoutIfNeeded];
}

#pragma mark - Other


- (void)reloadData
{
    UIView *squareOne = self.tilesPerSquare[0];

    for (int i=0; i<64; i++) {
        CGPoint point = CGPointMake((int)(i%8), (int)(i/8));
        FDChessboardPiece piece = [self.dataSource chessboardView:self
                                               pieceForCoordinate:point];
        self.piecesPerSquare[i] = @(piece);
        
        UIImageView *pieceImageView;
        NSString *file;
        UIColor *color;
        switch (piece) {
            case FDChessboardPieceEmpty:
                break;
            case FDChessboardPieceWhitePawn:
                file = @"wp";
                color = self.lightPieceColor;
                break;
            case FDChessboardPieceBlackPawn:
                file = @"bp";
                color = self.darkPieceColor;
                break;
            case FDChessboardPieceWhiteKnight:
                file = @"wn";
                color = self.lightPieceColor;
                break;
            case FDChessboardPieceBlackKnight:
                file = @"bn";
                color = self.darkPieceColor;
                break;
            case FDChessboardPieceWhiteBishop:
                file = @"wb";
                color = self.lightPieceColor;
                break;
            case FDChessboardPieceBlackBishop:
                file = @"bb";
                color = self.darkPieceColor;
                break;
            case FDChessboardPieceWhiteRook:
                file = @"wr";
                color = self.lightPieceColor;
                break;
            case FDChessboardPieceBlackRook:
                file = @"br";
                color = self.darkPieceColor;
                break;
            case FDChessboardPieceWhiteQueen:
                file = @"wq";
                color = self.lightPieceColor;
                break;
            case FDChessboardPieceBlackQueen:
                file = @"bq";
                color = self.darkPieceColor;
                break;
            case FDChessboardPieceWhiteKing:
                file = @"wk";
                color = self.lightPieceColor;
                break;
            case FDChessboardPieceBlackKing:
                file = @"bk";
                color = self.darkPieceColor;
                break;
        }
        if (file) {
            UIImage *image = [UIImage imageWithSVGNamed:file
                                             targetSize:CGSizeMake(200, 200)
                                              fillColor:color];
            pieceImageView = [[UIImageView alloc] initWithImage:image];
            pieceImageView.translatesAutoresizingMaskIntoConstraints = NO;
            self.pieceImageViewsPerSquare[i] = pieceImageView;
            [self addSubview:pieceImageView];
            NSLayoutConstraint *constraint;
            constraint = [NSLayoutConstraint constraintWithItem:pieceImageView
                                                      attribute:NSLayoutAttributeWidth
                                                      relatedBy:NSLayoutRelationEqual
                                                         toItem:squareOne
                                                      attribute:NSLayoutAttributeWidth
                                                     multiplier:1
                                                       constant:0];
            [self addConstraint:constraint];
            constraint = [NSLayoutConstraint constraintWithItem:pieceImageView
                                                      attribute:NSLayoutAttributeHeight
                                                      relatedBy:NSLayoutRelationEqual
                                                         toItem:squareOne
                                                      attribute:NSLayoutAttributeHeight
                                                     multiplier:1
                                                       constant:0];
            [self addConstraint:constraint];
            constraint = [NSLayoutConstraint constraintWithItem:pieceImageView
                                                      attribute:NSLayoutAttributeTop
                                                      relatedBy:NSLayoutRelationEqual
                                                         toItem:self.tilesPerSquare[i]
                                                      attribute:NSLayoutAttributeTop
                                                     multiplier:1
                                                       constant:0];
            [self addConstraint:constraint];
            constraint = [NSLayoutConstraint constraintWithItem:pieceImageView
                                                      attribute:NSLayoutAttributeLeading
                                                      relatedBy:NSLayoutRelationEqual
                                                         toItem:self.tilesPerSquare[i]
                                                      attribute:NSLayoutAttributeLeading
                                                     multiplier:1
                                                       constant:0];
            [self addConstraint:constraint];
        } else {
            self.pieceImageViewsPerSquare[i] = [NSNull null];
        }
    }
    [self layoutIfNeeded];
    
}

- (BOOL)movePieceAtCoordinate:(CGPoint)from toCoordinate:(CGPoint)to
{
    return YES;
}

- (BOOL)movePieceAtCoordinate:(CGPoint)from toCoordinate:(CGPoint)to andPromoteAs:(FDChessboardPiece)as
{
    return YES;
}

- (BOOL)premovePieceAtCoordinate:(CGPoint)from toCoordinate:(CGPoint)to
{
    return YES;
}

- (BOOL)premovePieceAtCoordinate:(CGPoint)from toCoordinate:(CGPoint)to andPromoteAs:(FDChessboardPiece)as
{
    return YES;
}


@end
