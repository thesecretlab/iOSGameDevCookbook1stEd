//
//  ViewController.m
//  PerlinNoise
//
//  Created by Jon Manning on 6/03/2014.
//  Copyright (c) 2014 Secret Lab. All rights reserved.
//

#import "ViewController.h"
#import "PerlinNoise.h"

@interface ViewController ()

@property (weak, nonatomic) IBOutlet UIImageView *perlinNoiseView;
@property (weak, nonatomic) IBOutlet UISlider *seedSlider;
@property (weak, nonatomic) IBOutlet UISlider *persistenceSlider;
@property (weak, nonatomic) IBOutlet UISlider *octavesSlider;

@property (weak, nonatomic) IBOutlet UILabel *seedLabel;
@property (weak, nonatomic) IBOutlet UILabel *persistenceLabel;
@property (weak, nonatomic) IBOutlet UILabel *octavesLabel;


@property (weak, nonatomic) IBOutlet UIButton *updateButton;
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *spinnerView;
@end

@implementation ViewController

- (IBAction) updateNoiseView {
    self.updateButton.enabled = NO;
    self.updateButton.alpha = 0.5;
    [self.spinnerView startAnimating];
    
    CGSize size = self.perlinNoiseView.bounds.size;
    
    [[PerlinNoise noise] imageWithSize:size
                           persistence:self.persistenceSlider.value
                               octaves:self.octavesSlider.value
                                  seed:self.seedSlider.value completion:^(UIImage *image) {
                                      
                                      self.perlinNoiseView.image = image;
                                      
                                      self.updateButton.enabled = YES;
                                      self.updateButton.alpha = 1.0;
                                      [self.spinnerView stopAnimating];
                                      
                                  }];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    
    [self updateNoiseView];
    [self updateLabels];
    
}

- (void) updateLabels {
    self.seedLabel.text = [NSString stringWithFormat:@"%i", (int)self.seedSlider.value];
    self.octavesLabel.text = [NSString stringWithFormat:@"%i", (int)self.octavesSlider.value];
    self.persistenceLabel.text = [NSString stringWithFormat:@"%.2f",  self.persistenceSlider.value];
    
}

- (IBAction)sliderUpdated:(id)sender {
    [self updateLabels];
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
