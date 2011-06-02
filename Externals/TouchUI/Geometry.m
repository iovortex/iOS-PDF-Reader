//
//  Geometry.m
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

#import "Geometry.h"

CGRect ScaleAndAlignRectToRect(CGRect inImageRect, CGRect inDestinationRect, EImageScaling inScaling, EImageAlignment inAlignment)
{
CGRect theScaledImageRect = {};

#if TARGET_OS_IPHONE == 0
#warning FIX THIS FOR NON IPHONE
#endif /* TARGET_OS_IPHONE == 0 */
BOOL flipped = YES;

if (inScaling == ImageScaling_ToFit)
	{
	theScaledImageRect.origin = inDestinationRect.origin;
	theScaledImageRect.size = inDestinationRect.size;
	}
else
	{
	CGSize theScaledImageSize = inImageRect.size;

	if (inScaling == ImageScaling_Proportionally)
		{
		float theScaleFactor = 1.0f;
		if (inDestinationRect.size.width / inImageRect.size.width < inDestinationRect.size.height / inImageRect.size.height)
			{
			theScaleFactor = inDestinationRect.size.width / inImageRect.size.width;
			}
		else
			{
			theScaleFactor = inDestinationRect.size.height / inImageRect.size.height;
			}
		theScaledImageSize.width *= theScaleFactor;
		theScaledImageSize.height *= theScaleFactor;

		theScaledImageRect.size = theScaledImageSize;
		}
	else if (inScaling == ImageScaling_None)
		{
		theScaledImageRect.size.width = theScaledImageSize.width;
		theScaledImageRect.size.height = theScaledImageSize.height;
		}
	//
	if (inAlignment == ImageAlignment_Center)
		{
		theScaledImageRect.origin.x = inDestinationRect.origin.x + (inDestinationRect.size.width - theScaledImageSize.width) / 2.0f;
		theScaledImageRect.origin.y = inDestinationRect.origin.y + (inDestinationRect.size.height - theScaledImageSize.height) / 2.0f;
		}
	else if (inAlignment == ImageAlignment_Top)
		{
		theScaledImageRect.origin.x = inDestinationRect.origin.x + (inDestinationRect.size.width - theScaledImageSize.width) / 2.0f;
		theScaledImageRect.origin.y = inDestinationRect.origin.y + inDestinationRect.size.height - theScaledImageSize.height;
		}
	else if (inAlignment == ImageAlignment_TopLeft)
		{
		theScaledImageRect.origin.x = inDestinationRect.origin.x;
		theScaledImageRect.origin.y = inDestinationRect.origin.y + inDestinationRect.size.height - theScaledImageSize.height;
		}
	else if (inAlignment == ImageAlignment_TopRight)
		{
		theScaledImageRect.origin.x = inDestinationRect.origin.x + inDestinationRect.size.width - theScaledImageSize.width;
		theScaledImageRect.origin.y = inDestinationRect.origin.y + inDestinationRect.size.height - theScaledImageSize.height;
		}
	else if (inAlignment == ImageAlignment_Left)
		{
		theScaledImageRect.origin.x = inDestinationRect.origin.x;
		theScaledImageRect.origin.y = inDestinationRect.origin.y + (inDestinationRect.size.height - theScaledImageSize.height) / 2.0f;
		}
	else if (inAlignment == ImageAlignment_Bottom)
		{
		theScaledImageRect.origin.x = inDestinationRect.origin.x + (inDestinationRect.size.width - theScaledImageSize.width) / 2.0f;
		theScaledImageRect.origin.y = inDestinationRect.origin.y;
		}
	else if (inAlignment == ImageAlignment_BottomLeft)
		{
		theScaledImageRect.origin.x = inDestinationRect.origin.x;
		theScaledImageRect.origin.y = inDestinationRect.origin.y;
		}
	else if (inAlignment == ImageAlignment_BottomRight)
		{
		theScaledImageRect.origin.x = inDestinationRect.origin.x + inDestinationRect.size.width - theScaledImageSize.width;
		theScaledImageRect.origin.y = inDestinationRect.origin.y;
		}
	else if (inAlignment == ImageAlignment_Right)
		{
		theScaledImageRect.origin.x = inDestinationRect.origin.x + inDestinationRect.size.width - theScaledImageSize.width;
		theScaledImageRect.origin.y = inDestinationRect.origin.y + (inDestinationRect.size.height - theScaledImageSize.height) / 2.0f;
		}
	}

if (flipped == YES)
	{
	CGAffineTransform theTransform = CGAffineTransformMakeScale(1, -1);
	theTransform = CGAffineTransformTranslate(theTransform, 0, -inDestinationRect.size.height);

	theScaledImageRect = CGRectApplyAffineTransform(theScaledImageRect, theTransform);
	}

return(theScaledImageRect);
}

NSString *NSStringFromCIntegerPoint(CIntegerPoint inPoint)
{
return([NSString stringWithFormat:@"%d,%d", inPoint.x, inPoint.y]);
}

extern CIntegerPoint CIntegerPointFromString(NSString *inString)
{
NSScanner *theScanner = [NSScanner scannerWithString:inString];
CIntegerPoint thePoint;

BOOL theResult = [theScanner scanInteger:&thePoint.x];
if (theResult == NO)
	[NSException raise:NSGenericException format:@"Could not scan CIntegerPoint"];
theResult = [theScanner scanString:@"," intoString:NULL];
if (theResult == NO)
	[NSException raise:NSGenericException format:@"Could not scan CIntegerPoint"];
theResult = [theScanner scanInteger:&thePoint.y];
if (theResult == NO)
	[NSException raise:NSGenericException format:@"Could not scan CIntegerPoint"];

return(thePoint);
}


#if !defined(TARGET_OS_IPHONE) || !TARGET_OS_IPHONE
NSString *NSStringFromCGAffineTransform(CGAffineTransform t)
{
return([NSString stringWithFormat:@"%g, %g, %g, %g, %g, %g", t.a, t.b, t.c, t.d, t.tx, t.ty]);
}
#endif /* defined(TARGET_OS_IPHONE) && TARGET_OS_IPHONE */
