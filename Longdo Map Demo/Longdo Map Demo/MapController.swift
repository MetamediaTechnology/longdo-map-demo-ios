//
//  Map.swift
//  Longdo Map Demo
//
//  Created by กมลภพ จารุจิตต์ on 4/8/2567 BE.
//

import Foundation
import SwiftUI
import LongdoMapFramework
import CoreLocation
import Network

class MapController: NSObject, ObservableObject, CLLocationManagerDelegate {
    var map = LongdoMap()
    let locationManager = CLLocationManager()
    let loc = CLLocationCoordinate2D(latitude: 13.7, longitude: 100.5)
    var trackLocation = false
    var currentLocationMarker: LongdoMap.LDObject?
    var home: LongdoMap.LDObject?
    var marker: LongdoMap.LDObject?
    var layer: LongdoMap.LDObject?
    var popup: LongdoMap.LDObject?
    var geom: LongdoMap.LDObject?
    var object: LongdoMap.LDObject?
    var searchPoi: [LongdoMap.LDObject] = []
    var moveTimer: Timer?
    var rotateTimer: Timer?
    var followPathTimer: Timer?
    var guideTimer: Timer?
    var currentMethod: String?
    let monitor = NWPathMonitor()
    let queue = DispatchQueue.global(qos: .background)
    var networkStatus: NWPath.Status?
    
    func create(option: LongdoMap.Option) -> LongdoMap {
#warning("Please insert your Longdo Map API key.")
        map.apiKey = ""
        map.options = option
        map.render()
        monitor.pathUpdateHandler = { path in
            self.networkStatus = path.status
        }
        monitor.start(queue: queue)
        locationManager.delegate = self
        return map
    }
    
    func isConnectedToNetwork() -> Bool {
        if networkStatus != .satisfied {
            print("Internet connection is required for this feature.")
        }
        return networkStatus == .satisfied
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let location = locations.last else {
            return
        }
        if currentMethod == "location" {
            if currentLocationMarker == nil, let img = UIImage(named: "location.north.circle.fill") {
                self.currentLocationMarker = self.map.ldobject("Marker", with: [
                    location.coordinate,
                    [
                        "title": "Marker",
                        "icon": [
                            "url": img,
                            "size": CGSizeMake(24, 24)
                        ]
                    ]
                ])
                let _ = self.map.call(method: "Overlays.add", args: [self.currentLocationMarker!])
            }
            else {
                let _ = self.map.objectCall(ldobject: self.currentLocationMarker!, method: "move", args: [
                    location.coordinate,
                    true
                ])
            }
            if trackLocation {
                trackLocation = false
                let _ = self.map.call(method: "goTo", args: [[
                    "center": location.coordinate,
                    "zoom": 14
                ]])
            }
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateHeading newHeading: CLHeading) {
        if currentLocationMarker != nil {
            let _ = map.objectCall(ldobject: currentLocationMarker!, method: "update", args: [
                ["rotate": newHeading.trueHeading >= 0 ? newHeading.trueHeading : newHeading.magneticHeading]
            ])
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print(error)
    }
    
    func clearAll() {
        let _ = map.call(method: "Layers.setBase", args: [map.ldstatic("Layers", with: "NORMAL")])
        let _ = map.call(method: "language", args: [LongdoLocale.Thai])
        let _ = map.call(method: "Ui.Mouse.enableDrag", args: [true])
        let _ = map.call(method: "zoomRange", args: [1...18])
        let _ = map.call(method: "rotate", args: [0, true])
        let _ = map.call(method: "pitch", args: [0])
        let _ = map.call(method: "enableFilter", args: [
            map.ldstatic("Filter", with: "None")
        ])
        map.isUserInteractionEnabled = true
//        clearAllLayer()
        clearAllOverlays()
        clearAllTag()
        removeEventsAndCameras()
        removeGeometryObject()
        clearRoute()
        clearSearch()
        unbind()
        locationManager.stopUpdatingLocation()
        locationManager.stopUpdatingHeading()
        currentLocationMarker = nil
    }
    
    ///Note:
    ///> The `handler` parameter is not available. All handlers for the selected event name will be unbound.
    func unbind() {
        let event = ["GuideComplete", "Location", "Zoom", "ZoomRange", "Resize", "Click", "Drag", "Drop", "LayerChange", "OverlayClick", "OverlayChange", "OverlayLoad", "OverlayDrop", "BeforeContextmenu"]
        for i in event {
            let _ = self.map.call(method: "Event.unbind", args: [map.ldstatic("EventName", with: i)])
        }
    }
    
    func getNormalLayer(layerName: String) -> LongdoMap.LDStatic {
        return map.ldstatic("Layers", with: layerName)
    }
    
    // MARK: - Map Layers
    func selectLanguage() {
        let _ = map.call(method: "language", args: [LongdoLocale.English])
    }
    
    func setBaseLayer() {
        let _ = map.call(method: "Layers.setBase", args: [map.ldstatic("Layers", with: "GRAY")])
        
        let _ = self.map.call(method: "goTo", args: [[
            "center": CLLocationCoordinate2D(latitude: 13.7, longitude: 100.5),
            "zoom": 10
        ]])
    }
    
    func addLayer() {
        if isConnectedToNetwork() {
            let _ = map.call(method: "Layers.add", args: [map.ldstatic("Layers", with: "TRAFFIC")])
            
            let _ = self.map.call(method: "goTo", args: [[
                "center": CLLocationCoordinate2D(latitude: 13.7, longitude: 100.5),
                "zoom": 10
            ]])
        }
    }
    
    func removeTrafficLayer() {
        let _ = map.call(method: "Layers.remove", args: [map.ldstatic("Layers", with: "TRAFFIC")])
    }
    
    func clearAllLayer() {
        let _ = map.call(method: "Layers.clear", args: nil)
    }
    
    func addEventsAndCameras() {
        if isConnectedToNetwork() {
            let _ = map.call(method: "Overlays.load", args: [map.ldstatic("Overlays", with: "events")])
            let _ = map.call(method: "Overlays.load", args: [map.ldstatic("Overlays", with: "cameras")])
            
            let _ = self.map.call(method: "goTo", args: [[
                "center": CLLocationCoordinate2D(latitude: 13.71, longitude: 100.53),
                "zoom": 12
            ]])
        }
    }
    
    func removeEventsAndCameras() {
        let _ = map.call(method: "Overlays.unload", args: [map.ldstatic("Overlays", with: "events")])
        let _ = map.call(method: "Overlays.unload", args: [map.ldstatic("Overlays", with: "cameras")])
    }
    
    func addWMSLayer() {
        if isConnectedToNetwork() {
            layer = map.ldobject("Layer", with: [
                "bluemarble_terrain",
                [
                    "type": map.ldstatic("LayerType", with: "WMS"),
                    "url": "https://ms.longdo.com/mapproxy/service",
                    "zoomRange": 1...9,
                    "refresh": 180,
                    "opacity": 0.5,
                    "weight": 10,
                    "bound": [
                        "minLon": 100,
                        "minLat": 10,
                        "maxLon": 105,
                        "maxLat": 20
                    ]
                ]
            ])
            let _ = map.call(method: "Layers.add", args: [layer!])
            
            let _ = self.map.call(method: "goTo", args: [[
                "center": CLLocationCoordinate2D(latitude: 13.7, longitude: 100.5),
                "zoom": 8
            ]])
        }
    }
    
    func addTMSLayer() {
        if isConnectedToNetwork() {
            layer = map.ldobject("Layer", with: [
                "",
                [
                    "type": map.ldstatic("LayerType", with: "TMS"),
                    "url": "https://ms.longdo.com/mapproxy/tms/1.0.0/bluemarble_terrain/EPSG3857",
                    "bound": [
                        "minLon": 100.122195,
                        "minLat": 14.249463,
                        "maxLon": 100.533496,
                        "maxLat": 14.480279
                    ]
                ]
            ])
            let _ = map.call(method: "Layers.add", args: [layer!])
            
            let _ = self.map.call(method: "goTo", args: [[
                "center": CLLocationCoordinate2D(latitude: 14.35, longitude: 100.3)
            ]])
        }
    }
    
    func addWTMSLayer() {
        if isConnectedToNetwork() {
            layer = map.ldobject("Layer", with: [
                "bluemarble_terrain",
                [
                    "type": map.ldstatic("LayerType", with: "WMTS_REST"),
                    "url": "https://ms.longdo.com/mapproxy/wmts",
                    "srs": "GLOBAL_WEBMERCATOR",
                ]
            ])
            let _ = map.call(method: "Layers.add", args: [layer!])
            
            let _ = self.map.call(method: "goTo", args: [[
                "center": CLLocationCoordinate2D(latitude: 14.35, longitude: 100.3),
                "zoom": 10
            ]])
        }
    }
    
    func enableFilter() {
        let _ = map.call(method: "enableFilter", args: [
            map.ldstatic("Filter", with: "Dark")
        ])
    }
    
    func removeLayer() {
        if let l = layer {
            let _ = map.call(method: "Layers.remove", args: [l])
        }
    }
    
    // MARK: - Marker
    func addURLMarker() {
        DispatchQueue.main.async {
            self.marker = self.map.ldobject("Marker", with: [
                CLLocationCoordinate2D(latitude: 12.8, longitude: 101.2),
                [
                    "title": "Marker",
                    "icon": [
                        "url": UIImage(named: "pin_mark") ?? "https://map.longdo.com/mmmap/images/pin_mark.png",
                        "offset": [
                            "x": 12,
                            "y": 45
                        ]
                    ],
                    "detail": "Drag me",
                    "visibleRange": 7...9,
                    "draggable": true,
                    "weight": self.map.ldstatic("OverlayWeight", with: "Top")
                ]
            ])
            let _ = self.map.call(method: "Overlays.add", args: [self.marker!])
            
            let _ = self.map.call(method: "goTo", args: [[
                "center": CLLocationCoordinate2D(latitude: 12.8, longitude: 101.2),
                "zoom": 8
            ]])
        }
    }
    
    func addHTMLMarker() {
        marker = map.ldobject("Marker", with: [
            CLLocationCoordinate2D(latitude: 14.25, longitude: 99.35),
            [
                "title": "Custom Marker",
                "icon": [
                    "html": "<div style=\"font-size: 36px; border: 1px solid #000;\">♨</div>",
                    "offset": [
                        "x": 0,
                        "y": 0
                    ]
                ],
                "popup": [
                    "html": "<div style=\"font-size: 24px; background: #eef;\">Onsen</div>"
                ]
            ]
        ])
        let _ = map.call(method: "Overlays.add", args: [marker!])
        
        let _ = self.map.call(method: "goTo", args: [[
            "center": CLLocationCoordinate2D(latitude: 14.25, longitude: 99.35),
            "zoom": 8
        ]])
    }
    
    func addRotateMarker() {
        marker = map.ldobject("Marker", with: [
            CLLocationCoordinate2D(latitude: 13.84, longitude: 100.41),
            [
                "title": "Rotate Marker",
                "rotate": 90
            ]
        ])
        let _ = map.call(method: "Overlays.add", args: [marker!])
        
        let _ = self.map.call(method: "goTo", args: [[
            "center": CLLocationCoordinate2D(latitude: 13.84, longitude: 100.41),
            "zoom": 8
        ]])
    }
    
    func removeMarker() {
        if let m = marker {
            moveTimer?.invalidate()
            rotateTimer?.invalidate()
            followPathTimer?.invalidate()
            let _ = map.call(method: "Overlays.remove", args: [m])
        }
    }
    
    func markerList() -> Any {
        return map.call(method: "Overlays.list", args: nil) ?? "no result"
    }
    
    func markerCount() -> Any {
        return map.call(method: "Overlays.size", args: nil) ?? "no result"
    }
    
    func clearAllOverlays() {
        moveTimer?.invalidate()
        rotateTimer?.invalidate()
        followPathTimer?.invalidate()
        let _ = map.call(method: "Overlays.clear", args: nil)
    }
    
    func addPopup() {
        popup = map.ldobject("Popup", with: [
            CLLocationCoordinate2D(latitude: 14, longitude: 99),
            [
                "title": "Popup",
                "detail": "Simple popup"
            ]
        ])
        let _ = map.call(method: "Overlays.add", args: [popup!])
        
        let _ = self.map.call(method: "goTo", args: [[
            "center": CLLocationCoordinate2D(latitude: 14, longitude: 99),
            "zoom": 8
        ]])
    }
    
    func addCustomPopup() {
        popup = map.ldobject("Popup", with: [
            CLLocationCoordinate2D(latitude: 14, longitude: 101),
            [
                "title": "Popup",
                "detail": "Popup detail...",
                "loadDetail": map.ldfunction("e => setTimeout(() => e.innerHTML = 'Content changed', 1000)"),
                "size": [
                    "width": 200,
                    "height": 200
                ],
                "closable": false
            ]
        ])
        let _ = map.call(method: "Overlays.add", args: [popup!])
        
        let _ = self.map.call(method: "goTo", args: [[
            "center": CLLocationCoordinate2D(latitude: 14, longitude: 101),
            "zoom": 8
        ]])
    }
    
    func addHTMLPopup() {
        popup = map.ldobject("Popup", with: [
            CLLocationCoordinate2D(latitude: 14, longitude: 102),
            [
                "html": "<div style=\"background: #eeeeff;\">popup</div>"
            ]
        ])
        let _ = map.call(method: "Overlays.add", args: [popup!])
        
        let _ = self.map.call(method: "goTo", args: [[
            "center": CLLocationCoordinate2D(latitude: 14, longitude: 102),
            "zoom": 8
        ]])
    }
    
    func removePopup() {
        if let p = popup {
            let _ = map.call(method: "Overlays.remove", args: [p])
        }
    }
    
    func dropMarker() {
        marker = map.ldobject("Marker", with: [
            CLLocationCoordinate2D(latitude: 14.525007, longitude: 100.643005)
        ])
        let _ = map.call(method: "Overlays.drop", args: [marker!])
        
        let _ = self.map.call(method: "goTo", args: [[
            "center": CLLocationCoordinate2D(latitude: 14.525007, longitude: 100.643005),
            "zoom": 8
        ]])
    }
    
    func startBounceMarker() {
        marker = map.ldobject("Marker", with: [
            CLLocationCoordinate2D(latitude: 14.525007, longitude: 101.643005)
        ])
        let _ = map.call(method: "Overlays.add", args: [marker!])
        let _ = map.call(method: "Overlays.bounce", args: [marker!])
        
        let _ = self.map.call(method: "goTo", args: [[
            "center": CLLocationCoordinate2D(latitude: 14.525007, longitude: 101.643005),
            "zoom": 8
        ]])
    }
    
    func stopBounceMarker() {
        let _ = map.call(method: "Overlays.bounce", args: nil)
    }
    
    func moveMarker() {
        marker = map.ldobject("Marker", with: [
            CLLocationCoordinate2D(latitude: 15.525007, longitude: 100.643005)
        ])
        let _ = map.call(method: "Overlays.add", args: [marker!])
        moveOut()
        
        let _ = self.map.call(method: "goTo", args: [[
            "center": CLLocationCoordinate2D(latitude: 15, longitude: 102),
            "zoom": 6
        ]])
    }
    
    @objc func moveOut() {
        let _ = map.objectCall(ldobject: marker!, method: "move", args: [
            CLLocationCoordinate2D(latitude: 15, longitude: 102),
            true
        ])
        moveTimer = Timer.scheduledTimer(timeInterval: 3.0, target: self, selector: #selector(self.moveBack), userInfo: nil, repeats: false)
    }
    
    @objc func moveBack() {
        let _ = map.objectCall(ldobject: marker!, method: "move", args: [
            CLLocationCoordinate2D(latitude: 15.525007, longitude: 100.643005),
            true
        ])
        moveTimer = Timer.scheduledTimer(timeInterval: 3.0, target: self, selector: #selector(self.moveOut), userInfo: nil, repeats: false)
    }
    
    func rotateMarker() {
        marker = map.ldobject("Marker", with: [
            CLLocationCoordinate2D(latitude: 15.525007, longitude: 100.643005)
        ])
        let _ = map.call(method: "Overlays.add", args: [marker!])
        rotateTimer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(self.rotateClockwise), userInfo: nil, repeats: true)
        
        let _ = self.map.call(method: "goTo", args: [[
            "center": CLLocationCoordinate2D(latitude: 15.525007, longitude: 100.643005),
            "zoom": 8
        ]])
    }
    
    @objc func rotateClockwise() {
        let _ = map.objectCall(ldobject: marker!, method: "update", args: [
            ["rotate": (Date().timeIntervalSince1970.truncatingRemainder(dividingBy: 60)) * 6]
        ])
    }
    
    //Coming soon
    func followPathMarker() {
        marker = map.ldobject("Marker", with: [
            CLLocationCoordinate2D(latitude: 15.525007, longitude: 101.643005)
        ])
        let _ = map.call(method: "Overlays.add", args: [marker!])
        followPathTimer = Timer.scheduledTimer(timeInterval: 5.0, target: self, selector: #selector(self.followPath), userInfo: nil, repeats: true)
        
        let _ = self.map.call(method: "goTo", args: [[
            "center": CLLocationCoordinate2D(latitude: 15.525007, longitude: 101.643005),
            "zoom": 8
        ]])
    }
    
    @objc func followPath() {
        let line = map.ldobject("Polyline", with: [
            CLLocationCoordinate2D(latitude: 18, longitude: 102),
            CLLocationCoordinate2D(latitude: 17, longitude: 98),
            CLLocationCoordinate2D(latitude: 14, longitude: 99),
            CLLocationCoordinate2D(latitude: 15.525007, longitude: 101.643005)
        ])
        let _ = map.call(method: "Overlays.pathAnimation", args: [
            marker!,
            line
        ])
    }
    
    // MARK: - Tag
    func addLocalTag() {
        let _ = map.call(method: "Tags.add", args: [
            { (tile: [String: Any], zoom: Int) -> Void in
                if let bbox = tile["bbox"] as? [String: Double] {
                    for _ in 1...3 {
                        let m = self.map.ldobject("Marker", with: [
                                CLLocationCoordinate2D(
                                    latitude: Double.random(in: bbox["south"]!...bbox["north"]!),
                                    longitude: Double.random(in: bbox["west"]!...bbox["east"]!)
                                ),
                                [
                                    "visibleRange": zoom...zoom
                                ]
                            ])
                        let _ = self.map.call(method: "Overlays.add", args: [m])
                    }
                }
            }
        ])
        
        let _ = self.map.call(method: "goTo", args: [[
            "center": CLLocationCoordinate2D(latitude: 13.7, longitude: 100.5),
            "zoom": 12
        ]])
    }
    
    func addLongdoTag() {
        let _ = map.call(method: "Tags.add", args: ["shopping"])
        
        let _ = self.map.call(method: "goTo", args: [[
            "center": CLLocationCoordinate2D(latitude: 13.7, longitude: 100.5),
            "zoom": 12
        ]])
    }
    
    func addTagWithOption() {
        let _ = map.call(method: "Tags.add", args: [
            "hotel",
            [
                "visibleRange": 10...20,
                "icon": [
                    "url": UIImage(named: "pin_mark") ??  "https://map.longdo.com/mmmap/images/pin_mark.png",
                    "offset": [
                        "x": 12,
                        "y": 45
                    ]
                ]
            ]
        ])
        
        let _ = self.map.call(method: "goTo", args: [[
            "center": CLLocationCoordinate2D(latitude: 13.7, longitude: 100.5),
            "zoom": 12
        ]])
    }
    
    func addTagWithGeocode() {
        let _ = map.call(method: "Tags.add", args: [
            "shopping",
            [
                "area": 10
            ]
        ])
        
        let _ = self.map.call(method: "goTo", args: [[
            "center": CLLocationCoordinate2D(latitude: 13.7, longitude: 100.5),
            "zoom": 8
        ]])
    }
    
    func removeTag() {
        let _ = map.call(method: "Tags.remove", args: ["hotel"])
        let _ = map.call(method: "Tags.remove", args: ["shopping"])
    }
    
    func clearAllTag() {
        let _ = map.call(method: "Tags.clear", args: nil)
    }
    
    // MARK: - Geometry
    func addLine() {
        geom = map.ldobject("Polyline", with: [[
            CLLocationCoordinate2D(latitude: 15, longitude: 100),
            CLLocationCoordinate2D(latitude: 10, longitude: 100)
        ]])
        let _ = map.call(method: "Overlays.add", args: [geom!])
        
        let _ = self.map.call(method: "goTo", args: [[
            "center": CLLocationCoordinate2D(latitude: 13.7, longitude: 100.5),
            "zoom": 6
        ]])
    }
    
    func removeOverlay() {
        if let g = geom {
            let _ = map.call(method: "Overlays.remove", args: [g])
        }
    }
    
    func addLineWithOption() {
        geom = map.ldobject("Polyline", with: [
            [
                CLLocationCoordinate2D(latitude: 14, longitude: 100),
                CLLocationCoordinate2D(latitude: 15, longitude: 101),
                CLLocationCoordinate2D(latitude: 14, longitude: 102)
            ],
            [
                "title": "Polyline",
                "detail": "-",
                "label": "Polyline",
                "lineWidth": 4,
                "lineColor": UIColor.systemRed
            ]
        ])
        let _ = map.call(method: "Overlays.add", args: [geom!])
        
        let _ = self.map.call(method: "goTo", args: [[
            "center": CLLocationCoordinate2D(latitude: 15, longitude: 101),
            "zoom": 6
        ]])
    }
    
    func addDashLine() {
        geom = map.ldobject("Polyline", with: [
            [
                CLLocationCoordinate2D(latitude: 14, longitude: 99),
                CLLocationCoordinate2D(latitude: 15, longitude: 100),
                CLLocationCoordinate2D(latitude: 14, longitude: 101)
            ],
            [
                "title": "Dashline",
                "detail": "-",
                "label": "Dashline",
                "lineWidth": 4,
                "lineColor": UIColor.systemGreen,
                "lineStyle": map.ldstatic("LineStyle", with: "Dashed")
            ]
        ])
        let _ = map.call(method: "Overlays.add", args: [geom!])
        
        let _ = self.map.call(method: "goTo", args: [[
            "center": CLLocationCoordinate2D(latitude: 15, longitude: 100),
            "zoom": 6
        ]])
    }
    
    func addPolygon() {
        geom = map.ldobject("Polygon", with: [
            [
                CLLocationCoordinate2D(latitude: 14, longitude: 99),
                CLLocationCoordinate2D(latitude: 13, longitude: 100),
                CLLocationCoordinate2D(latitude: 13, longitude: 102),
                CLLocationCoordinate2D(latitude: 14, longitude: 103)
            ],
            [
                "title": "Polygon",
                "detail": "-",
                "label": "Polygon",
                "lineWidth": 2,
                "lineColor": UIColor.black,
                "fillColor": UIColor.init(red: 1, green: 0, blue: 0, alpha: 0.4),
                "visibleRange": 6...18,
                "editable": true,
                "weight": map.ldstatic("OverlayWeight", with: "Top")
            ]
        ])
        let _ = map.call(method: "Overlays.add", args: [geom!])
        
        let _ = self.map.call(method: "goTo", args: [[
            "center": CLLocationCoordinate2D(latitude: 13, longitude: 101),
            "zoom": 6
        ]])
    }
    
    func addCircle() {
        geom = map.ldobject("Circle", with: [
            CLLocationCoordinate2D(latitude: 15, longitude: 101),
            1,
            [
                "title": "Geom 3",
                "detail": "-",
                "lineWidth": 2,
                "lineColor": UIColor.red.withAlphaComponent(0.8),
                "fillColor": UIColor.red.withAlphaComponent(0.4)
            ]
        ])
        let _ = map.call(method: "Overlays.add", args: [geom!])
        
        let _ = self.map.call(method: "goTo", args: [[
            "center": CLLocationCoordinate2D(latitude: 15, longitude: 101),
            "zoom": 6
        ]])
    }
    
    func addDot() {
        geom = map.ldobject("Dot", with: [
            CLLocationCoordinate2D(latitude: 12.5, longitude: 100.5),
            [
                "lineWidth": 20,
                "draggable": true
            ]
        ])
        let _ = map.call(method: "Overlays.add", args: [geom!])
        
        let _ = self.map.call(method: "goTo", args: [[
            "center": CLLocationCoordinate2D(latitude: 12.5, longitude: 100.5),
            "zoom": 6
        ]])
    }
    
    func addDonut() {
        geom = map.ldobject("Polygon", with: [
            [
                CLLocationCoordinate2D(latitude: 15, longitude: 101),
                CLLocationCoordinate2D(latitude: 15, longitude: 105),
                CLLocationCoordinate2D(latitude: 12, longitude: 103),
                nil,
                CLLocationCoordinate2D(latitude: 14.9, longitude: 103),
                CLLocationCoordinate2D(latitude: 13.5, longitude: 102.1),
                CLLocationCoordinate2D(latitude: 13.5, longitude: 103.9)
            ],
            [
                "label": 20,
                "clickable": true
            ]
        ])
        let _ = map.call(method: "Overlays.add", args: [geom!])
        
        let _ = self.map.call(method: "goTo", args: [[
            "center": CLLocationCoordinate2D(latitude: 13.5, longitude: 103),
            "zoom": 6
        ]])
    }
    
    func addRectangle() {
        geom = map.ldobject("Rectangle", with: [
            CLLocationCoordinate2D(latitude: 17, longitude: 97),
            [
                "width": 2,
                "height": 1
            ],
            [
                "editable": true
            ]
        ])
        let _ = map.call(method: "Overlays.add", args: [geom!])
        
        let _ = self.map.call(method: "goTo", args: [[
            "center": CLLocationCoordinate2D(latitude: 16, longitude: 97.5),
            "zoom": 6
        ]])
    }
    
    func addImageAsLayer() {
        if let imageBase64 = UIImage(named: "Bangkok-central-map") {
            let originalImgSizePx = imageBase64.size
            let pinLocation = CLLocationCoordinate2D(latitude: 13.74745, longitude: 100.519455)
            let drawScaleWidth = 0.0612;
            let drawScaleHeight = 0.0587;
            let size = CGSize(
                width: originalImgSizePx.width < originalImgSizePx.height ? drawScaleWidth
                    : (drawScaleWidth * originalImgSizePx.width) / originalImgSizePx.height,
                height: originalImgSizePx.height < originalImgSizePx.width ? drawScaleHeight
                    : (drawScaleHeight * originalImgSizePx.height) / originalImgSizePx.width)
            let topLeftLocation = CLLocationCoordinate2D(latitude: pinLocation.latitude + size.height / 2, longitude: pinLocation.longitude - size.width / 2)
            geom = map.ldobject("Rectangle", with: [
                topLeftLocation,
                size,
                [
                    "lineWidth": 2,
                    "lineColor": UIColor.black,
                    "fillColor": UIColor.clear,
                    "texture": imageBase64,
                    "textureAlpha": 1,
                ]
            ])
                
            let _ = map.call(method: "Overlays.add", args: [geom!])
            let _ = map.call(method: "goTo", args: [[ "center": pinLocation, "zoom": 13 ]])
        }
    }
    
    func geometryLocation() -> Any {
        if let g = geom {
            return map.objectCall(ldobject: g, method: "location", args: nil) ?? "N/A"
        }
        return "N/A"
    }
    
    // MARK: - Administration
    func addBangkok() {
        if isConnectedToNetwork() {
            object = map.ldobject("Overlays.Object", with: [
                10,
                "IG"
            ])
            let _ = map.call(method: "Overlays.load", args: [object!])
            
            let _ = self.map.call(method: "goTo", args: [[
                "center": CLLocationCoordinate2D(latitude: 13.71, longitude: 100.53),
                "zoom": 7
            ]])
        }
    }
    
    func addEastRegion() {
        if isConnectedToNetwork() {
            object = map.ldobject("Overlays.Object", with: [
                "2_",
                "IG"
            ])
            let _ = map.call(method: "Overlays.load", args: [object!])
            
            let _ = self.map.call(method: "goTo", args: [[
                "center": CLLocationCoordinate2D(latitude: 13.45, longitude: 101.87),
                "zoom": 6
            ]])
        }
    }
    
    func addBangkokDistrict() {
        if isConnectedToNetwork() {
            object = map.ldobject("Overlays.Object", with: [
                "10__",
                "IG"
            ])
            let _ = map.call(method: "Overlays.load", args: [object!])
            
            let _ = self.map.call(method: "goTo", args: [[
                "center": CLLocationCoordinate2D(latitude: 13.71, longitude: 100.53),
                "zoom": 8
            ]])
        }
    }
    
    func addMultipleSubdistrict() {
        if isConnectedToNetwork() {
            object = map.ldobject("Overlays.Object", with: [
                "610604;610607;610703;610704;610802",
                "IG",
                [
                    "combine": true,
                    "simplify": 0.00005,
                    "ignorefragment": false
                ]
            ])
            let _ = map.call(method: "Overlays.load", args: [object!])
            
            let _ = self.map.call(method: "goTo", args: [[
                "center": CLLocationCoordinate2D(latitude: 15.34, longitude: 99.25),
                "zoom": 7
            ]])
        }
    }
    
    func addProvinceWithOption() {
        if isConnectedToNetwork() {
            object = map.ldobject("Overlays.Object", with: [
                "12",
                "IG",
                [
                    "title": "นนทบุรี",
                    "label": "นนทบุรี",
                    "lineColor": UIColor.init(white: 0.5, alpha: 1),
                    "fillColor": nil
                ]
            ])
            let _ = map.call(method: "Overlays.load", args: [object!])
            
            let _ = self.map.call(method: "goTo", args: [[
                "center": CLLocationCoordinate2D(latitude: 13.97, longitude: 100.39),
                "zoom": 9
            ]])
        }
    }
    
    func addSubdistrictByName() {
        if isConnectedToNetwork() {
            object = map.ldobject("Overlays.Object", with: [
                "นนทบุรี",
                "ADM"
            ])
            let _ = map.call(method: "Overlays.load", args: [object!])
            
            let _ = self.map.call(method: "goTo", args: [[
                "center": CLLocationCoordinate2D(latitude: 13.97, longitude: 100.39),
                "zoom": 9
            ]])
        }
    }
    
    func addLongdoPlace() {
        if isConnectedToNetwork() {
            object = map.ldobject("Overlays.Object", with: [
                "A10000001",
                "LONGDO"
            ])
            let _ = map.call(method: "Overlays.load", args: [object!])
            
            let _ = self.map.call(method: "goTo", args: [[
                "center": CLLocationCoordinate2D(latitude: 13.722731, longitude: 100.529571),
                "zoom": 14
            ]])
        }
    }
    
    func removeGeometryObject() {
        if let o = object {
            let _ = map.call(method: "Overlays.unload", args: [o])
        }
    }
    
    // MARK: - Route
    func getRoute() {
        if isConnectedToNetwork() {
            marker = map.ldobject("Marker", with: [
                CLLocationCoordinate2D(latitude: 13.764953, longitude: 100.538316),
                [
                    "title": "Victory monument",
                    "detail": "I'm here"
                ]
            ])
            let _ = map.call(method: "Route.add", args: [marker!])
            let _ = map.call(method: "Route.add", args: [
                CLLocationCoordinate2D(latitude: 15, longitude: 100)
            ])
            let _ = map.call(method: "Route.search", args: nil)
            
            let _ = self.map.call(method: "goTo", args: [[
                "center": CLLocationCoordinate2D(latitude: 14.48, longitude: 100.36),
                "zoom": 8
            ]])
        }
    }
    
    func autoReroute() {
        clearRoute()
        getRoute()
        let _ = map.call(method: "Route.auto", args: [true])
    }
    
    func getRouteByCost() {
        clearRoute()
        let _ = map.call(method: "Route.mode", args: [map.ldstatic("RouteMode", with: "Cost")])
        getRoute()
    }
    
    func getRouteByDistance() {
        clearRoute()
        let _ = map.call(method: "Route.mode", args: [map.ldstatic("RouteMode", with: "Distance")])
        getRoute()
    }
    
    func getRouteWithoutTollway() {
        clearRoute()
        let _ = map.call(method: "Route.enableRoute", args: [
            map.ldstatic("RouteType", with: "Tollway"),
            false
        ])
        getRoute()
    }
    
    func getRouteWithMotorcycle() {
        clearRoute()
        let _ = map.call(method: "Route.enableRestrict", args: [
            map.ldstatic("RouteRestrict", with: "Bike"),
            true
        ])
        getRoute()
    }
    
    func getRouteGuide(completion: @escaping (_ message: String) -> Void) {
        clearRoute()
        unbind()
        let _ = map.call(method: "Event.bind", args: [
            map.ldstatic("EventName", with: "GuideComplete"),
            {
                (guide: Any?) -> Void in
                print(guide ?? "no data")
                if let g = guide as? [[String: Any]], g.count > 0,
                    let turn = g[0]["guide"] as? [[String: Any?]],
                    let data = g[0]["data"] as? [String: Any] {
                    var str = ["ออกจาก จุดเริ่มต้น \(round(data["fdistance"] as? Double ?? 0) / 1000) กม."]
                    let turnText = ["เลี้ยวซ้ายสู่", "เลี้ยวขวาสู่", "เบี่ยงซ้ายสู่", "เบี่ยงขวาสู่", "ไปตาม", "ตรงไปตาม", "เข้าสู่", "", "", "ถึง", "", "", "", "", ""]
                    for i in turn {
                        str.append("\(turnText[(i["turn"] as? LongdoTurn ?? .Unknown).rawValue]) \(i["name"] as? String ?? "") \(round(i["distance"] as? Double ?? 0) / 1000) กม.")
                    }
                    str.append("รวมระยะทาง \(round(data["distance"] as? Double ?? 0) / 1000) กม. เวลา \(Int(floor((data["interval"] as? Double ?? 0) / 3600))) ชม. \(Int(ceil(Double((data["interval"] as? Int ?? 0) % 3600) / 60))) น.")
                    completion("\(str.joined(separator: "\n"))")
                }
            }
        ])
        getRoute()
    }
    
    func clearRoute() {
        let _ = map.call(method: "Route.clear", args: nil)
        let _ = map.call(method: "Route.clearPath", args: nil)
    }
    
    // MARK: - Search
    func searchCentral() {
        if isConnectedToNetwork() {
            let _ = self.map.call(method: "goTo", args: [[
                "center": CLLocationCoordinate2D(latitude: 13.813, longitude: 100.546),
                "zoom": 11
            ]])
            
            let _ = map.call(method: "Search.search", args: [
                "central",
                [
                    "area": 10, //Bangkok geocode
                    "tag": "hotel",
                    "span": "2000km",
                    "limit": 10
                ]
            ])
            {
                (data: Any?) -> Void in
                if let result = data as? [String: Any?], let poi = result["data"] as? [[String: Any?]] {
                    self.searchPoi = []
                    for i in poi {
                        if let lat = i["lat"] as? Double, let lon = i["lon"] as? Double {
                            let poiMarker = self.map.ldobject("Marker", with: [
                                CLLocationCoordinate2D(latitude: lat, longitude: lon),
                                [
                                    "title": i["name"],
                                    "detail": i["address"]
                                ]
                            ])
                            self.searchPoi.append(poiMarker)
                            if let newPoi = self.searchPoi.last {
                                let _ = self.map.call(method: "Overlays.add", args: [newPoi])
                            }
                        }
                    }
                }
            }
        }
    }
    
    func searchInEnglish() {
        let _ = map.call(method: "Search.language", args: [LongdoLocale.English])
        searchCentral()
    }
    
    func suggestCentral(completion: @escaping (_ message: String) -> Void) {
        if isConnectedToNetwork() {
            let _ = map.call(method: "Search.suggest", args: [
                "central",
                [
                    "area": 10 //Bangkok geocode
                ]
            ])
            {
                (data: Any?) -> Void in
                if let result = data as? [String: Any?], let poi = result["data"] as? [[String: Any?]] {
                    var str: [String] = []
                    for i in poi {
                        if let word = i["w"] as? String {
                            str.append("- \(word)")
                        }
                    }
                    completion(str.joined(separator: "\n"))
                }
            }
        }
    }
    
    func clearSearch() {
        for m in searchPoi {
            let _ = map.call(method: "Overlays.remove", args: [m])
        }
    }
    
    // MARK: - Conversion
    func getGeoCode(completion: @escaping (_ message: String) -> Void) {
        if isConnectedToNetwork() {
            if let pos = map.call(method: "location", args: nil) {
                let _ = map.call(method: "Search.address", args: [pos])
                {
                    (data: Any?) -> Void in
                    completion("\(data ?? "no data")")
                }
            }
            else {
                completion("no location")
            }
        }
    }
    
    func getLatitudeLength(completion: @escaping (_ message: String) -> Void) {
        if let pos = map.call(method: "location", args: nil) as? CLLocationCoordinate2D {
            if let radian = map.call(method: "Util.latitudeLength", args: [pos.latitude]) {
                completion("Distance for 1 radian at latitude \(pos.latitude) = \(radian) metres.")
            }
            else {
                completion("no data")
            }
        }
        else {
            completion("no location")
        }
    }
    
    // MARK: - Events
    func locationEvent(completion: @escaping (_ message: String) -> Void) {
        unbind()
        let _ = map.call(method: "Event.bind", args: [
            map.ldstatic("EventName", with: "Location"),
            {
                () -> Void in
                if let pos = self.map.call(method: "location", args: nil) {
                    completion("\(pos)")
                }
            }
        ])
    }
    
    func zoomEvent(completion: @escaping (_ message: String) -> Void) {
        unbind()
        let _ = map.call(method: "Event.bind", args: [
            map.ldstatic("EventName", with: "Zoom"),
            {
                () -> Void in
                if let zoom = self.map.call(method: "zoom", args: nil) {
                    completion("\(zoom)")
                }
            }
        ])
    }
    
    func zoomRangeEvent(completion: @escaping (_ message: String) -> Void) {
        unbind()
        let _ = map.call(method: "Event.bind", args: [
            map.ldstatic("EventName", with: "ZoomRange"),
            {
                () -> Void in
                if let zr = self.map.call(method: "zoomRange", args: nil) {
                    completion("\(zr)")
                }
            }
        ])
        let _ = map.call(method: "zoomRange", args: [1...10])
    }
    
    func resizeEvent(completion: @escaping (_ message: String) -> Void) {
        unbind()
        let _ = self.map.call(method: "Event.bind", args: [
            map.ldstatic("EventName", with: "Resize"),
            {
                () -> Void in
                if let bound = self.map.call(method: "bound", args: nil) {
                    completion("\(bound)")
                }
            }
        ])
    }
    
    func clickEvent() {
        unbind()
        let _ = self.map.call(method: "Event.bind", args: [
            map.ldstatic("EventName", with: "Click"),
            {
                (result: Any?) -> Void in
                if let pos = result as? [String: Double] {
                    DispatchQueue.main.async {
                        self.marker = self.map.ldobject("Marker", with: [pos])
                        let _ = self.map.call(method: "Overlays.add", args: [self.marker!])
                    }
                }
            }
        ])
    }
    
    func longTapEvent() {
        unbind()
        let _ = self.map.call(method: "Event.bind", args: [
            map.ldstatic("EventName", with: "BeforeContextmenu"),
            {
                (result: Any?) -> Void in
                if let data = result as? [String: CLLocationCoordinate2D], let pos = data["location"] {
                    DispatchQueue.main.async {
                        self.marker = self.map.ldobject("Marker", with: [pos])
                        let _ = self.map.call(method: "Overlays.add", args: [self.marker!])
                    }
                }
            },
            false
        ])
    }
    
    func dragEvent(completion: @escaping (_ message: String) -> Void) {
        unbind()
        let _ = self.map.call(method: "Event.bind", args: [
            map.ldstatic("EventName", with: "Drag"),
            {
                (result: Any?) -> Void in
                completion("Drag event triggered.")
            }
        ])
    }
    
    func dropEvent(completion: @escaping (_ message: String) -> Void) {
        unbind()
        let _ = self.map.call(method: "Event.bind", args: [
            map.ldstatic("EventName", with: "Drop"),
            {
                (result: Any?) -> Void in
                completion("Drop event triggered.")
            }
        ])
    }
    
    func layerChangeEvent(completion: @escaping (_ message: String) -> Void) {
        unbind()
        let _ = self.map.call(method: "Event.bind", args: [
            map.ldstatic("EventName", with: "LayerChange"),
            {
                (result: Any?) -> Void in
                completion("\(result ?? "no data")")
            }
        ])
        addLayer()
    }
    
    func overlayClickEvent(completion: @escaping (_ message: String) -> Void) {
        unbind()
        let _ = self.map.call(method: "Event.bind", args: [
            map.ldstatic("EventName", with: "OverlayClick"),
            {
                (result: Any?) -> Void in
                completion("\(result ?? "no data")")
            }
        ])
        addURLMarker()
    }
    
    func overlayChangeEvent(completion: @escaping (_ message: String) -> Void) {
        unbind()
        let _ = self.map.call(method: "Event.bind", args: [
            map.ldstatic("EventName", with: "OverlayChange"),
            {
                (result: Any?) -> Void in
                completion("\(result ?? "no data")")
            }
        ])
        addURLMarker()
    }
    
    func overlayLoadEvent(completion: @escaping (_ message: String) -> Void) {
        unbind()
        let _ = self.map.call(method: "Event.bind", args: [
            map.ldstatic("EventName", with: "OverlayLoad"),
            {
                (result: Any?) -> Void in
                completion("\(result ?? "no data")")
            }
        ])
        addBangkok()
    }
    
    func overlayDropEvent(completion: @escaping (_ message: String) -> Void) {
        unbind()
        let _ = self.map.call(method: "Event.bind", args: [
            map.ldstatic("EventName", with: "OverlayDrop"),
            {
                (result: Any?) -> Void in
                completion("\(result ?? "no data")")
            }
        ])
        addURLMarker()
    }
    
    // MARK: - User Interface
    func setCustomLocation() {
        let _ = self.map.call(method: "location", args: [
            CLLocationCoordinate2D(latitude: 16, longitude: 100),
            true
        ])
    }
    
    func setGeoLocation() {
        currentMethod = "location"
        trackLocation = true
        locationManager.requestWhenInUseAuthorization()
        locationManager.startUpdatingLocation()
        locationManager.startUpdatingHeading()
        //see func locationManager
    }
    
    func getLocation() -> Any {
        return map.call(method: "location", args: nil) ?? "no result"
    }
    
    func setZoom() {
        let _ = map.call(method: "zoom", args: [14, true])
    }
    
    func setLocationAndZoom() {
        let _ = map.call(method: "goTo", args: [[
            "center": CLLocationCoordinate2D(latitude: 16, longitude: 100),
            "zoom": 13
        ]])
    }
    
    func setRotate() {
        let _ = map.call(method: "rotate", args: [30, true])
    }
    
    func setPitch() {
        let _ = map.call(method: "pitch", args: [60])
    }
    
    func zoomIn() {
        let _ = map.call(method: "zoom", args: [true, true])
    }
    
    func zoomOut() {
        let _ = map.call(method: "zoom", args: [false, true])
    }
    
    func setZoomRange() {
        let _ = map.call(method: "zoomRange", args: [1...5])
    }
    
    func getZoomRange() -> Any {
        return map.call(method: "zoomRange", args: nil) ?? "no data"
    }
    
    func setBound() {
        let _ = map.call(method: "bound", args: [[
            "minLat": 13,
            "maxLat": 14,
            "minLon": 100,
            "maxLon": 101
        ]])
    }
    
    func getBound() -> Any {
        return map.call(method: "bound", args: nil) ?? "no data"
    }
    
    func toggleDPad() {
        let _ = map.call(method: "Ui.DPad.visible", args: [
            !(map.call(method: "Ui.DPad.visible", args: nil) as? Bool ?? false)
        ])
    }
    
    func toggleZoombar() {
        let _ = map.call(method: "Ui.Zoombar.visible", args: [
            !(map.call(method: "Ui.Zoombar.visible", args: nil) as? Bool ?? false)
        ])
    }
    
    func toggleLayerSelector() {
        let _ = map.call(method: "Ui.LayerSelector.visible", args: [
            !(map.call(method: "Ui.LayerSelector.visible", args: nil) as? Bool ?? false)
        ])
    }
    
    func toggleCrosshair() {
        let _ = map.call(method: "Ui.Crosshair.visible", args: [
            !(map.call(method: "Ui.Crosshair.visible", args: nil) as? Bool ?? false)
        ])
    }
    
    func toggleScale() {
        let _ = map.call(method: "Ui.Scale.visible", args: [
            !(map.call(method: "Ui.Scale.visible", args: nil) as? Bool ?? false)
        ])
    }
    
    func toggleTerrain() {
        let _ = map.call(method: "Ui.Terrain.visible", args: [
            !(map.call(method: "Ui.Terrain.visible", args: nil) as? Bool ?? false)
        ])
    }
    
    func toggleTouchAndDrag() {
        map.isUserInteractionEnabled = !map.isUserInteractionEnabled
    }
    
    func toggleDrag() {
        let _ = map.call(method: "Ui.Mouse.enableDrag", args: [
            !(map.call(method: "Ui.Mouse.enableDrag", args: nil) as? Bool ?? false)
        ])
    }
    
    // MARK: - Etc.
    func getOverlayType(completion: @escaping (_ message: String) -> Void) {
        unbind()
        let _ = self.map.call(method: "Event.bind", args: [
            map.ldstatic("EventName", with: "OverlayClick"),
            {
                (result: Any?) -> Void in
                if let overlay = result as? LongdoMap.LDObject {
                    completion("\(overlay.type)")
                }
            }
        ])
        DispatchQueue.main.async {
            self.marker = self.map.ldobject("Marker", with: [
                CLLocationCoordinate2D(latitude: 12.8, longitude: 101.2)
            ])
            let _ = self.map.call(method: "Overlays.add", args: [self.marker!])
        }
        
        let _ = self.map.call(method: "goTo", args: [[
            "center": CLLocationCoordinate2D(latitude: 12.8, longitude: 101.2),
            "zoom": 12
        ]])
    }
    
    func getDistance(completion: @escaping (_ message: String) -> Void) {
        var markerCar1: LongdoMap.LDObject?
        var markerCar2: LongdoMap.LDObject?
        var geom1: LongdoMap.LDObject?
        
        unbind()
        let _ = self.map.call(method: "Event.bind", args: [
            map.ldstatic("EventName", with: "OverlayDrop"),
            {
                (result: Any?) -> Void in
                let _ = self.map.call(method: "Overlays.remove", args: [geom1!])
                geom1 = self.map.ldobject("Polyline", with: [
                    [
                        self.map.objectCall(ldobject: markerCar1!, method: "location", args: nil),
                        self.map.objectCall(ldobject: markerCar2!, method: "location", args: nil)
                    ],
                    [
                        "lineColor": UIColor.blue.withAlphaComponent(0.6)
                    ]
                ])
                let _ = self.map.call(method: "Overlays.add", args: [geom1!])
                if let distance = self.map.objectCall(ldobject: markerCar1!, method: "distance", args: [markerCar2!]) as? Double {
                    completion("ระยะกระจัด \(round(distance) / 1000.0) กิโลเมตร")
                }
            }
        ])
        DispatchQueue.main.async {
            markerCar1 = self.map.ldobject("Marker", with: [
                CLLocationCoordinate2D(latitude: 13.686867, longitude: 100.426157),
                [
                    "draggable": true
                ]
            ])
            markerCar2 = self.map.ldobject("Marker", with: [
                CLLocationCoordinate2D(latitude: 13.712259, longitude: 100.457989),
                [
                    "draggable": true
                ]
            ])
            geom1 = self.map.ldobject("Polyline", with: [
                [
                    self.map.objectCall(ldobject: markerCar1!, method: "location", args: nil),
                    self.map.objectCall(ldobject: markerCar2!, method: "location", args: nil)
                ],
                [
                    "lineColor": UIColor.blue.withAlphaComponent(0.6)
                ]
            ])
            let _ = self.map.call(method: "Overlays.add", args: [markerCar1!])
            let _ = self.map.call(method: "Overlays.add", args: [markerCar2!])
            let _ = self.map.call(method: "Overlays.add", args: [geom1!])
            if let distance = self.map.objectCall(ldobject: markerCar1!, method: "distance", args: [markerCar2!]) as? Double {
                completion("ระยะกระจัด \(round(distance) / 1000.0) กิโลเมตร")
            }
        }
        
        let _ = self.map.call(method: "goTo", args: [[
            "center": CLLocationCoordinate2D(latitude: 13.7, longitude: 100.45),
            "zoom": 12
        ]])
    }
    
    func getContain(completion: @escaping (_ message: String) -> Void) {
        var dropMarker: LongdoMap.LDObject?
        var geom1: LongdoMap.LDObject?
        var geom2: LongdoMap.LDObject?
        
        unbind()
        let _ = self.map.call(method: "Event.bind", args: [
            map.ldstatic("EventName", with: "OverlayDrop"),
            {
                (result: Any?) -> Void in
                if let c = self.map.objectCall(ldobject: geom1!, method: "contains", args: [dropMarker!]) as? Bool, c {
                    completion("In yellow area.")
                }
                else if let c = self.map.objectCall(ldobject: geom2!, method: "contains", args: [dropMarker!]) as? Bool, c {
                    completion("In red area.")
                }
                else {
                    completion("Outside selected area.")
                }
            }
        ])
        DispatchQueue.main.async {
            dropMarker = self.map.ldobject("Marker", with: [
                CLLocationCoordinate2D(latitude: 13.78, longitude: 100.43),
                [
                    "draggable": true,
                    "weight": self.map.ldstatic("OverlayWeight", with: "Top")
                ]
            ])
            geom1 = self.map.ldobject("Polygon", with: [
                [
                    CLLocationCoordinate2D(latitude: 13.94, longitude: 100.2),
                    CLLocationCoordinate2D(latitude: 13.94, longitude: 100.45),
                    CLLocationCoordinate2D(latitude: 13.62, longitude: 100.45),
                    CLLocationCoordinate2D(latitude: 13.62, longitude: 100.2)
                ],
                [
                    "title": "Yellow",
                    "lineWidth": 1,
                    "lineColor": UIColor.black.withAlphaComponent(0.7),
                    "fillColor": UIColor.init(red: 246 / 255.0, green: 210 / 255.0, blue: 88 / 255.0, alpha: 0.6),
                    "label": "Yellow"
                ]
            ])
            geom2 = self.map.ldobject("Polygon", with: [
                [
                    CLLocationCoordinate2D(latitude: 13.94, longitude: 100.7),
                    CLLocationCoordinate2D(latitude: 13.94, longitude: 100.45),
                    CLLocationCoordinate2D(latitude: 13.62, longitude: 100.45),
                    CLLocationCoordinate2D(latitude: 13.62, longitude: 100.7)
                ],
                [
                    "title": "Red",
                    "lineWidth": 1,
                    "lineColor": UIColor.black.withAlphaComponent(0.7),
                    "fillColor": UIColor.init(red: 209 / 255.0, green: 47 / 255.0, blue: 47 / 255.0, alpha: 0.6),
                    "label": "Red"
                ]
            ])
            let _ = self.map.call(method: "Overlays.add", args: [dropMarker!])
            let _ = self.map.call(method: "Overlays.add", args: [geom1!])
            let _ = self.map.call(method: "Overlays.add", args: [geom2!])
            let _ = self.map.call(method: "bound", args: [[
                "minLat": 13.57,
                "maxLat": 13.99,
                "minLon": 100.15,
                "maxLon": 100.75
            ]])
        }
    }
    
    func nearPOI() {
        if isConnectedToNetwork() {
            if let loc = map.call(method: "location", args: nil) {
                let _ = map.call(method: "Search.nearPoi", args: [loc])
                {
                    (data: Any?) -> Void in
                    if let result = data as? [String: Any?], let poi = result["data"] as? [[String: Any?]] {
                        self.searchPoi = []
                        for i in poi {
                            if let lat = i["lat"] as? Double, let lon = i["lon"] as? Double {
                                let poiMarker = self.map.ldobject("Marker", with: [
                                    CLLocationCoordinate2D(latitude: lat, longitude: lon),
                                    [
                                        "title": i["name"],
                                        "detail": i["address"]
                                    ]
                                ])
                                self.searchPoi.append(poiMarker)
                                if let newPoi = self.searchPoi.last {
                                    let _ = self.map.call(method: "Overlays.add", args: [newPoi])
                                }
                            }
                        }
                        self.locationBound()
                    }
                }
            }
        }
    }
    
    func locationBound() {
        var bound: [String: Double] = [
            "minLat": 90,
            "minLon": 180,
            "maxLat": -90,
            "maxLon": -180
        ]
        for poi in self.searchPoi {
            if let loc = self.map.objectCall(ldobject: poi, method: "location", args: nil) as? CLLocationCoordinate2D {
                if loc.latitude < bound["minLat"]! {
                    bound["minLat"] = loc.latitude
                }
                if loc.latitude > bound["maxLat"]! {
                    bound["maxLat"] = loc.latitude
                }
                if loc.longitude < bound["minLon"]! {
                    bound["minLon"] = loc.longitude
                }
                if loc.longitude > bound["maxLon"]! {
                    bound["maxLon"] = loc.longitude
                }
            }
        }
        let difLat = (bound["maxLat"]! - bound["minLat"]!) * 0.1
        let difLon = (bound["maxLon"]! - bound["minLon"]!) * 0.1
        bound["minLat"] = bound["minLat"]! - difLat
        bound["maxLat"] = bound["maxLat"]! + difLat
        bound["minLon"] = bound["minLon"]! - difLon
        bound["maxLon"] = bound["maxLon"]! + difLon
        let _ = self.map.call(method: "bound", args: [bound])
    }
    
    func addHeatMap() {
        if isConnectedToNetwork() {
            layer = map.ldobject("Layer", with:[
                [
                    "sources": [
                        "earthquakes": [
                            "type": "geojson",
                            "data": "https://docs.mapbox.com/mapbox-gl-js/assets/earthquakes.geojson",
                        ],
                    ],
                    "layers": [
                        [
                            "id": "earthquakes-heat",
                            "type": "heatmap",
                            "source": "earthquakes",
                            "maxzoom": 9,
                            "paint": [
                                // Increase the heatmap weight based on frequency and property magnitude
                                "heatmap-weight": [
                                    "interpolate",
                                    ["linear"],
                                    ["get", "mag"],
                                    0,
                                    0,
                                    6,
                                    1,
                                ],
                                // Increase the heatmap color weight weight by zoom level
                                // heatmap-intensity is a multiplier on top of heatmap-weight
                                "heatmap-intensity": [
                                    "interpolate",
                                    ["linear"],
                                    ["zoom"],
                                    0,
                                    1,
                                    9,
                                    3,
                                ],
                                // Color ramp for heatmap.  Domain is 0 (low) to 1 (high).
                                // Begin color ramp at 0-stop with a 0-transparancy color
                                // to create a blur-like effect.
                                "heatmap-color": [
                                    "interpolate",
                                    ["linear"],
                                    ["heatmap-density"],
                                    0,
                                    "rgba(33,102,172,0)",
                                    0.2,
                                    "rgb(103,169,207)",
                                    0.4,
                                    "rgb(209,229,240)",
                                    0.6,
                                    "rgb(253,219,199)",
                                    0.8,
                                    "rgb(239,138,98)",
                                    1,
                                    "rgb(178,24,43)",
                                ],
                                // Adjust the heatmap radius by zoom level
                                "heatmap-radius": [
                                    "interpolate",
                                    ["linear"],
                                    ["zoom"],
                                    0,
                                    2,
                                    9,
                                    20,
                                ],
                                // Transition from heatmap to circle layer by zoom level
                                "heatmap-opacity": [
                                    "interpolate",
                                    ["linear"],
                                    ["zoom"],
                                    7,
                                    1,
                                    9,
                                    0,
                                ],
                            ],
                        ],
                        "waterway-label",
                    ],
                ]
            ])
            let _ = map.call(method: "Layers.add", args: [layer!])
            
            let _ = self.map.call(method: "goTo", args: [[
                "center": CLLocationCoordinate2D(latitude: 35.5, longitude: -135.2),
                "zoom": 2
            ]])
        }
    }
    
    func addClusterMarker(){
        if isConnectedToNetwork() {
            layer = map.ldobject("Layer", with:[
                [
                    "sources": [
                        "earthquakes": [
                            "type": "geojson",
                            "data": "https://maplibre.org/maplibre-gl-js/docs/assets/earthquakes.geojson",
                            "cluster": true,
                            "clusterMaxZoom": 14, // Max zoom to cluster points on
                            "clusterRadius": 50, // Radius of each cluster when clustering points (defaults to 50)
                        ]
                    ],
                    "layers": [
                        [
                            "id": "clusters",
                            "type": "circle",
                            "source": "earthquakes",
                            "filter": ["has", "point_count"],
                            "paint": [
                                "circle-color": [
                                    "step",
                                    ["get", "point_count"],
                                    "#51bbd6", 100,
                                    "#f1f075", 750,
                                    "#f28cb1",
                                ],
                                "circle-radius": ["step", ["get", "point_count"], 20, 100, 30, 750, 40],
                            ],
                        ],
                        [
                            "id": "cluster-count",
                            "type": "symbol",
                            "source": "earthquakes",
                            "filter": ["has", "point_count"],
                            "layout": [
                                "text-field": "{point_count_abbreviated}",
                                "text-font": ["OCJ"],
                                "text-size": 12,
                            ],
                        ],
                        [
                            "id": "unclustered-point",
                            "type": "circle",
                            "source": "earthquakes",
                            "filter": ["!", ["has", "point_count"]],
                            "paint": [
                                "circle-color": "#11b4da",
                                "circle-radius": 4,
                                "circle-stroke-width": 1,
                                "circle-stroke-color": "#fff",
                            ],
                        ],
                    ]
                ]
            ])
            let _ = map.call(method: "Layers.add", args: [layer!])
            
            let _ = self.map.call(method: "goTo", args: [[
                "center": CLLocationCoordinate2D(latitude: 45.58, longitude: 94.65),
                "zoom": 1
            ]])
        }
    }
    
    func add3DObject() {
        if isConnectedToNetwork() {
            let layer = map.call(method: "Layers.setBase", args: [map.ldstatic("Layers", with: "NORMAL")]) as? LongdoMap.LDObject
            let scale = 100
            let data = """
        [{
            coordinates: [100.5, 13.7, 0],
            color: [255, 0, 0, 255],
            scale: [\(scale), \(scale), \(scale)],
            translation: [0, 0, \(scale)/ 2]
        }]
        """
            let _ = map.objectCall(ldobject: layer!, method: "insert", args: ["", map.ldfunction(
        """
            new deck.MapboxLayer({
                id: 'scenegraph-layer',
                type: deck.ScenegraphLayer,
                data: \(data),
                scenegraph: 'https://raw.githubusercontent.com/KhronosGroup/glTF-Sample-Models/master/2.0/Box/glTF-Binary/Box.glb',
                getPosition: d => d.coordinates,
                getColor: d => d.color,
                getScale: d => d.scale,
                getTranslation: d => d.translation,
                opacity: 0.5,
                _lighting: 'pbr',
                parameters: { depthTest: false }
            })
        """)])
            let _ = map.call(method: "goTo", args: [[
                "center": CLLocationCoordinate2D(latitude: 13.699123, longitude: 100.500136),
                "zoom": 16,
                "pitch": 60
            ]])
        }
    }
}
