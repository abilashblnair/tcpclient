//
//  ViewController.m
//  TcpClient
//
//  Created by Abilash Cumulations on 18/01/17.
//  Copyright © 2017 Abilash Cumulations. All rights reserved.
//

#import "ViewController.h"
#import "UtilityHandler.h"

@interface ViewController ()<UITableViewDelegate,UITableViewDataSource,UITextFieldDelegate>
{
    //Message field
    __weak IBOutlet UITextField *messageField;
    __weak IBOutlet UIView *headerView;
    __weak IBOutlet UITableView *clientTV;

    NSMutableArray *messages;
    
}
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    
    //Local message storing array to store receive and sent message to maintain tableview
    messages = [NSMutableArray new];
    
    if (_isUDP) {
        if (_isMulticast == 1) {
             self.title = [NSString stringWithFormat:@"UDP Group IP:%@",_ipAddress];
        }else
        {
            self.title = [NSString stringWithFormat:@"UDP IP:%@",_ipAddress];
        }
    }else
    {
            self.title =  [NSString stringWithFormat:@"TCP Client"];
    }
    [self setCloseConnection];
}
- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [self closeConnection];
}

- (void)closeConnection
{
    self.navigationItem.rightBarButtonItem = nil;
    if (_isUDP) {
        [_udpClientSocket close];
    }else
    {
        [_gcdClientSocket disconnect];
    }
    [self.navigationController popViewControllerAnimated:true];
}

- (void)setCloseConnection
{
    UIBarButtonItem *close = [[UIBarButtonItem alloc]initWithTitle:@"Close" style:UIBarButtonItemStylePlain target:self action:@selector(closeConnection)];
    self.navigationItem.rightBarButtonItem = close;
}

- (IBAction)didClickOnSendMessage:(id)sender
{
     [self.view endEditing:true];
    //Validating the message field is empty
    if (messageField.text.length > 0) {
    //Converting string to data to process
        NSData *data = [[NSData alloc]initWithData:[[NSString stringWithFormat:@"%@\n",messageField.text] dataUsingEncoding:NSASCIIStringEncoding]];
        
        if (!_isUDP) {
            //TCP socket write the value with time out i.e., if -1 -> Infinite time
                 [_gcdClientSocket writeData:data withTimeout:-1 tag:1];
            [messages addObject:[NSString stringWithFormat:@"Client:%@",messageField.text]];
            [clientTV reloadData];
        }else
        {
            //UDP Clinet socket send data for IP and port value with infinity timeout interval
            [_udpClientSocket sendData:data toHost:_ipAddress port:_portadd.integerValue withTimeout:-1 tag:0];
            if (_isMulticast == 0) {
                
                [messages addObject:[NSString stringWithFormat:@"Client:%@",messageField.text]];
                [clientTV reloadData];
                
            }

        }
            messageField.text = @"";
    }
}






#pragma mark -  Tableview delegate and datasource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return messages.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell" forIndexPath:indexPath];
    //Displaying the messgae on cell from array
    cell.textLabel.text = messages[indexPath.row];
    return cell;
}



#pragma mark - Uitextfield delegate

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return true;
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
    //Read the data which is sent by other connect or server
    [sender readDataWithTimeout:-1 tag:0];
    
    NSString *output = [[NSString alloc]initWithData:data encoding:NSASCIIStringEncoding];
    NSLog(@"Received Data: %@",output);
    [messages addObject:[NSString stringWithFormat:@"Server: %@",output]];
    [clientTV reloadData];
    
}

- (void)socketDidDisconnect:(GCDAsyncSocket *)sock withError:(NSError *)err
{
    if (err.code == 4) {
        [UtilityHandler alertView:@"Alert!" withMessage:@"Session timeout please connect again." withCompletion:^(bool status) {
            dispatch_async(dispatch_get_main_queue(), ^{
                [self.navigationController popViewControllerAnimated:true];
            });
        }];
    }else
    {
    [messages removeAllObjects];
    [clientTV reloadData];
    [UtilityHandler alertView:@"Alert!" withMessage:@"Server disconnected or Invalid server" withCompletion:^(bool status) {
        dispatch_async(dispatch_get_main_queue(), ^{
                [self.navigationController popViewControllerAnimated:true];
        });
    }];
    }
   

}






#pragma mark - UDP Socket delegate
- (void)udpSocket:(GCDAsyncUdpSocket *)sock didConnectToAddress:(NSData *)address
{
    
}



- (void)udpSocket:(GCDAsyncUdpSocket *)sock didSendDataWithTag:(long)tag
{
    
}
- (void)udpSocket:(GCDAsyncUdpSocket *)sock didNotSendDataWithTag:(long)tag dueToError:(NSError * _Nullable)error
{
    
}


- (void)udpSocket:(GCDAsyncUdpSocket *)sock didReceiveData:(NSData *)data
      fromAddress:(NSData *)address
withFilterContext:(nullable id)filterContext
{
    NSString *msg = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
    if (msg)
    {
        NSLog(@"RCV: %@", msg);
        NSString *host = nil;
        uint16_t port = 0;
        [GCDAsyncUdpSocket getHost:&host port:&port fromAddress:address];
        NSLog(@"Unknown message from : %@:%hu", host, port);

        [messages addObject:[NSString stringWithFormat:@"%@: %@",host,msg]];
        [clientTV reloadData];
        
        
    }
    else
    {
        NSString *host = nil;
        uint16_t port = 0;
        [GCDAsyncUdpSocket getHost:&host port:&port fromAddress:address];
        NSLog(@"Unknown message from : %@:%hu", host, port);
    }
}

/**
 * Called when the socket is closed.
 **/
- (void)udpSocketDidClose:(GCDAsyncUdpSocket *)sock withError:(NSError  * _Nullable)error
{
    
}



@end
