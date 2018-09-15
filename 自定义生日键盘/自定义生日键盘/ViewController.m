//
//  ViewController.m
//  自定义生日键盘
//
//  Created by apple on 16/6/14.
//  Copyright © 2016年 apple. All rights reserved.
//

/**
 在Xcode的导航区域(navigator area)的上面点击断点按钮，然后导航区域就跳转到整个项目的断点展示区域，点击这个断点展示区域左下角的“+”按钮，在显示出来的选择菜单中选择添加全局断点(Exception Breakpoint…)。如果程序有问题并且不加全局断点的话，在运行程序后程序就会直接崩溃，并且在Xcode的控制台上会显示相应的错误信息，代码区域则会停留在main.m文件中的main函数上，不会具体显示出bug到底出现在哪行代码。如果加了全局断点的话，程序运行后依然会崩溃，但是此时Xcode的控制台上不会显示相关的错误信息，而且代码区域会停留在具体出现bug的那行代码上，这样就能在短时间内定位是哪行代码引起的bug。
 */
#import "ViewController.h"
#import "ZPProvinces.h"

@interface ViewController () <UITextFieldDelegate, UIPickerViewDataSource, UIPickerViewDelegate>

@property (weak, nonatomic) IBOutlet UITextField *birthdayTextField;  //生日显示框
@property (weak, nonatomic) IBOutlet UITextField *cityTextField;  //城市显示框

/**
 如果在storyboard或者xib文件中用连线的方式把UI控件引用到代码中，则引用的时候系统默认用weak关键字来修饰这个控件，后面的代码中也可以直接用"self."的方式来获取这个控件；
 如果直接在代码中撰写UI控件并且要在后面的代码中用"self."的方式来引用此控件的话则应该用strong关键字来修饰这个控件。如果用weak关键字来修饰这个UI控件并且在后面的代码中用"self."的方式来引用此控件的话则会报"Assigning retained object to weak property; object will be released after assignment"警告，意思就是说由弱指针指着的这个控件对象，待赋值之后会被释放，所以在此种情况下用weak关键字来修饰UI控件并不恰当，应该用strong关键字来进行修饰。
 */
@property (strong, nonatomic) UIDatePicker *datePicker;
@property (strong, nonatomic) UIPickerView *pickerView;
@property (nonatomic, strong) NSArray *provincesArray;
@property (nonatomic, assign) NSInteger selectedProvinceIndex;  //第一列选中的省份的序号

@end

@implementation ViewController

#pragma mark ————— 懒加载 —————
- (NSArray *)provincesArray
{
    if (_provincesArray == nil)
    {
        NSString *path = [[NSBundle mainBundle] pathForResource:@"provinces" ofType:@"plist"];
        NSArray *dictArray = [NSArray arrayWithContentsOfFile:path];
        
        NSMutableArray *tempArray = [NSMutableArray array];
        for (NSDictionary *dict in dictArray)
        {
            ZPProvinces *province = [ZPProvinces provincesWithDict:dict];
            [tempArray addObject:province];
        }
        
        _provincesArray = tempArray;
    }
    
    return _provincesArray;
}

#pragma mark ————— 生命周期 —————
- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    self.birthdayTextField.delegate = self;
    self.cityTextField.delegate = self;
    
    //设置日期选择器
    [self setUpDatePicker];
    
    //设置省份和城市选择器
    [self setUpPickerView];
}

#pragma mark ————— 设置日期选择器 —————
- (void)setUpDatePicker
{
    /**
     创建UIDatePicker控件：
     UIDatePicker控件有默认的位置和尺寸，如无特殊需要就不必再在代码中设置了。
     */
    self.datePicker = [[UIDatePicker alloc] init];
    
    /**
     设置UIDatePicker控件上面显示的语言种类。
     */
    self.datePicker.locale = [NSLocale localeWithLocaleIdentifier:@"zh"];
    
    /**
     设置UIDatePicker控件上显示的日期和时间格式。
     */
    self.datePicker.datePickerMode = UIDatePickerModeDate;
    
    /**
     监听UIDatePicker控件的滚动。
     */
    [self.datePicker addTarget:self action:@selector(dataChange:) forControlEvents:UIControlEventValueChanged];
    
    /**
     设置生日输入框的弹出视图是日期选择器。
     */
    self.birthdayTextField.inputView = self.datePicker;
}

#pragma mark ————— 选择生日 —————
- (void)dataChange:(UIDatePicker *)datePicker
{
    /**
     把NSDate类型转换成NSString类型
     */
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    formatter.dateFormat = @"yyyy-MM-dd";
    NSString *dateString = [formatter stringFromDate:datePicker.date];
    
    self.birthdayTextField.text = dateString;
}

#pragma mark ————— 设置省份和城市选择器 —————
-(void)setUpPickerView
{
    /**
     设置UIPickerView控件：
     UIPickerView控件有默认的位置和尺寸，如无特殊需要就不必再在代码中设置了。
     */
    self.pickerView = [[UIPickerView alloc] init];
    
    self.pickerView.dataSource = self;
    self.pickerView.delegate = self;
    
    /**
     设置省份和城市输入框的弹出视图是UIPickerView控件。
     */
    self.cityTextField.inputView = self.pickerView;
}

#pragma mark ————— UITextFieldDelegate —————
/**
 是否允许文本框开始编辑：
 默认返回的是YES，如果返回的是NO则说明不允许文本框开始编辑，在这种情况下用户点击文本框没有任何反应，也不会在文本框内出现闪动的光标；
 如果返回的是NO则和设置"textField.enabled = NO;"代码的效果一样。
 */
//-(BOOL)textFieldShouldBeginEditing:(UITextField *)textField
//{
//    return NO;
//}

/**
 是否允许当前的文本框结束编辑：
 默认返回的是YES，即编辑完了当前的文本框可以去编辑其他的文本框。如果返回的是NO则只允许编辑当前的文本框，不能够结束当前文本框的编辑也不能够再去编辑其他的文本框。
 */
//-(BOOL)textFieldShouldEndEditing:(UITextField *)textField
//{
//    return NO;
//}

/**
 是否允许用户在键盘上敲击的内容（方法的string参数）显示到输入框中：
 可以利用这个方法滤去一些用户已经输入的但是APP不想显示的内容。
 */
-(BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    NSLog(@"%@", string);
    
    if ([string isEqualToString:@"$"])
    {
        return NO;
    }else
    {
        return YES;
    }
}

/**
 文本框开始编辑的时候会调用此方法
 */
-(void)textFieldDidBeginEditing:(UITextField *)textField
{
    if (textField == self.birthdayTextField)
    {
        //点击生日选择输入框，要默认填入UIDatePicker控件当前选中的日期
        [self dataChange:self.datePicker];
    }else
    {
        //点击省份和城市选择输入框，要默认填入UIPickerView控件的第0个省份和城市
        [self pickerView:self.pickerView didSelectRow:0 inComponent:0];
    }
}

#pragma mark ————— UIPickerViewDataSource —————
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    return 2;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    if (component == 0)
    {
        return self.provincesArray.count;
    }else
    {
        //当前选中的省份
        ZPProvinces *province = [self.provincesArray objectAtIndex:self.selectedProvinceIndex];
        
        return province.cities.count;
    }
}

- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
{
    if (component == 0)
    {
        ZPProvinces *province = [self.provincesArray objectAtIndex:row];
        
        return province.name;
    }else
    {
        //当前在第一列中选中的省份
        ZPProvinces *province = [self.provincesArray objectAtIndex:self.selectedProvinceIndex];
        
        /**
         当转动UIPickerView控件第一列的同时又转动第二列，会出现程序崩溃的现象。原因就是在转动之前，第一列的某个省份对应第二列一定个数的城市，当转动第一列的时候，省份会出现变化，这个时候由于第一列的转动速度很快而第二列的城市没有及时根据第一列省份的变化而相应变化成新的省份所对应的城市，还保留第一列转动之前那个省份所对应的城市，所以就造成了第一列的省份和第二列的城市不匹配的情况，也就是转动之后新的第一列的省份实际所对应的城市的个数和第二列当前所显示的城市的总数不匹配，也就是转动第一列的同时再转动第二列会出现数组越界的情况，从而导致程序的崩溃；
         要想解决上述的问题就要在pickerView:didSelectRow:inComponent:方法中记录转动之前第一列选中的省份所在的位置并且要写成本类的一个属性，而且在pickerView:titleForRow:forComponent:方法中代码要写成上面的样式，这样的话在转动第一列的时候并且在转动没有停止的时候第二列的城市不会根据第一列中省份的变化而进行更新，还保留在转动之前第一列的省份所对应的那些城市，所以在第一列转动的同时转动第二列就不会出现数组越界的情况，故而程序不会崩溃，当第一列转动停止的时候，就会转到一个新的省份，同时系统就会调用pickerView:didSelectRow:inComponent:方法，会给之前定义的那个属性赋一个新的值，代表这个第一列转到的新的省份所在的位置，然后在pickerView:didSelectRow:inComponent:方法中调用reloadComponent:方法来更新第二列的城市，此时系统就会调用pickerView:titleForRow:forComponent:方法来根据第一列新的省份获取第二列所对应的城市从而达到更新第二列数据的目的。
         */
        return [province.cities objectAtIndex:row];
    }
}

#pragma mark ————— UIPickerViewDelegate —————
-(void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
    if (component == 0)
    {
        //记录当前第0列选中的省份
        self.selectedProvinceIndex = [pickerView selectedRowInComponent:0];
        NSLog(@"selectedProvinceIndex = %ld", (long)self.selectedProvinceIndex);
        
        //第0列选好以后，刷新第1列
        [pickerView reloadComponent:1];
    }
    
    ZPProvinces *province = [self.provincesArray objectAtIndex:self.selectedProvinceIndex];
    
    NSInteger cityIndex = [pickerView selectedRowInComponent:1];
    NSString *cityName = [province.cities objectAtIndex:cityIndex];
    
    self.cityTextField.text = [NSString stringWithFormat:@"%@ %@", province.name, cityName];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
