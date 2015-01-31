//
//  NetworkManager.m
//  WeatherExample
//
//  Created by 孙培峰 on 1/23/15.
//  Copyright (c) 2015 孙培峰. All rights reserved.
//

#import "NetworkManager.h"

@interface NetworkManager()<NSURLSessionDelegate>

@property (nonatomic, strong) NSURLSession *session;
@property (nonatomic, strong) NSString *baseString;
@property (nonatomic, strong) NSURL *baseURL;

@end

const NSString *APIKey = @"f43a2d3eaa085044";

@implementation NetworkManager

- (NetworkManager *)initWithDelegate:(id<NetworkManagerDelegate>)delegate{
    if (self = [super init]) {
        _baseString = [NSString stringWithFormat: @"http://api.wunderground.com/api/%@/",APIKey];
        _baseURL = [NSURL URLWithString:_baseString];
        _delegate = delegate;
        NSURLSessionConfiguration *config = [NSURLSessionConfiguration defaultSessionConfiguration];
        _session = [NSURLSession sessionWithConfiguration:config delegate:self delegateQueue:nil];
    }
    return self;
}

- (void)loadWeatherInfoWithCity:(NSString *)cityString
{
    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"conditions/q/CA/%@.json",cityString] relativeToURL:_baseURL];
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    NSURLSessionTask *task = [self.session dataTaskWithRequest:request completionHandler:^(NSData *data, NSURLResponse *response, NSError *networkError){
        
        if (networkError) {
            NSLog(@"NetworkError:%@",networkError.localizedDescription);
            return;
        }
        NSError *jsonParsingError;
        NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableLeaves error:&jsonParsingError];
        if (jsonParsingError) {
            NSLog(@"JsonParsingError:%@",jsonParsingError.description);
            return;
        }
        [self.delegate weatherInfoDidLoadWithString: [NSString stringWithFormat:@"%@ Feels like:%@",cityString,dic[@"current_observation"][@"feelslike_c"]]];
    }];
    [task resume];
}

//+ (BOOL)isWeatherInfoLoaded
//{
//    
//}





















@end
