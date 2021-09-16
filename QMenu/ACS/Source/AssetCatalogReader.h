//
//  AssetCatalogReader.h
//  Asset Catalog Tinkerer
//
//  Created by Guilherme Rambo on 27/03/16.
//  Copyright © 2016 Guilherme Rambo. All rights reserved.
//

@import Cocoa;

/// The name of the asset
extern NSString *__nonnull const kACSNameKey;
/// An NSImage representing the image for the asset
extern NSString *__nonnull const kACSImageKey;
/// An NSImage representing a smaller version of the asset's image (suitable for thumbnails)
extern NSString *__nonnull const kACSThumbnailKey;
/// An NSString with the suggested filename for the asset
extern NSString *__nonnull const kACSFilenameKey;
/// An NSData containing PNG image data for the asset
extern NSString *__nonnull const kACSPNGDataKey;
/// An NSBitmapImageRep containing a bitmap representation of the asset
extern NSString *__nonnull const kACSImageRepKey;

typedef void(^AssetCatalogReaderSuccessHandler)(NSArray <NSDictionary <NSString *, NSObject *> *> *__nonnull images);
typedef void(^AssetCatalogReaderFailureHandler)(NSError * __nonnull error);
typedef void(^AssetCatalogReaderProgressHandler)(CGFloat progress);

@interface AssetCatalogReader : NSObject

@property (nonatomic, assign) NSSize thumbnailSize;

@property (nonatomic, strong) NSArray <NSDictionary <NSString *, NSObject *> *> *__nonnull images;
@property (nonatomic, copy) NSString *__nullable catalogName;

// After reading, contains the total number of assets contained within the asset catalog
@property (readonly) NSUInteger totalNumberOfAssets;

- (instancetype __nonnull)initWithFileURL:(NSURL * __nonnull)URL;
- (void)readWithProgress:(AssetCatalogReaderProgressHandler _Nullable)progress success:(AssetCatalogReaderSuccessHandler _Nullable)success failure:(AssetCatalogReaderFailureHandler _Nullable )failure;

// Performs a more lightweight read (used by the QuickLook PlugIn)
- (void)resourceConstrainedReadWithMaxCount:(int)max success:(AssetCatalogReaderSuccessHandler _Nullable)success failure:(AssetCatalogReaderFailureHandler _Nullable )failure;

- (void)cancelReading;

@property (nonatomic, assign) BOOL cancelled;

@property (nonatomic, assign) BOOL distinguishCatalogsFromThemeStores;
@property (nonatomic, assign) BOOL ignorePackedAssets;

@end
