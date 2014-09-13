//
//  FDChessboardView.m
//  FDChessboardView
//
//  Created by William Entriken on 9/12/14.
//  Copyright (c) 2014 William Entriken. All rights reserved.
//

#import "FDChessBoardView.h"

@implementation FDChessboardView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

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
