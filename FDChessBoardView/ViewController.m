//
//  ViewController.m
//  FDChessboardView
//
//  Created by William Entriken on 9/12/14.
//  Copyright (c) 2014 William Entriken. All rights reserved.
//

#import "ViewController.h"

@interface ViewController () <FDChessboardViewDataSource>
@property NSMutableArray *pieces;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    self.pieces = [NSMutableArray array];
    NSString *position = @"RNBQKBNRPPPPPPPP................................pppppppprnbqkbnr";
    
    for (int i=0; i<64; i++) {
        switch ([position characterAtIndex:i]) {
            case 'K':
                [self.pieces addObject:@(FDChessboardPieceWhiteKing)];
                break;
            case 'k':
                [self.pieces addObject:@(FDChessboardPieceBlackKing)];
                break;
            case 'Q':
                [self.pieces addObject:@(FDChessboardPieceWhiteQueen)];
                break;
            case 'q':
                [self.pieces addObject:@(FDChessboardPieceBlackQueen)];
                break;
            case 'R':
                [self.pieces addObject:@(FDChessboardPieceWhiteRook)];
                break;
            case 'r':
                [self.pieces addObject:@(FDChessboardPieceBlackRook)];
                break;
            case 'B':
                [self.pieces addObject:@(FDChessboardPieceWhiteBishop)];
                break;
            case 'b':
                [self.pieces addObject:@(FDChessboardPieceBlackBishop)];
                break;
            case 'N':
                [self.pieces addObject:@(FDChessboardPieceWhiteKnight)];
                break;
            case 'n':
                [self.pieces addObject:@(FDChessboardPieceBlackKnight)];
                break;
            case 'P':
                [self.pieces addObject:@(FDChessboardPieceWhitePawn)];
                break;
            case 'p':
                [self.pieces addObject:@(FDChessboardPieceBlackPawn)];
                break;
            default:
                [self.pieces addObject:@(FDChessboardPieceEmpty)];
                break;
        }
    }
    
    self.chessboard.dataSource = self;
}

- (FDChessboardPiece)chessboardView:(FDChessboardView *)board pieceForCoordinate:(CGPoint)coordinate
{
    return [(NSNumber *)self.pieces[(int)(coordinate.y*8 + coordinate.x)] intValue];
}


@end
