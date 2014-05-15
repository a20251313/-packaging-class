//
// Copyright (c) 2012 Jason Kozemczak
//
// Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated
// documentation files (the "Software"), to deal in the Software without restriction, including without limitation
// the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software,
// and to permit persons to whom the Software is furnished to do so, subject to the following conditions:
//
// The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.
//
// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO
// THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
// AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN
// ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR
// OTHER DEALINGS IN THE SOFTWARE.
//


#import <CoreGraphics/CoreGraphics.h>
#import <QuartzCore/QuartzCore.h>
#import "CKCalendarView.h"
//#import "BFSchedule.h"
//#import "BFPlanDaysModel.h"
#define BUTTON_MARGIN 2
#define CALENDAR_MARGIN 5
#define TOP_HEIGHT 30
#define DAYS_HEADER_HEIGHT 20
#define DEFAULT_CELL_WIDTH 43
#define CELL_BORDER_WIDTH 1

#define UIColorFromRGB(rgbValue) [UIColor colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 green:((float)((rgbValue & 0xFF00) >> 8))/255.0 blue:((float)(rgbValue & 0xFF))/255.0 alpha:1.0]


@class CALayer;
@class CAGradientLayer;

@interface GradientView : UIView

@property(nonatomic, strong, readonly) CAGradientLayer *gradientLayer;
- (void)setColors:(NSArray *)colors;


@end

@implementation GradientView

- (id)init {
    return [self initWithFrame:CGRectZero];
}

+ (Class)layerClass {
    return [CAGradientLayer class];
}

- (CAGradientLayer *)gradientLayer {
    return (CAGradientLayer *)self.layer;
}

- (void)setColors:(NSArray *)colors {
    NSMutableArray *cgColors = [NSMutableArray array];
    for (UIColor *color in colors) {
        [cgColors addObject:( id)color.CGColor];
    }
    self.gradientLayer.colors = cgColors;
}

@end


@interface DateButton : UIButton

@property (nonatomic, strong) NSDate *date;

@end

@implementation DateButton

@synthesize date = _date;

- (void)setDate:(NSDate *)aDate {
    _date = aDate;
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    dateFormatter.dateFormat = @"d";
    [self setTitle:[dateFormatter stringFromDate:_date] forState:UIControlStateNormal];
}

@end


@interface CKCalendarView ()

@property(nonatomic, strong) UIView *highlight;
@property(nonatomic, strong) UILabel *titleLabel;

@property(nonatomic, strong) UIButton *prevButton;
@property(nonatomic, strong) UIButton *nextButton;
@property(nonatomic, strong) UIButton *preYearButton;
@property(nonatomic, strong) UIButton *nextYearButton;

@property(nonatomic, strong) UIView *calendarContainer;
@property(nonatomic, strong) GradientView *daysHeader;
@property(nonatomic, strong) NSArray *dayOfWeekLabels;
@property(nonatomic, strong) NSMutableArray *dateButtons;

@property (nonatomic) startDay calendarStartDay;
@property (nonatomic, strong) NSDate *monthShowing;
@property (nonatomic, strong) NSCalendar *calendar;
@property(nonatomic, assign) CGFloat cellWidth;

@end

@implementation CKCalendarView

@synthesize highlight = _highlight;
@synthesize titleLabel = _titleLabel;
@synthesize prevButton = _prevButton;
@synthesize nextButton = _nextButton;
@synthesize preYearButton = _preYearButton;
@synthesize nextYearButton = _nextYearButton;
@synthesize calendarContainer = _calendarContainer;
@synthesize daysHeader = _daysHeader;
@synthesize dayOfWeekLabels = _dayOfWeekLabels;
@synthesize dateButtons = _dateButtons;

@synthesize monthShowing = _monthShowing;
@synthesize calendar = _calendar;

@synthesize selectedDate = _selectedDate;
@synthesize delegate = _delegate;

@synthesize selectedDateTextColor = _selectedDateTextColor;
@synthesize selectedDateBackgroundColor = _selectedDateBackgroundColor;
@synthesize currentDateTextColor = _currentDateTextColor;
@synthesize currentDateBackgroundColor = _currentDateBackgroundColor;
@synthesize cellWidth = _cellWidth;

@synthesize calendarStartDay;

@synthesize models=_models;


- (id)init {
    return [self initWithStartDay:startSunday];
}

- (id)initWithStartDay:(startDay)firstDay {
    self.calendarStartDay = firstDay;
    return [self initWithFrame:CGRectMake(0, 0, 320, 320)];
}

- (id)initWithStartDay:(startDay)firstDay frame:(CGRect)frame {
    self.calendarStartDay = firstDay;
    return [self initWithFrame:frame];
}

- (id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
        [self.calendar setLocale:[NSLocale currentLocale]]; 
        [self.calendar setFirstWeekday:self.calendarStartDay];
        self.cellWidth = DEFAULT_CELL_WIDTH;
        self.layer.cornerRadius = 6.0f;
//        self.layer.shadowOffset = CGSizeMake(0, 0);
//        self.layer.shadowRadius = 2.0f;
//        self.layer.shadowOpacity = 0.4f;
        //self.layer.borderColor = [UIColor blackColor].CGColor;
        self.layer.borderColor=[UIColor clearColor].CGColor;
        self.layer.borderWidth = 1.0f;

        UIView *highlight = [[UIView alloc] initWithFrame:CGRectZero];
        //highlight.backgroundColor = [UIColor colorWithWhite:1.0 alpha:0.2];
        highlight.backgroundColor=[UIColor clearColor];
        highlight.layer.cornerRadius = 6.0f;
        [self addSubview:highlight];
        self.highlight = highlight;

        // SET UP THE HEADER
        UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        titleLabel.textAlignment = NSTextAlignmentCenter;
        titleLabel.backgroundColor = [UIColor clearColor];
        titleLabel.autoresizingMask = UIViewAutoresizingFlexibleBottomMargin | UIViewAutoresizingFlexibleWidth;
        [self addSubview:titleLabel];
        self.titleLabel = titleLabel;

        UIButton *preYear = [UIButton buttonWithType:UIButtonTypeCustom];
        [preYear setImage:[UIImage imageNamed:@"leftArrow"] forState:UIControlStateNormal];
        preYear.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleWidth;
        [preYear addTarget:self action:@selector(moveCalendarToPreviousYear) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:preYear];
        self.preYearButton = preYear;
        
        UIButton *prevButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [prevButton setImage:[UIImage imageNamed:@"Yann-leftArrow"] forState:UIControlStateNormal];
        prevButton.autoresizingMask = UIViewAutoresizingFlexibleBottomMargin | UIViewAutoresizingFlexibleRightMargin;
        [prevButton addTarget:self action:@selector(moveCalendarToPreviousMonth) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:prevButton];
        self.prevButton = prevButton;

        UIButton *nextButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [nextButton setImage:[UIImage imageNamed:@"Yann-rightArrow"] forState:UIControlStateNormal];
        nextButton.autoresizingMask = UIViewAutoresizingFlexibleBottomMargin | UIViewAutoresizingFlexibleLeftMargin;
        [nextButton addTarget:self action:@selector(moveCalendarToNextMonth) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:nextButton];
        self.nextButton = nextButton;
        
        UIButton *nextYear = [UIButton buttonWithType:UIButtonTypeCustom];
        [nextYear setImage:[UIImage imageNamed:@"rightArrow"] forState:UIControlStateNormal];
        nextYear.autoresizingMask = UIViewAutoresizingFlexibleBottomMargin | UIViewAutoresizingFlexibleLeftMargin;
        [nextYear addTarget:self action:@selector(moveCalendarToNextYear) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:nextYear];
        self.nextYearButton = nextYear;

        // THE CALENDAR ITSELF
        UIView *calendarContainer = [[UIView alloc] initWithFrame:CGRectZero];
        //calendarContainer.layer.borderWidth = 1.0f;
        //calendarContainer.layer.borderColor = [UIColor blackColor].CGColor;
        calendarContainer.autoresizingMask = UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleWidth;
        //calendarContainer.layer.cornerRadius = 4.0f;
        calendarContainer.clipsToBounds = YES;
        [self addSubview:calendarContainer];
        self.calendarContainer = calendarContainer;

        GradientView *daysHeader = [[GradientView alloc] initWithFrame:CGRectZero];
        daysHeader.autoresizingMask = UIViewAutoresizingFlexibleBottomMargin | UIViewAutoresizingFlexibleWidth;
        [self.calendarContainer addSubview:daysHeader];
        self.daysHeader = daysHeader;

        NSMutableArray *labels = [NSMutableArray array];
        for (NSString *day in [self getDaysOfTheWeek]) {
            UILabel *dayOfWeekLabel = [[UILabel alloc] initWithFrame:CGRectZero];
            dayOfWeekLabel.text = [day uppercaseString];
            dayOfWeekLabel.textAlignment = NSTextAlignmentCenter;
            dayOfWeekLabel.backgroundColor = [UIColor clearColor];
            //dayOfWeekLabel.shadowColor = [UIColor whiteColor];
            //dayOfWeekLabel.shadowOffset = CGSizeMake(0, 1);
            [labels addObject:dayOfWeekLabel];
            [self.calendarContainer addSubview:dayOfWeekLabel];
        }
        self.dayOfWeekLabels = labels;

        // at most we'll need 42 buttons, so let's just bite the bullet and make them now...
        NSMutableArray *dateButtons = [NSMutableArray array];
        //dateButtons = [NSMutableArray array];
        NSUserDefaults *def = [NSUserDefaults standardUserDefaults];
        if ([[def valueForKey:@"style"] isEqualToString:@"day"]) {
            for (int i = 0; i < 43; i++) {
                DateButton *dateButton = [DateButton buttonWithType:UIButtonTypeCustom];
                [dateButton setTitle:[NSString stringWithFormat:@"%d", i] forState:UIControlStateNormal];
                [dateButton.titleLabel setFont:[UIFont systemFontOfSize:13]];
                [dateButton addTarget:self action:@selector(dateButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
                [dateButtons addObject:dateButton];
//                dateButton.contentVerticalAlignment=UIControlContentHorizontalAlignmentLeft;
//                dateButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentRight;
//                [dateButton.layer setBorderWidth:0.4];
//                CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
//                CGColorRef colorref = CGColorCreate(colorSpace, (CGFloat[]){230/255,230/255,230/255,0.3});
//                [dateButton.layer setBorderColor:colorref];
                //[dateButton.layer setBorderColor:[CKCalendarView getColorFromRed:12 Green:12 Blue:12 Alpha:0.5]];
            }

        }
        if ([[def valueForKey:@"style"] isEqualToString:@"month"]) {
            for (int i = 0; i < 43; i++) {
                DateButton *dateButton = [DateButton buttonWithType:UIButtonTypeCustom];
                if (i == 0 || i == 24 || i == 25) {
                    [dateButton.layer setBorderWidth:1];
                }else{
                    [dateButton.layer setBorderWidth:0.6f];
                }
                [dateButton setTitle:[NSString stringWithFormat:@"%d", i] forState:UIControlStateNormal];
                [dateButton addTarget:self action:@selector(dateButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
                [dateButtons addObject:dateButton];
                dateButton.contentVerticalAlignment=UIControlContentHorizontalAlignmentLeft;
                dateButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentRight;
                CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
                CGColorRef colorref = CGColorCreate(colorSpace, (CGFloat[]){230/255,230/255,230/255,0.3});
                [dateButton.layer setBorderColor:colorref];
                //[dateButton.layer setBorderColor:[CKCalendarView getColorFromRed:12 Green:12 Blue:12 Alpha:0.5]];
            }

        }
                self.dateButtons = dateButtons;

        // initialize the thing
        self.monthShowing = [NSDate date];
        [self setDefaultStyle];
        
//        NSDate *myDate = [self planDayFromeDate:[NSDate date]];
//        NSTimeInterval secondsPerDay1 = 24*60*60;
//        NSTimeInterval secondsPerDay2 = 24*60*60*2;
//        self.planDays=[NSMutableArray arrayWithObjects:myDate,[myDate dateByAddingTimeInterval:secondsPerDay1],[myDate dateByAddingTimeInterval:secondsPerDay2], nil];
    }

    [self layoutSubviews]; // TODO: this is a hack to get the first month to show properly
    return self;
}
- (void)initCurrentDay{
    self.selectedDate = nil;
    self.monthShowing = [NSDate date];
    [self planDayFromeDate:[NSDate date]];
}
+(CGColorRef)getColorFromRed:(int)red Green:(int)green Blue:(int)blue Alpha:(int)alpha
{
    CGFloat r = (CGFloat)red/255.0;
    CGFloat g = (CGFloat)green/255.0;
    CGFloat b = (CGFloat)blue/255.0;
    CGFloat a = (CGFloat)alpha/255.0;
    CGFloat components[4] = {r,g,b,a};
    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
    CGColorRef color = CGColorCreate(colorSpace, components);
    CGColorSpaceRelease(colorSpace);
    return color;
}

- (void)layoutSubviews {
    [super layoutSubviews];

    CGFloat containerWidth = self.bounds.size.width - (CALENDAR_MARGIN * 2);
    self.cellWidth = (containerWidth / 7.0) - CELL_BORDER_WIDTH;

    CGFloat containerHeight = ([self numberOfWeeksInMonthContainingDate:self.monthShowing] * (self.cellWidth + CELL_BORDER_WIDTH) + DAYS_HEADER_HEIGHT);


    CGRect newFrame = self.frame;
    newFrame.size.height = containerHeight + CALENDAR_MARGIN + TOP_HEIGHT;
    self.frame = newFrame;

    self.highlight.frame = CGRectMake(1, 1, self.bounds.size.width - 2, 1);

    self.titleLabel.frame = CGRectMake(0, 0, self.bounds.size.width, TOP_HEIGHT);
    self.preYearButton.frame = CGRectMake(BUTTON_MARGIN, BUTTON_MARGIN, 37, 30);
    self.prevButton.frame = CGRectMake(BUTTON_MARGIN+37, BUTTON_MARGIN, 37, 30);
    self.nextButton.frame = CGRectMake(self.bounds.size.width - 37*2 - BUTTON_MARGIN, BUTTON_MARGIN, 37, 30);
    self.nextYearButton.frame = CGRectMake(self.bounds.size.width - 37 - BUTTON_MARGIN, BUTTON_MARGIN, 37, 30);

    self.calendarContainer.frame = CGRectMake(CALENDAR_MARGIN, CGRectGetMaxY(self.titleLabel.frame), containerWidth, containerHeight);
    self.daysHeader.frame = CGRectMake(0, 0, self.calendarContainer.frame.size.width, DAYS_HEADER_HEIGHT);

    CGRect lastDayFrame = CGRectZero;
    for (UILabel *dayLabel in self.dayOfWeekLabels) {
        dayLabel.frame = CGRectMake(CGRectGetMaxX(lastDayFrame) + CELL_BORDER_WIDTH, lastDayFrame.origin.y, self.cellWidth, self.daysHeader.frame.size.height);
        lastDayFrame = dayLabel.frame;
    }

    for (DateButton *dateButton in self.dateButtons) {
        [dateButton removeFromSuperview];
    }

    NSDate *date = [self firstDayOfMonthContainingDate:self.monthShowing];
    uint dateButtonPosition = 0;
    while ([self dateIsInMonthShowing:date]) {
        DateButton *dateButton = [self.dateButtons objectAtIndex:dateButtonPosition];

        if ([dateButton viewWithTag:11]) {
            [[dateButton viewWithTag:11] removeFromSuperview];
        }
        dateButton.date = date;
        if ([dateButton.date isEqualToDate:self.selectedDate]) {
            dateButton.backgroundColor = self.selectedDateBackgroundColor;
            [dateButton setTitleColor:self.selectedDateTextColor forState:UIControlStateNormal];
        } else if ([self dateIsToday:dateButton.date]) {
            
            
            [dateButton setTitleColor:self.currentDateTextColor forState:UIControlStateNormal];
            dateButton.backgroundColor = self.currentDateBackgroundColor;
        } else {
            dateButton.backgroundColor = [self dateBackgroundColor];
            [dateButton setTitleColor:[self dateTextColor] forState:UIControlStateNormal];
        }
        dateButton.frame = [self calculateDayCellFrame:date];
//        for (BFPlanDaysModel *model in self.models) {
//            if ([dateButton.date isEqualToDate:model.myPlanDate]) {
//                UIImageView *tip=[[UIImageView alloc]initWithImage:[UIImage imageNamed:@"tip2"]];
//                [tip setTag:11];
//                [dateButton addSubview:tip];
//            }
//        }
        
        [self.calendarContainer addSubview:dateButton];

        date = [self nextDay:date];
        dateButtonPosition++;
    }
}

- (void)setMonthShowing:(NSDate *)aMonthShowing {
    _monthShowing = aMonthShowing;

    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    dateFormatter.dateFormat = @"YYYY MMMM";
    self.titleLabel.text = [dateFormatter stringFromDate:aMonthShowing];
    [self setNeedsLayout];
}

- (void)setDefaultStyle {
    //self.backgroundColor = UIColorFromRGB(0x393B40);
    self.backgroundColor=[UIColor clearColor];
    [self setTitleColor:UIColorFromRGB(0x941d21)];
    [self setTitleFont:[UIFont systemFontOfSize:17.0]];

    [self setDayOfWeekFont:[UIFont systemFontOfSize:10.0]];
    [self setDayOfWeekTextColor:UIColorFromRGB(0x686868)];
    //[self setDayOfWeekBottomColor:UIColorFromRGB(0xCCCFD5) topColor:[UIColor whiteColor]];
    [self setDayOfWeekBottomColor:[UIColor clearColor] topColor:[UIColor clearColor]];

    [self setDateFont:[UIFont systemFontOfSize:19.0f]];
    //[self setDateTextColor:UIColorFromRGB(0x393B40)];
    [self setDateBackgroundColor:UIColorFromRGB(0xF2F2F2)];
    [self setDateTextColor:UIColorFromRGB(0x686868)];
    [self setDateBackgroundColor:[UIColor clearColor]];
 //   [self setDateBorderColor:UIColorFromRGB(0x972a2f)];

    [self setSelectedDateTextColor:UIColorFromRGB(0x87CEFA)];
    [self setSelectedDateBackgroundColor:UIColorFromRGB(0xF2F2F2)];

    [self setCurrentDateTextColor:UIColorFromRGB(0x686868)];
    [self setCurrentDateBackgroundColor:UIColorFromRGB(0xF2F2F2)];
}

- (CGRect)calculateDayCellFrame:(NSDate *)date {
    NSInteger row = [self weekNumberInMonthForDate:date] - 1;
    int placeInWeek = (([self dayOfWeekForDate:date] - 1) - self.calendar.firstWeekday + 8) % 7;

    return CGRectMake(placeInWeek * (self.cellWidth + CELL_BORDER_WIDTH), (row * (self.cellWidth + CELL_BORDER_WIDTH)) + CGRectGetMaxY(self.daysHeader.frame) + CELL_BORDER_WIDTH, self.cellWidth, self.cellWidth);
}

- (void)moveCalendarToNextMonth {
    NSDateComponents* comps = [[NSDateComponents alloc]init];
    [comps setMonth:1];
    self.monthShowing = [self.calendar dateByAddingComponents:comps toDate:self.monthShowing options:0];
}
- (void)moveCalendarToNextYear {
    NSDateComponents* comps = [[NSDateComponents alloc]init];
    [comps setYear:1];
    self.monthShowing = [self.calendar dateByAddingComponents:comps toDate:self.monthShowing options:0];
}
- (void)moveCalendarToPreviousMonth {
    self.monthShowing = [[self firstDayOfMonthContainingDate:self.monthShowing] dateByAddingTimeInterval:-100000];
}
- (void)moveCalendarToPreviousYear {

    NSDateComponents *comps = [self.calendar components:(NSYearCalendarUnit | NSMonthCalendarUnit | NSDayCalendarUnit) fromDate:self.monthShowing];
    [comps setDay:1];
    NSInteger currentYear = comps.year;
    NSInteger preYear = currentYear - 1;
    [comps setYear:preYear];
    NSDate *date =  [self.calendar dateFromComponents:comps];
    self.monthShowing = [self firstDayOfMonthContainingDate:date];
}

- (void)dateButtonPressed:(id)sender {
    DateButton *dateButton = sender;
    self.selectedDate = dateButton.date;
    [self setNeedsLayout];
    
    if (_delegate) {
        [self setHidden:YES];
        [self.delegate calendar:self didSelectDate:self.selectedDate];
    }
}

#pragma mark - Theming getters/setters

- (void)setTitleFont:(UIFont *)font {
    self.titleLabel.font = font;
}
- (UIFont *)titleFont {
    return self.titleLabel.font;
}

- (void)setTitleColor:(UIColor *)color {
    self.titleLabel.textColor = color;
}
- (UIColor *)titleColor {
    return self.titleLabel.textColor;
}

- (void)setButtonColor:(UIColor *)color {
    [self.prevButton setImage:[CKCalendarView imageNamed:@"Yann-leftArrow" withColor:color] forState:UIControlStateNormal];
    [self.nextButton setImage:[CKCalendarView imageNamed:@"Yann-rightArrow" withColor:color] forState:UIControlStateNormal];
}

- (void)setInnerBorderColor:(UIColor *)color {
    self.calendarContainer.layer.borderColor = color.CGColor;
}

- (void)setDayOfWeekFont:(UIFont *)font {
    for (UILabel *label in self.dayOfWeekLabels) {
        label.font = font;
    }
}
- (UIFont *)dayOfWeekFont {
    return (self.dayOfWeekLabels.count > 0) ? ((UILabel *)[self.dayOfWeekLabels lastObject]).font : nil;
}

- (void)setDayOfWeekTextColor:(UIColor *)color {
    for (UILabel *label in self.dayOfWeekLabels) {
        label.textColor = color;
    }
}
- (UIColor *)dayOfWeekTextColor {
    return (self.dayOfWeekLabels.count > 0) ? ((UILabel *)[self.dayOfWeekLabels lastObject]).textColor : nil;
}

- (void)setDayOfWeekBottomColor:(UIColor *)bottomColor topColor:(UIColor *)topColor {
    [self.daysHeader setColors:[NSArray arrayWithObjects:topColor, bottomColor, nil]];
}

- (void)setDateFont:(UIFont *)font {
    for (DateButton *dateButton in self.dateButtons) {
        dateButton.titleLabel.font = font;
    }
}
- (UIFont *)dateFont {
    return (self.dateButtons.count > 0) ? ((DateButton *)[self.dateButtons lastObject]).titleLabel.font : nil;
}

- (void)setDateTextColor:(UIColor *)color {
    for (DateButton *dateButton in self.dateButtons) {
        [dateButton setTitleColor:color forState:UIControlStateNormal];
    }
}
- (UIColor *)dateTextColor {
    return (self.dateButtons.count > 0) ? [((DateButton *)[self.dateButtons lastObject]) titleColorForState:UIControlStateNormal] : nil;
}

- (void)setDateBackgroundColor:(UIColor *)color {
    for (DateButton *dateButton in self.dateButtons) {
        dateButton.backgroundColor = color;
    }
}
- (UIColor *)dateBackgroundColor {
    return (self.dateButtons.count > 0) ? ((DateButton *)[self.dateButtons lastObject]).backgroundColor : nil;
}

- (void)setDateBorderColor:(UIColor *)color {
    self.calendarContainer.backgroundColor = color;
}
- (UIColor *)dateBorderColor {
    return self.calendarContainer.backgroundColor;
}

#pragma mark - Calendar helpers
-(NSDate*)planDayFromeDate:(NSDate*)date
{
    NSDateComponents *comps = [self.calendar components:(NSYearCalendarUnit | NSMonthCalendarUnit | NSDayCalendarUnit) fromDate:date];
    return [self.calendar dateFromComponents:comps];
}
- (NSDate *)firstDayOfMonthContainingDate:(NSDate *)date {
    NSDateComponents *comps = [self.calendar components:(NSYearCalendarUnit | NSMonthCalendarUnit | NSDayCalendarUnit) fromDate:date];
    [comps setDay:1];
    return [self.calendar dateFromComponents:comps];
}

- (NSArray *)getDaysOfTheWeek {
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    
    // adjust array depending on which weekday should be first
    NSArray *weekdays = [dateFormatter shortWeekdaySymbols];
    NSUInteger firstWeekdayIndex = [self.calendar firstWeekday] -1;
    if (firstWeekdayIndex > 0)
    {
        weekdays = [[weekdays subarrayWithRange:NSMakeRange(firstWeekdayIndex, 7-firstWeekdayIndex)]
                    arrayByAddingObjectsFromArray:[weekdays subarrayWithRange:NSMakeRange(0,firstWeekdayIndex)]];
    }
    return weekdays;
}

- (NSInteger)dayOfWeekForDate:(NSDate *)date {
    NSDateComponents *comps = [self.calendar components:NSWeekdayCalendarUnit fromDate:date];
    return comps.weekday;
}

- (BOOL)dateIsToday:(NSDate *)date {
    NSDateComponents *otherDay = [self.calendar components:NSEraCalendarUnit|NSYearCalendarUnit|NSMonthCalendarUnit|NSDayCalendarUnit fromDate:date];
    NSDateComponents *today = [self.calendar components:NSEraCalendarUnit|NSYearCalendarUnit|NSMonthCalendarUnit|NSDayCalendarUnit fromDate:[NSDate date]];
    return ([today day] == [otherDay day] &&
            [today month] == [otherDay month] &&
            [today year] == [otherDay year] &&
            [today era] == [otherDay era]);
}

- (NSInteger)weekNumberInMonthForDate:(NSDate *)date {
    NSDateComponents *comps = [self.calendar components:(NSWeekOfMonthCalendarUnit) fromDate:date];
    return comps.weekOfMonth;
}

- (NSInteger)numberOfWeeksInMonthContainingDate:(NSDate *)date {
    return [self.calendar rangeOfUnit:NSWeekCalendarUnit inUnit:NSMonthCalendarUnit forDate:date].length;
}

- (BOOL)dateIsInMonthShowing:(NSDate *)date {
    NSDateComponents *comps1 = [self.calendar components:(NSMonthCalendarUnit) fromDate:self.monthShowing];
    NSDateComponents *comps2 = [self.calendar components:(NSMonthCalendarUnit) fromDate:date];
    return comps1.month == comps2.month;
}

- (NSDate *)nextDay:(NSDate *)date {
    NSDateComponents *comps = [[NSDateComponents alloc] init];
    [comps setDay:1];
    return [self.calendar dateByAddingComponents:comps toDate:date options:0];
}

+ (UIImage *)imageNamed:(NSString *)name withColor:(UIColor *)color {
    UIImage *img = [UIImage imageNamed:name];

    UIGraphicsBeginImageContext(img.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    [color setFill];

    CGContextTranslateCTM(context, 0, img.size.height);
    CGContextScaleCTM(context, 1.0, -1.0);

    CGContextSetBlendMode(context, kCGBlendModeColorBurn);
    CGRect rect = CGRectMake(0, 0, img.size.width, img.size.height);
    CGContextDrawImage(context, rect, img.CGImage);

    CGContextClipToMask(context, rect, img.CGImage);
    CGContextAddRect(context, rect);
    CGContextDrawPath(context,kCGPathFill);

    UIImage *coloredImg = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();

    return coloredImg;
}

@end