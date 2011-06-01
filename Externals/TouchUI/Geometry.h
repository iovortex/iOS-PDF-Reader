//
//  Geometry.h
//  TouchCode
//
//  Created by Jonathan Wight on 10/15/2005.
//  Copyright 2005 toxicsoftware.com. All rights reserved.
//
//  Permission is hereby granted, free of charge, to any person
//  obtaining a copy of this software and associated documentation
//  files (the "Software"), to deal in the Software without
//  restriction, including without limitation the rights to use,
//  copy, modify, merge, publish, distribute, sublicense, and/or sell
//  copies of the Software, and to permit persons to whom the
//  Software is furnished to do so, subject to the following
//  conditions:
//
//  The above copyright notice and this permission notice shall be
//  included in all copies or substantial portions of the Software.
//
//  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND,
//  EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES
//  OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND
//  NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT
//  HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY,
//  WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING
//  FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR
//  OTHER DEALINGS IN THE SOFTWARE.
//

#import <Foundation/Foundation.h>

typedef enum {
   ImageScaling_Proportionally = 0,
   ImageScaling_ToFit,
   ImageScaling_None,
} EImageScaling;

typedef enum {
   ImageAlignment_Center = 0,
   ImageAlignment_Top,
   ImageAlignment_TopLeft,
   ImageAlignment_TopRight,
   ImageAlignment_Left,
   ImageAlignment_Bottom,
   ImageAlignment_BottomLeft,
   ImageAlignment_BottomRight,
   ImageAlignment_Right
} EImageAlignment;

extern CGRect ScaleAndAlignRectToRect(CGRect inImageRect, CGRect inDestinationRect, EImageScaling inScaling, EImageAlignment inAlignment);

#if CGFLOAT_IS_DOUBLE == 0
#define cos_ cosf
#define sin_ sinf
#define atan_ atanf
#define abs_ fabsf
#define pow_ powf
#define fmod_ fmodf
#define fabs_ fabsf
#define sqrt_ sqrtf
#else
#define cos_ cos
#define sin_ sin
#define atan_ atan
#define abs_ fabs
#define pow_ pow
#define fmod_ fmod
#define fabs_ fabs
#define sqrt_ sqrt
#endif

static inline CGFloat RadiansToDegrees(CGFloat inValue)
{
return(inValue * (180.0f / (CGFloat)M_PI));
}

static inline CGFloat DegreesToRadians(CGFloat inValue)
{
return(inValue * ((CGFloat)M_PI / 180.0f));
}

static inline CGFloat SemicirclesToDegrees(CGFloat inValue)
{
return(inValue * (180.0f / pow_(2.0f, 31.0f)));
}

static inline CGFloat DegreesToSemicircles(CGFloat inValue)
{
return(inValue * (pow_(2.0f, 31.0f) / 180.0f));
}

static inline CGFloat SemicirclesToRadians(CGFloat inValue)
{
return(DegreesToRadians(SemicirclesToDegrees(inValue)));
}

static inline CGFloat RadiansToSemicircles(CGFloat inValue)
{
return(DegreesToSemicircles(RadiansToDegrees(inValue)));
}

static inline CGFloat FeetToMeters(CGFloat inValue)
{
return(inValue * 12.0f * 2.54f / 100.0f);
}

static inline CGFloat MetersToFeet(CGFloat inValue)
{
return(inValue * 100.0f / 2.54f / 12.0f);
}

static inline CGPoint Rotation(CGFloat inAngle, CGFloat inLength)
{
CGFloat theCosine = cos_(DegreesToRadians(fmod_(90.0f - inAngle, 360.0f)));
CGFloat theSine = sin_(DegreesToRadians(fmod_(90.0f - inAngle, 360.0f)));
CGPoint thePoint = {
	.x = theCosine * inLength,
	.y = theSine * inLength,
	};
return(thePoint);
}

static inline CGRect CGRectFromPoints(CGPoint P1, CGPoint P2)
{
CGRect theRect = { .origin = P1, .size = { .width = fabs_(P2.x - P1.x), .height = fabs_(P2.y - P1.y) } };

theRect.origin.x = MIN(P1.x, P2.x);
theRect.origin.y = MIN(P1.y, P2.y);

return(theRect);
}

static inline CGRect CGRectFromOriginAndSize(CGPoint inOrigin, CGSize inSize)
{
CGRect theRect = { .origin = inOrigin, .size = inSize };
return(theRect);
}

static inline int quadrant(CGFloat x, CGFloat y)
{
#if TARGET_OS_IPHONE == 0
#warning FIX THIS FOR NON IPHONE
#endif /* TARGET_OS_IPHONE == 0 */
BOOL flipped = YES;
if (flipped == NO)
	{
	if (x >= 0)
		{
		if (y >= 0)
			return 0;
		if (y < 0)
			return 1;
		}
	if (x < 0 && y < 0)
		return 2;
	else
		return 3;
	}
else
	{
	if (x >= 0)
		{
		if (y >= 0)
			return 1;
		if (y < 0)
			return 0;
		}
	if (x < 0 && y < 0)
		return 3;
	else
		return 2;
	}
}

static inline CGFloat angle(CGFloat x, CGFloat y)
{
BOOL flipped = YES; // TODO
if (flipped == NO)
	{
	const int q = quadrant(x, y);
	if (q == 0)
		{
		if (x == 0.0f)
			return 0.0f;
		else if (y == 0.0f)
			return 90.0f;
		else
			return RadiansToDegrees(atan_(x / y));
		}
	else if (q == 1)
		return 180.0f + RadiansToDegrees(atan_(x / y));
	else if (q == 2)
		return 180.0f + RadiansToDegrees(atan_(x / y));
	else
		{
		if (x == 0.0f)
			return 0.0f;
		return 360.0f + RadiansToDegrees(atan_(x / y));
		}
	}
else
	{
	const int q = quadrant(x, y);
	if (q == 0)
		{
		if (y == 0.0f)
			return 90.0f;
		return 90.0f + RadiansToDegrees(atan_(y / x));
		}
	else if (q == 1)
		return 90.0f + RadiansToDegrees(atan_(y / x));
	else if (q == 2)
		return 270.0f + RadiansToDegrees(atan_(y / x));
	else
		{
		if (x == 0.0f)
			return 0.0f;
		return 270.0f + RadiansToDegrees(atan_(y / x));
		}
	}
}

static inline CGPoint CGPointClampToRect(CGPoint p, CGRect r)
{
// TODO replace with MIN and MAX
if (p.x < CGRectGetMinX(r))
	{
	p.x = CGRectGetMinX(r);
	}
else if (p.x > CGRectGetMaxX(r))
	{
	p.x = CGRectGetMaxX(r);
	}

if (p.y < CGRectGetMinY(r))
	{
	p.y = CGRectGetMinY(r);
	}
else if (p.y > CGRectGetMaxY(r))
	{
	p.y = CGRectGetMaxY(r);
	}
return(p);
}

static inline CGPoint CGPointSubtract(CGPoint p1, CGPoint p2)
{
return(CGPointMake(p1.x - p2.x, p1.y - p2.y));
}

static inline CGRect CGRectUnionOfRectsInArray(NSArray *inArray)
{
CGRect theUnionRect = CGRectZero;
for (NSValue *theValue in inArray)
	{
	CGRect theRect = [theValue CGRectValue];
	theUnionRect = CGRectUnion(theRect, theUnionRect);
	}
return(theUnionRect);
}

static inline CGFloat distance(CGPoint start, CGPoint finish)
{
const CGFloat theDistance = sqrt_(pow_(fabs_(start.x - finish.x), 2.0f) + pow_(abs_(start.y - finish.y), 2.0f));
return(theDistance);
}

static inline CGFloat magnitude(CGPoint point)
{
const CGFloat theMagnitude = sqrt_(fabs_(point.x * point.x) + fabs_(point.y * point.y));
return(theMagnitude);
}

#pragma mark -

static inline CGPoint CGPointAdd(CGPoint a, CGPoint b)
{
const CGPoint r = { .x = a.x + b.x, .y = a.y + b.y };
return(r);
}

static inline CGPoint CGPointMultiply(CGPoint a, CGPoint b)
{
const CGPoint r = { .x = a.x * b.x, .y = a.y * b.y };
return(r);
}


#pragma mark -

struct CIntegerPoint {
	NSInteger x;
	NSInteger y;
};
typedef struct CIntegerPoint CIntegerPoint;

struct CIntegerSize {
	NSInteger width;
	NSInteger height;
};
typedef struct CIntegerSize CIntegerSize;

struct CIntegerRect {
	CIntegerPoint origin;
	CIntegerSize size;
};
typedef struct CIntegerRect CIntegerRect;

static inline CIntegerPoint CIntegerPointMake(NSInteger x, NSInteger y)
{
const CIntegerPoint thePoint = { .x = x, .y = y };
return(thePoint);
}

extern NSString *NSStringFromCIntegerPoint(CIntegerPoint inPoint);
extern CIntegerPoint CIntegerPointFromString(NSString *inString);


#if !defined(TARGET_OS_IPHONE) || !TARGET_OS_IPHONE
extern NSString *NSStringFromCGAffineTransform(CGAffineTransform t);
#endif /* defined(TARGET_OS_IPHONE) && TARGET_OS_IPHONE */
