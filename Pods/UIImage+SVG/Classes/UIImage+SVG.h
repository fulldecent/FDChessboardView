//
//  UIImage+SVG.h
//  UIImage-SVG
//
//  Created by Thijs Scheepers on 25/04/14.
//  Copyright (c) 2014 Label305 B.V. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIImage (SVG)

/**
 * Returns a non cached UIImage in the specified target size. The vector path
 * is filled with the specified fill color.
 */
+ (instancetype)imageWithSVGNamed:(NSString*)svgName
					   targetSize:(CGSize)targetSize
						fillColor:(UIColor*)fillColor;

/**
 * Returns a UImage in the specified target size. The vector path
 * is filled with the specified fill color. Use the cacheImage property to
 * cache the rendered UIImage for later reuse.
 */
+ (instancetype)imageWithSVGNamed:(NSString*)svgName
					   targetSize:(CGSize)targetSize
						fillColor:(UIColor*)fillColor
							cache:(BOOL)cacheImage;

@end
