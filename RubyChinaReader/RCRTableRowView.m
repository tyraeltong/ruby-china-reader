//
//  RCRTableRowView.m
//  RubyChinaReader
//
//  Created by James Chen on 3/4/12.
//  Copyright (c) 2012 ashchan.com. All rights reserved.
//

#import "RCRTableRowView.h"

@interface RCRTableRowView () {
    BOOL mouseInside;
    NSTrackingArea *trackingArea;
}
@property BOOL mouseInside;
@end

@implementation RCRTableRowView

@synthesize objectValue;
@dynamic mouseInside;

- (void)setMouseInside:(BOOL)value {
    if (mouseInside != value) {
        mouseInside = value;
        [self setNeedsDisplay:YES];
    }
}

- (BOOL)mouseInside {
    return mouseInside;
}

- (void)mouseEntered:(NSEvent *)theEvent {
    self.mouseInside = YES;
}

- (void)mouseExited:(NSEvent *)theEvent {
    self.mouseInside = NO;
}

- (void)ensureTrackingArea {
    if (trackingArea == nil) {
        trackingArea = [[NSTrackingArea alloc] initWithRect:NSZeroRect options:NSTrackingInVisibleRect | NSTrackingActiveAlways | NSTrackingMouseEnteredAndExited owner:self userInfo:nil];
    }
}

- (void)updateTrackingAreas {
    [super updateTrackingAreas];
    [self ensureTrackingArea];
    if (![[self trackingAreas] containsObject:trackingArea]) {
        [self addTrackingArea:trackingArea];
    }
}

static NSGradient *gradientWithTargetColor(NSColor *targetColor) {
    NSArray *colors = [NSArray arrayWithObjects:[targetColor colorWithAlphaComponent:0], targetColor, targetColor, [targetColor colorWithAlphaComponent:0], nil];
    const CGFloat locations[4] = { 0.0, 0.35, 0.65, 1.0 };
    return [[NSGradient alloc] initWithColors:colors atLocations:locations colorSpace:[NSColorSpace sRGBColorSpace]];
}

void DrawSeparatorInRect(NSRect rect) {
    static NSGradient *gradient = nil;
    if (gradient == nil) {
        gradient = gradientWithTargetColor([NSColor colorWithSRGBRed:.80 green:.80 blue:.80 alpha:1]);
    }
    [gradient drawInRect:rect angle:0];
    
}
- (NSRect)separatorRect {
    NSRect separatorRect = self.bounds;
    separatorRect.origin.y = NSMaxY(separatorRect) - 1;
    separatorRect.size.height = 1;
    return separatorRect;
}

- (void)drawSeparatorInRect:(NSRect)dirtyRect {
    DrawSeparatorInRect([self separatorRect]);
}

- (void)drawSelectionInRect:(NSRect)dirtyRect {
    if (self.selectionHighlightStyle != NSTableViewSelectionHighlightStyleNone) {
        NSRect selectionRect = NSInsetRect(self.bounds, 0, 0.2);
        [[NSColor colorWithCalibratedWhite:.82 alpha:1.0] setFill];
        NSBezierPath *selectionPath = [NSBezierPath bezierPathWithRoundedRect:selectionRect xRadius:1 yRadius:1];
        [selectionPath fill];
    }
}

- (void)drawBackgroundInRect:(NSRect)dirtyRect {
    [self.backgroundColor set];
    NSRectFill(self.bounds);
    
    if (self.mouseInside) {
        NSGradient *gradient = gradientWithTargetColor([NSColor colorWithCalibratedWhite:.82 alpha:1.0]);
        [gradient drawInRect:self.bounds angle:0];
    }
}

- (NSBackgroundStyle)interiorBackgroundStyle {
    return NSBackgroundStyleLight;  
}

- (void)setFrame:(NSRect)frameRect {
    [super setFrame:frameRect];
    if ([self inLiveResize]) {
        if (self.selected) {
            [self setNeedsDisplay:YES];
        } else {
            [self setNeedsDisplayInRect:[self separatorRect]];
        }
    }
}

@end
