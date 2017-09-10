//
//  LUCI_Packet.h
//  DDMS
//
//  Created by Akshay Vernekar on 17/09/14.
//  Copyright (c) 2014 Libre Wireless Technologies. All rights reserved.
//

#import <Foundation/Foundation.h>

static int HEADER_SIZE = 10;

@interface LUCI_Packet : NSObject
{
    
    NSString *TAG ;
    short remoteID;
    short CommandType;
    short Command;
    short CommandStatus;
    short CRC;
    short DataLen;
    
    
    //Bitstream of the LUCI header
    NSMutableData *header ;
    
    //size of the LUCI payload
    int payload_size;
    
    //Bitstream of the LUCI payload
    NSMutableData *payload;
	
}


-(id) initLUCIPacket:(NSData*)message message_size:(short)mSize Command:(short)aCommand;
-(id)initLUCIPacket:(NSData *)message message_size:(short)mSize MBNo:(short )aCommand CommandType:(short)CommType;
-(int) getpayloaddata:(NSData*)message;
-(int) getpayload_length;
-(int) getlength;
-(int) getpacket:(NSData*)packet;


@end
