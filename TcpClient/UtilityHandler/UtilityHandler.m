//
//  UtilityHandler.m
//  TCPServer
//
//  Created by Abilash Cumulations on 18/01/17.
//  Copyright © 2017 Abilash Cumulations. All rights reserved.
//

#import "UtilityHandler.h"
#include <ifaddrs.h>
#include <arpa/inet.h>

@interface UtilityHandler()<UITextFieldDelegate>

@end
@implementation UtilityHandler

- (instancetype)initDefault
{
    self = [super init];
    if (self) {
    
    }
    return self;
}

///Selecting the type of Socket method
- (void)actionSheetWithMultipleType:(void(^)(NSString*))block
{
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Socket Type" message:@"" preferredStyle:UIAlertControllerStyleActionSheet];
    [alert addAction:[UIAlertAction actionWithTitle:@"GCD" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        block(@"GCD");
    }]];
    
    [alert addAction:[UIAlertAction actionWithTitle:@"NSStream" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        block(@"Normal");
    }]];
    [alert addAction:[UIAlertAction actionWithTitle:@"UDP" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        block(@"UDP");
    }]];
    [alert addAction:[UIAlertAction actionWithTitle:@"Cancel" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        
    }]];
    
  [[UIApplication sharedApplication].keyWindow.rootViewController presentViewController:alert animated:true completion:nil];
    
}

///Selecting the type of Socket method

+ (void)actionSheetWithTwoType:(NSArray *)types withTitle:(NSString *)title  completion:(void(^)(NSString*))block
{
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:title message:@"" preferredStyle:UIAlertControllerStyleActionSheet];
    [alert addAction:[UIAlertAction actionWithTitle:[types objectAtIndex:0] style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        block([types objectAtIndex:0]);
    }]];
    
    [alert addAction:[UIAlertAction actionWithTitle:[types objectAtIndex:1] style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        block([types objectAtIndex:1]);
    }]];
    
    [alert addAction:[UIAlertAction actionWithTitle:@"Cancel" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        
    }]];
    
    [[UIApplication sharedApplication].keyWindow.rootViewController presentViewController:alert animated:true completion:nil];
    
}

- (void)alertViewWithTextField:(NSString *)title withMessage:(NSString *)message withPlaceHolder:(NSString *)placeholder withCompletionHandler:(void(^)(BOOL,NSString *))block
{
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:title message:message preferredStyle:UIAlertControllerStyleAlert];
    [alert addTextFieldWithConfigurationHandler:^(UITextField * _Nonnull textField) {
        textField.placeholder = placeholder;
        textField.delegate = self;
        textField.keyboardType = UIKeyboardTypeNumberPad;
    }];
    
    [alert addAction:[UIAlertAction actionWithTitle:@"Confirm" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [[UIApplication sharedApplication].keyWindow.rootViewController.view endEditing:true];
        block(true,[alert.textFields objectAtIndex:0].text);
    }]];
    
    [alert addAction:[UIAlertAction actionWithTitle:@"Cancel" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [[UIApplication sharedApplication].keyWindow.rootViewController.view endEditing:true];
        block(false,@"");
    }]];
    
    [[UIApplication sharedApplication].keyWindow.rootViewController presentViewController:alert animated:true completion:nil];
    
}


+ (BOOL)validationIsNotEmpty:(NSString *)text
{
    BOOL validationStatus = true;
    if (text.length == 0) {
        validationStatus = false;
    }
    return validationStatus;
}


+ (void)alertView:(NSString *)title withMessage:(NSString *)message withCompletion:(void(^)(bool))block
{
     UIAlertController *alert = [UIAlertController alertControllerWithTitle:title message:message preferredStyle:UIAlertControllerStyleAlert];
    [alert addAction:[UIAlertAction actionWithTitle:@"Ok" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        if (block != nil) {
            block(true);  
        }

    }]];
    
    [[UIApplication sharedApplication].keyWindow.rootViewController presentViewController:alert animated:true completion:nil];
    

}


+ (NSString *)getIPAddress {
    
    NSString *address = @"error";
    struct ifaddrs *interfaces = NULL;
    struct ifaddrs *temp_addr = NULL;
    int success = 0;
    // retrieve the current interfaces - returns 0 on success
    success = getifaddrs(&interfaces);
    if (success == 0) {
        // Loop through linked list of interfaces
        temp_addr = interfaces;
        while(temp_addr != NULL) {
            if(temp_addr->ifa_addr->sa_family == AF_INET) {
                // Check if interface is en0 which is the wifi connection on the iPhone
                if([[NSString stringWithUTF8String:temp_addr->ifa_name] isEqualToString:@"en0"]) {
                    // Get NSString from C String
                    address = [NSString stringWithUTF8String:inet_ntoa(((struct sockaddr_in *)temp_addr->ifa_addr)->sin_addr)];
                    
                }
                
            }
            
            temp_addr = temp_addr->ifa_next;
        }
    }
    // Free memory
    freeifaddrs(interfaces);
    return address;
    
}



#pragma mark - Textfield delegate

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return true;
}
@end
