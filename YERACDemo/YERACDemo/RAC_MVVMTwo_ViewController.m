//
//  RAC_MVVMTwo_ViewController.m
//  YERACDemo
//
//  Created by yongen on 17/2/14.
//  Copyright © 2017年 yongen. All rights reserved.
//

#import "RAC_MVVMTwo_ViewController.h"
#import "LoginViewModel.h"

@interface RAC_MVVMTwo_ViewController ()

@property (nonatomic, strong) UITextField *accountField;
@property (nonatomic, strong) UITextField *pwdField;
@property (nonatomic, strong) UIButton *loginBtn;
@property(nonatomic, strong) LoginViewModel *loginVM;

@end

@implementation RAC_MVVMTwo_ViewController

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
    // MVVM:
    // VM:视图模型----处理展示的业务逻辑  最好不要包括视图
    // 每一个控制器都对应一个VM模型
    // MVVM:开发中先创建VM，把业务逻辑处理好，然后在控制器里执行
    self.view.backgroundColor = [UIColor whiteColor];
    [self bindViewModel];
    [self loginEvent];
}

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
