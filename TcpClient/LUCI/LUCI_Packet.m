//
//  LUCI_Packet.m
//  DDMS
//
//  Created by Akshay Vernekar on 17/09/14.
//  Copyright (c) 2014 Libre Wireless Technologies. All rights reserved.
//

#import "LUCI_Packet.h"

@implementation LUCI_Packet

-(id)initLUCIPacket:(NSData *)message message_size:(short)mSize Command:(short )aCommand
{
    remoteID=0;
    CommandType = 2;
    Command=aCommand;
    CommandStatus=0;
    CRC=0;
    DataLen=mSize;
    
    
    
    //get the header bitsream:
    Byte bytes[HEADER_SIZE];
    
    bytes[0] = remoteID & 0x00FF;
    bytes[1] = ((remoteID & 0xFF00)>> 8);
    bytes[2] = (CommandType & 0x00FF);
    bytes[3] = (Command & 0x00FF);
    bytes[4] = ((Command & 0xFF00)>> 8);
    bytes[5] = CommandStatus;
    bytes[6] = (CRC & 0x00FF);
    bytes[7] = ((CRC & 0xFF00)>> 8);
    bytes[8] = (DataLen & 0x00FF);
    bytes[9] = ((DataLen & 0xFF00)>> 8);
    
    header = [NSMutableData dataWithBytes:bytes length:HEADER_SIZE];
    //NSLog(@"a< LUCI header=%@",header);
    
    payload_size =  mSize;
    //NSLog(@"a< LUCI payload=%@",message);
    payload = [[NSMutableData alloc]init];
    [payload setData:message];
    //NSLog(@"a< LUCI payload=%@",payload);
    return self;
    
}

-(id)initLUCIPacket:(NSData *)message message_size:(short)mSize MBNo:(short )aCommand CommandType:(short)CommType
{
    remoteID=0;
    CommandType = CommType;
    Command=aCommand;
    CommandStatus=0;
    CRC=0;
    DataLen=mSize;
    
    
    
    //get the header bitsream:
    Byte bytes[HEADER_SIZE];
    
    bytes[0] = remoteID & 0x00FF;
    bytes[1] = ((remoteID & 0xFF00)>> 8);
    bytes[2] = (CommandType & 0x00FF);
    bytes[3] = (Command & 0x00FF);
    bytes[4] = ((Command & 0xFF00)>> 8);
    bytes[5] = CommandStatus;
    bytes[6] = (CRC & 0x00FF);
    bytes[7] = ((CRC & 0xFF00)>> 8);
    bytes[8] = (DataLen & 0x00FF);
    bytes[9] = ((DataLen & 0xFF00)>> 8);
    
    header = [NSMutableData dataWithBytes:bytes length:HEADER_SIZE];
    //NSLog(@"a< LUCI header=%@",header);
    
    payload_size =  mSize;
    //payload = [NSMutableData dataWithBytes:(__bridge const void *)(message) length:payload_size];
    //NSLog(@"a< LUCI payload=%@",message);
    payload = [[NSMutableData alloc]init];
    [payload setData:message];
    //NSLog(@"a< LUCI payload=%@",payload);
    return self;
    
}


-(int) getpayloaddata:(NSMutableData*)message
{
    [message setData:payload];
    return payload_size;
}

-(int) getpayload_length
{
    return payload_size;
}

-(int) getlength
{
    return(payload_size + HEADER_SIZE);
}

-(int) getpacket:(NSMutableData*)packet
{
    //construct the packet = header + payload
    //NSLog(@"internal header=%@",header);
    [packet setData:header];
    //NSLog(@"header=%@",packet);
    
    //NSLog(@"internal header=%@",payload);
    [packet appendData:payload];
    //NSLog(@"header=%@",packet);

    //return total size of the packet
    return(payload_size + HEADER_SIZE);
}

@end
