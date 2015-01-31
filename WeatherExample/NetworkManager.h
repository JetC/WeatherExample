//
//  NetworkManager.h
//  WeatherExample
//
//  Created by 孙培峰 on 1/23/15.
//  Copyright (c) 2015 孙培峰. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol NetworkManagerDelegate <NSObject>

- (void)weatherInfoDidLoadWithString:(NSString *)infoString;
- (void)weatherInfoFailedWithError:(NSError *)error;
- (void)weatherInfoParsingFailedWithError:(NSError *)error;

@end

@interface NetworkManager : NSObject

@property (nonatomic, weak) id<NetworkManagerDelegate> delegate;

- (NetworkManager *)initWithDelegate:(id<NetworkManagerDelegate>) delegate;
- (void)loadWeatherInfoWithCity:(NSString *)cityString;


@end
