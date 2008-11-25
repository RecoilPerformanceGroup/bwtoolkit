//
//  BWTexturedSlider.m
//  BWToolkit
//
//  Created by Brandon Walkin (www.brandonwalkin.com)
//  All code is provided under the New BSD license.
//

#import "BWTexturedSlider.h"
#import "BWTexturedSliderCell.h"

static NSImage *quietSpeakerImage, *loudSpeakerImage, *smallPhotoImage, *largePhotoImage;
static float imageInset = 25;

@implementation BWTexturedSlider

@synthesize indicatorIndex;
@synthesize minButton;
@synthesize maxButton;

+ (void)initialize 
{
	NSBundle *bundle = [NSBundle bundleForClass:[BWTexturedSlider class]];
	
	quietSpeakerImage = [[NSImage alloc] initWithContentsOfFile:[bundle pathForImageResource:@"TexturedSliderSpeakerQuiet.png"]];
	loudSpeakerImage = [[NSImage alloc] initWithContentsOfFile:[bundle pathForImageResource:@"TexturedSliderSpeakerLoud.png"]];
	smallPhotoImage = [[NSImage alloc] initWithContentsOfFile:[bundle pathForImageResource:@"TexturedSliderPhotoSmall.tif"]];
	largePhotoImage	= [[NSImage alloc] initWithContentsOfFile:[bundle pathForImageResource:@"TexturedSliderPhotoLarge.tif"]];
}

- (id)initWithCoder:(NSCoder *)decoder
{
	if ((self = [super initWithCoder:decoder]) != nil)
	{
		indicatorIndex = [decoder decodeIntForKey:@"BWTSIndicatorIndex"];
		[self setMinButton:[decoder decodeObjectForKey:@"BWTSMinButton"]];
		[self setMaxButton:[decoder decodeObjectForKey:@"BWTSMaxButton"]];
		
		minButtonRect = NSMakeRect(0, 0, imageInset, self.bounds.size.height);
		maxButtonRect = NSMakeRect(NSMaxX(self.bounds) - imageInset, 0, imageInset, self.bounds.size.height);		
	}
	return self;
}

- (void)encodeWithCoder:(NSCoder*)coder
{
    [super encodeWithCoder:coder];
	
	[coder encodeInt:[self indicatorIndex] forKey:@"BWTSIndicatorIndex"];
	[coder encodeObject:[self minButton] forKey:@"BWTSMinButton"];
	[coder encodeObject:[self maxButton] forKey:@"BWTSMaxButton"];
}

- (int)trackHeight
{
	return [[self cell] trackHeight];
}

- (void)setTrackHeight:(int)newTrackHeight
{
	[[self cell] setTrackHeight:newTrackHeight];
	[self setNeedsDisplay:YES];
}

- (void)setSliderToMinimum
{
	[self setDoubleValue:[self minValue]];
}

- (void)setSliderToMaximum
{
	[self setDoubleValue:[self maxValue]];
}

- (NSView *)hitTest:(NSPoint)aPoint
{
	NSPoint convertedPoint = [self convertPoint:aPoint fromView:nil];
	
	if (NSPointInRect(convertedPoint, minButtonRect))
		return minButton;
	else if (NSPointInRect(convertedPoint, maxButtonRect))
		return maxButton;
	else
		return [super hitTest:aPoint];
}

- (void)drawRect:(NSRect)aRect
{
	aRect = self.bounds;
	sliderCellRect = aRect;
	
	if ([self indicatorIndex] == 2)
	{
		[minButton setFrameOrigin:NSMakePoint(imageInset-19, 3)];
		[maxButton setFrameOrigin:NSMakePoint(NSMaxX(self.bounds)-imageInset+4, 3)];
		
		sliderCellRect.size.width -= imageInset * 2;
		sliderCellRect.origin.x += imageInset;
	}
	else if ([self indicatorIndex] == 3)
	{
		[minButton setFrameOrigin:NSMakePoint(imageInset-7, 4)];
		[maxButton setFrameOrigin:NSMakePoint(NSMaxX(self.bounds)-imageInset, 4)];
		
		sliderCellRect.size.width -= imageInset * 2;
		sliderCellRect.origin.x += imageInset;
	}
	
	[[self cell] drawWithFrame:sliderCellRect inView:self];
}

- (void)setIndicatorIndex:(int)anIndex
{
	[minButton removeFromSuperview];
	[maxButton removeFromSuperview];

	if (indicatorIndex == 0 && (anIndex == 2 || anIndex == 3))
	{
		NSRect newFrame = self.frame;
		newFrame.size.width += imageInset * 2;
		newFrame.origin.x -= imageInset;
		[self setFrame:newFrame];
	}
	
	if ((indicatorIndex == 2 || indicatorIndex == 3) && anIndex == 0)
	{
		NSRect newFrame = self.frame;
		newFrame.size.width -= imageInset * 2;
		newFrame.origin.x += imageInset;
		[self setFrame:newFrame];
	}
	
	if (anIndex == 2)
	{
		minButton = [[NSButton alloc] initWithFrame:NSMakeRect(0,0,smallPhotoImage.size.width,smallPhotoImage.size.height)];
		[minButton setBordered:NO];
		[minButton setImage:smallPhotoImage];	
		[minButton setTarget:self];
		[minButton setAction:@selector(setSliderToMinimum)];
		[[minButton cell] setHighlightsBy:2]; 
		
		maxButton = [[NSButton alloc] initWithFrame:NSMakeRect(NSMaxX(self.bounds) - imageInset,0,largePhotoImage.size.width,largePhotoImage.size.height)];
		[maxButton setBordered:NO];
		[maxButton setImage:largePhotoImage];
		[maxButton setTarget:self];
		[maxButton setAction:@selector(setSliderToMaximum)];
		[[maxButton cell] setHighlightsBy:2]; 
		
		[self addSubview:minButton];
		[self addSubview:maxButton];
	}
	else if (anIndex == 3)
	{
		minButton = [[NSButton alloc] initWithFrame:NSMakeRect(0,0,quietSpeakerImage.size.width,quietSpeakerImage.size.height)];
		[minButton setBordered:NO];
		[minButton setImage:quietSpeakerImage];	
		[minButton setTarget:self];
		[minButton setAction:@selector(setSliderToMinimum)];
		[[minButton cell] setHighlightsBy:2]; 
		
		maxButton = [[NSButton alloc] initWithFrame:NSMakeRect(NSMaxX(self.bounds) - imageInset,0,loudSpeakerImage.size.width,loudSpeakerImage.size.height)];
		[maxButton setBordered:NO];
		[maxButton setImage:loudSpeakerImage];
		[maxButton setTarget:self];
		[maxButton setAction:@selector(setSliderToMaximum)];
		[[maxButton cell] setHighlightsBy:2]; 
		
		[self addSubview:minButton];
		[self addSubview:maxButton];
	}
	
	indicatorIndex = anIndex;
}

- (void)dealloc
{
	[minButton release];
	[maxButton release];
	[super dealloc];
}

@end
