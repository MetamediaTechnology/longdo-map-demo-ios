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

- (void)tagData:(NSArray<LMTagAnnotation *> *_Nonnull)poi;
- (void)removeOldTagFromZoom:(NSInteger)zoom;

@end

@protocol LMSearchDelegate <NSObject>

/**
 Callback from function searchWithKeyword.
 @param poi Point of Interest results from search keyword.
 */
- (void)searchData:(NSArray<LMPinAnnotation *> *_Nonnull)poi;

/**
 Callback from function suggestWithKeyword.
 @param keyword Suggest name for each POI (Point of Interest) retrieved from search keyword.
 */
- (void)suggestData:(NSArray<NSString *> *_Nonnull)keyword;

@end

@protocol LMTileDataDelegate <NSObject>

/**
 Callback from custom layer which use JSON format.
 @param data Result data for each map-tile retrieved from custom layer with JSON format.
 */
- (void)dataFromTile:(NSData *_Nullable)data;

@optional
/**
 List of air quality data in current area.
 @param poi AQI data for each map-tile retrieved from AQI layer.
 */
- (void)aqiDataFromTile:(NSArray<LMAQIAnnotation *> *_Nonnull)poi;

/**
 List of tag data in current area.
 @param poi Tag data for each map-tile.
 */
- (void)tagData:(NSArray<LMTagAnnotation *> *_Nonnull)poi;

@end

@protocol LMAQIDataDelegate <NSObject>

/**
 Callback when user tap AQI annotation.
 @param data AQI data for each annotation that user tapped.
 */
- (void)aqiData:(LMAQIInfo *_Nonnull)data;

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
    ///Rain radar non-base layer with auto-refresh.
    RAIN_RADAR,
    ///Bluemarble terrain base layer.
    TERRAIN,
    ///Thaichote satellite base layer.
    THAICHOTE,
    ///Thaichote satellite base layer.
    THAICHOTE_HTTP,
    ///Land parcel layer.
    DOL_GRAY,
    ///Standard+POI non-base layer.
    POI_TRANSPARENT,
    ///Traffic non-base layer with auto-refresh.
    TRAFFIC,
    ///Google roadmap base layer.
    GOOGLE_ROADMAP,
    ///Google traffic base layer.
    GOOGLE_TRAFFIC,
    ///Google satellite base layer.
    GOOGLE_SATELLITE,
    ///Google hybrid base layer.
    GOOGLE_HYBRID,
    ///Offline layer. (Please contact company sales : sales@mm.co.th)
    OFFLINE,
    ///Blank layer.
    BLANK,
    ///Longdo tag layer.
    TAG,
    ///Longdo layer by name specified in `sourceLayer`.
    BY_NAME,
    ///Air quality data layer.
    AQI,
    ///Custom layer.
    CUSTOM
};

/*!
 @enum LMTileFormat
 
 @discussion The LMTileFormat enum defines constants that
 can be used to specify the type of custom map-tile format.
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
 
 @discussion The LMCache enum defines how map tiles cache in device.
 */
typedef NS_ENUM(NSInteger, LMCache) {
    DEFAULTCACHE,
    ALWAYCACHE,
    ALWAYLOAD
};

@interface LMTileOverlayRenderer : MKTileOverlayRenderer

@end

@interface LMLayer : NSObject

/// Type of Longdo overlay layer.
@property (nonatomic, assign) LMMode mode;
/// Tile format of overlay if use custom overlay.
@property (nonatomic, assign) LMTileFormat tileFormat;
/// URL of overlay layer if use `CUSTOM` overlay, name of layer if use `BY_NAME` overlay.
@property (nonatomic, strong) NSString * _Nonnull sourceLayer;
/// Google API extra query string if use `GOOGLE` overlay.
@property (nonatomic, strong) NSString * _Nonnull googleQuery;
/// Referer URL of overlay layer if use custom overlay.
@property (nonatomic, strong) NSString * _Nullable referer;
/// Alpha value of overlay layer between 0.0 - 1.0.
@property (nonatomic, assign) CGFloat alpha;
/// Minimum zoom level of map that layer will be appeared.
@property (nonatomic, assign) NSInteger minZoom;
/// Maximum zoom level of map that layer will be appeared.
@property (nonatomic, assign) NSInteger maxZoom;

/**
 Initializes `LMLayer` with Longdo overlay type.
 @param mode Overlay layer type.
 */
- (id _Nonnull)initWithMode:(LMMode)mode;

@end

@interface LMTileOverlay : MKTileOverlay

@property (nonatomic, assign) LMCache cache;
@property (nonatomic, assign) LMLanguage language;
@property (nonatomic, assign) CGFloat alpha;
@property (nonatomic, strong) NSMutableArray<NSNumber *> * _Nonnull mode;
@property (nonatomic, strong) NSMutableArray<NSNumber *> * _Nullable tileFormat;
@property (nonatomic, strong) NSMutableArray<NSString *> * _Nullable urlLayer;
@property (nonatomic, assign) id <LMTileDataDelegate> _Nonnull dataDelegate;
@property (nonatomic, strong) NSMutableArray<NSString *> * _Nullable referer;

- (id _Nullable)initWithMode:(NSArray<NSNumber *> *_Nonnull)mapMode key:(NSString *_Nullable)key domain:(NSURL *_Nullable)domain andLanguage:(LMLanguage)lang;
- (void)setCustomUrl:(NSArray<NSString *> *_Nonnull)urlString withTileFormat:(NSArray<NSNumber *> *_Nullable)format andReferer:(NSArray<NSString *> *_Nullable)refer;
- (void)setTag:(NSArray<NSString *> *_Nonnull)tagString;

@end

@interface LongdoMapView : MKMapView <LMTileDataDelegate, MKMapViewDelegate, LocationControllerDelegate>

@property (nonatomic, assign) id <LMSearchDelegate> _Nonnull searchDelegate;
@property (nonatomic, assign) id <LMTileDataDelegate> _Nonnull dataDelegate;
@property (nonatomic, assign) id <LMAQIDataDelegate> _Nonnull aqiDelegate;
/// Language of map view.
@property (nonatomic, assign) LMLanguage language;
/// Zoom level of map view.
@property (nonatomic, assign) CGFloat zoomLevel;
/// An appearance of user location's annotation.
@property (nonatomic, assign) LMUserAnnotationType userAnnotationType;
/// URL Path of User's Longdo Box.
@property (nonatomic, strong) NSURL* _Nonnull boxDomain;
/// Crosshairs on center of map.
@property (nonatomic, strong) UIImageView* _Nonnull crosshair;
/// Custom user location image on map. (Recommended resolution is 32 x 40 px)
@property (nonatomic, strong) IBInspectable UIImage* _Nullable userLocationImage;
/// Custom user location arrow on map. (Recommended resolution is 70 x 70 px)
@property (nonatomic, strong) IBInspectable UIImage* _Nullable userLocationArrow;
/// Flag to indicate whether the map shows traffic events.
@property (nonatomic, assign) IBInspectable BOOL showsEvents;
/// Flag to indicate whether the map shows traffic cameras.
@property (nonatomic, assign) IBInspectable BOOL showsCameras;
/// Flag to indicate whether the map shows air quality.
@property (nonatomic, assign) IBInspectable BOOL showsAQI;
/// Flag to indicate whether the map shows Air4Thai data.
@property (nonatomic, assign) IBInspectable BOOL showsAir4Thai;

#pragma mark - Set Map
/**
 Initializes a `LongdoMapView` object with Longdo Map API Key.
 @param key Longdo Map API Key.
 */
- (void)setKey:(NSString * _Nonnull)key;

/**
 Enable cache for map.
 @param cached Set how to cache.
 */
- (void)setCache:(LMCache)cached;

/**
 Manually update crosshairs to center of map when the map's frame changed.
 */
- (void)updateCrosshair;

/**
 Get map span with specific zoom.
 @param zoom Zoom level of the map.
 @return Span of the map with specific zoom.
 */
- (MKCoordinateSpan)coordinateSpanWithZoomLevel:(CGFloat)zoom;

/**
 Remove map-tile caches from device.
 @return Clear cache successfully.
 */
- (BOOL)clearAllCaches;

#pragma mark - Set Layer
/**
 Add overlay layer to map view.
 @param overlayName Overlay layer prepared to add.
 @deprecated This method has deprecated since version 3.10.
 */
- (void)addLMOverlay:(LMMode)overlayName DEPRECATED_MSG_ATTRIBUTE("Use addLMLayer: instead.");

/**
 Add overlay layer to map view.
 @param layer Overlay layer prepared to add.
 */
- (void)addLMLayer:(LMLayer *_Nonnull)layer;

/**
 Add custom overlay layer to map view.
 @param urlString URL of layer prepared to add. (replace position x, y and zoom level with {x}, {y} and {z} if bounding box is not used)
 @param tileFormat Tile format type.
 @param refer Tile referer (if no referer, send empty string).
 @deprecated This method has deprecated since version 3.10.
 */
- (void)addCustomOverlayWithURL:(NSString *_Nonnull)urlString andFormat:(LMTileFormat)tileFormat withReferer:(NSString *_Nonnull)refer DEPRECATED_MSG_ATTRIBUTE("Use addLMLayer: instead.");

/**
 Add overlay layers to map view.
 @param overlayNames Set of overlay layers prepared to add.
 @param urlStrings URL set of layers prepared to add. (replace position x, y and zoom level with {x}, {y} and {z} if bounding box is not used)
 @param tileFormats Tile set of format type.
 @param refer Tile referer set (if no referer, send empty string).
 @deprecated This method has deprecated since version 3.10.
 */
- (void)addLMOverlays:(NSArray<NSNumber *>*_Nonnull)overlayNames WithURL:(NSArray<NSString *>*_Nonnull)urlStrings andFormat:(NSArray<NSNumber *>*_Nonnull)tileFormats withReferer:(NSArray<NSString *>*_Nonnull)refer DEPRECATED_MSG_ATTRIBUTE("Use addLMLayers: instead.");

/**
 Add multiple overlay layers to map view.
 @param layers Array of overlay layers prepared to add with bottom-to-top orientation.
 */
- (void)addLMLayers:(NSArray<LMLayer *>*_Nonnull)layers;

/**
 Remove overlay layer from map view.
 @param overlayName Existing overlay layer prepared to remove.
 */
- (void)removeLMOverlay:(LMMode)overlayName;

/**
 Remove overlay layer from map view.
 @param sourceLayer Layer from URL prepared to remove.
 */
- (void)removeSourceLayer:(NSString *_Nonnull)sourceLayer;

/**
 Show Longdo tags on the map.
 @param tagString Array of tag name.
 */
- (void)showTags:(NSArray *_Nonnull)tagString;

/**
 Show Longdo tags on the map.
 @param tagString Array of tag names.
 @param options Options for Longdo tags.
 */
- (void)showTags:(NSArray *_Nonnull)tagString withOptions:(LMTagOptions *_Nullable)options;

/**
 Remove Longdo tags from the map.
 */
- (void)removeAllTags;

#pragma mark - Calculate
/**
 Convert WGS 84 value to UTM value.
 @param coordinate Value in WGS 84 format.
 @param hasZone Show UTM zone in return value.
 @return Value in UTM format.
 */
- (NSString *_Nullable)UTMFrom:(CLLocationCoordinate2D)coordinate withZone:(BOOL)hasZone;

/**
 Convert UTM value to WGS 84 value.
 @param utmString Value in UTM format.
 @return Value in WGS 84 format.
 */
- (CLLocationCoordinate2D)coordinateFromUTM:(NSString *_Nonnull)utmString;

/**
 Get area size in meters from `MKPolygon`.
 @param polygon Polygon for calculating area size.
 @return Size of polygon area.
 */
- (double)areaOfPolygon:(MKPolygon *_Nonnull)polygon;

#pragma mark - Search
/**
 Search with Longdo Map POI.
 @param keyword Word for searching with Longdo.
 @param location Center of location for searching with Longdo.
 */
- (void)searchWithKeyword:(NSString *_Nonnull)keyword andCoordinate:(CLLocationCoordinate2D)location DEPRECATED_MSG_ATTRIBUTE("Use searchKeyword:withOptions:result: instead.");

/**
 Search with Longdo Map POI.
 @param keyword The word for searching with Longdo.
 @param location The center of location for searching with Longdo.
 @param span The span with unit in degree, meter or kilometer.
 @param offset Offset of the first result returned.
 @param limit Number of results returned.
 */
- (void)searchWithKeyword:(NSString *_Nonnull)keyword coordinate:(CLLocationCoordinate2D)location span:(NSString *_Nullable)span offset:(NSInteger)offset andLimit:(NSInteger)limit DEPRECATED_MSG_ATTRIBUTE("Use searchKeyword:withOptions:result: instead.");

/**
 Suggest with Longdo Map POI.
 @param keyword The word for suggestion with Longdo.
 */
- (void)suggestWithKeyword:(NSString *_Nonnull)keyword DEPRECATED_MSG_ATTRIBUTE("Use suggestKeyword:withOptions:result: instead.");

/**
 Search with Longdo Map POI.
 @param keyword An informative word for searching with Longdo.
 @param options Options for searching with Longdo.
 @param result A completion block to call when Point of Interest (POI) result is available.
 */
- (void)searchKeyword:(NSString *_Nonnull)keyword withOptions:(LMSearchOptions *_Nullable)options result:(void (^_Nonnull)(NSArray<LMPinAnnotation *> *_Nullable poi, NSError *_Nullable err))result;

/**
 Suggest with Longdo Map POI.
 @param keyword An informative word for suggestion with Longdo.
 @param options Options for suggestion with Longdo.
 @param result A completion block to call when a suggested name for each POI is available.
 */
- (void)suggestKeyword:(NSString *_Nonnull)keyword withOptions:(LMSuggestOptions *_Nullable)options result:(void (^_Nonnull)(NSArray<NSString *> *_Nullable keyword, NSError *_Nullable err))result;

/**
 Route with Longdo Map.
 @param start A starting point for routing with Longdo.
 @param destination A destination point for routing with Longdo.
 @param options Options for routing with Longdo.
 @param result A completion block to call when a routing result is available.
 */
- (void)routeFrom:(CLLocationCoordinate2D)start To:(CLLocationCoordinate2D)destination withOptions:(LMRouteOptions *_Nullable)options result:(void (^_Nonnull)(LMRouteResult *_Nullable route, NSError *_Nullable err))result;

#pragma mark - Traffic
/**
 Show event pins and data on Longdo Map.
 */
- (void)showEvents DEPRECATED_MSG_ATTRIBUTE("Use showsEvents = true instead.");

/**
 Show camera pins and data on Longdo Map.
 */
- (void)showCameras DEPRECATED_MSG_ATTRIBUTE("Use showsCameras = true instead.");

/**
 Remove event pins on Longdo Map.
 */
- (void)removeEvents DEPRECATED_MSG_ATTRIBUTE("Use showsEvents = false instead.");

/**
 Remove camera pins on Longdo Map.
 */
- (void)removeCameras DEPRECATED_MSG_ATTRIBUTE("Use showsCameras = false instead.");

/**
 Get VDO view from camera annotation data.
 */
- (UIView *_Nullable)getVDOViewFromCameraData:(LMCameraAnnotation *_Nonnull)camera;

@end
