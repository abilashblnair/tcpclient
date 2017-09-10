//
//  ConnectionInputVC.h
//  TcpClient
//
//  Created by Abilash Cumulations on 18/01/17.
//  Copyright © 2017 Abilash Cumulations. All rights reserved.
//

#import <UIKit/UIKit.h>

#define     READ                 1
#define     WRITE                2
#define     REMOTE_ID            0

@interface ConnectionInputVC : UIViewController

@property(nonatomic, strong) NSMutableData *inputBuffer;

@end
