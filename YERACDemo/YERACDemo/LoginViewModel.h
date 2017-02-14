//
//  LoginViewModel.h
//  YERACDemo
//
//  Created by yongen on 17/1/11.
//  Copyright © 2017年 yongen. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface LoginViewModel : NSObject

// 处理按钮是否允许点击
@property(nonatomic, strong, readonly) RACSignal *loginEnableSignal;
/**
 *  保存登录界面的账号和密码
 */
@property(nonatomic, strong) NSString *account;
@property(nonatomic, strong) NSString *pwd;
// 登录按钮的命令
@property(nonatomic, strong, readonly) RACCommand *loginCommand;

@end
