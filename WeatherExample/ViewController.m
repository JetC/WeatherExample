//
//  ViewController.m
//  WeatherExample
//
//  Created by 孙培峰 on 1/23/15.
//  Copyright (c) 2015 孙培峰. All rights reserved.
//

#import "ViewController.h"
#import "NetworkManager.h"

@interface ViewController ()<NetworkManagerDelegate>

@property (strong, nonatomic) NetworkManager *networkManager;
@property (weak, nonatomic) IBOutlet UILabel *weatherInfoLabel;

@end

@implementation ViewController

//这里是 view 刚刚加载完成(didLoad),但还没有显示的(didAppear)时候会被调用
- (void)viewDidLoad {
    [super viewDidLoad];
    /*加载 NetworkManager
     由于想要让NetworkManager的网络内容加载完成之后还能通知此处的ViewController来更新 View(即是修改label.text的内容)
     所以把 ViewController 自身作为 NetworkManager 的 delegate
     这样在NetworkManager完成网络相关的加载后可以在其中直接使用self.delegate来使用ViewController完成更新 View 的操作
     */
    self.networkManager = [[NetworkManager alloc]initWithDelegate:self];
}

- (IBAction)startQuery:(id)sender {
    //点击"查询"按钮就会调用此方法
    [self.networkManager loadWeatherInfoWithCity:@"San_Francisco"];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)weatherInfoDidLoadWithString:(NSString *)infoString
{
    [[NSOperationQueue mainQueue]addOperationWithBlock:^{
        
    /*(由{}包起来的部分称为代码块,即Block)
        上面的一行是将本代码块加入主线程执行
     要记得和界面相关的东西都要再主线程执行嗯...
      */
        self.weatherInfoLabel.text = infoString;
    }];
}

- (void)weatherInfoFailedWithError:(NSError *)error
{
    //一般此类出错处理是弹出 AlertView 就是弹个小窗口提示用户的那种,我们这里暂且不写那么多,但记得要对一些可能出错的地方写好出错处理嗯
    NSLog(@"weatherInfoFailedWithError:%@",[error localizedDescription]);
}









@end
