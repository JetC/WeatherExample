//
//  NetworkManager.h
//  WeatherExample
//
//  Created by 孙培峰 on 1/23/15.
//  Copyright (c) 2015 孙培峰. All rights reserved.
//

#import <Foundation/Foundation.h>

//下面直到第一个@end都是协议的区域,规定了所有满足NetworkManagerDelegate这个协议的类需要实现哪些方法,不实现的话会被 Xcode 警告
@protocol NetworkManagerDelegate <NSObject>

- (void)weatherInfoDidLoadWithString:(NSString *)infoString;
- (void)weatherInfoFailedWithError:(NSError *)error;
- (void)weatherInfoParsingFailedWithError:(NSError *)error;

@end




//声明NetworkManager类的接口
@interface NetworkManager : NSObject

//注意一个类的 delegate 应该使用 weak 而不是 strong
//id 代表任意类
//本处使用此 delegate 来保持和 ViewController 的联系,使得可以在网络请求完成后更新 View 上的内容
@property (nonatomic, weak) id<NetworkManagerDelegate> delegate;

- (NetworkManager *)initWithDelegate:(id<NetworkManagerDelegate>) delegate;
- (void)loadWeatherInfoWithCity:(NSString *)cityString;


@end
