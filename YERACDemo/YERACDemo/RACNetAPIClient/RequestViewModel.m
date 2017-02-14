//
//  RequestViewModel.m
//  YERACDemo
//
//  Created by yongen on 17/1/9.
//  Copyright © 2017年 yongen. All rights reserved.
//

#import "RequestViewModel.h"

@interface RequestViewModel ()

@end

@implementation RequestViewModel

- (instancetype)init{
    self = [super init];
    if (self) {
        [self configRequest];
    }
    return self;
}

- (void)configRequest{
    
    _requestCommand = [[RACCommand alloc] initWithSignalBlock:^RACSignal *(id input){
       
        //执行命令
        //发送请求
        //创建信号  把发送请求的代码包装到信号里面。
        RACSignal *signal = [RACSignal createSignal:^RACDisposable *(id <RACSubscriber> subscriber){
            AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
            [manager GET:@"https://api.douban.com/v2/book/search" parameters:@{@"q":@"帅哥"} progress:^(NSProgress *_Nonnull downloadProgress){
                
            }success:^(NSURLSessionDataTask *task, id responseObject){
                
                [responseObject writeToFile:@"" atomically:YES];
                
                NSArray *dicArr = responseObject[@"books"];
                NSArray *modelArr = [[dicArr.rac_sequence map:^id (id value){
                    return [[NSObject alloc] init];
                }] array];
                
                [subscriber sendNext:modelArr];
                
                
            } failure:^(NSURLSessionDataTask *task, NSError *error){
               
                
            }];
            
            return nil;
        }];
        return signal;// 模型数组
    }];
}



@end
