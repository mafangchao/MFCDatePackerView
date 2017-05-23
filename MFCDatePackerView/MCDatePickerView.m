//
//  MCDatePickerView.m
//  MFCDatePackerView
//
//  Created by machao on 2017/5/23.
//  Copyright © 2017年 machao. All rights reserved.
//

static float ToolbarH  = 44;
static float PickerViewH  = 200;
#define SCREEN_W [UIScreen mainScreen].bounds.size.width
#define SCREEN_H [UIScreen mainScreen].bounds.size.height

#import "MCDatePickerView.h"

@interface MCDatePickerView() <UIPickerViewDataSource,UIPickerViewDelegate>

@property (nonatomic ,strong) UIPickerView *datePickerView;
@property (nonatomic ,strong) UIToolbar *toolBar;

@property (nonatomic ,strong) NSMutableArray *month;
@property (nonatomic ,strong) NSMutableArray *year;

@property (nonatomic ,assign) NSInteger selectYearRow;
@property (nonatomic ,assign) NSInteger selectMonthRow;

@property (nonatomic, assign) CGFloat toolViewY;//self的Y值
@property (nonatomic, assign ) XMGStyleType type;
@end

@implementation MCDatePickerView

- (instancetype)initWithFrame:(CGRect)frame type:(XMGStyleType)type{
    self.type = type;
    return  [self initWithFrame:frame];
}
- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    
    if (self)
    {
        [self setupView];
    }
    return self;
}

#pragma mark - Delegate
 
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    if (self.type == XMGStyleTypeYear) {
        return 1;
    }
    return 2;
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row
       inComponent:(NSInteger)component
{
    if (component == 0)
    {
        self.selectYearRow  = row;
    }
    else
    {
        self.selectMonthRow = row;
    }
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    return component == 0 ? self.year.count : self.month.count;
}

- (nullable NSString *)pickerView:(UIPickerView *)pickerView
                      titleForRow:(NSInteger)row
                     forComponent:(NSInteger)component
{
    if (component == 0)
    {
        return [NSString stringWithFormat:@"%@年",self.year[row]];
    }
    else
    {
        return [NSString stringWithFormat:@"%@月",self.month[row]];
    }
}

/**
    界面设置
 */
- (void)setupView
{
    [self addSubview:self.toolBar];
    
    UIPickerView *datePickerView = [[UIPickerView alloc] init];
    datePickerView = [[UIPickerView alloc] initWithFrame:CGRectMake(0, ToolbarH, SCREEN_W, PickerViewH)];
    datePickerView.backgroundColor = [UIColor whiteColor];
    datePickerView.delegate   = self;
    datePickerView.dataSource = self;
    self.datePickerView = datePickerView;
    [self addSubview:datePickerView];
    
    self.toolViewY = SCREEN_H - (ToolbarH + PickerViewH);
    self.frame     = CGRectMake(0, SCREEN_H, SCREEN_W, (ToolbarH + PickerViewH));
    
    [self setCurrentDate];
}

/**
    设置默认时间->当前年月
 */
- (void)setCurrentDate
{
    NSDate *date = [NSDate date];
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"yyyy-MM"];
    NSString *currentDate = [formatter stringFromDate:date];
    int year  = [[currentDate componentsSeparatedByString:@"-"][0] intValue];
    int month = [[currentDate componentsSeparatedByString:@"-"][1] intValue];
    
    NSInteger currentRow = year - [self.year[0] integerValue];
    
    [self.datePickerView selectRow:currentRow inComponent:0 animated:NO];
    if (self.type == XMGStyleTypeYearAndMonth) {
        [self.datePickerView selectRow:month-1 inComponent:1 animated:NO];
    }
    self.selectYearRow = currentRow;
    self.selectMonthRow = month-1;
}

/**
    工具栏
 */
- (UIToolbar *)toolBar
{
    if (!_toolBar)
    {

        _toolBar = [[UIToolbar alloc] init];
        _toolBar.frame = CGRectMake(0, 0, SCREEN_W, ToolbarH);
        UIBarButtonItem *cancelItem = [[UIBarButtonItem alloc] initWithTitle:@"   取消" style:UIBarButtonItemStylePlain target:self action:@selector(remove)];
        UIBarButtonItem *flexSpace = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil];
        UIBarButtonItem *doneItem = [[UIBarButtonItem alloc] initWithTitle:@"确认   " style:UIBarButtonItemStylePlain target:self action:@selector(doneClick)];

        _toolBar.items = @[cancelItem, flexSpace, doneItem];
    }
    return _toolBar;
}

/**
    确定
 */
- (void)doneClick
{
    NSString *year  = self.year[self.selectYearRow];
    NSString *month = self.month[self.selectMonthRow];
    
    if (month.length == 1)
    {
        month = [NSString stringWithFormat:@"0%@",month];
    }
    
    NSString *resultDate = [NSString stringWithFormat:@"%@年%@月",year,month];
    
    
    if (self.delegate && [self.delegate respondsToSelector:@selector(didSelectDateResult:)])
    {
        [self.delegate didSelectDateResult:resultDate];
    }
    
    [self remove];
}


/**
    移除PickerView
 */
- (void)remove
{
    
    [UIView animateWithDuration:0.35 animations:^
     {
         self.frame = CGRectMake(0, SCREEN_H, SCREEN_W, PickerViewH + ToolbarH);
         
     } completion:^(BOOL finished)
     {
         for (UIView *view in [[UIApplication sharedApplication].keyWindow subviews])
         {
             if (view.tag == 1001)
             {
                 [view removeFromSuperview];
             }
         }
     }];
    
}

/**
    显示PickerView
 */
- (void)show
{
    UIView *screenView         = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_W, SCREEN_H)];
    screenView.backgroundColor = [UIColor colorWithRed:0/255.0
                                                 green:0/255.0
                                                  blue:0/255.0
                                                 alpha:0.5];
    screenView.tag             = 1001;
    [screenView addSubview:self];
    
    [[UIApplication sharedApplication].keyWindow addSubview: screenView];
    
    [UIView animateWithDuration:0.35 animations:^
     {
         screenView.alpha = 1.0;
         self.frame = CGRectMake(0, self.toolViewY, SCREEN_W, PickerViewH + ToolbarH);
         
     } completion:^(BOOL finished)
     {
         
     }];
}

/**
    获取年份数据
 */
- (NSMutableArray *)year
{
    if (!_year)
    {
        _year = [NSMutableArray array];
        
        for (int i = 1900; i < 2100; i++)
        {
            NSString *yearStr = [NSString stringWithFormat:@"%d",i];
            [_year addObject:yearStr];
        }
        
    }
    return _year;
}

/**
    获取月份数据
 */
- (NSMutableArray *)month
{
    if (!_month)
    {
        _month = [NSMutableArray array];
        
        for (int i = 1; i < 13; i++)
        {
            NSString *monthStr = [NSString stringWithFormat:@"%d",i];
            [_month addObject:monthStr];
        }
    }
    
    return _month;
}

@end
