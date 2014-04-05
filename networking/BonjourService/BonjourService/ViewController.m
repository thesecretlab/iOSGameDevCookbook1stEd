//
//  ViewController.m
//  BonjourService
//
//  Created by Jon Manning on 12/06/13.
//  Copyright (c) 2013 Secret Lab. All rights reserved.
//

#import "ViewController.h"

@interface ViewController () <NSNetServiceDelegate> {
    NSNetService* netService;
}

@end

@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    
    netService = [[NSNetService alloc] initWithDomain:@"" type:@"_myserver._tcp" name:@"" port:9090];
    [netService setDelegate:self];
    
    NSDictionary* TXTRecord = @{@"serverVersion":@"1"};
    
    netService.TXTRecordData = [NSNetService dataFromTXTRecordDictionary:TXTRecord];
    
    [netService publish];
}

- (void)netServiceDidPublish:(NSNetService *)sender {
    NSLog(@"Net service published: %@", sender);
}

- (void)netService:(NSNetService *)sender didNotPublish:(NSDictionary *)errorDict {
    NSLog(@"Net service failed to publish: %@", errorDict);
}

- (void) stopPublishing {
    [netService stop];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
