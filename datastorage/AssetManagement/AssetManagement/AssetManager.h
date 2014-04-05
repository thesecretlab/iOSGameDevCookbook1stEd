//
//  AssetManager.h
//  AssetManagement
//
//  Created by Jon Manning on 27/11/2013.
//  Copyright (c) 2013 Jon Manning. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef void (^LoadingBlock)(NSData* loadedData);
typedef void (^LoadingCompleteBlock)(void);

@interface AssetManager : NSObject

@property (strong) NSURL* baseURL;

+ (AssetManager*) sharedManager;

- (NSURL*) urlForAsset:(NSString*) assetName;
- (void) loadAsset:(NSString* )assetName withCompletion:(LoadingBlock)completionBlock;
- (void) waitForResourcesToLoad:(LoadingCompleteBlock)completionBlock;

@end
