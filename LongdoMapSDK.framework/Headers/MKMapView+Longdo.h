//
//  MKMapView+Util.h
//  LongdoMap
//
//  Created by กมลภพ จารุจิตต์ on 21/10/58.
//  Copyright © พ.ศ. 2558 Metamedia Technology. All rights reserved.
//

@import MapKit;
#import "Annotation.h"

@protocol LMTagDelegate <NSObject>

- (void)tagData:(NSArray<LMTagAnnotation *> *)poi;
- (void)removeTagFromZoom:(NSInteger)zoom;

@end

@protocol LMSearchDelegate <NSObject>

/**
 Callback from searchWithKeyword function
 @param poi point of interest results from search keyword.
 */
- (void)searchData:(NSArray<LMPinAnnotation *> *)poi;

/**
 Callback from suggestWithKeyword function
 @param keyword suggest name of point of interest results from search keyword.
 */
- (void)suggestData:(NSArray<NSString *> *)keyword;

@end

@protocol LMTileDataDelegate <NSObject>

- (void)dataFromTile:(NSData *)data;

@end

/*!
 @enum LMMode
 
 @discussion The LMMode enum defines constants that
 can be used to specify the type of map view.
 */
typedef NS_ENUM(NSInteger, LMMode) {
    ///Hillshade base layer.
    BASE,
    ///SPOT5 satellite base layer.
    GISTDA_SPOT5,
    ///Gray-ish base layer.
    GRAY,
    ///Basic base layer.
    HYDRO,
    ///MapQuest-OSM base layer.
    MAPQUEST,
    ///Standard base layer.
    NORMAL,
    ///Revert standard base layer.
    NORMALR,
    ///Open Cycle base layer.
    OPENCYCLE,
    ///Open Street Map base layer.
    OSM,
    ///Standard+POI base layer.
    POI,
    ///Political base layer.
    POLITICAL,
    ///Political base layer (No label).
    POLITICAL_NOLABEL,
    ///Bluemarble terrain base layer.
    TERRAIN,
    ///Thaichote satellite base layer.
    THAICHOTE,
    ///Thaichote satellite base layer.
    THAICHOTE_HTTP,
    ///Standard+POI non-base layer.
    POI_TRANSPARENT,
    ///Traffic non-base layer with auto-refresh.
    TRAFFIC,
    ///Offline layer. (Please contact company sales.)
    OFFLINE,
    ///Blank layer.
    BLANK,
    ///Longdo tag layer.
    TAG,
    ///Custom Layer.
    CUSTOM
};

/*!
@enum LMTileFormat

@discussion The LMTileFormat enum defines constants that
can be used to specify the type of custom map tile format.
*/
typedef NS_ENUM(NSInteger, LMTileFormat) {
    ///If not use custom format
    LONGDO,
    ///Web Map Service format
    WMS,
    WMTS = WMS,
    ///Tile Map Service format
    TMS,
    ///JSON of point format
    JSON,
    ///Bounding box format with specific SRS
    BBOX4326,
    BBOX3857
};

/*!
 @enum LMLanguage
 
 @discussion The LMLanguage enum defines constants that
 can be used to specify language of map view.
 */
typedef NS_ENUM(NSInteger, LMLanguage) {
    THAI,
    ENGLISH
};

/*!
 @enum LMCache
 
 @discussion The LMCache enum defines how map tile cache in device.
 */
typedef NS_ENUM(NSInteger, LMCache) {
    DEFAULTCACHE,
    ALWAYCACHE,
    ALWAYLOAD
};

@interface LMTileOverlayRenderer : MKTileOverlayRenderer {
    NSInteger oldZoom;
    NSMutableArray *pathOnMap;
}

@property (nonatomic, strong) NSArray *tag;
@property (nonatomic, assign) NSString *language;
@property (nonatomic, strong) NSString *apikey;
@property (nonatomic, assign) id <LMTagDelegate> tagDelegate;

@end

@interface LMTileOverlay : MKTileOverlay {
    NSString *apikey;
    LMLanguage language;
    NSString *docDir;
    NSFileManager *fileManager;
    NSUserDefaults *defaults;
    NSMutableArray *tileList;
}

@property (nonatomic, assign) LMCache cache;
@property (nonatomic, strong) NSMutableArray<NSNumber *> *mode;
@property (nonatomic, strong) NSMutableArray<NSNumber *> *tileFormat;
@property (nonatomic, strong) NSMutableArray<NSString *> *urlLayer;
@property (nonatomic, assign) id <LMTileDataDelegate> dataDelegate;
@property (nonatomic, strong) NSMutableArray<NSString *> *referer;

- (id)initWithMode:(NSArray<NSNumber *> *)mapMode withKey:(NSString *)key andLanguage:(LMLanguage)lang;
- (void)setCustomUrl:(NSArray<NSString *> *)urlString withTileFormat:(NSArray<NSNumber *> *)format andReferer:(NSArray<NSString *> *)refer;

@end

@interface LongdoMapView : MKMapView <LMTagDelegate, LMTileDataDelegate, MKMapViewDelegate> {
    LMTileOverlayRenderer *tagOverlay;
    NSString *apikey;
    LMCache cache;
}

@property (nonatomic, assign) id <LMSearchDelegate> searchDelegate;
@property (nonatomic, assign) id <LMTileDataDelegate> dataDelegate;
@property (nonatomic, assign) LMLanguage language;

/**
 Initializes a `LongdoMapView` object with Longdo Map API Key.
 @param key Longdo Map API Key.
 */
- (void)setKey:(NSString *)key;

/**
Enable cache for map.
 @param cached set how to cache.
 */
- (void)setCache:(LMCache)cached;

/**
 Get map current zoom.
 @return Map current zoom.
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
 @return Span of the map with specific zoom.
 */
- (MKCoordinateSpan)coordinateSpanWithZoomLevel:(CGFloat)zoomLevel;

/**
 Add overlay layer to map view.
 @param overlayName overlay layer to be added.
 */
- (void)addLMOverlay:(LMMode)overlayName;

/**
 Add custom overlay layer to map view.
 @param urlString URL of layer to be added. (if not using bounding box, replace x,y position and zoom with {x}, {y}, {z})
 @param tileFormat Tile format type.
 @param refer Tile referer (if no referer, send empty string).
 */
- (void)addCustomOverlayWithURL:(NSString *)urlString andFormat:(LMTileFormat)tileFormat withReferer:(NSString *)refer;

/**
 Add overlay layers to map view.
 @param overlayNames set of overlay layer to be added.
 @param urlStrings set of URL of layer to be added. (if not using bounding box, replace x,y position and zoom with {x}, {y}, {z})
 @param tileFormats Tile set of format type.
 @param refer Tile referer set (if no referer, send empty string).
 */
- (void)addLMOverlays:(NSArray<NSNumber *>*)overlayNames WithURL:(NSArray<NSString *>*)urlStrings andFormat:(NSArray<NSNumber *>*)tileFormats withReferer:(NSArray<NSString *>*)refer;

/**
 Remove overlay layer from map view.
 @param overlayName overlay layer that include in overlay to be removed.
 */
- (void)removeLMOverlay:(LMMode)overlayName;

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
 Remove map tile caches from device.
 @return Clear cache success.
 */
- (BOOL)clearAllCaches;

/**
 Convert WGS 84 value to UTM value.
 @param coordinate value in WGS 84 format.
 @param hasZone show UTM zone in return value.
 @return Value in UTM format.
 */
- (NSString *)UTMFrom:(CLLocationCoordinate2D)coordinate withZone:(BOOL)hasZone;

/**
 Convert UTM value to WGS 84 value.
 @param utmString value in UTM format.
 @return Value in WGS 84 format.
 */
- (CLLocationCoordinate2D)coordinateFromUTM:(NSString *)utmString;

/**
 Search with Longdo map poi
 @param keyword word to search with Longdo
 @param location center of location to search with Longdo
 */
- (void)searchWithKeyword:(NSString *)keyword andCoordinate:(CLLocationCoordinate2D)location;

/**
 Search with Longdo map poi
 @param keyword word to search with Longdo
 @param location center of location to search with Longdo
 @param span span with unit in deg, m or km
 @param offset offset of the first result returned
 @param limit number of results returned
 */
- (void)searchWithKeyword:(NSString *)keyword coordinate:(CLLocationCoordinate2D)location span:(NSString *)span offset:(NSInteger)offset andLimit:(NSInteger)limit;

/**
 Suggest with Longdo map poi
 @param keyword word to suggest with Longdo
 */
- (void)suggestWithKeyword:(NSString *)keyword;

/**
 Show event pins and data on Longdo map
 */
- (void)showEvents;

/**
 Show camera pins and data on Longdo map
 */
- (void)showCameras;

/**
 Remove event pins on Longdo map
 */
- (void)removeEvents;

/**
 Remove camera pins on Longdo map
 */
- (void)removeCameras;

@end
