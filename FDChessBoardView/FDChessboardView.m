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
@property (strong, nonatomic) NSMutableArray *pieceImagesPerSquare;
@property (strong, nonatomic) NSMutableArray *constraints;
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
        _lightBackgroundColor = [UIColor colorWithHue:0.5 saturation:0.5 brightness:0.5 alpha:1.0];
    return _lightBackgroundColor;
}

- (UIColor *)darkBackgroundColor
{
    if (!_darkBackgroundColor)
        _darkBackgroundColor = [UIColor colorWithHue:0.5 saturation:0.5 brightness:0.2 alpha:1.0];
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


#pragma mark - UIView Initializers

- (void)setup
{
    [self resetConstraintsAndSetTiles];
    [self insertPiece];
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



#pragma mark - Drawing helpers

- (void)resetConstraintsAndSetTiles
{
    self.translatesAutoresizingMaskIntoConstraints = NO;
    self.constraints = [NSMutableArray array];
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
            [self.constraints addObject:constraint];
        } else {
            constraint = [NSLayoutConstraint constraintWithItem:self.tilesPerSquare[i]
                                                      attribute:NSLayoutAttributeBottom
                                                      relatedBy:NSLayoutRelationEqual
                                                         toItem:self.tilesPerSquare[i-8]
                                                      attribute:NSLayoutAttributeTop
                                                     multiplier:1
                                                       constant:0];
            [self addConstraint:constraint];
            [self.constraints addObject:constraint];
            constraint = [NSLayoutConstraint constraintWithItem:self.tilesPerSquare[i]
                                                      attribute:NSLayoutAttributeHeight
                                                      relatedBy:NSLayoutRelationEqual
                                                         toItem:self.tilesPerSquare[i-8]
                                                      attribute:NSLayoutAttributeHeight
                                                     multiplier:1
                                                       constant:0];
            [self addConstraint:constraint];
            [self.constraints addObject:constraint];
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
            [self.constraints addObject:constraint];
        } else {
            constraint = [NSLayoutConstraint constraintWithItem:self.tilesPerSquare[i]
                                                      attribute:NSLayoutAttributeLeft
                                                      relatedBy:NSLayoutRelationEqual
                                                         toItem:self.tilesPerSquare[i-1]
                                                      attribute:NSLayoutAttributeRight
                                                     multiplier:1
                                                       constant:0];
            [self addConstraint:constraint];
            [self.constraints addObject:constraint];
            constraint = [NSLayoutConstraint constraintWithItem:self.tilesPerSquare[i]
                                                      attribute:NSLayoutAttributeWidth
                                                      relatedBy:NSLayoutRelationEqual
                                                         toItem:self.tilesPerSquare[i-1]
                                                      attribute:NSLayoutAttributeWidth
                                                     multiplier:1
                                                       constant:0];
            [self addConstraint:constraint];
            [self.constraints addObject:constraint];
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
            [self.constraints addObject:constraint];
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
            [self.constraints addObject:constraint];
        }
    }
    [self layoutIfNeeded];
}

- (void)insertPiece
{
    UIImage* image = [UIImage imageWithSVGNamed:@"bk"
                                     targetSize:CGSizeMake(200, 200)
                                      fillColor:[UIColor blueColor]];
    UIImageView *iv = [[UIImageView alloc] initWithImage:image];
    [self addSubview:iv];
    [self layoutIfNeeded];
}


#pragma mark - Other


- (void)reloadData
{
    
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
