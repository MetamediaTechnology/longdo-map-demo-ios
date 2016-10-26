//
//  MKMapView+Util.h
//  LongdoMap
//
//  Created by กมลภพ จารุจิตต์ on 21/10/58.
//  Copyright © พ.ศ. 2558 Metamedia Technology. All rights reserved.
//

@import MapKit;
#import "Annotation.h"

@protocol LongdoTagDelegate <NSObject>

- (void)tagData:(NSArray<TagAnnotation *> *)poi;
- (void)removeTagFromZoom:(NSInteger)zoom;

@end

@protocol LongdoSearchDelegate <NSObject>

- (void)searchData:(NSArray<PinAnnotation *> *)poi;
- (void)suggestData:(NSArray<NSString *> *)keyword;

@end

typedef NS_ENUM(NSInteger, LongdoMode) {
    BASE, // Hillshade base layer
    GISTDA_SPOT5, // SPOT5 satellite base layer
    GRAY, // Gray-ish base layer
    HYDRO, // Basic base layer
    MAPQUEST, // MapQuest-OSM base layer
    NORMAL, // Standard base layer
    OPENCYCLE, // Open Cycle base layer
    OSM, // Open Street Map base layer
    POI, // Standard+POI base layer
    POLITICAL, // Political base layer
    POLITICAL_NOLABEL, // Political base layer (No label)
    TERRAIN, // Bluemarble terrain base layer
    THAICHOTE, // Thaichote satellite base layer
    POI_TRANSPARENT, // Standard+POI non-base layer
    TRAFFIC, // Traffic non-base layer with auto-refresh
    TAG, // Longdo tag layer
    CUSTOM // Custom Layer
};

typedef NS_ENUM(NSInteger, LongdoLanguage) {
    THAI,
    ENGLISH
};

@interface LongdoTileOverlayRenderer : MKTileOverlayRenderer {
    NSInteger oldZoom;
    NSMutableArray *pathOnMap;
}

@property (nonatomic, strong) NSArray *tag;
@property (nonatomic, assign) NSString *language;
@property (nonatomic, strong) NSString *apikey;
@property (nonatomic, assign) id <LongdoTagDelegate> delegate;

@end

@interface LongdoTileOverlay : MKTileOverlay {
    NSString *apikey;
    LongdoLanguage language;
    NSString *modeName;
    NSString *urlLayer;
}

@property (nonatomic, assign) LongdoMode mode;

- (id)initWithMode:(LongdoMode)mode withKey:(NSString *)key andLanguage:(LongdoLanguage)lang;
- (void)setCustomUrl:(NSString *)urlString;

@end

@interface LongdoMapView : MKMapView <LongdoTagDelegate, MKMapViewDelegate> {
    LongdoTileOverlayRenderer *tagOverlay;
    NSString *apikey;
}

@property (nonatomic, assign) id <LongdoSearchDelegate> searchDelegate;
@property (nonatomic, assign) LongdoLanguage language;

/**
 Initializes a `LongdoMapView` object with Longdo Map API Key.
 @param key Longdo Map API Key.
 */
- (void)setKey:(NSString *)key;

/**
 Get map current zoom.
 @return map current zoom.
 */
- (CGFloat)getZoomLevel;

/**
 Set map current zoom.
 @param zoomLevel the zoom of the map.
 */
- (void)setZoomLevel:(CGFloat)zoomLevel;

/**
 Get map span with specific zoom.
 @param zoomLevel the zoom of the map.
 @return span of the map with specific zoom.
 */
- (MKCoordinateSpan)coordinateSpanWithZoomLevel:(CGFloat)zoomLevel;

/**
 Add overlay layer to map view.
 @param overlayName overlay layer to be added.
 */
- (void)addLongdoOverlay:(LongdoMode)overlayName;

/**
 Add custom overlay layer to map view.
 @param urlString URL of layer to be added. (replace x,y position and zoom with {x}, {y}, {z})
 */
- (void)addCustomOverlayWithURL:(NSString *)urlString;

/**
 Remove overlay layer from map view.
 @param overlayName overlay layer to be removed.
 */
- (void)removeLongdoOverlay:(LongdoMode)overlayName;

/**
 Show longdo tags on the map.
 @param tag array of tag name.
 */
- (void)showTags:(NSArray *)tag;

/**
 Remove longdo tags from the map.
 */
- (void)removeAllTags;

/**
 Search with Longdo map poi
 @param keyword word to search with Longdo
 */
- (void)searchWithKeyword:(NSString *)keyword;

/**
 Suggest with Longdo map poi
 @param keyword word to suggest with Longdo
 */
- (void)suggestWithKeyword:(NSString *)keyword;

@end
