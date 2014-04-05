//
//  StoreViewController.m
//  GameCenter
//
//  Created by Jon Manning on 29/11/2013.
//  Copyright (c) 2013 Jon Manning. All rights reserved.
//

#import "StoreViewController.h"
#import <StoreKit/StoreKit.h>

@interface StoreViewController () <SKProductsRequestDelegate> {
    
}

@end

@implementation StoreViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    // Do any additional setup after loading the view.
    
    NSSet* productIdentifiers = [NSSet setWithArray:@[@"ExtraMissiles01"]];
    
    SKProductsRequest* productsRequest = [[SKProductsRequest alloc] initWithProductIdentifiers:productIdentifiers];
    productsRequest.delegate = self;
    [productsRequest start];
    
	
}

- (void)productsRequest:(SKProductsRequest *)request didReceiveResponse:(SKProductsResponse *)response {
    
    for (NSString* invalidProduct in response.invalidProductIdentifiers) {
        NSLog(@"Invalid product ID: %@", invalidProduct);
    }
    
    if (response.products.count == 0) {
        NSLog(@"No products to offer!");
    }
    
    NSNumberFormatter* priceFormatter = [[NSNumberFormatter alloc] init];
    [priceFormatter setNumberStyle:NSNumberFormatterCurrencyStyle];
    [priceFormatter setLocale:[response.products.firstObject priceLocale]];
    
    for (SKProduct* product in response.products) {
        NSString* title = product.localizedTitle;
        NSString* price = [priceFormatter stringFromNumber:product.price];
        
        NSLog(@"Product: %@ (%@)", title, price);
    }
}

- (void) buyProduct:(SKProduct*)product {
    
    SKPayment* payment = [SKPayment paymentWithProduct:product];
    
    
//}
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
