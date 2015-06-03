//
//  JHTickerView.m
//  Ticker
//
//  Created by Jeff Hodnett on 03/05/2011.
//  Copyright 2011 Applausible. All rights reserved.
//

#import "JHTickerView.h"
#import <QuartzCore/QuartzCore.h>

@interface JHTickerView(Private)
-(void)setupView;
-(void)animateCurrentTickerString;
-(void)pauseLayer:(CALayer *)layer;
-(void)resumeLayer:(CALayer *)layer;
@end

@implementation JHTickerView

@synthesize tickerStrings;
@synthesize tickerSpeed;
@synthesize loops;
@synthesize direction;
@synthesize isStart;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self)
    {
     //    DLOG(@"jhTickerview alloc");
        // Initialization code
		[self setupView];
        self.tickerSpeed = 40;
        self.tickerStrings = [[[NSMutableArray alloc] init] autorelease];
        
    }
    return self;
}

-(id)initWithCoder:(NSCoder *)aDecoder {
	if( (self = [super initWithCoder:aDecoder]) )
    {
      //   DLOG(@"jhTickerview alloc");
		// Initialization code
        self.tickerSpeed = 40;
		[self setupView];
        self.tickerStrings = [[[NSMutableArray alloc] init] autorelease];
	}
	return self;
}

/*
 // Only override drawRect: if you perform custom drawing.
 // An empty implementation adversely affects performance during animation.
 - (void)drawRect:(CGRect)rect
 {
 // Drawing code
 }
 */

- (void)dealloc
{
   DLOG(@"jhTickerview dealloc");
	[tickerLabel release];
    tickerLabel = nil;
	
    self.tickerStrings = nil;
	
    [super dealloc];
}

-(void)setupView {
	// Set background color to white
	[self setBackgroundColor:[UIColor whiteColor]];
	
	// Set a corner radius
	[self.layer setCornerRadius:5.0f];
	//[self.layer setBorderWidth:2.0f];
	//[self.layer setBorderColor:[UIColor blackColor].CGColor];
	[self setClipsToBounds:YES];
    [self setBackgroundColor:[UIColor clearColor]];
	
	// Set the font
    //	tickerFont = [UIFont fontWithName:@"Marker Felt" size:22.0];
    tickerFont = [UIFont systemFontOfSize:16.0];
	
	// Add the label (i'm gonna center it on the view - please feel free to do your own thing)
	tickerLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, self.frame.size.height / 4-5, self.frame.size.width, self.frame.size.height)];
	[tickerLabel setBackgroundColor:[UIColor clearColor]];
	[tickerLabel setNumberOfLines:1];
	[tickerLabel setFont:tickerFont];
    [tickerLabel setTextColor:[UIColor whiteColor]];
    [tickerLabel setBackgroundColor:[UIColor clearColor]];
	[self addSubview:tickerLabel];
	
	// Set that it loops by default
	loops = YES;
    
    isStop = NO;
    isPause = NO;
    
    // Set the default direction
    direction = JHTickerDirectionLTR;
}

-(CABasicAnimation *)aniWithPosition:(CFTimeInterval)timer fromValue:(CGPoint)fromValue tovalue:(CGPoint)tovalue
{
    CABasicAnimation *animation=[CABasicAnimation animationWithKeyPath:@"position"];
    animation.removedOnCompletion = NO;
    animation.fillMode = kCAFillModeForwards;
    animation.fromValue = [NSValue valueWithCGPoint:fromValue];
    animation.toValue = [NSValue valueWithCGPoint:tovalue];
    animation.timingFunction= [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionLinear];
    animation.autoreverses = NO;
    
    animation.duration = timer;
    animation.repeatCount = 1;
    
    return animation;
}


-(void)animateCurrentTickerString
{
    if (isStop  || isPause)
    {
        
      //  DLOG(@"ani stop because:isStop:%d isPause:%d",isStop,isPause);
        return;
    }
    
    
    DLOG(@"ani become active :isStop:%d isPause:%d",isStop,isPause);
    
    if (currentIndex >= [tickerStrings count])
    {
        currentIndex = 0;
    }
	NSString *currentString = [tickerStrings objectAtIndex:currentIndex];
	
	// Calculate the size of the text and update the frame size of the ticker label
	CGSize textSize = [currentString sizeWithFont:tickerFont constrainedToSize:CGSizeMake(9999, self.frame.size.height) lineBreakMode:NSLineBreakByWordWrapping];
    
    // Setup some starting and end points
	float startingX = 0.0f;
    float endX = 0.0f;
    switch (direction) {
        case JHTickerDirectionRTL:
            startingX = -textSize.width;
            endX = self.frame.size.width;
            break;
        case JHTickerDirectionLTR:
        default:
            startingX = self.frame.size.width;
            endX = -textSize.width;
            break;
    }
    
	
    if (tickerLabel)
    {
        // Set starting position
        [tickerLabel setFrame:CGRectMake(startingX, tickerLabel.frame.origin.y, textSize.width, textSize.height)];
        
        // Set the string
        [tickerLabel setText:currentString];
        // Calculate a uniform duration for the item
        float duration = (textSize.width + self.frame.size.width) / tickerSpeed;
        
        duration /= 1.9f;
        
       // DLOG(@"animateCurrentTickerString duration:%f (textSize.width + self.frame.size.width):%f tickerSpeed:%f",duration,(textSize.width + self.frame.size.width),tickerSpeed);
        
        CGRect tickerFrame = tickerLabel.frame;
        tickerFrame.origin.x = endX;
       // [tickerLabel setFrame:tickerFrame];
        
        
        
        CABasicAnimation  *ani = [self aniWithPosition:duration fromValue:tickerLabel.center tovalue:CGPointMake(tickerFrame.origin.x+tickerFrame.size.width/2, tickerFrame.origin.y+tickerFrame.size.height/2)];//[CABasicAnimation animationWithKeyPath:@"position"];
        ani.delegate = self;
        [tickerLabel.layer addAnimation:ani forKey:@"tickerLabel"];
        
        
       /* ani.fillMode = kCAFillModeForwards;
        ani.repeatCount  = 1;
        ani.delegate = self;
        ani.duration = duration;
        ani.removedOnCompletion = NO;
        ani.fromValue = [NSValue valueWithCGPoint:tickerLabel.center];
        ani.toValue = [NSValue valueWithCGPoint:CGPointMake(tickerFrame.origin.x+tickerFrame.size.width/2, tickerFrame.origin.y+tickerFrame.size.height/2)];
        [tickerLabel.layer addAnimation:ani forKey:nil];*/
        
        
        // Create a UIView animation
     /*   [UIView beginAnimations:@"" context:nil];
        [UIView setAnimationCurve:UIViewAnimationCurveLinear];
        [UIView setAnimationDuration:duration];
        [UIView setAnimationDelegate:self];
        [UIView setAnimationDidStopSelector:@selector(tickerMoveAnimationDidStop:finished:context:)];
        
        // Update end position
        CGRect tickerFrame = tickerLabel.frame;
        tickerFrame.origin.x = endX;
        [tickerLabel setFrame:tickerFrame];
        
        [UIView commitAnimations];*/
        
    }
    
    
}


- (void)animationDidStop:(CAAnimation *)anim finished:(BOOL)flag
{
    if (!flag)
    {
        return;
    }
   // CAAnimation  *ani = [tickerLabel.layer animationForKey:@"tickerLabel"];
    //DLOG(@"CABasicAnimation:%@  ",ani);
    if (isStop  || isPause)
    {
        isStart = NO;
        //[tickerLabel.layer removeAllAnimations];
        DLOG(@"tickerMoveAnimationDidStop ani stop because:isStop:%d isPause:%d",isStop,isPause);
        return;
    }
    
    

    DLOG(@"animationDidStop:%@ flag:%d",anim,flag);
	// Update the index
	currentIndex++;
	
	// Check the index count
	if(currentIndex >= [tickerStrings count])
    {
		currentIndex = 0;
        
		// Check if we should loop
		if(!loops)
        {
			// Set not running
			running = NO;
            isStart = NO;
            
			return;
		}
	}
	
	// Animate
    [self animateCurrentTickerString];
	//[self performSelectorOnMainThread:@selector(animateCurrentTickerString) withObject:nil waitUntilDone:YES];
    
}



#pragma mark - Ticker Animation Handling
-(void)start
{
    [self stop];
    
	isPause = NO;
    isStop = NO;
    
	// Set the index to 0 on starting
	currentIndex = 0;
	
	// Set running
	running = YES;
	
    
    isStart = YES;
	// Start the animation

    //[self performSelectorOnMainThread:@selector(animateCurrentTickerString) withObject:nil waitUntilDone:YES];
	[self animateCurrentTickerString];
}

-(void)stop
{
    currentIndex = 0;
    
    running = NO;
    isStop = YES;
    isStart = NO;
    
    //CAAnimation  *ani = [tickerLabel.layer animationForKey:@"tickerLabel"];
    //[ani setDelegate:nil];
    [tickerLabel.layer removeAllAnimations];
   // [self pauseLayer:self.layer];
    
}

-(void)pause
{
	
    running = NO;
    isPause = YES;
    isStart = NO;
    [tickerLabel.layer removeAllAnimations];
    // [self pauseLayer:self.layer];
	/*// Check if running
	if(running) {
		// Pause the layer
		[self pauseLayer:self.layer];
		
		running = NO;
        isPause = YES;
	}*/
}


-(void)removeFromSuperview
{
    self.loops = NO;
    isStart = NO;
    [tickerLabel.layer removeAllAnimations];
    [super removeFromSuperview];
}
-(void)resume
{
    isPause = NO;
    running = YES;
    isStart = YES;
    [self animateCurrentTickerString];
}

#pragma mark - UIView layer animations utilities
-(void)pauseLayer:(CALayer *)layer
{
    CFTimeInterval pausedTime = [layer convertTime:CACurrentMediaTime() fromLayer:nil];
    layer.speed = 0.0;
    layer.timeOffset = pausedTime;
}

-(void)resumeLayer:(CALayer *)layer
{
    CFTimeInterval pausedTime = [layer timeOffset];
    layer.speed = 1.0;
    layer.timeOffset = 0.0;
    layer.beginTime = 0.0;
    CFTimeInterval timeSincePause = [layer convertTime:CACurrentMediaTime() fromLayer:nil] - pausedTime;
    layer.beginTime = timeSincePause;
}

@end
