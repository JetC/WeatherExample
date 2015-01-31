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

//APIKey 是我申请的不要外传得太狠就行...
//一般在代码运行时不会/不希望被修改的内容,尽量定义为 const, 减少无意中错误修改的可能
const NSString *APIKey = @"f43a2d3eaa085044";

@implementation NetworkManager

- (NetworkManager *)initWithDelegate:(id<NetworkManagerDelegate>)delegate{
    /*
     注意下一行代码if 的条件 ,里面的self = [super init]使用了一个等号而不是之前常见的两个
     代表的意图是:只要 self 被成功地赋值为[super init],之后 self 就不会为 nil, 条件成立,之后就会执行 if 下面花括号内的代码
     其实这个 if 的条件基本总是会成立的,因为 self = [super init] 极少出现错误
     (只有在内存不足以创建这样小的一个对象时,或者其他极端情况下,总之极少发生)
     这样写 if 只是以防万一,是好的代码习惯
     */
    if (self = [super init]) {
        //把常用的内容写在一个统一的地方
        //这样在网址等外部因素更改时可以减少代码的修改量
        //至于用@property声明的变量(如baseString),可以用 self.baseString 或 _baseString来访问,二者存在一定的不同,稍后会讲到,目前可以当做是一样的来用,大多数时候都用self.来访问
        _baseString = [NSString stringWithFormat: @"http://api.wunderground.com/api/%@/",APIKey];
        _baseURL = [NSURL URLWithString:_baseString];
        _delegate = delegate;
        
        //用默认(default)的配置创建 session,供网络连接使用,因为与服务器的连接是建立在 session 基础上的
        NSURLSessionConfiguration *config = [NSURLSessionConfiguration defaultSessionConfiguration];
        _session = [NSURLSession sessionWithConfiguration:config delegate:self delegateQueue:nil];
    }
    return self;
}

- (void)loadWeatherInfoWithCity:(NSString *)cityString
{
    //这里就相当于把baseURL对应的链接后面接上了@"conditions/q/CA/%@.json"这样的字符串,这样就定位到具体请求的地址
    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"conditions/q/CA/%@.json",cityString] relativeToURL:_baseURL];
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    
    //以上都是为发出网络请求来准备好 NSURL 对象和相应的 NSURLRequest
    //下面开始发出请求
    //打一个断点在下一行代码处,然后按 F6 ,会发现之后会直接跳到[task resume]那里,这是因为由于网络总是要有延迟的,我们总要等到网络返回给了我们相应的信息后才能做进一步的操作,所以网络请求大多是异步请求
    //那么网络返回给了我们相应的信息后我们要做什么操作呢,就都在 block 里面,这里称为 completionHandler
    
    //下面的1-4代表了代码的执行顺序
    
    //1.创建 task
    NSURLSessionTask *task = [self.session dataTaskWithRequest:request completionHandler:^(NSData *data, NSURLResponse *response, NSError *networkError){
        
        //3.网络返回给了相应的信息后
        if (networkError) {
            NSLog(@"NetworkError:%@",networkError.localizedDescription);
            return;
        }
        NSError *jsonParsingError;
        //网络获取回来的数据都是 NSData 类型的,我们需要转换成对应类型的东西才能用
        //我们知道返回的数据是 JSON 格式,所以使用NSJSONSerialization来把 JSON 格式的内容转为NSDictionary类型
        NSDictionary *dictionary = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableLeaves error:&jsonParsingError];
        if (jsonParsingError) {
            NSLog(@"JsonParsingError:%@",jsonParsingError.description);
            return;
        }
        //NSDictionary 说白了就是键值对(key-value pairs),使用正确的key就能找到唯一与之对应的对象,其中每个 dictionary 里的 key 是不会重复的(重复了就没有作为key的意义了233)
        //dictionary[@"current_observation"]就是在 dictionary 内以@"current_observation"为 key, 寻找相应的内容(value)
        //与dictionary[@"current_observation"]对应的value还是个NSDictionary 类型的东西,这时再对它找@"feelslike_c"为 key 的 value, 就可以找到体感温度的值
        [self.delegate weatherInfoDidLoadWithString:[NSString stringWithFormat:@"%@ Feels like:%@",cityString,dictionary[@"current_observation"][@"feelslike_c"]]];
        //4.至此网络部分结束
        
    }];
    //2.使task开始进行网络请求
    [task resume];
}






















@end
