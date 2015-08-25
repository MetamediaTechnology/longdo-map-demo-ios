//
//  ViewController.m
//  LongdoMapDemo
//
//  Created by Spicydog Proxy on 13-08-2015.
//  Copyright (c) 2015 MetaMedia Technology. All rights reserved.
//

#import "ViewController.h"

@interface ViewController () {
  bool isShowTagHospital;
  bool isShowTagGasStation;
  bool isShowTagBank;
  
  MMLongdoTag* tagHospital;
  MMLongdoTag* tagGasStation;
  MMLongdoTag* tagBank;
}

@end

@implementation ViewController

- (void)viewDidLoad {
  [super viewDidLoad];
  // Do any additional setup after loading the view, typically from a nib.
  
  _mapView.mapViewDelegate = self;
  _mapView = [_mapView initMapWithKey:@"LONGDO_MAP_DEMO_API_KEY"];
  
  // Initialize Longdo Tags
  tagHospital = [MMLongdoTag tagWithName:@"hospital"];
  tagGasStation = [MMLongdoTag tagWithName:@"gas_station"];
  tagBank = [MMLongdoTag tagWithName:@"bank"];
}

- (void)didReceiveMemoryWarning {
  [super didReceiveMemoryWarning];
  // Dispose of any resources that can be recreated.
}

- (IBAction)showNormalLayer:(id)sender {
  [_mapView removeAllOverlayLayers];
  
  MMLayer *layerNormal = [_mapView layerName:LAYER_NAME_NORMAL];
  [_mapView setBaseLayer:layerNormal];
}

- (IBAction)showTrafficLayer:(id)sender {
  [_mapView removeAllOverlayLayers];
  
  MMLayer *layerGray = [_mapView layerName:LAYER_NAME_GRAY];
  [_mapView setBaseLayer:layerGray];
  
  MMLayer *layerTraffic= [_mapView layerName:LAYER_NAME_TRAFFIC];
  [_mapView addOverlayLayer:layerTraffic];
}

- (IBAction)showSatelliteLayer:(id)sender {
  [_mapView removeAllOverlayLayers];
  
  MMLayer *layerThaichote = [_mapView layerName:LAYER_NAME_THAICHOTE];
  [_mapView setBaseLayer:layerThaichote];
  
  MMLayer *layerPoiTransparent = [_mapView layerName:LAYER_NAME_POI_TRANSPARENT];
  [_mapView addOverlayLayer:layerPoiTransparent];
}


- (IBAction)toggleTagHospital:(id)sender {
  isShowTagHospital = !isShowTagHospital;
  [self displayLongdoTags];
}

- (IBAction)toggleTagGasStation:(id)sender {
  isShowTagGasStation = !isShowTagGasStation;
  [self displayLongdoTags];
}

- (IBAction)toggleTagBank:(id)sender {
  isShowTagBank = !isShowTagBank;
  [self displayLongdoTags];
}



- (IBAction)zoomIn:(id)sender {
  [_mapView zoomIn];
}

- (IBAction)zoomOut:(id)sender {
  [_mapView zoomOut];
}

- (void)addUrlMarkerAtLocation:(MMLocation)location {
  NSString *pinUrl = @"http://map.longdo.com/mmmap/images/pin_mark_rotate.gif";
  MMMarker *marker = [MMMarker markerWithImageUrl:pinUrl
                                      andLocation:location];
  
  [marker setOffset:CGPointMake(0.3f, -0.5f)];
  [marker effectDrop:true];
  [_mapView addMarker:marker];
}


- (void)displayLongdoTags {
  NSMutableArray *longdoTags = [NSMutableArray array];
  
  if (isShowTagHospital) {
    [longdoTags addObject:tagHospital];
  }
  if (isShowTagGasStation) {
    [longdoTags addObject:tagGasStation];
  }
  if (isShowTagBank) {
    [longdoTags addObject:tagBank];
  }
  
  [_mapView showLongdoTags:longdoTags];
}

// Map View Callbacks

// Map Status
- (void)mapView:(MMMapView *)mapView mapStatus:(int)status {
  
}

- (void)mapView:(MMMapView *)mapView mapState:(MMMapState)mapState {
  
}


// Click
- (void)mapView:(MMMapView *)mapView clickOnMarker:(MMMarker *)marker {
  [_mapView removeMarker:marker];
}

- (void)mapView:(MMMapView *)mapView clickOnLongdoTag:(NSDictionary *)data {
  
}

- (void)mapView:(MMMapView *)mapView clickedAtLocation:(MMLocation)location {
  [self addUrlMarkerAtLocation:location];
}


// Long Click
- (void)mapView:(MMMapView *)mapView
longClickStartAtLocation:(MMLocation)location {
  
}

- (void)mapView:(MMMapView *)mapView
longClickFinishAtLocation:(MMLocation)location {
  
}


// Zooming
- (void)mapView:(MMMapView *)mapView startZoomFrom:(int)zoom {
  
}

- (void)mapView:(MMMapView *)mapView finishZoomTo:(int)zoom {
  
}


// Moving
- (void)mapView:(MMMapView *)mapView startMovingFrom:(MMLocation)location {
  
}

- (void)mapView:(MMMapView *)mapView finishMovingTo:(MMLocation)location {
  
}


// User Action
- (void)onUserPanning:(MMMapView *)mapView {
  
}

- (void)onUserZooming:(MMMapView *)mapView {
  
}

@end
