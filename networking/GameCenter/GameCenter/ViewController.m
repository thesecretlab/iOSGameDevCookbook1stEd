//
//  ViewController.m
//  GameCenter
//
//  Created by Jon Manning on 19/11/2013.
//  Copyright (c) 2013 Jon Manning. All rights reserved.
//

#import "ViewController.h"
#import <GameKit/GameKit.h>
#import <MultipeerConnectivity/MultipeerConnectivity.h>

@interface ViewController () <GKGameCenterControllerDelegate, GKMatchmakerViewControllerDelegate, MCBrowserViewControllerDelegate, MCSessionDelegate, GKMatchDelegate, GKTurnBasedMatchmakerViewControllerDelegate, GKTurnBasedEventListener>
@property (weak, nonatomic) IBOutlet UIImageView *playerPhotoView;
@property (weak, nonatomic) IBOutlet UILabel *playerName;

@property (strong) NSArray* friendPlayerIDs;

@property (strong) MCPeerID* localPeerID;
@property (strong) MCSession* session;

@property (strong) MCAdvertiserAssistant* advertiser;

@end

@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    
#warning Uncomment this
    //[self authenticatePlayer];
    
}
    
- (void) authenticatePlayer {
    GKLocalPlayer* localPlayer = [GKLocalPlayer localPlayer];
    
    localPlayer.authenticateHandler = ^(UIViewController* viewController, NSError* error) {
        if (viewController != nil) {
            [self presentViewController:viewController animated:YES completion:nil];
        } else if (localPlayer.isAuthenticated) {
            // We're now authenticated!
            [self playerWasAuthenticated];
        } else {
            // Game Center is unavailable, either due to the network or because the player has turned it off.
        }
    };
}

- (IBAction)hostLocalGame {
    NSString* playerID = [NSString stringWithFormat:@"Player %i", arc4random_uniform(8)];
    
    self.localPeerID = [[MCPeerID alloc] initWithDisplayName:playerID];
    
    self.session = [[MCSession alloc] initWithPeer:self.localPeerID];
    self.session.delegate = self;
    
    NSString* serviceType = @"mygame-v1"; // should be unique
    self.advertiser = [[MCAdvertiserAssistant alloc] initWithServiceType:serviceType discoveryInfo:nil session:self.session];
    [self.advertiser start];
    
    
}

- (void)session:(MCSession *)session peer:(MCPeerID *)peerID didChangeState:(MCSessionState)state {
    // A peer has changed state - it's now either connecting, connected, or disconnected.
}

- (void)session:(MCSession *)session didReceiveData:(NSData *)data fromPeer:(MCPeerID *)peerID {
    // Data has been received from a peer.
    
    // Do something with the received data, on the main thread
    [[NSOperationQueue mainQueue] addOperationWithBlock:^{
        // Process the data
    }];
}

- (void)session:(MCSession *)session didStartReceivingResourceWithName:(NSString *)resourceName fromPeer:(MCPeerID *)peerID withProgress:(NSProgress *)progress {
    // A file started being sent from a peer. (Not used in this example.)
}

- (void)session:(MCSession *)session didFinishReceivingResourceWithName:(NSString *)resourceName fromPeer:(MCPeerID *)peerID atURL:(NSURL *)localURL withError:(NSError *)error {
    // A file finished being sent from a peer. (Not used in this example.)
}


- (void)session:(MCSession *)session didReceiveStream:(NSInputStream *)stream withName:(NSString *)streamName fromPeer:(MCPeerID *)peerID {
    // Data started being streamed from a peer. (Not used in this example.)
}


- (IBAction) findLocalPlayers {
    // Keep this peer ID around
    
    NSString* playerID = [NSString stringWithFormat:@"Player %i", arc4random_uniform(8)];
    
    self.localPeerID = [[MCPeerID alloc] initWithDisplayName:playerID];
    
    // Keep this around also
    self.session = [[MCSession alloc] initWithPeer:self.localPeerID];
    self.session.delegate = self;
    
    NSString* serviceType = @"mygame-v1"; // should be unique
    MCBrowserViewController* viewController = [[MCBrowserViewController alloc] initWithServiceType:serviceType session:self.session];
    
    viewController.minimumNumberOfPeers = 2;
    viewController.maximumNumberOfPeers = 2;
    
    viewController.delegate = self;
    
    [self presentViewController:viewController animated:YES completion:nil];
}


- (void)browserViewControllerDidFinish:(MCBrowserViewController *)browserViewController {
    // The MCSession is now ready to use.
    
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)browserViewControllerWasCancelled:(MCBrowserViewController *)browserViewController {
    // The user cancelled.
    
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void) showPlayerList {
    
    [[GKLocalPlayer localPlayer] loadFriendsWithCompletionHandler:^(NSArray *friendIDs, NSError *error) {
        
        [GKPlayer loadPlayersForIdentifiers:friendIDs withCompletionHandler:^(NSArray *players, NSError *error) {
            
            // Get info for each player
            
            for (GKPlayer* player in players) {
                NSLog(@"Friend: %@", player.displayName);
            }
            
        }];
        
    }];
}

- (void) playerWasAuthenticated {
    [self showPlayerList];
    
    GKLocalPlayer* localPlayer = [GKLocalPlayer localPlayer];
    
    self.playerName.text = localPlayer.alias;
    
    [[GKLocalPlayer localPlayer] loadPhotoForSize:GKPhotoSizeNormal withCompletionHandler:^(UIImage *photo, NSError *error) {
        self.playerPhotoView.image = photo;
    }];
    
    
}

- (IBAction)showGameCenter:(id)sender {
    GKGameCenterViewController* viewController = [[GKGameCenterViewController alloc] init];
    
    [self presentViewController:viewController animated:YES completion:nil];
    viewController.gameCenterDelegate = self;
}

- (void)gameCenterViewControllerDidFinish:(GKGameCenterViewController *)gameCenterViewController {
    [self dismissViewControllerAnimated:YES completion:nil];
}



- (IBAction)loadHighScores {
    // Get the list of scores defined in iTunes Connect
    [GKLeaderboard loadLeaderboardsWithCompletionHandler:^(NSArray *leaderboards, NSError *error) {
        
        // For each leaderboard:
        for (GKLeaderboard* leaderboard in leaderboards) {

            // Get the scores
            [leaderboard loadScoresWithCompletionHandler:^(NSArray *scores, NSError *error) {
                
                NSLog(@"Leaderboard %@:", leaderboard.title);
                
                // Show the score
                for (GKScore* score in scores) {
                    NSLog(@"%@", score.formattedValue);
                }
            }];
        }
    }];
    
}

- (IBAction)startMatch:(id)sender {
    GKMatchRequest* request = [[GKMatchRequest alloc] init];
    
    request.maxPlayers = 2;
    request.minPlayers = 2;
    
    GKMatchmakerViewController* viewController = [[GKMatchmakerViewController alloc] initWithMatchRequest:request];
    
    viewController.matchmakerDelegate = self;
    
    [self presentViewController:viewController animated:YES completion:nil];
    
}

- (void)match:(GKMatch *)match didReceiveData:(NSData *)data fromPlayer:(NSString *)playerID {
    // Do something with the received data, on the main thread
    [[NSOperationQueue mainQueue] addOperationWithBlock:^{
        // Process the data
    }];
}

- (void)matchmakerViewController:(GKMatchmakerViewController *)viewController didFindMatch:(GKMatch *)match {
    // Start using the match
    
    match.delegate = self;
    
    NSData* data = [@"Hello!" dataUsingEncoding:NSUTF8StringEncoding];
    
    NSError* error = nil;
    
    [match sendDataToAllPlayers:data withDataMode:GKMatchSendDataReliable error:&error];
    
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)matchmakerViewController:(GKMatchmakerViewController *)viewController didFailWithError:(NSError *)error {
    // We couldn't create a match
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)matchmakerViewControllerWasCancelled:(GKMatchmakerViewController *)viewController {
    // The user cancelled matchmaking
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (IBAction) addScore {
    
    NSUInteger scoreValue = arc4random_uniform(1000);
    
    GKScore* score = [[GKScore alloc] initWithLeaderboardIdentifier:@"leaderboardtest1"];
    score.value = scoreValue;
    
    [GKScore reportScores:@[score] withCompletionHandler:^(NSError *error) {
        NSLog(@"Completed; error = %@", error);
        
        
        UIViewController* challengeCompose = [score challengeComposeControllerWithPlayers:self.friendPlayerIDs
 message:@"Beat this!" completionHandler:^(UIViewController *composeController, BOOL didIssueChallenge, NSArray *sentPlayerIDs) {
     [self dismissViewControllerAnimated:YES completion:nil];
 }];
        
        [self presentViewController:challengeCompose animated:YES completion:nil];
        
    }];
    
}

- (void) startTurnBasedGame {
    GKMatchRequest* matchRequest = [[GKMatchRequest alloc] init];
    matchRequest.minPlayers = 2;
    matchRequest.maxPlayers = 2;
    
    GKTurnBasedMatchmakerViewController* matchmaker = [[GKTurnBasedMatchmakerViewController alloc] initWithMatchRequest:matchRequest];
    matchmaker.turnBasedMatchmakerDelegate = self;
    
    [self presentViewController:matchmaker animated:YES completion:nil];
    
}

- (void)turnBasedMatchmakerViewController:(GKTurnBasedMatchmakerViewController *)viewController didFindMatch:(GKTurnBasedMatch *)match {
    
    // Close the matchmaker
    [self dismissViewControllerAnimated:YES completion:nil];
    
    // Do something with the match. For example:
    
    if ([match.currentParticipant.playerID isEqual:[GKLocalPlayer localPlayer].playerID]) {
        // We're the current player, so let the player do something
    } else {
        // It's not our turn, so just show the game state
    }
}

- (void)turnBasedMatchmakerViewControllerWasCancelled:(GKTurnBasedMatchmakerViewController *)viewController {
    // The matchmaker was closed without selecting a match.
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)turnBasedMatchmakerViewController:(GKTurnBasedMatchmakerViewController *)viewController didFailWithError:(NSError *)error {
    // The matchmaker failed to find a match for some reason.
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)turnBasedMatchmakerViewController:(GKTurnBasedMatchmakerViewController *)viewController playerQuitForMatch:(GKTurnBasedMatch *)match {
    
    // The player told the matchmaker view controller that they wanted to quit a game in which they're the current player.
    // Do something with the match data to reflect the fact that we're quitting (for example, give all of our buildings to someone else, or remove them from the game)
    
    [self dismissViewControllerAnimated:YES completion:nil];
    
    NSData* matchData = match.matchData;
    
    [match participantQuitInTurnWithOutcome:GKTurnBasedMatchOutcomeQuit nextParticipants:nil turnTimeout:2000.0 matchData:matchData completionHandler:^(NSError *error) {
        // Finished telling Game Center that we quit
    }];
    
}

- (void)player:(GKPlayer *)player receivedTurnEventForMatch:(GKTurnBasedMatch *)match didBecomeActive:(BOOL)didBecomeActive {
    // The game was updated. The player _may_ have just become the current player in the game.
}


- (void)player:(GKPlayer *)player matchEnded:(GKTurnBasedMatch *)match {
    // Tell the player that the match is over
}


- (void) endTurn {
    GKTurnBasedMatch* match = nil;
    NSData* matchData = nil;
    
    NSArray* nextParticipants = nil;
    
    // nextParticipants is an NSArray of GKTurnBasedParticipants. You can get the list of participants
    // using match.participants. Game Center will tell the first participant in the array that it's their turn;
    // if they don't do it within 600 seconds (10 minutes), it will be the player after that's turn, and so on.
    // (If the last participant in the array doesn't complete their turn within 10 minutes, it remains their turn.)
    [match endTurnWithNextParticipants:nextParticipants turnTimeout:600 matchData:matchData completionHandler:^(NSError *error) {
        // We're done sending the match data
    }];
}

- (void) endMatch {
    GKTurnBasedMatch* match = nil;
    NSData* matchData = nil;
    
    // End the match. All players will receive the updated
    [match endMatchInTurnWithMatchData:matchData completionHandler:^(NSError *error) {
        // We're done telling Game Center that the match is done
    }];
}

- (void) updateTurn {
    GKTurnBasedMatch* match = nil;
    NSData* matchData = nil;
    
    // Tell other players about the new state of the game. It still remains the current player's turn.
    [match saveCurrentTurnWithMatchData:matchData completionHandler:^(NSError *error) {
        // We're done sending the match data
    }];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
