
#import "CalendarView.h"


@interface CalendarView()
{
    NSCalendar *gregorian;
    NSInteger _selectedMonth;
    NSInteger _selectedYear;
    
    UIView   *m_bgView;
}

@property(nonatomic,strong)NSDate   *clickDate;
@end
@implementation CalendarView
@synthesize clickDate;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:[UIScreen mainScreen].bounds];
    if (self) {
    
        self.calendarDate = [NSDate date];
        
        UITapGestureRecognizer  *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(clickSelf:)];
        [self addGestureRecognizer:tap];
    }
    return self;
}

-(void)clickSelf:(UITapGestureRecognizer*)gets
{
    CGPoint point = [gets locationInView:self];
    if (!CGRectContainsPoint(m_bgView.frame, point))
    {
        [self removeFromSuperview];
    }
}

-(void)show
{
    [self setBackgroundColor:COLOR_RGBA(150, 150, 150, 0.9)];
    UIWindow    *window = [UIApplication sharedApplication].keyWindow;
    [window addSubview:self];
}

- (void)drawRect:(CGRect)rect
{

    
    CGFloat fwidth = [UIScreen mainScreen].bounds.size.width;
    CGFloat fheight = [UIScreen mainScreen].bounds.size.height;
    if (!m_bgView)
    {
        m_bgView = [[UIView alloc] initWithFrame:CGRectMake(10, (fheight-400)/2, fwidth-20, fheight)];
        [self addSubview:m_bgView];
        [m_bgView setBackgroundColor:[UIColor whiteColor]];
        m_bgView.layer.masksToBounds = YES;
        m_bgView.layer.cornerRadius = 8;
    }
    [self setCalendarParameters];
    _weekNames = @[@"Mo",@"Tu",@"We",@"Th",@"Fr",@"Sa",@"Su"];
    NSDateComponents *components = [gregorian components:(NSEraCalendarUnit | NSYearCalendarUnit | NSMonthCalendarUnit | NSDayCalendarUnit) fromDate:self.calendarDate];
    components.day = 1;
    NSDate *firstDayOfMonth = [gregorian dateFromComponents:components];
    NSDateComponents *comps = [gregorian components:NSWeekdayCalendarUnit fromDate:firstDayOfMonth];
    int weekday = [comps weekday];
    weekday  = weekday - 2;
    
    if(weekday < 0)
        weekday += 7;
    
    NSCalendar *c = [NSCalendar currentCalendar];
    NSRange days = [c rangeOfUnit:NSDayCalendarUnit
                           inUnit:NSMonthCalendarUnit
                          forDate:self.calendarDate];
    
    NSInteger columns = 7;
    NSInteger width = 40;
    NSInteger originX = 10;
    NSInteger originY = 40;
    NSInteger monthLength = days.length;
    
    UILabel *titleText = [[UILabel alloc]initWithFrame:CGRectMake(originX,0,m_bgView.frame.size.width, 40)];
    titleText.textAlignment = NSTextAlignmentCenter;
    [titleText setBackgroundColor:[UIColor clearColor]];
    NSDateFormatter *format = [[NSDateFormatter alloc] init];
    [format setDateFormat:@"MMMM yyyy"];
    NSString *dateString = [[format stringFromDate:self.calendarDate] uppercaseString];
    [titleText setText:dateString];
    [titleText setFont:[UIFont boldSystemFontOfSize:15]];
    [titleText setTextColor:COLOR_RGB(0, 83, 133)];
    titleText.userInteractionEnabled = YES;
    [m_bgView addSubview:titleText];
    
    UIView  *lineView = [[UIView alloc] initWithFrame:CGRectMake(0, 39, m_bgView.frame.size.width, 1)];
    [lineView setBackgroundColor:COLOR_RGB(191, 211, 224)];
    [m_bgView addSubview:lineView];
    
    UIButton    *btnPre = [[UIButton alloc] initWithFrame:CGRectMake(50, 0, 40, 40)];
    [btnPre setImage:[UIImage imageNamed:@"btn_previous_month"] forState:UIControlStateNormal];
    [btnPre setImage:[UIImage imageNamed:@"btn_previous_month_highlight"] forState:UIControlStateHighlighted];
    [btnPre setImageEdgeInsets:UIEdgeInsetsMake(9, 9, 9, 9)];
    [btnPre addTarget:self action:@selector(swiperight:) forControlEvents:UIControlEventTouchUpInside];
    [titleText addSubview:btnPre];
    
    UIButton    *btnNext = [[UIButton alloc] initWithFrame:CGRectMake(titleText.frame.size.width-90, 0, 40, 40)];
    [btnNext setImage:[UIImage imageNamed:@"btn_next_month"] forState:UIControlStateNormal];
    [btnNext setImage:[UIImage imageNamed:@"btn_next_month_highlight"] forState:UIControlStateHighlighted];
    [btnNext setImageEdgeInsets:UIEdgeInsetsMake(9, 9, 9, 9)];
    [btnNext addTarget:self action:@selector(swipeleft:) forControlEvents:UIControlEventTouchUpInside];
    [titleText addSubview:btnNext];
    
    
    for (int i =0; i<_weekNames.count; i++) {
        UIButton *weekNameLabel = [UIButton buttonWithType:UIButtonTypeCustom];
        weekNameLabel.titleLabel.text = [_weekNames objectAtIndex:i];
        [weekNameLabel setTitle:[_weekNames objectAtIndex:i] forState:UIControlStateNormal];
        [weekNameLabel setFrame:CGRectMake(originX+(width*(i%columns)), originY, width, width)];
        [weekNameLabel setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [weekNameLabel.titleLabel setFont:[UIFont boldSystemFontOfSize:15]];
        weekNameLabel.userInteractionEnabled = NO;
        [m_bgView addSubview:weekNameLabel];
    }
    
    CGFloat flastHeight = 0;
    for (NSInteger i= 0; i<monthLength; i++)
    {
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        button.tag = i+1;
        button.titleLabel.text = [NSString stringWithFormat:@"%d",i+1];
        [button setTitle:[NSString stringWithFormat:@"%d",i+1] forState:UIControlStateNormal];
        [button setTitleColor:COLOR_RGB(186, 201, 213) forState:UIControlStateNormal];
        [button.titleLabel setFont:[UIFont fontWithName:@"HelveticaNeue" size:15.0f]];
        [button addTarget:self action:@selector(tappedDate:) forControlEvents:UIControlEventTouchUpInside];
        NSInteger offsetX = (width*((i+weekday)%columns));
        NSInteger offsetY = (width *((i+weekday)/columns));
        
        [button.titleLabel setBackgroundColor:[UIColor clearColor]];
        [button setFrame:CGRectMake(originX+offsetX+2, originY+40+offsetY+2, width-4, width-4)];
        if ((button.frame.origin.x-2-originX)/width != 4)
        {
            //只有周五可以点击
            button.enabled = NO;
            [button setBackgroundColor:COLOR_RGB(241, 248, 253)];
        }else
        {/*
            UIView  *lightGrayView = [[UIView alloc] initWithFrame:button.bounds];
            [lightGrayView setBackgroundColor:[UIColor colorWithRed:0.9 green:0.7 blue:0.7 alpha:0.8]];
            [button addSubview:lightGrayView];
            lightGrayView.userInteractionEnabled = NO;*/
            [button setBackgroundColor:COLOR_RGB(232, 240, 249)];
            [button setTitleColor:COLOR_RGB(0, 83, 133) forState:UIControlStateNormal];
            [button.titleLabel setFont:[UIFont boldSystemFontOfSize:15]];
        
        }
        [button.layer setBorderColor:[COLOR_RGB(236, 240, 241) CGColor]];
        [button.layer setBorderWidth:1];
        button.layer.masksToBounds = YES;
        button.layer.cornerRadius = 2;
        [m_bgView addSubview:button];
        flastHeight = button.frame.origin.y-2+width;
    }

    UIView  *lineView2 = [[UIView alloc] initWithFrame:CGRectMake(0, flastHeight+5, m_bgView.frame.size.width, 1)];
    [lineView2 setBackgroundColor:COLOR_RGB(191, 211, 224)];
    [m_bgView addSubview:lineView2];
    
    flastHeight += 5;
    
    UIButton    *btnEnsure = [[UIButton alloc] initWithFrame:CGRectMake(0, flastHeight+1, m_bgView.frame.size.width, 40)];
    [btnEnsure setTitleColor:COLOR_RGB(0, 83, 133) forState:UIControlStateNormal];
    [btnEnsure addTarget:self action:@selector(clickEnsure:) forControlEvents:UIControlEventTouchUpInside];
    [btnEnsure setTitle:@"确   定" forState:UIControlStateNormal];
    [m_bgView addSubview:btnEnsure];
    
    flastHeight += 40+1;
    
    [m_bgView setFrame:CGRectMake(10,(fheight-flastHeight)/2, m_bgView.frame.size.width, flastHeight)];
    
    _selectedDate = -1;
}

-(void)clickEnsure:(id)sender
{
    NSLog(@"clickEnsure:%@",sender);
    if (self.delegate && [self.delegate respondsToSelector:@selector(clickEnsureWithDate:)])
    {
        [self.delegate clickEnsureWithDate:self.clickDate];
    }
    
    [self removeFromSuperview];
    
}
-(IBAction)tappedDate:(UIButton *)sender
{
    gregorian = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
    NSDateComponents *components = [gregorian components:(NSEraCalendarUnit | NSYearCalendarUnit | NSMonthCalendarUnit | NSDayCalendarUnit) fromDate:self.calendarDate];
    if(!(_selectedDate == sender.tag && _selectedMonth == [components month] && _selectedYear == [components year]))
    {
        if(_selectedDate != -1)
        {
            UIButton *previousSelected =(UIButton *) [m_bgView viewWithTag:_selectedDate];
            [previousSelected setBackgroundColor:COLOR_RGB(232, 240, 249)];
            [previousSelected setTitleColor:COLOR_RGB(0, 83, 133) forState:UIControlStateNormal];
        }
        
        [sender setBackgroundColor:COLOR_RGB(0, 83, 133)];
        [sender setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [sender.titleLabel setFont:[UIFont boldSystemFontOfSize:15]];
        _selectedDate = sender.tag;
        NSDateComponents *components = [gregorian components:(NSEraCalendarUnit | NSYearCalendarUnit | NSMonthCalendarUnit | NSDayCalendarUnit) fromDate:self.calendarDate];
        components.day = _selectedDate;
        _selectedMonth = components.month;
        _selectedYear = components.year;
        NSDate *clickedDate = [gregorian dateFromComponents:components];
        [self.delegate tappedOnDate:clickedDate];
        
        self.clickDate = clickedDate;
    }
}

-(void)swipeleft:(UISwipeGestureRecognizer*)gestureRecognizer
{
    
    [m_bgView.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
    NSDateComponents *components = [gregorian components:(NSEraCalendarUnit | NSYearCalendarUnit | NSMonthCalendarUnit | NSDayCalendarUnit) fromDate:self.calendarDate];
    components.day = 1;
    components.month += 1;
    self.calendarDate = [gregorian dateFromComponents:components];
    [UIView transitionWithView:self
                      duration:0.5f
                       options:UIViewAnimationOptionTransitionCrossDissolve
                    animations:^ { [self setNeedsDisplay]; }
                    completion:nil];
    
    
}

-(void)swiperight:(UISwipeGestureRecognizer*)gestureRecognizer
{
    
    [m_bgView.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
    NSDateComponents *components = [gregorian components:(NSEraCalendarUnit | NSYearCalendarUnit | NSMonthCalendarUnit | NSDayCalendarUnit) fromDate:self.calendarDate];
    components.day = 1;
    components.month -= 1;
    self.calendarDate = [gregorian dateFromComponents:components];
    [UIView transitionWithView:self
                      duration:0.5f
                       options:UIViewAnimationOptionTransitionCrossDissolve
                    animations:^ { [self setNeedsDisplay]; }
                    completion:nil];
}
-(void)setCalendarParameters
{
    if(gregorian == nil)
    {
        gregorian = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
        NSDateComponents *components = [gregorian components:(NSEraCalendarUnit | NSYearCalendarUnit | NSMonthCalendarUnit | NSDayCalendarUnit) fromDate:self.calendarDate];
        _selectedDate  = -1;//components.day;    //
        _selectedMonth = components.month;
        _selectedYear = components.year;
    }
}
@end

