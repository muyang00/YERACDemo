//
//  ViewController.m
//  YERACDemo
//
//  Created by yongen on 17/1/4.
//  Copyright © 2017年 yongen. All rights reserved.
//
//  //RAC (好的学习文章)

//https://gold.xitu.io/entry/568bd2ae60b2e57ba2cd2c7b

#import "ViewController.h"
#import "RACReturnSignal.h"
#import "RequestViewModel.h"
#import "RAC_MVVM_ViewController.h"
#import "RAC_MVVMTwo_ViewController.h"

@interface ViewController ()

@property (nonatomic, strong) UITextField *textfield;
@property (nonatomic, strong) UILabel *label;
@property (nonatomic, strong) RACSignal *signal;

@property(nonatomic, strong)RequestViewModel *requestVM;

@property (nonatomic, strong) UITextField *accountField;
@property (nonatomic, strong) UITextField *pwdField;
@property (nonatomic, strong) UIButton *loginBtn;

@end

@implementation ViewController

- (IBAction)nextPageVC:(UIBarButtonItem *)sender {
    
    RAC_MVVM_ViewController *VC = [[RAC_MVVM_ViewController alloc]init];
    [self.navigationController pushViewController:VC animated:YES];
}

- (IBAction)MVVMTwoPageVC:(UIBarButtonItem *)sender {
    
    RAC_MVVMTwo_ViewController *VC = [[RAC_MVVMTwo_ViewController alloc]init];
    [self.navigationController pushViewController:VC animated:YES];
}

- (RequestViewModel *)requestVM {
    if (!_requestVM) {
        _requestVM = [[RequestViewModel alloc] init];
    }
    return _requestVM;
}

- (UILabel *)label{
    if (_label == nil) {
        _label = [[UILabel alloc]initWithFrame:CGRectMake(20, 300, kScreenWidth - 40, 35)];
        _label.backgroundColor = [UIColor lightGrayColor];
        
        [self.view addSubview:_label];
    }
    return _label;
}

- (UITextField *)textfield{
    if (_textfield == nil) {
        
        self.textfield = [[UITextField alloc]initWithFrame:CGRectMake(20, 100, kScreenWidth - 40, 40)];
        self.textfield.backgroundColor = [UIColor orangeColor];
        [self.view addSubview:self.textfield];
    }
    return _textfield;
}
- (UITextField *)accountField{
    if (!_accountField) {
        
        self.accountField = [[UITextField alloc]initWithFrame:CGRectMake(20, 150, kScreenWidth - 40, 30)];
        _accountField.borderStyle = UITextBorderStyleRoundedRect;
        
        [self.view addSubview:self.accountField];
    }
    return _accountField;
}
- (UITextField *)pwdField{
    if (!_pwdField) {
        
        self.pwdField = [[UITextField alloc]initWithFrame:CGRectMake(20, 230, kScreenWidth - 40, 30)];
        _pwdField.borderStyle = UITextBorderStyleRoundedRect;
        [self.view addSubview:self.pwdField];
    }
    return _pwdField;
}

- (UIButton *)loginBtn{
    if (!_loginBtn) {
        self.loginBtn  = [UIButton buttonWithType:UIButtonTypeCustom];
        self.loginBtn.frame = CGRectMake(20, 300, kScreenWidth - 40, 40);
        self.loginBtn.backgroundColor = [UIColor orangeColor];
        [self.loginBtn setTitle:@"登录" forState:UIControlStateNormal];
        [self.loginBtn setTitle:@"huidian" forState:UIControlStateSelected];
        //[self.loginBtn addTarget:self action:@selector(loginBtnAction:) forControlEvents:UIControlEventTouchUpInside];
        [self.view addSubview:self.loginBtn];
    }
    return _loginBtn;
}

- (void)loginBtnAction:(UIButton *)sender{
    sender.selected = !sender.selected;
    
    DLog(@"loginBtnAction");
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
   
    //[self configFirstRACDemo];
    //[self configSecondRACDemo];
//    [self configThirdRACDemo];
    //[self configFourthRACDemo];
    //[self configFifthRACDemo];
    //[self configsixthRACDemo];
    
    [self RACMulticastConnection];
    
  
   // [self configSeventhRACDemo];
    
    
    
}

#pragma mark - RAC组合使用

- (void)configSeventhRACDemo{
    DLog(@"RAC组合使用");

    //[self combineLatest];
    //[self zipWith];
    //[self merge];
//    [self then];
    [self concat];
    
}

// 把多个信号聚合成你想要的信号,使用场景----：比如-当多个输入框都有值的时候按钮才可点击。
// 思路--- 就是把输入框输入值的信号都聚合成按钮是否能点击的信号。
- (void)combineLatest {
    
    RACSignal *combinSignal = [RACSignal combineLatest:@[self.accountField.rac_textSignal, self.pwdField.rac_textSignal] reduce:^id(NSString *account, NSString *pwd){ //reduce里的参数一定要和combineLatest数组里的一一对应。
        // block: 只要源信号发送内容，就会调用，组合成一个新值。
        NSLog(@"%@ %@", account, pwd);
        return @(account.length && pwd.length);
    }];
    
    //    // 订阅信号
    //    [combinSignal subscribeNext:^(id x) {
    //        self.loginBtn.enabled = [x boolValue];
    //    }];    // ----这样写有些麻烦，可以直接用RAC宏
    RAC(self.loginBtn, enabled) = combinSignal;
    
    [[self.loginBtn rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(id x){
       
       DLog(@"loginBtnAction");
        
    }];
    
}


- (void)zipWith {
    //zipWith:把两个信号压缩成一个信号，只有当两个信号同时发出信号内容时，并且把两个信号的内容合并成一个元祖，才会触发压缩流的next事件。
    // 创建信号A
    RACSubject *signalA = [RACSubject subject];
    // 创建信号B
    RACSubject *signalB = [RACSubject subject];
    // 压缩成一个信号
    // **-zipWith-**: 当一个界面多个请求的时候，要等所有请求完成才更新UI
    // 等所有信号都发送内容的时候才会调用
    RACSignal *zipSignal = [signalA zipWith:signalB];
    [zipSignal subscribeNext:^(id x) {
        NSLog(@"%@", x); //所有的值都被包装成了元组
    }];
    
    // 发送信号 交互顺序，元组内元素的顺序不会变，跟发送的顺序无关，而是跟压缩的顺序有关[signalA zipWith:signalB]---先是A后是B
    
    [signalA sendNext:@1];
    [signalB sendNext:@2];
}

// 任何一个信号请求完成都会被订阅到
// merge:多个信号合并成一个信号，任何一个信号有新值就会调用
- (void)merge {
    // 创建信号A
    RACSubject *signalA = [RACSubject subject];
    // 创建信号B
    RACSubject *signalB = [RACSubject subject];
    //组合信号
    RACSignal *mergeSignal = [signalA merge:signalB];
    // 订阅信号
    [mergeSignal subscribeNext:^(id x) {
        NSLog(@"%@", x);
    }];
    // 发送信号---交换位置则数据结果顺序也会交换
   
    [signalA sendNext:@"上部分"];
    [signalB sendNext:@"下部分"];
}

// then --- 使用需求：有两部分数据：想让上部分先进行网络请求但是过滤掉数据，然后进行下部分的，拿到下部分数据
- (void)then {
    // 创建信号A
    RACSignal *signalA = [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
        // 发送请求
        NSLog(@"----发送上部分请求---afn");
        
        [subscriber sendNext:@"上部分数据"];
        [subscriber sendCompleted]; // 必须要调用sendCompleted方法！
        return nil;
    }];
    
    // 创建信号B，
    RACSignal *signalsB = [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
        // 发送请求
        NSLog(@"--发送下部分请求--afn");
        [subscriber sendNext:@"下部分数据"];
        return nil;
    }];
    // 创建组合信号
    // then;忽略掉第一个信号的所有值
    RACSignal *thenSignal = [signalA then:^RACSignal *{
        // 返回的信号就是要组合的信号
        return signalsB;
    }];
    
    // 订阅信号
    [thenSignal subscribeNext:^(id x) {
        NSLog(@"%@", x);
    }];
    
}

// concat----- 使用需求：有两部分数据：想让上部分先执行，完了之后再让下部分执行（都可获取值）
- (void)concat {
    // 组合
    
    // 创建信号A
    RACSignal *signalA = [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
        // 发送请求
        //        NSLog(@"----发送上部分请求---afn");
        
        [subscriber sendNext:@"上部分数据"];
        [subscriber sendCompleted]; // 必须要调用sendCompleted方法！
        return nil;
    }];
    
    // 创建信号B，
    RACSignal *signalsB = [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
        // 发送请求
        //        NSLog(@"--发送下部分请求--afn");
        [subscriber sendNext:@"下部分数据"];
        return nil;
    }];
    
    
    // concat:按顺序去链接
    //**-注意-**：concat，第一个信号必须要调用sendCompleted
    // 创建组合信号
    RACSignal *concatSignal = [signalA concat:signalsB];
    // 订阅组合信号
    [concatSignal subscribeNext:^(id x) {
        NSLog(@"%@",x);
    }];
    
}


#pragma mark - RACMulticastConnection

- (void)RACMulticastConnection{
    
    /**
     *  当有多个订阅者，但是我们只想发送一个信号的时候怎么办？这时我们就可以用RACMulticastConnection，来实现。代码示例如下
     */
    
    // 这样的缺点是：没订阅一次信号就得重新创建并发送请求，这样很不友好
    
    RACSignal *signal = [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
        // didSubscribeblock中的代码都统称为副作用。
        // 发送请求---比如afn
        NSLog(@"发送请求啦");
        // 发送信号
        [subscriber sendNext:@"信号"];
        return nil;
    }];
    [signal subscribeNext:^(id x) {
        NSLog(@"%@", x);
    }];
    [signal subscribeNext:^(id x) {
        NSLog(@"%@", x);
    }];
    [signal subscribeNext:^(id x) {
        NSLog(@"%@", x);
    }];
    
    // 比较好的做法。 使用RACMulticastConnection，无论有多少个订阅者，无论订阅多少次，我只发送一个。
    // 1.发送请求，用一个信号内包装，不管有多少个订阅者，只想发一次请求
    RACSignal *resignal = [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
        // 发送请求
        NSLog(@"注意啦,我只发一次请求");
        // 发送信号
        [subscriber sendNext:@"信号"];
        return nil;
    }];
    //2. 创建连接类
    RACMulticastConnection *connection = [resignal publish];
    [connection.signal subscribeNext:^(id x) {
        NSLog(@"%@", x);
    }];
    [connection.signal subscribeNext:^(id x) {
        NSLog(@"%@", x);
    }];
    [connection.signal subscribeNext:^(id x) {
        NSLog(@"%@", x);
    }];
    //3. 连接。只有连接了才会把信号源变为热信号
    [connection connect];
    
    
}


#pragma mark - RACCommand
- (void)configsixthRACDemo{
    
    // RACCommand:RAC中用于处理事件的类，可以把事件如何处理，事件中的数据如何传递，包装到这个类中，他可以很方便的监控事件的执行过程，比如看事件有没有执行完毕
    // 使用场景：监听按钮点击，网络请求
    
     [self test3];
    
}

// 普通做法
- (void)test1 {
    // RACCommand: 处理事件
    // 不能返回空的信号
    // 1.创建命令
    RACCommand *command = [[RACCommand alloc] initWithSignalBlock:^RACSignal *(id input) {
        //block调用，执行命令的时候就会调用
        NSLog(@" ---  %@",input); // input 为执行命令传进来的参数
        // 这里的返回值不允许为nil
        return [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
            [subscriber sendNext:@"执行命令产生的数据"];
            return nil;
        }];
    }];
    
    // 如何拿到执行命令中产生的数据呢？
    // 订阅命令内部的信号
    // ** 方式一：直接订阅执行命令返回的信号
    
    // 2.执行命令
    RACSignal *signal =[command execute:@2]; // 这里其实用到的是replaySubject 可以先发送命令再订阅
    // 在这里就可以订阅信号了
    [signal subscribeNext:^(id x) {
        NSLog(@" ++++  %@",x);
    }];
    
}
// 一般做法
- (void)test2 {
    // 1.创建命令
    RACCommand *command = [[RACCommand alloc] initWithSignalBlock:^RACSignal *(id input) {
        //block调用，执行命令的时候就会调用
        NSLog(@"%@",input); // input 为执行命令传进来的参数
        // 这里的返回值不允许为nil
        return [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
            [subscriber sendNext:@"执行命令产生的数据"];
            return nil;
        }];
    }];
    
    // 方式二：
    // 订阅信号
    // 注意：这里必须是先订阅才能发送命令
    // executionSignals：信号源，信号中信号，signalofsignals:信号，发送数据就是信号
    [command.executionSignals subscribeNext:^(RACSignal *x) {
        [x subscribeNext:^(id x) {
            NSLog(@"%@", x);
        }];
        //        NSLog(@"%@", x);
    }];
    
    // 2.执行命令
    [command execute:@2];
}
// 高级做法
- (void)test3 {
    
    // 1.创建命令
    RACCommand *command = [[RACCommand alloc] initWithSignalBlock:^RACSignal *(id input) {
        // block调用：执行命令的时候就会调用
        NSLog(@"%@", input);
        // 这里的返回值不允许为nil
        return [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
            [subscriber sendNext:@"发送信号"];
            return nil;
        }];
    }];
    
    // 方式三
    // switchToLatest获取最新发送的信号，只能用于信号中信号。
    [command.executionSignals.switchToLatest subscribeNext:^(id x) {
        NSLog(@"%@", x);
    }];
    // 2.执行命令
    [command execute:@"擦擦"];
    
}

// switchToLatest
- (void)test4 {
    // 创建信号中信号
    RACSubject *signalofsignals = [RACSubject subject];
    RACSubject *signalA = [RACSubject subject];
    // 订阅信号
    //    [signalofsignals subscribeNext:^(RACSignal *x) {
    //        [x subscribeNext:^(id x) {
    //            NSLog(@"%@", x);
    //        }];
    //    }];
    // switchToLatest: 获取信号中信号发送的最新信号
    [signalofsignals.switchToLatest subscribeNext:^(id x) {
        NSLog(@"%@", x);
    }];
    // 发送信号
    [signalofsignals sendNext:signalA];
    [signalA sendNext:@4];
}

// 监听事件有没有完成
- (void)test5 {
    //注意：当前命令内部发送数据完成，一定要主动发送完成
    // 1.创建命令
    RACCommand *command = [[RACCommand alloc] initWithSignalBlock:^RACSignal *(id input) {
        // block调用：执行命令的时候就会调用
        NSLog(@"%@", input);
        // 这里的返回值不允许为nil
        return [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
            // 发送数据
            [subscriber sendNext:@"执行命令产生的数据"];
            
            // *** 发送完成 **
            [subscriber sendCompleted];
            return nil;
        }];
    }];
    // 监听事件有没有完成
    [command.executing subscribeNext:^(id x) {
        if ([x boolValue] == YES) { // 正在执行
            NSLog(@"当前正在执行%@", x);
        }else {
            // 执行完成/没有执行
            NSLog(@"执行完成/没有执行");
        }
    }];
    
    // 2.执行命令
    [command execute:@1];
    
}



#pragma mark -- 发送请求

- (void)requestData{
    // 发送请求
    RACSignal *signal = [self.requestVM.requestCommand execute:nil];
    [signal subscribeNext:^(id x) {
        NSLog(@"%@",x);
    }];
}


#pragma mark -- bind 绑定
- (void)configFifthRACDemo{
    
    RACSubject *subject = [RACSubject subject];
    RACSignal *bindSignal = [subject bind:^RACStreamBindBlock{
        //block 调用时刻：只要绑定信号订阅就会调用， 不做什么事情
        return ^RACSignal *(id value, BOOL *stop){
            //一般在这个block中做事，发数据的时候就会来到这个block
            //只要源信号（subject）发送数据，就会调用block
            //block作用：处理源信号内容
            //vlaue :源信号发送的内容
            value = @3;//如果在这里吧value的值改了，那么订阅绑定信号的值的yy就变了
            NSLog(@"接受到源信号的内容：%@", value);
            //返回信号，不能为nil,如果非要返回空---则empty或 alloc init。
            
            return [RACReturnSignal return:value];// 把返回的值包装成信号
        };
    }];
    
    // 3.订阅绑定信号
    [bindSignal subscribeNext:^(id yy) {
        
        NSLog(@"接收到绑定信号处理完的信号:%@", yy);
    }];
    // 4.发送信号
    [subject sendNext:@"123"];
    
    // bind（绑定）的使用思想和Hook的一样---> 都是拦截API从而可以对数据进行操作，，而影响返回数据。
    // 发送信号的时候会来到   行的block。在这个block里我们可以对数据进行一些操作，那么   行打印的value和订阅绑定信号后的value就会变了。变成什么样随你喜欢喽
}



#pragma mark -- RAC宏

- (void)configFourthRACDemo{
    
    RAC(self.label, text) = self.textfield.rac_textSignal;
    
    //    [self.textfield.rac_textSignal subscribeNext:^(id x){
    //
    //        self.label.text = x;
    //    }];
    
    [RACObserve(self.label, text) subscribeNext:^(id x){
        
        NSLog(@"====label的文字变了");
    }];
    /**
     *  循环引用问题
     */
    
    @weakify(self)
    RACSignal *signal = [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber){
        @strongify(self)
        NSLog(@"%@",self.view);
        return nil;
    }];
    _signal = signal;

}

#pragma mark -- 遍历数组，字典

- (void)configThirdRACDemo{
    //    NSArray *dictArr = @[@"23", @"34", @"44", @"56", @"67", @"77", @"78"];
    //
    //    [dictArr.rac_sequence.signal subscribeNext:^(id x) {
    //        NSLog(@"%@", x);
    //    } error:^(NSError *error) {
    //        NSLog(@"===error===");
    //    } completed:^{
    //        NSLog(@"ok---完毕");
    //    }];
    //
    //
    //    RACSequence *stream = [dictArr rac_sequence];
    //
    //    DLog(@"stream == %@", stream);
    
    
    NSDictionary *dict = @{@"key":@1, @"key2":@2};
    [dict.rac_sequence.signal subscribeNext:^(id x) {
        NSLog(@"%@", x);
        NSString *key = x[0];
        NSString *value = x[1];
        NSLog(@"%@ -------- %@", key, value);
        // RACTupleUnpack宏：专门用来解析元组
        // RACTupleUnpack 等会右边：需要解析的元组 宏的参数，填解析的什么样数据
        // 元组里面有几个值，宏的参数就必须填几个
        RACTupleUnpack(NSString *key2, NSString *value2) = x;
        NSLog(@"%@ ===😀😀=====  %@", key2, value2);
        
        RACTuple *tuple = RACTuplePack(@33, @2);
        NSLog(@"7777-----%@", tuple);
        
        
        
    } error:^(NSError *error) {
        NSLog(@"===error");
    } completed:^{
        NSLog(@"-----ok---完毕");
    }];
    

}

#pragma mark -- 高阶函数的使用

- (void)configSecondRACDemo{
    /*
     RAC的核心就是信号，即RACSignal。
     
     信号可以看做是传递信号的工具，当数据变化时，信号就会发送改变的信息，以通知信号的订阅者执行方法。
     热/冷信号
     
     默认一个信号都是冷信号，也就是值改变了，也不会触发，只有订阅了这个信号，这个信号才会变为热信号，值改变了才会触发。
     */
    //创建信号
    RACSignal *signal = [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber){
        
        [subscriber sendNext:@"signal"];
        [subscriber sendCompleted];
        return nil;
    }];
    //订阅信号
    [signal subscribeNext:^(id x){
        
        DLog(@"x = %@", x);
    } error:^(NSError *error){
        DLog(@"NSError = %@", error);
    }completed:^{
        
        DLog(@"completed");
    }];
    
    
    //信号的处理
    //map
    //这里的map不是地图，而是映射的意思，就是创建一个订阅者的映射并且返回数据，具体用法我们来看代码。
    
    [[self.textfield.rac_textSignal map:^id(id value){
        
        DLog(@"value = %@", value);
        return @1;
    }] subscribeNext:^(id x){
        DLog(@"x = %@", x);
    }];
    
    // flattenMap中返回的是什么信号，订阅的就是什么信号(那么，x的值等于value的值，如果我们操纵value的值那么x也会随之而变)
     // flattenMap 主要用于信号中的信号
    /*
     // flattenMap 主要用于信号中的信号
     // 创建信号
     RACSubject *signalofSignals = [RACSubject subject];
     RACSubject *signal = [RACSubject subject];
     
     // 订阅信号
     //方式1
     //    [signalofSignals subscribeNext:^(id x) {
     //
     //        [x subscribeNext:^(id x) {
     //            NSLog(@"%@", x);
     //        }];
     //    }];
     // 方式2
     //    [signalofSignals.switchToLatest];
     // 方式3
     //   RACSignal *bignSignal = [signalofSignals flattenMap:^RACStream *(id value) {
     //
     //        //value:就是源信号发送内容
     //        return value;
     //    }];
     //    [bignSignal subscribeNext:^(id x) {
     //        NSLog(@"%@", x);
     //    }];
     // 方式4--------也是开发中常用的
     [[signalofSignals flattenMap:^RACStream *(id value) {
     return value;
     }] subscribeNext:^(id x) {
     NSLog(@"%@", x);
     }];
     
     // 发送信号
     [signalofSignals sendNext:signal];
     [signal sendNext:@"123"];

     
     */
    
    
    //filter
    //filter就是过滤，它可以帮助你筛选出你需要的信号变化。
    
    [[self.textfield.rac_textSignal filter:^BOOL (NSString *string){
        
        return [string  length] > 3;
        
    }] subscribeNext:^(id yy){
        
        DLog(@"yy  ==  %@", yy);
        
    }];
    

    //take/skip/repeat
    //take是获取，skip是跳过，这两个方法后面跟着的都是NSInteger。所以take 2就是获取前两个信号，skip 2就是跳过前两个。repeat是重复发送信号。
    RACSignal *signal00 = [[[RACSignal createSignal:^RACDisposable *(id <RACSubscriber> subscriber){
        [subscriber sendNext:@"1"];
        [subscriber sendNext:@"2"];
        [subscriber sendNext:@"3"];
        [subscriber sendNext:@"4"];
        [subscriber sendNext:@"5"];
        [subscriber sendNext:@"6"];
        [subscriber sendCompleted];
        return nil;
    }] take:3] skip:2];
    
    
    [signal00 subscribeNext:^(id x){
        DLog(@"x = %@", x);
    }completed:^{
        DLog(@"completed");
    }];
    
    //相似的还有takeLast takeUntil takeWhileBlock skipWhileBlock skipUntilBlock repeatWhileBlock都可以根据字面意思来理解。
    
    // take:可以屏蔽一些值,去前面几个值---这里take为2 则只拿到前两个值
    //takeLast:和take的用法一样，不过他取的是最后的几个值，如下，则取的是最后两个值
    //注意点:takeLast 一定要调用sendCompleted，告诉他发送完成了，这样才能取到最后的几个值
    
    // takeUntil:---给takeUntil传的是哪个信号，那么当这个信号发送信号或sendCompleted，就不能再接受源信号的内容了。
    
    /*
     RACSubject *subject = [RACSubject subject];
     RACSubject *subject2 = [RACSubject subject];
     [[subject takeUntil:subject2] subscribeNext:^(id x) {
     NSLog(@"%@", x);
     }];
     // 发送信号
     [subject sendNext:@1];
     [subject sendNext:@2];
     [subject2 sendNext:@3];  // 1
     //    [subject2 sendCompleted]; // 或2
     [subject sendNext:@4];
     */
    
    //delay
    //延时信号，顾名思义，即延迟发送信号。
    
    RACSignal *signalDelay = [[RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
        [subscriber sendNext:@"delay"];
        [subscriber sendCompleted];
        return nil;
    }] delay:3];
    
    DLog(@"tag");
    
    [signalDelay subscribeNext:^(id x) {
        DLog(@"%@", x);
    }];
    
    
    //throttle
    /*
     节流，在我们做搜索框的时候，有时候需求的时实时搜索，即用户每每输入字符，view都要求展现搜索结果。这时如果用户搜索的字符串较长，那么由于网络请求的延时可能造成UI显示错误，并且多次不必要的请求还会加大服务器的压力，这显然是不合理的，此时我们就需要用到节流。
     */
    
    [[[self.textfield rac_textSignal] throttle:0.5 ] subscribeNext:^(id x){
        
        DLog(@"x = %@", x);
    }];
    
    
    //distinctUntilChanged
    
    //网络请求中为了减轻服务器压力，无用的请求我们应该尽可能不发送。distinctUntilChanged的作用是使RAC不会连续发送两次相同的信号，这样就解决了这个问题。
    //如果当前的值跟上一次的值一样，就不会被订阅到
    [[[self.textfield rac_textSignal] distinctUntilChanged] subscribeNext:^(id xx){
        
        DLog(@"xx = %@", xx);
    }];
    
    
    //timeout
    //超时信号，当超出限定时间后会给订阅者发送error信号。
    
    RACSignal *signalTimeout = [[RACSignal createSignal:^RACDisposable *(id <RACSubscriber>subscriber){
        [[RACScheduler mainThreadScheduler]afterDelay:4 schedule:^{
            
            [subscriber sendNext:@"delay"];
            [subscriber sendCompleted];
        }];
        return nil;
    }] timeout:2 onScheduler:[RACScheduler mainThreadScheduler]];
    
    [signalTimeout subscribeNext:^(id zz){
        DLog(@" zz == %@", zz);
    } error:^(NSError *error){
        DLog(@"error == %@", error);
    }];
    
    //由于在创建信号是限定了延迟3秒发送，但是加了timeout2秒的限定，所以这一定是一个超时信号。这个信号被订阅后，由于超时，不会执行订阅成功的输出x方法，而是跳到error的块输出了错误信息。timeout在用RAC封装网络请求时可以节省不少的代码量。
    
    
    //ignore
    //忽略信号，指定一个任意类型的量（可以是字符串，数组等），当需要发送信号时讲进行判断，若相同则该信号会被忽略发送。
    //ignore:忽略一些值
    //ignoreValues:表示忽略所有的值
    
    [[[self.textfield rac_textSignal] ignore:@"good"] subscribeNext:^(id aa){// ignoreValues:表示忽略所有的值

        
        DLog(@"aa == %@", aa);
    }];
}

#pragma mark -- 简单的引用

- (void)configFirstRACDemo{
    
    /*
     简单的说，RAC就是一个第三方库，他可以大大简化你的代码过程。
     
     官方的说，ReactiveCocoa（其简称为RAC）是由GitHub开源的一个应用于iOS和OS X开发的新框架。RAC具有函数式编程和响应式编程的特性。
     */
    
    /*
     实现了一个功能，即监听了textFild的UIControlEventEditingChanged事件，当事件发生时实现方法NSLog。
     */
    [[self.textfield rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(id x){
        
        DLog(@"UIControlEventTouchUpInside --- %@", self.textfield.text);
    }];
    [[self.textfield rac_textSignal] subscribeNext:^(id x) {
        DLog(@"%@",x);
    }];
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] init];
    [[tap rac_gestureSignal] subscribeNext:^(id x) {
        DLog(@"tap");
    }];
    [self.view addGestureRecognizer:tap];
    
    /*
     @selector是指这次事件监听的方法fromProtocol指依赖的代理。这里block中有一个RACTuple，他相当于是一个集合类，他下面的first，second等就是类的各个参数，我这里点了AlertView第二个按钮other输出了一下。
     */
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"RAC" message:@"RAC TEST" delegate:self cancelButtonTitle:@"cancel" otherButtonTitles:@"other", nil];
    [[self rac_signalForSelector:@selector(alertView:clickedButtonAtIndex:) fromProtocol:@protocol(UIAlertViewDelegate)] subscribeNext:^(RACTuple *tuple) {
        DLog(@"%@",tuple.first);
        DLog(@"%@",tuple.second);
        DLog(@"%@",tuple.third);
    }];
    [alertView show];
    
    
    /*
     可以看出tuple.second是ButtonAtIndex中Button的序号。那么对于上面那个我举的例子，就可以用switch给各个按钮添加方法，这样的代码看起来更容易理解，方面后期维护。
     */
    [[alertView rac_buttonClickedSignal] subscribeNext:^(id x) {
        DLog(@"%@",x);
    }];
    
    NSMutableArray *dataArray = [[NSMutableArray alloc] initWithObjects:@"1", @"2", @"3", nil];
    [[NSNotificationCenter defaultCenter] postNotificationName:@"postData" object:dataArray];
    
    [[[NSNotificationCenter defaultCenter] rac_addObserverForName:@"postData" object:nil] subscribeNext:^(NSNotification *notification) {
        DLog(@"%@", notification.name);
        DLog(@"%@", notification.object);
    }];
    
    //值得一提的是，RAC中的通知不需要remove observer，因为在rac_add方法中他已经写了remove。
    
    /*
     RAC中得KVO大部分都是宏定义，所以代码异常简洁，简单来说就是RACObserve(TARGET, KEYPATH)这种形式，TARGET是监听目标，KEYPATH是要观察的属性值，这里举一个很简单的例子，如果UIScrollView滚动则输出success。
     */
    UIScrollView *scrolView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, 200, 400)];
    scrolView.contentSize = CGSizeMake(200, 800);
    scrolView.backgroundColor = [UIColor greenColor];
    [self.view addSubview:scrolView];
    [RACObserve(scrolView, contentOffset) subscribeNext:^(id x) {
        DLog(@"success");
    }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
