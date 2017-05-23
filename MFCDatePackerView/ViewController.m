//
//  ViewController.m
//  MFCDatePackerView
//
//  Created by machao on 2017/5/23.
//  Copyright © 2017年 machao. All rights reserved.
//

#import "ViewController.h"
#import "MCDatePickerView.h"

@interface ViewController ()<MCDatePickerViewDelegate>
@property (weak, nonatomic) IBOutlet UIButton *yearButton;
@property (weak, nonatomic) IBOutlet UIButton *monthButton;
@property (nonatomic, assign ,getter=isYearShow) BOOL yearShow;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
  
}
- (IBAction)yearButtonClick:(id)sender {
    MCDatePickerView *yearView = [[MCDatePickerView alloc] initWithFrame:CGRectZero type:XMGStyleTypeYear];
    self.yearShow = YES;
    yearView.delegate = self;
    [yearView show];
}

- (IBAction)monthButtonClick:(id)sender {
    MCDatePickerView *monthView = [[MCDatePickerView alloc] initWithFrame:CGRectZero type:XMGStyleTypeYearAndMonth];
    self.yearShow = NO;
    monthView.delegate = self;
    [monthView show];
}

-(void)didSelectDateResult:(NSString *)resultDate{
    if (self.isYearShow) {
        [self.yearButton setTitle:[resultDate substringToIndex:5] forState:UIControlStateNormal];
    }else{
        [self.monthButton setTitle:resultDate forState:UIControlStateNormal];
    }
    
}


@end
