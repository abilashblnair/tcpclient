//
//  ViewController.h
//  TcpClient
//
//  Created by Abilash Cumulations on 18/01/17.
//  Copyright © 2017 Abilash Cumulations. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GCDAsyncSocket.h"
#import "GCDAsyncUdpSocket.h"

//#define isMulticast 1

@interface ViewController : UIViewController<GCDAsyncSocketDelegate,GCDAsyncUdpSocketDelegate>

@property (nonatomic,strong) GCDAsyncSocket *gcdClientSocket;
@property (nonatomic,strong) GCDAsyncUdpSocket *udpClientSocket;

@property (nonatomic,assign) BOOL isUDP;
@property (nonatomic,assign) NSInteger isMulticast;
@property (nonatomic,strong) NSString *ipAddress;
@property (nonatomic,strong) NSString *portadd;
@end

