//
//  ViewController.m
//  LongdoMapDemo
//
//  Created by Spicydog Proxy on 13-08-2015.
//  Copyright (c) 2015 MetaMedia Technology. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
  [super viewDidLoad];
  // Do any additional setup after loading the view, typically from a nib.
  
  _mapView.mapViewDelegate = self;
  _mapView = [_mapView initMapWithKey:@"LONGDO_MAP_DEMO_API_KEY"];
  
  
  UIImage *icon = [UIImage imageNamed:@"MarkerBuilding"];
  MMLocation location = MMLocationMake(13.722634, 100.529313);
  MMMarker *marker = [MMMarker markerWithImage:icon andLocation:location];
  [_mapView addMarker:marker];
  
  
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

// Map View Callbacks

// Map Status
- (void)mapView:(MMMapView *)mapView mapStatus:(int)status {
  
}

- (void)mapView:(MMMapView *)mapView mapState:(MMMapState)mapState {
  
}


// Click
- (void)mapView:(MMMapView *)mapView clickOnMarker:(MMMarker *)marker {
  
}

- (void)mapView:(MMMapView *)mapView clickOnLongdoTag:(NSDictionary *)data {
  
}

- (void)mapView:(MMMapView *)mapView clickedAtLocation:(MMLocation)location {
  
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
