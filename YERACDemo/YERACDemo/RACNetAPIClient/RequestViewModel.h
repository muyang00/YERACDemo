//
//  RequestViewModel.h
//  YERACDemo
//
//  Created by yongen on 17/1/9.
//  Copyright © 2017年 yongen. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface RequestViewModel : NSObject

@property (nonatomic, strong) RACCommand *requestCommand;

@end
