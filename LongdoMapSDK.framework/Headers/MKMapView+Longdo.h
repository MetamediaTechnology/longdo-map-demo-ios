//
//  MKMapView+Util.h
//  LongdoMap
//
//  Created by กมลภพ จารุจิตต์ on 21/10/58.
//  Copyright © พ.ศ. 2558 Metamedia Technology. All rights reserved.
//

@import AVKit;
@import AVFoundation;
@import MapKit;
#import "Annotation.h"
#import "LocationController.h"

@protocol LMTagDelegate <NSObject>

- (void)tagData:(NSArray<LMTagAnnotation *> *)poi;
- (void)removeOldTagFromZoom:(NSInteger)zoom;

@end

@protocol LMSearchDelegate <NSObject>

/**
 Callback from searchWithKeyword function.
 @param poi Point of interest results from search keyword.
 */
- (void)searchData:(NSArray<LMPinAnnotation *> *)poi;

/**
 Callback from suggestWithKeyword function.
 @param keyword Suggest name of point of interest results from search keyword.
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
    ///Longdo layer by name specific in `sourceLayer`.
    BY_NAME,
    ///Custom layer.
    CUSTOM
};

/*!
@enum LMTileFormat

@discussion The LMTileFormat enum defines constants that
can be used to specify the type of custom map tile format.
*/
typedef NS_ENUM(NSInteger, LMTileFormat) {
    ///If not use custom format.
    LONGDO,
    ///Web Map Service format.
    WMS,
    WMTS = WMS,
    ///Tile Map Service format.
    TMS,
    ///JSON of point format.
    JSON,
    ///Bounding box format with specific SRS.
    BBOX4326,
    BBOX3857
};

/*!
 @enum LMLanguage
 
 @discussion The LMLanguage enum defines constants that
 can be used to specify language of map view.
 */
typedef NS_ENUM(NSInteger, LMLanguage) {
    THAI = 1,
    ENGLISH
};

/*!
 @enum LMUserAnnotationType
 
 @discussion The LMUserAnnotationType enum defines appearance of user location's annotation.
 */
typedef NS_ENUM(NSInteger, LMUserAnnotationType) {
    ///Longdo Map Style
    LONGDO_PIN = 1,
    ///Apple MapKit Style
    NATIVE_PIN
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

@interface LMTileOverlayRenderer : MKTileOverlayRenderer

@property (nonatomic, strong) NSArray *tag;
@property (nonatomic, assign) NSString *language;
@property (nonatomic, assign) NSURL *boxDomain;
@property (nonatomic, strong) NSString *apikey;
@property (nonatomic, weak) id <LMTagDelegate> tagDelegate;

@end

@interface LMLayer : NSObject

/// Type of Longdo overlay layer.
@property (nonatomic, assign) LMMode mode;
/// Tile format of overlay if use custom overlay.
@property (nonatomic, assign) LMTileFormat tileFormat;
/// URL of overlay layer if use `CUSTOM` overlay or name of layer if use `BY_NAME` overlay.
@property (nonatomic, strong) NSString *sourceLayer;
/// Referer URL of overlay layer if use custom overlay.
@property (nonatomic, strong) NSString *referer;
/// Alpha value of overlay layer between 0.0 - 1.0.
@property (nonatomic, assign) CGFloat alpha;
/// Minimum zoom of map that layer will be appeared.
@property (nonatomic, assign) NSInteger minZoom;
/// Maximum zoom of map that layer will be appeared.
@property (nonatomic, assign) NSInteger maxZoom;

/**
 Initializes `LMLayer` with Longdo overlay type.
 @param mode Overlay layer type.
 */
- (id)initWithMode:(LMMode)mode;

@end

@interface LMTileOverlay : MKTileOverlay

@property (nonatomic, assign) LMCache cache;
@property (nonatomic, assign) LMLanguage language;
@property (nonatomic, assign) CGFloat alpha;
@property (nonatomic, strong) NSMutableArray<NSNumber *> *mode;
@property (nonatomic, strong) NSMutableArray<NSNumber *> *tileFormat;
@property (nonatomic, strong) NSMutableArray<NSString *> *urlLayer;
@property (nonatomic, assign) id <LMTileDataDelegate> dataDelegate;
@property (nonatomic, strong) NSMutableArray<NSString *> *referer;

- (id)initWithMode:(NSArray<NSNumber *> *)mapMode key:(NSString *)key domain:(NSURL *)domain andLanguage:(LMLanguage)lang;
- (void)setCustomUrl:(NSArray<NSString *> *)urlString withTileFormat:(NSArray<NSNumber *> *)format andReferer:(NSArray<NSString *> *)refer;

@end

@interface LongdoMapView : MKMapView <LMTagDelegate, LMTileDataDelegate, MKMapViewDelegate, LocationControllerDelegate>

@property (nonatomic, assign) id <LMSearchDelegate> searchDelegate;
@property (nonatomic, assign) id <LMTileDataDelegate> dataDelegate;
/// The language of map view.
@property (nonatomic, assign) LMLanguage language;
/// Zoom level of map view.
@property (nonatomic, assign) CGFloat zoomLevel;
/// An appearance of user location's annotation.
@property (nonatomic, assign) LMUserAnnotationType userAnnotationType;
/// URL Path of User's Longdo Box.
@property (nonatomic, strong) NSURL* boxDomain;
/// Crosshair on center of Map.
@property (nonatomic, strong) UIImageView* crosshair;
/// Custom user location image on map. (Best size at 32x40 px)
@property (nonatomic, strong) IBInspectable UIImage* userLocationImage;
/// Custom user location arrow on map. (Best canvas size at 70x70 px)
@property (nonatomic, strong) IBInspectable UIImage* userLocationArrow;
/// A Boolean indicating whether the map shows traffic events.
@property (nonatomic, assign) IBInspectable BOOL showsEvents;
/// A Boolean indicating whether the map shows traffic cameras.
@property (nonatomic, assign) IBInspectable BOOL showsCameras;

#pragma mark - Set Map
/**
 Initializes a `LongdoMapView` object with Longdo Map API Key.
 @param key Longdo Map API Key.
 */
- (void)setKey:(NSString *)key;

/**
Enable cache for map.
 @param cached Set how to cache.
 */
- (void)setCache:(LMCache)cached;

/**
 Manually update crosshair to center of the map when map's frame changed.
 */
- (void)updateCrosshair;

/**
 Get map span with specific zoom.
 @param zoom The zoom of the map.
 @return Span of the map with specific zoom.
 */
- (MKCoordinateSpan)coordinateSpanWithZoomLevel:(CGFloat)zoom;

/**
 Remove map tile caches from device.
 @return Clear cache success.
 */
- (BOOL)clearAllCaches;

#pragma mark - Set Layer
/**
 Add overlay layer to map view.
 @param overlayName Overlay layer to be added.
 @deprecated This method is deprecated starting in version 3.10
 */
- (void)addLMOverlay:(LMMode)overlayName DEPRECATED_MSG_ATTRIBUTE("Use addLMLayer: instead.");

/**
 Add overlay layer to map view.
 @param layer Overlay layer to be added.
 */
- (void)addLMLayer:(LMLayer *)layer;

/**
 Add custom overlay layer to map view.
 @param urlString URL of layer to be added. (if not using bounding box, replace x,y position and zoom with {x}, {y}, {z})
 @param tileFormat Tile format type.
 @param refer Tile referer (if no referer, send empty string).
 @deprecated This method is deprecated starting in version 3.10
 */
- (void)addCustomOverlayWithURL:(NSString *)urlString andFormat:(LMTileFormat)tileFormat withReferer:(NSString *)refer DEPRECATED_MSG_ATTRIBUTE("Use addLMLayer: instead.");

/**
 Add overlay layers to map view.
 @param overlayNames Set of overlay layer to be added.
 @param urlStrings Set of URL of layer to be added. (if not using bounding box, replace x,y position and zoom with {x}, {y}, {z})
 @param tileFormats Tile set of format type.
 @param refer Tile referer set (if no referer, send empty string).
 @deprecated This method is deprecated starting in version 3.10
 */
- (void)addLMOverlays:(NSArray<NSNumber *>*)overlayNames WithURL:(NSArray<NSString *>*)urlStrings andFormat:(NSArray<NSNumber *>*)tileFormats withReferer:(NSArray<NSString *>*)refer DEPRECATED_MSG_ATTRIBUTE("Use addLMLayers: instead.");

/**
 Add multiple overlay layers to map view.
 @param layers Array of overlay layers to be added from bottom to top.
 */
- (void)addLMLayers:(NSArray<LMLayer *>*)layers;

/**
 Remove overlay layer from map view.
 @param overlayName Overlay layer that include in overlay to be removed.
 */
- (void)removeLMOverlay:(LMMode)overlayName;

/**
 Remove overlay layer from map view.
 @param sourceLayer Layer from URL that need to be removed.
 */
- (void)removeSourceLayer:(NSString *)sourceLayer;

/**
 Show longdo tags on the map.
 @param tag Array of tag name.
 */
- (void)showTags:(NSArray *)tag;

/**
 Remove longdo tags from the map.
 */
- (void)removeAllTags;

#pragma mark - Calculate
/**
 Convert WGS 84 value to UTM value.
 @param coordinate Value in WGS 84 format.
 @param hasZone Show UTM zone in return value.
 @return Value in UTM format.
 */
- (NSString *)UTMFrom:(CLLocationCoordinate2D)coordinate withZone:(BOOL)hasZone;

/**
 Convert UTM value to WGS 84 value.
 @param utmString Value in UTM format.
 @return Value in WGS 84 format.
 */
- (CLLocationCoordinate2D)coordinateFromUTM:(NSString *)utmString;

/**
 Get area size in metres from `MKPolygon`.
 @param polygon Polygon for calculate area size.
 @return Size of polygon area.
 */
- (double)areaOfPolygon:(MKPolygon *)polygon;

#pragma mark - Search
/**
 Search with Longdo map poi.
 @param keyword Word to search with Longdo.
 @param location Center of location to search with Longdo.
 */
- (void)searchWithKeyword:(NSString *)keyword andCoordinate:(CLLocationCoordinate2D)location;

/**
 Search with Longdo map poi.
 @param keyword The word to search with Longdo.
 @param location The center of location to search with Longdo.
 @param span The span with unit in deg, m or km.
 @param offset The offset of the first result returned.
 @param limit Number of results returned.
 */
- (void)searchWithKeyword:(NSString *)keyword coordinate:(CLLocationCoordinate2D)location span:(NSString *)span offset:(NSInteger)offset andLimit:(NSInteger)limit;

/**
 Suggest with Longdo map poi.
 @param keyword The word for suggest with Longdo.
 */
- (void)suggestWithKeyword:(NSString *)keyword;

#pragma mark - Traffic
/**
 Show event pins and data on Longdo map.
 */
- (void)showEvents DEPRECATED_MSG_ATTRIBUTE("Use showsEvents = true instead.");

/**
 Show camera pins and data on Longdo map.
 */
- (void)showCameras DEPRECATED_MSG_ATTRIBUTE("Use showsCameras = true instead.");

/**
 Remove event pins on Longdo map.
 */
- (void)removeEvents DEPRECATED_MSG_ATTRIBUTE("Use showsEvents = false instead.");

/**
 Remove camera pins on Longdo map.
 */
- (void)removeCameras DEPRECATED_MSG_ATTRIBUTE("Use showsCameras = false instead.");
  
/**
 Get vdo view from camera annotation data.
 */
- (UIView *)getVDOViewFromCameraData:(LMCameraAnnotation *)camera;

@end
