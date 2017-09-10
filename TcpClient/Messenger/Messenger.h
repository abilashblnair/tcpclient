//
//  Messenger.h
//  TcpClient
//
//  Created by Abilash Cumulations on 07/06/17.
//  Copyright © 2017 Abilash Cumulations. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "GCDAsyncSocket.h"

@interface Messenger : NSObject

- (id)initWithSocket:(GCDAsyncSocket *)socket;

@property (nonatomic,strong) GCDAsyncSocket *asyncSocket;
@property (nonatomic,assign) NSInteger port;
@property (nonatomic,strong) NSString *ipAddress;

-(void) sendMessage:(NSString*)message  MBno:(int)mbno MsgType:(int)messageType;
@end
