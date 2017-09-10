//
//  ConnectionInputVC.m
//  TcpClient
//
//  Created by Abilash Cumulations on 18/01/17.
//  Copyright © 2017 Abilash Cumulations. All rights reserved.
//

#import "ConnectionInputVC.h"
#import "UtilityHandler.h"
#import "ViewController.h"
#import "LUCI_Packet.h"
#import <AVFoundation/AVFoundation.h>

@interface ConnectionInputVC ()<UITextFieldDelegate,GCDAsyncSocketDelegate>
{
    __weak IBOutlet UITextField *ipField;
    
    __weak IBOutlet UITextField *portField;
    
    __weak IBOutlet UITextField *messageBoxField;
    BOOL isUDP;
    
    __weak IBOutlet NSLayoutConstraint *heightOfCommunicationView;
    int isMulticast;
    __weak IBOutlet UIView *messageView;
    __weak IBOutlet UIView *connectionView;
    __weak IBOutlet UISegmentedControl *typeSegmentor;
    
    __weak IBOutlet UITextField *messageField;
    __weak IBOutlet UITextView *outputField;
    GCDAsyncSocket *gcdClientSocket;
    
    __weak IBOutlet UILabel *outputLabel;
    NSString *outputMessage;
}

@property (strong, nonatomic) AVPlayer *player;
@end

@implementation ConnectionInputVC

- (void)viewDidLoad {
    [super viewDidLoad];
    outputMessage = @"";
    messageView.hidden = true;
    // Do any additional setup after loading the view.
//    [self actionSheetTochangeView:^(BOOL gcdType) {
//        isUDP = gcdType;
//        if (isUDP) {
//            [UtilityHandler actionSheetWithTwoType:@[@"Unicast",@"Multicast"] withTitle:@"UDP cast Type" completion:^(NSString *udptype) {
//                if ([udptype isEqualToString:@"Unicast"]) {
//                    isMulticast = 0;
//                }else
//                {
//                    isMulticast = 1;
//                }
//            }];
//        }
//    }];
    
    [self manageConnectionView:false];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    ipField.text = @"";
    portField.text = @"";
    
}


- (void)manageConnectionView:(BOOL)isMessage
{
    dispatch_async(dispatch_get_main_queue(), ^{
        if (isMessage) {
            [UIView animateWithDuration:0.5 animations:^{
                messageView.hidden = false;
                heightOfCommunicationView.constant = 0;
                [self.view layoutIfNeeded];
            } completion:^(BOOL finished) {
                connectionView.hidden = true;
                outputField.hidden = false;
                outputLabel.hidden = false;
            }];
            
        }else
        {
            [UIView animateWithDuration:0.5 animations:^{
                connectionView.hidden = false;
                heightOfCommunicationView.constant = 165;
                [self.view layoutIfNeeded];
                
            } completion:^(BOOL finished) {
                outputLabel.hidden = true;
                messageView.hidden = true;
                outputField.hidden = true;
                outputField.text = @"";
            }];
        }
 
    });
}
///Selecting the type of Socket method
- (void)actionSheetTochangeView:(void(^)(BOOL))block
{
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Socket Type" message:@"" preferredStyle:UIAlertControllerStyleActionSheet];
    
    [alert addAction:[UIAlertAction actionWithTitle:@"TCP" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        block(false);
    }]];
    [alert addAction:[UIAlertAction actionWithTitle:@"UDP" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        block(true);
    }]];
    [alert addAction:[UIAlertAction actionWithTitle:@"Cancel" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        block(false);
    }]];
    
    [self presentViewController:alert animated:true completion:nil];
    
    
}

- (IBAction)didConnectToServer:(id)sender
{
    [self.view endEditing:true];
    if ([self validation]) {
        if (!isUDP) {
            gcdClientSocket = [[GCDAsyncSocket alloc]initWithDelegate:self delegateQueue:dispatch_get_main_queue()];
            NSError *error;
            if (![gcdClientSocket connectToHost:ipField.text onPort:portField.text.integerValue error:&error]) {
                NSLog(@"Error occured during socket connecting to client %@",error.localizedDescription);
                [UtilityHandler alertView:@"Alert!" withMessage:@"Unable to connet to server" withCompletion:nil];
                return;
            }else
            {
                [self manageConnectionView:true];
                 [UtilityHandler alertView:@"Success!" withMessage:@"Connect to device successfully, you are now ready to communicate with device." withCompletion:nil];
                
                dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                    [self sendMessage:[UtilityHandler getIPAddress] MBno:3 MsgType:WRITE];

                });
            }
        }
        
    }
}


//- (IBAction)didConnectToServer:(id)sender
//{
//    ViewController *controller = [self.storyboard instantiateViewControllerWithIdentifier:@"ViewController"];
//    if ([self validation]) {
//
//        if (!isUDP) {
//
//            controller.gcdClientSocket = [[GCDAsyncSocket alloc]initWithDelegate:controller delegateQueue:dispatch_get_main_queue()];
//            NSError *error;
//            if (![controller.gcdClientSocket connectToHost:ipField.text onPort:portField.text.integerValue error:&error]) {
//                NSLog(@"Error occured during socket connecting to client %@",error.localizedDescription);
//                [UtilityHandler alertView:@"Alert!" withMessage:@"Unable to connet to server" withCompletion:nil];
//                return;
//            }
//
//        }else
//        {
//            controller.udpClientSocket = [[GCDAsyncUdpSocket alloc]initWithDelegate:controller delegateQueue:dispatch_get_main_queue()];
//
//            if (isMulticast == 1) {
//                NSError *error = nil;
//                if (![controller.udpClientSocket bindToPort:portField.text.integerValue error:&error]) {
//                    NSLog(@"Error in acceptOnPort:error: -> %@", error);
//                    [UtilityHandler alertView:@"Alert!" withMessage:@"Failed to create socket." withCompletion:nil];
//                    return;
//
//                }else
//                {
//                    [controller.udpClientSocket beginReceiving:&error];
//                    if (![controller.udpClientSocket joinMulticastGroup:ipField.text error:&error]) {
//                        [UtilityHandler alertView:@"Alert!" withMessage:@"Failed to connect to multicast group socket." withCompletion:nil];
//                        return;
//
//                    }
//                }
//
//
//            }
//            controller.isMulticast = isMulticast;
//            controller.ipAddress = ipField.text;
//            controller.portadd = portField.text;
//            controller.isUDP = isUDP;
//
//
//        }
//        [self.navigationController pushViewController:controller animated:true];
//    }
//}


- (BOOL)validation
{
    BOOL validationStatus = true;
    if (![UtilityHandler validationIsNotEmpty:ipField.text]) {
        [UtilityHandler alertView:@"Alert!" withMessage:@"Ip address is empty." withCompletion:nil];
        validationStatus = false;
    }else if (![UtilityHandler validationIsNotEmpty:portField.text]) {
        [UtilityHandler alertView:@"Alert!" withMessage:@"Port field is empty." withCompletion:nil];
        validationStatus = false;
    }
    return validationStatus;
}
- (IBAction)didChangeType:(UISegmentedControl *)sender {
    
}

#pragma mark - Uitextfield delegate

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return true;
}

- (IBAction)didSendMessageToDevice:(id)sender
{
    [self.view endEditing:true];
    [self sendMessage:messageField.text MBno:[messageBoxField.text intValue] MsgType:typeSegmentor.selectedSegmentIndex == 0 ? WRITE : READ];
    messageField.text = @"";
    messageBoxField.text = @"";
}



#pragma mark - GCD Socket delegate
- (void)socket:(GCDAsyncSocket *)sender didConnectToHost:(NSString *)host port:(UInt16)port
{
    NSLog(@"Cool, I'm connected! That was easy.");
    
    [sender readDataWithTimeout:-1 tag:0];
}

- (void)socket:(GCDAsyncSocket *)sock didWriteDataWithTag:(long)tag
{
    NSLog(@"Written data delegate passed");
}

- (void)socket:(GCDAsyncSocket *)sender didReadData:(NSData *)data withTag:(long)tag
{

    NSString *msg = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
    
    NSLog(@"MSG: %@",msg);
    outputMessage = msg;
    
    outputField.text = outputMessage;
    if ([msg containsString:@"http"]) {
    
       msg =  [msg stringByReplacingOccurrencesOfString:@" " withString:@"%20"];
        
        NSURL *url = [NSURL URLWithString:msg];
        
        
        self.player = [[AVPlayer alloc] initWithURL:url];
               [self.player play];

    }
    
    //[self processResponse:data from:ipField.text];
    [sender readDataWithTimeout:-1 tag:0];
    
    
}

- (void)socketDidDisconnect:(GCDAsyncSocket *)sock withError:(NSError *)err
{
    if (err.code == 4) {
        [UtilityHandler alertView:@"Alert!" withMessage:@"Session timeout please connect again." withCompletion:^(bool status) {
            dispatch_async(dispatch_get_main_queue(), ^{
                [self manageConnectionView:false];
            });
        }];
    }else
    {
        //        [messages removeAllObjects];
        //        [clientTV reloadData];
        [UtilityHandler alertView:@"Alert!" withMessage:@"Server disconnected or Invalid server" withCompletion:^(bool status) {
            dispatch_async(dispatch_get_main_queue(), ^{
                [self manageConnectionView:false];
            });
        }];
    }
    
    
}



#pragma mark -  Send message to device

-(void) sendMessage:(NSString*)message  MBno:(int)mbno MsgType:(int)messageType
{
    NSLog(@"a<--TCP  message=%@,MB no =%d,Message Type =%d IP = %@",message,mbno,messageType,[gcdClientSocket connectedHost]);
    if([gcdClientSocket isConnected])
    {
        NSData* msgData = [message dataUsingEncoding:NSUTF8StringEncoding];
        LUCI_Packet *packet = [[LUCI_Packet alloc] initLUCIPacket:msgData message_size:[msgData length] MBNo:mbno CommandType:messageType];
        
        NSMutableData *packetData = [[NSMutableData alloc] init];
        [packet getpacket:packetData];
        
        [gcdClientSocket writeData:packetData withTimeout:-1 tag:0];
        [gcdClientSocket readDataWithTimeout:-1 tag:0];
        NSMutableDictionary *socketInfo = [[NSMutableDictionary alloc] init];
        [socketInfo setObject:gcdClientSocket forKey:@"SocketInfo"];
        
    }
}



-(NSString *) parseFirstLine:(NSString*)msg
{
    NSCharacterSet *newline = [NSCharacterSet newlineCharacterSet];
    NSScanner *msgScanner = [NSScanner scannerWithString:msg];
    [msgScanner setCaseSensitive:NO];
    [msgScanner setCharactersToBeSkipped:nil];
    NSString *out;
    [msgScanner scanUpToCharactersFromSet:newline intoString:&out];
    //NSLog(@"a<--Value Found=%@",out);
    return out;
    
}


- (void)processResponse:(NSData *)Packet from:(NSString *)IP
{

    @synchronized (_inputBuffer)
    {
        
        if(_inputBuffer == nil)
            _inputBuffer = [[NSMutableData alloc] initWithLength:0];
        
        [_inputBuffer appendData:Packet];
        unsigned char *arrayr = (unsigned char *)[_inputBuffer bytes];
        
        int remoteID = arrayr[0] || arrayr[1];
        
        if(remoteID == REMOTE_ID)
        {
            int luciDataSize = arrayr[8]*256 + arrayr[9];
            
            // if datasize is more than buffer size wait for next chunk
            if(luciDataSize >  ([_inputBuffer length]-10))
            {
                //                NSLog(@"Javed -->JSON Error [inputeBuffer length] = %lu, luciDataSize = %d",(unsigned long)[_inputBuffer length],luciDataSize);
                return;
            }
            //            NSLog(@"Javed -->JSON [inputeBuffer length] = %lu, luciDataSize = %d",(unsigned long)[_inputBuffer length],luciDataSize);
            NSData *luciPacket = [NSData dataWithData:_inputBuffer];
            [_inputBuffer setLength:0];
            
            NSInteger buff_size = [luciPacket length];
            NSInteger offset = 0;
            while ((buff_size - offset) >10)
            {
                unsigned char *luciArray = (unsigned char *)[luciPacket bytes];
                
                int msgBox = luciArray[offset+3]*16 + luciArray[offset+4];
                NSString *msgBoxStr = [NSString stringWithFormat: @"%d", msgBox];
                
                int commandType = luciArray[offset+2];
                
                NSString *commandTypeStr = [NSString stringWithFormat: @"%d", commandType];
                
                int dataSize = luciArray[offset+8]*256 + luciArray[offset+9];
                
                NSLog(@"a<--msg box=%d,dataSize=%d, msgbox =%@ , Command Type = %@",msgBox,dataSize,msgBoxStr,commandTypeStr);
                
                if(dataSize >0)
                {
                    //check the remaining buffer, if it is doesnt have data mentioned in datasize ignore.
                    NSInteger remainingBufferSize = buff_size - offset ;
                    
                    if((remainingBufferSize-10) >= dataSize)//10 bytes header
                    {
                        NSData *payload = [luciPacket subdataWithRange:NSMakeRange(offset+10, dataSize)];

                        NSString *msg = [[NSString alloc] initWithData:payload encoding:NSUTF8StringEncoding];
                        NSString *startLine = [self parseFirstLine:msg];
                        
                    
                        
                        NSLog(@"Starting line =========== %@",startLine);
                        NSLog(@"Recieved TCP NOTIFY from %@",msg);
                        
                        outputMessage = [NSString stringWithFormat:@"Type: %@\nMsg Box: %d\nValue: %@",commandType == 1 ? @"GET":@"SET",msgBox,msg];
                        
                        outputField.text = outputMessage;

                        

                    }
                    else
                    {
                        _inputBuffer = [NSMutableData dataWithData:[luciPacket subdataWithRange:NSMakeRange(offset, buff_size-offset)] ];
                        return;//doesnt have enough data
                    }
                    
                }
                offset += dataSize + 10;
            }
        }
        else
        {
            NSLog(@"REMOTE ID wrong");
            [_inputBuffer setLength:0];
        }
    }
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
