//
//  StrokeLabel.m
//  chalkCircle
//
//  Created by qqn_pipi on 13-11-8.
//
//

#import "StrokeLabel.h"
#import "UILabel+Extend.h"
#import "StringUtil.h"

@implementation StrokeLabel

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

//- (void)drawTextInRect:(CGRect)rect {
//    
//    CGSize shadowOffset = self.shadowOffset;
//    UIColor *textColor = self.textColor;
//    
//    CGContextRef c = UIGraphicsGetCurrentContext();
//    CGContextSetLineWidth(c, self.textOutlineWidth);
//    CGContextSetLineJoin(c, kCGLineJoinRound);
//    
//    CGContextSetTextDrawingMode(c, kCGTextStroke);
//    self.textColor = self.textOutlineColor;
//    [super drawTextInRect:rect];
//    
//    CGContextSetTextDrawingMode(c, kCGTextFill);
//    self.textColor = textColor;
//    self.shadowOffset = CGSizeMake(0, 0);
//    [super drawTextInRect:rect];
//    
//    self.shadowOffset = shadowOffset;
//    
//}

- (void)drawTextInRect:(CGRect)rect
{
    CGRect textRect = rect;
    if (self.numberOfLines != 0) {
                
        CGSize size =  [self.text sizeWithMyFont:self.font constrainedToSize:rect.size lineBreakMode:self.lineBreakMode];
        int actualNumberOfLines = MIN(self.numberOfLines,  size.height / self.font.lineHeight);
        
        
        textRect.size = CGSizeMake(textRect.size.width, self.font.lineHeight * actualNumberOfLines);
    }
    
    CGContextRef ctx = UIGraphicsGetCurrentContext();
    
    CGContextSetAllowsFontSubpixelQuantization(ctx, true);
    CGContextSetShouldSubpixelQuantizeFonts(ctx, true);
    
    CGContextSetLineWidth(ctx, self.textOutlineWidth);
    CGContextSetLineJoin(ctx, kCGLineJoinRound);    
    
    //set position
    switch (self.textAlignment)
    {
        case NSTextAlignmentCenter:
        {
            textRect.origin.x = textRect.origin.x + (rect.size.width - textRect.size.width) / 2.0f;
            break;
        }
        case NSTextAlignmentRight:
        {
            textRect.origin.x = textRect.origin.x + rect.size.width - textRect.size.width;
            break;
        }
        default:
        {
            textRect.origin.x = rect.origin.x;
            break;
        }
    }
    switch (self.contentMode)
    {
        case UIViewContentModeTop:
        case UIViewContentModeTopLeft:
        case UIViewContentModeTopRight:
        {
            textRect.origin.y = rect.origin.y;
            break;
        }
        case UIViewContentModeBottom:
        case UIViewContentModeBottomLeft:
        case UIViewContentModeBottomRight:
        {
            textRect.origin.y = rect.origin.y + rect.size.height - textRect.size.height;
            break;
        }
        default:
        {
            textRect.origin.y = rect.origin.y + (rect.size.height - textRect.size.height)/2.0f;
            break;
        }
    }

    
    CGContextSaveGState(ctx);
    
    CGContextSetTextDrawingMode(ctx, kCGTextStroke);
    CGContextSetStrokeColorWithColor(ctx, self.textOutlineColor.CGColor);
    
    /// Make a copy of the default paragraph style
    NSMutableParagraphStyle *paragraphStyle = [[NSParagraphStyle defaultParagraphStyle] mutableCopy];
    /// Set line break mode
    paragraphStyle.lineBreakMode = self.lineBreakMode;
    /// Set text alignment
    paragraphStyle.alignment = self.textAlignment;
    NSDictionary *attributes = @{ NSFontAttributeName:self.font,
                            NSParagraphStyleAttributeName:paragraphStyle };
    
    [self.text drawInRect:textRect withAttributes:attributes];
    

    CGContextRestoreGState(ctx);
    
    CGContextSaveGState(ctx);
    CGContextSetTextDrawingMode(ctx, kCGTextFill);
    CGContextSetFillColorWithColor(ctx, self.textColor.CGColor);
    
    /// Make a copy of the default paragraph style
    NSMutableParagraphStyle* otherParagraphStyle = [[NSParagraphStyle defaultParagraphStyle] mutableCopy];
    /// Set line break mode
    otherParagraphStyle.lineBreakMode = self.lineBreakMode;
    /// Set text alignment
    otherParagraphStyle.alignment = self.textAlignment;
    NSDictionary *otherAttributes = @{ NSFontAttributeName:self.font,
                                  NSParagraphStyleAttributeName:otherParagraphStyle };
    
    [self.text drawInRect:textRect withAttributes:otherAttributes];
    
    CGContextRestoreGState(ctx);
}

//- (void)drawTextInRect:(CGRect)rect
//{
//    CGRect textRect = rect;
//    if (self.numberOfLines != 0) {
//
//        CGSize size =  [self.text sizeWithMyFont:self.font constrainedToSize:rect.size lineBreakMode:self.lineBreakMode];
//        int actualNumberOfLines = MIN(self.numberOfLines,  size.height / self.font.lineHeight);
//
//        textRect.size = CGSizeMake(textRect.size.width, self.font.lineHeight * actualNumberOfLines);
//    }
//
//
//    CGContextRef ctx = UIGraphicsGetCurrentContext();
//
//    CGContextSetShouldSubpixelQuantizeFonts(ctx, false);
//
//    CGContextSetLineWidth(ctx, self.textOutlineWidth);
//    CGContextSetLineJoin(ctx, kCGLineJoinRound);
//
//    //set position
//    switch (self.textAlignment)
//    {
//        case UITextAlignmentCenter:
//        {
//            textRect.origin.x = textRect.origin.x + (rect.size.width - textRect.size.width) / 2.0f;
//            break;
//        }
//        case UITextAlignmentRight:
//        {
//            textRect.origin.x = textRect.origin.x + rect.size.width - textRect.size.width;
//            break;
//        }
//        default:
//        {
//            textRect.origin.x = rect.origin.x;
//            break;
//        }
//    }
//    switch (self.contentMode)
//    {
//        case UIViewContentModeTop:
//        case UIViewContentModeTopLeft:
//        case UIViewContentModeTopRight:
//        {
//            textRect.origin.y = rect.origin.y;
//            break;
//        }
//        case UIViewContentModeBottom:
//        case UIViewContentModeBottomLeft:
//        case UIViewContentModeBottomRight:
//        {
//            textRect.origin.y = rect.origin.y + rect.size.height - textRect.size.height;
//            break;
//        }
//        default:
//        {
//            textRect.origin.y = rect.origin.y + (rect.size.height - textRect.size.height)/2.0f;
//            break;
//        }
//    }
//
//    CGContextSetFillColorWithColor(ctx, self.textColor.CGColor);
//    CGContextSetTextDrawingMode (ctx, kCGTextFillStroke);
//    CGContextSetStrokeColorWithColor(ctx, self.textOutlineColor.CGColor);
//
//    [self.text drawInRect:textRect
//                 withFont:self.font
//            lineBreakMode:self.lineBreakMode
//                alignment:self.textAlignment];
//
//}

@end
