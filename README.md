# xiaomage

这是一个时间选择器，弥补系统默认的只能选择年月日功能，这里增加了只选择年和年月两种模式，喜欢的帮助点个赞呗

#How to used

        ZHDatePickerView *pickerView = [[ZHDatePickerView alloc] initWithFrame:CGRectMake(0, 0, 0, 0) type:XMGStyleTypeYear];
        pickerView.delegate = self;
        [pickerView show];

#遵循协议 并 实现代理方法

# Delegate -- 方法
- (void)didSelectDateResult:(NSString *)resultDate;


