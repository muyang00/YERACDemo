//
//  RAC_MVVM_ViewController.m
//  YERACDemo
//
//  Created by yongen on 17/1/11.
//  Copyright © 2017年 yongen. All rights reserved.
//

#import "RAC_MVVM_ViewController.h"
#import "RACReturnSignal.h"
#import "LoginViewModel.h"

@interface RAC_MVVM_ViewController ()

@property (nonatomic, strong) UITextField *accountField;
@property (nonatomic, strong) UITextField *pwdField;
@property (nonatomic, strong) UIButton *loginBtn;

@property(nonatomic, strong) LoginViewModel *loginVM;

@end

@implementation RAC_MVVM_ViewController

- (LoginViewModel *)loginVM {
    if (!_loginVM) {
        _loginVM = [[LoginViewModel alloc] init];
    }
    return _loginVM;
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
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor whiteColor];
   
    [self configMVVM];
    
//    [self bindViewModel];
//    [self loginEvent];
}

/*
 2017-01-11 17:11:14.796 YERACDemo[99899:4640605] 点击登录按钮
 2017-01-11 17:11:14.811 YERACDemo[99899:4640605] 发送登录请求
 2017-01-11 17:11:14.843 YERACDemo[99899:4640605] --正在执行
 2017-01-11 17:11:15.390 YERACDemo[99899:4640605] 发送登录的数据
 2017-01-11 17:11:15.391 YERACDemo[99899:4640605] 执行完成
 */
- (void)bindViewModel {
    // 1.给视图模型的账号和密码绑定信号
    RAC(self.loginVM, account) = self.accountField.rac_textSignal;
    RAC(self.loginVM, pwd) = self.pwdField.rac_textSignal;
    
}
- (void)loginEvent {
    // 1.处理文本框业务逻辑--- 设置按钮是否能点击
    RAC(self.loginBtn, enabled) = self.loginVM.loginEnableSignal;
    // 2.监听登录按钮点击
    [[self.loginBtn rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(id x) {
        NSLog(@"点击登录按钮");
        // 处理登录事件
        [self.loginVM.loginCommand execute:nil];
        
    }];
}

- (void)configMVVM{
    
    
    RACSignal *loginEnableSignal = [RACSignal combineLatest:@[self.accountField.rac_textSignal, self.pwdField.rac_textSignal] reduce:^id(NSString *account, NSString *pwd){
        return @(account.length && pwd.length);
    }];
    
    RAC(self.loginBtn, enabled) = loginEnableSignal;
    
    RACCommand *command = [[RACCommand alloc]initWithSignalBlock:^RACSignal*(id input){
        
        return [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber){
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                [subscriber sendNext:@"fas数据"];
                [subscriber sendCompleted];
            });
            
            return nil;
        }];
    }];
    //获取命令中的信号源
    [command.executionSignals.switchToLatest subscribeNext:^(id x){
        NSLog(@"%@", x);
        
    }];
    //监听命令执行过程
    [[command.executing skip:1] subscribeNext:^(id x){//跳过第一步，没有执行这步
        if ([x boolValue] == YES) {
            NSLog(@"--------正在执行");
            // 显示蒙版
        }else{//执行完成
            NSLog(@"执行完成");
            //取消蒙版
        }
    }];
    
    //监听登录按钮点击
    [[self.loginBtn rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(id x){
        NSLog(@"点击登录按钮");
        //处理登录事件
        [command execute:nil];
    }];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
