//
//  MainMenuViewController.m
//  CreatingViewControllers
//
//  Created by Jon Manning on 1/09/13.
//  Copyright (c) 2013 Secret Lab. All rights reserved.
//

#import "MainMenuViewController.h"

@interface MainMenuViewController ()
@property (strong, nonatomic) IBOutlet UITextField *textField;

@end

@implementation MainMenuViewController

- (IBAction)buttonPressed:(id)sender {
    UIAlertView* alertView = [[UIAlertView alloc] init];
    alertView.title = @"Button tapped";
    alertView.message = @"The button was tapped!";
    [alertView addButtonWithTitle:@"OK"];
    [alertView show];
}

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
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
