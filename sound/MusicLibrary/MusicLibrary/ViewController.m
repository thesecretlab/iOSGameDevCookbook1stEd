//
//  ViewController.m
//  MusicLibrary
//
//  Created by Jon Manning on 6/09/13.
//  Copyright (c) 2013 Secret Lab. All rights reserved.
//

#import "ViewController.h"
#import <MediaPlayer/MediaPlayer.h>

@interface ViewController () <MPMediaPickerControllerDelegate>
@property (strong, nonatomic) IBOutlet UILabel *titleLabel;

@property (strong, nonatomic) IBOutlet UILabel *artistLabel;
@property (strong, nonatomic) IBOutlet UILabel *albumLabel;
@end

@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    [self updateTrackInformation];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(nowPlayingChanged:) name:MPMusicPlayerControllerNowPlayingItemDidChangeNotification object:nil];
    
    MPMusicPlayerController* musicPlayer = [MPMusicPlayerController iPodMusicPlayer];
    
    [musicPlayer beginGeneratingPlaybackNotifications];
}

- (void) nowPlayingChanged:(NSNotification*)notification {
    [self updateTrackInformation];
}

- (void) setPlaybackState {
    MPMusicPlayerController* musicPlayer = [MPMusicPlayerController iPodMusicPlayer];
    
    [musicPlayer playbackState];
   
    [musicPlayer play];
    [musicPlayer pause];
    [musicPlayer skipToBeginning];
    [musicPlayer skipToNextItem];
    [musicPlayer skipToPreviousItem];
    [musicPlayer beginSeekingForward];
    [musicPlayer beginSeekingBackward];
    [musicPlayer stop];
}

- (IBAction) showMediaPicker {
    MPMediaPickerController* picker = [[MPMediaPickerController alloc] initWithMediaTypes:MPMediaTypeAnyAudio];
    
    picker.allowsPickingMultipleItems = YES;
    picker.showsCloudItems = NO;
    
    picker.delegate = self;
    
    [self presentViewController:picker animated:NO completion:nil];
    
    
}


- (void)mediaPicker:(MPMediaPickerController *)mediaPicker didPickMediaItems:(MPMediaItemCollection *)mediaItemCollection {
    
    for (MPMediaItem* item in mediaItemCollection.items) {
        NSString* itemName = [item valueForProperty:MPMediaItemPropertyTitle];
        NSLog(@"Picked item: %@", itemName);
    }
    
    MPMusicPlayerController* musicPlayer = [MPMusicPlayerController iPodMusicPlayer];

    [musicPlayer setQueueWithItemCollection:mediaItemCollection];
    
    [musicPlayer play];
    
    [self dismissViewControllerAnimated:NO completion:nil];
}

- (void)mediaPickerDidCancel:(MPMediaPickerController *)mediaPicker {
    [self dismissViewControllerAnimated:NO completion:nil];
}

- (void) updateTrackInformation {
    MPMusicPlayerController* musicPlayer = [MPMusicPlayerController iPodMusicPlayer];
    
    MPMediaItem* currentTrack = musicPlayer.nowPlayingItem;
    
    NSString* title = [currentTrack valueForProperty:MPMediaItemPropertyTitle];
    NSString* artist = [currentTrack valueForProperty:MPMediaItemPropertyArtist];
    NSString* album = [currentTrack valueForProperty:MPMediaItemPropertyAlbumTitle];
    
    
    self.titleLabel.text = title;
    self.artistLabel.text = artist;
    self.albumLabel.text = album;
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
