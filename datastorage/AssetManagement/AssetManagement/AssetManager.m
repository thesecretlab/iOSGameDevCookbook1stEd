//
//  AssetManager.m
//  AssetManagement
//
//  Created by Jon Manning on 27/11/2013.
//  Copyright (c) 2013 Jon Manning. All rights reserved.
//

#import "AssetManager.h"

static AssetManager* sharedAssetManager = nil;

@implementation AssetManager {
    dispatch_queue_t _loadingQueue;
}

+ (AssetManager *)sharedManager {
    // If the shared instance hasn't yet been created, create it now
    if (sharedAssetManager == nil) {
        sharedAssetManager = [[AssetManager alloc] init];
    }
    
    return sharedAssetManager;
}

- (id)init
{
    self = [super init];
    if (self) {
        // Find assets inside the "Assets" folder, which is copied in
        self.baseURL = [[[NSBundle mainBundle] resourceURL] URLByAppendingPathComponent:@"Assets" isDirectory:YES];
        
        // Create the loading queue
        _loadingQueue = dispatch_queue_create("com.YourGame.LoadingQueue", DISPATCH_QUEUE_SERIAL);
        
    }
    return self;
}

- (NSURL *)urlForAsset:(NSString *)assetName {
    // Work out where to find the asset
    return [self.baseURL URLByAppendingPathComponent:assetName];
}

- (void)loadAsset:(NSString *)assetName withCompletion:(LoadingBlock)completionBlock {
    // Load the asset in the background; when it's done, give the loaded data to the completionBlock
    NSURL* urlToLoad = [self urlForAsset:assetName];
    
    dispatch_queue_t mainQueue = dispatch_get_main_queue();
    
    dispatch_async(_loadingQueue, ^{
        NSData* loadedData = [NSData dataWithContentsOfURL:urlToLoad];
        
        dispatch_sync(mainQueue, ^{
            completionBlock(loadedData);
        });
    });
}

- (void)waitForResourcesToLoad:(LoadingCompleteBlock)completionBlock {
    // Run the block on the main queue, after all of the load requests that have been queued up are complete
    dispatch_queue_t mainQueue = dispatch_get_main_queue();
    
    dispatch_async(_loadingQueue, ^{
        dispatch_sync(mainQueue, completionBlock);
    });
}

@end
