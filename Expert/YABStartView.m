//
//  YABStartView.m
//  Expert
//
//  Created by Ian Shafer on 11/20/13.
//  Copyright (c) 2013 Yabbly. All rights reserved.
//

#import "YABStartView.h"
#import "YABRestClient.h"

@interface YABStartView () <UITextViewDelegate, UITextFieldDelegate>

@end

@implementation YABStartView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        _descriptionTextView = [[UITextView alloc] initWithFrame:CGRectNull];
        _descriptionTextView.keyboardType = UIKeyboardTypeDefault;
        _descriptionTextView.delegate = self;

        _phoneNumberTextField = [[UITextField alloc] initWithFrame:CGRectNull];
        _phoneNumberTextField.placeholder = @"Phone number";
        _phoneNumberTextField.keyboardType = UIKeyboardTypePhonePad;

        _askAnExpertButton = [UIButton buttonWithType:UIButtonTypeSystem];
        [_askAnExpertButton setTitle:@"Ask an Expert" forState:UIControlStateNormal];
        [_askAnExpertButton addTarget:self action:@selector(handleAskAnExpertAction:) forControlEvents:UIControlEventTouchUpInside];
    }
    return self;
}

- (void)layoutSubviews
{
    CGRect formRect, buttonRect;
    CGRectDivide(self.frame, &buttonRect, &formRect, 50.f, CGRectMaxYEdge);

    CGRect descriptionRect, phoneRect;
    CGRectDivide(formRect, &phoneRect, &descriptionRect, 50.f, CGRectMaxYEdge);

    _descriptionTextView.frame = descriptionRect;
    [self addSubview:_descriptionTextView];

    _phoneNumberTextField.frame = phoneRect;
    [self addSubview:_phoneNumberTextField];

    _askAnExpertButton.frame = buttonRect;
    [self addSubview:_askAnExpertButton];
}

- (void)handleAskAnExpertAction:(id)sender
{
    NSLog(@"Ask an Expert touched");
    [[UIApplication sharedApplication] registerForRemoteNotificationTypes:
     (UIRemoteNotificationTypeBadge | UIRemoteNotificationTypeAlert | UIRemoteNotificationTypeSound)];

    [[YABRestClient singleton] findUserByPhoneNumber:_phoneNumberTextField.text
                                           onSuccess:^(NSArray *users) {
                                               NSLog(@"Found [%d] users", users.count);
                                           }
                                             onError:^(NSError *error) {
                                                 NSLog(@"Error [%@]", error.description);
                                             }];
}

- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text
{
    if ([text isEqualToString:@"\n"]) {
        [_descriptionTextView resignFirstResponder];
        return NO;
    }
    return YES;
}

@end
