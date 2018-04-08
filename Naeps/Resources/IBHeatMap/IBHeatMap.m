//
//  IBHeatMap.m
//  Ivan Bruel
//
//  Created by Ivan Bruel on 02/07/14.
//  Copyright (c) 2014 Ivan Bruel. All rights reserved.
//

#import "IBMatrix.h"

@interface IBHeatMap ()

@property (nonatomic, strong) IBMatrix *colorMatrix;
@property (nonatomic, strong) IBMatrix *densityMatrix;
@end


@implementation IBHeatMap


//- (void)drawRect:(CGRect)rect
//{
//    [super drawRect:rect];
//    CGContextRef context = UIGraphicsGetCurrentContext();
//    for (NSInteger x = 0; x < CGRectGetWidth(self.bounds); x ++) {
//        for (NSInteger y = 0; y < CGRectGetHeight(self.bounds); y ++) {
//            UIColor *color = [self.colorMatrix objectForColumn:x line:y];
//            if ([color isKindOfClass:[UIColor class]]) {
//                CGContextSetFillColorWithColor(context, color.CGColor);
//                CGContextFillRect(context, CGRectMake(x, y, 1, 1));
//            }
//        }
//    }
//}

#pragma mark - Helpers

- (CGPoint)absolutePointForRelativePoint:(CGPoint)point bounds:(CGRect)bounds
{
    return CGPointMake(point.x * CGRectGetWidth(bounds), point.y * CGRectGetHeight(bounds));
}

@end
