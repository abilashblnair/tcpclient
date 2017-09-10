//
//  UtilityHandler.h
//  TCPServer
//
//  Created by Abilash Cumulations on 18/01/17.
//  Copyright © 2017 Abilash Cumulations. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface UtilityHandler : NSObject

- (instancetype)initDefault;
- (void)alertViewWithTextField:(NSString *)title withMessage:(NSString *)message withPlaceHolder:(NSString *)placeholder withCompletionHandler:(void(^)(BOOL,NSString *))block;
+ (void)alertView:(NSString *)title withMessage:(NSString *)message withCompletion:(void(^)(bool))block;
+ (BOOL)validationIsNotEmpty:(NSString *)text;
+ (void)actionSheetWithTwoType:(NSArray *)types withTitle:(NSString *)title  completion:(void(^)(NSString*))block;

+ (NSString *)getIPAddress;
@end
