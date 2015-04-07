//
//  ViewController.m
//  VerticalScrollView
//
//  Created by Kevin on 4/6/15.
//  Copyright (c) 2015 makr.space. All rights reserved.
//

#import "ViewController.h"

@interface ViewController () <UIScrollViewDelegate, UITextFieldDelegate>

@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;
@property (weak, nonatomic) IBOutlet UIView *contentView;
@property (weak, nonatomic) IBOutlet UITextField *usernameTextField;
@property (weak, nonatomic) IBOutlet UITextField *passwordTextField;
@property (weak, nonatomic) IBOutlet UIImageView *logoImageView;
@property (weak, nonatomic) IBOutlet UIButton *loginButton;
@property CGSize kbSize;
@property BOOL didLoginChange;

@end

@implementation ViewController

- (void)viewWillAppear:(BOOL)animated
{
    [self registerForKeyboardNotifications];
    [self setUpUIElementsAndLogo];
}

- (void)viewWillDisappear:(BOOL)animated {

    [self deregisterFromKeyboardNotifications];
    [super viewWillDisappear:animated];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self tapGestureRecognizerEndsEditing];
    [self setScrollViewDelegateAndTextFieldDelegate];
    self.didLoginChange = YES;

}

- (void)setUpUIElementsAndLogo
{
    self.scrollView.backgroundColor = [UIColor whiteColor];
    self.loginButton.backgroundColor = [UIColor colorWithRed:231/255.0 green:226/255.0 blue:71/255.0 alpha:1];
    [self.loginButton setTitleColor:[UIColor colorWithRed:63/255.0 green:124/255.0 blue:172/255.0 alpha:1] forState:UIControlStateNormal];
    self.contentView.backgroundColor = [UIColor colorWithRed:63/255.0 green:124/255.0 blue:172/255.0 alpha:1];
    self.logoImageView.image = [UIImage imageNamed:@"controller"];
}

- (void)tapGestureRecognizerEndsEditing
{
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]
                                   initWithTarget:self
                                   action:@selector(dismissKeyboard)];

    [self.view addGestureRecognizer:tap];
}

- (void)dismissKeyboard
{
    [self.view endEditing:YES];
}

- (void)registerForKeyboardNotifications
{
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWasShown:)
                                                 name:UIKeyboardDidShowNotification
                                               object:nil];

    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillBeHidden:)
                                                 name:UIKeyboardWillHideNotification
                                               object:nil];
}

- (void)deregisterFromKeyboardNotifications
{
    [[NSNotificationCenter defaultCenter] removeObserver:self
                                                    name:UIKeyboardDidHideNotification
                                                  object:nil];

    [[NSNotificationCenter defaultCenter] removeObserver:self
                                                    name:UIKeyboardWillHideNotification
                                                  object:nil];
}

- (void)keyboardWasShown:(NSNotification *)notification {

    NSDictionary *info = [notification userInfo];

    self.kbSize = [[info objectForKey:UIKeyboardFrameBeginUserInfoKey] CGRectValue].size;

    UIEdgeInsets contentInsets = UIEdgeInsetsMake(0.0, 0.0, self.kbSize.height, 0.0);
    self.scrollView.contentInset = contentInsets;
    self.scrollView.scrollIndicatorInsets = contentInsets;

    CGRect aRect = self.view.frame;
    aRect.size.height -= self.kbSize.height;

    // iPhone 4S screen is 480. I move the scrollview higher by +100 to account for small screen dimension
    if (!CGRectContainsPoint(aRect, self.loginButton.frame.origin) && (self.view.frame.size.height == 480))
    {
        CGPoint scrollPoint = CGPointMake(0.0, self.loginButton.frame.origin.y-self.kbSize.height+100);
        [self.scrollView setContentOffset:scrollPoint animated:YES];
    }
    // this will account for anything above a iPhone 4S
    else if (!CGRectContainsPoint(aRect, self.loginButton.frame.origin) && (self.view.frame.size.height > 480))
    {
        CGPoint scrollPoint = CGPointMake(0.0, self.loginButton.frame.origin.y-self.kbSize.height);
        [self.scrollView setContentOffset:scrollPoint animated:YES];
    }

    self.scrollView.scrollEnabled = false;
}

- (void)keyboardWillBeHidden:(NSNotification *)notification
{
    [self.scrollView setContentOffset:CGPointZero animated:YES];
}

- (void)setScrollViewDelegateAndTextFieldDelegate
{
    self.scrollView.delegate = self;
    self.usernameTextField.delegate = self;
    self.passwordTextField.delegate = self;
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    if
        (textField == self.usernameTextField)
    {
        [textField resignFirstResponder];
        [self.passwordTextField becomeFirstResponder];
    }
    else if
        (textField == self.passwordTextField)
    {
        [textField resignFirstResponder];
    }
    return YES;
}


- (IBAction)loginButtonTapped:(UIButton *)sender
{
    if (self.didLoginChange == YES)
    {
        self.loginButton.backgroundColor = [UIColor whiteColor];
        self.didLoginChange = NO;
    }
    else
    {
        self.loginButton.backgroundColor = [UIColor colorWithRed:231/255.0 green:226/255.0 blue:71/255.0 alpha:1];
        self.didLoginChange = YES;
    }

}



@end
