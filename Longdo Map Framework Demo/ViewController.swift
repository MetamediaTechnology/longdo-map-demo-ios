//
//  ViewController.swift
//  Longdo Map Test
//
//  Created by กมลภพ จารุจิตต์ on 3/12/2564 BE.
//

import UIKit
import LongdoMapFramework
import CoreLocation

// TODO: key input, unbind
protocol MenuDelegate {
    func selectLanguage()
    func setBaseLayer()
    func addLayer()
    func removeTrafficLayer()
    func removeLayer()
    func clearAllLayer()
    func addEventsAndCameras()
    func removeEventsAndCameras()
    func addWMSLayer()
    func addTMSLayer()
    func addWTMSLayer()
    func addURLMarker()
    func addHTMLMarker()
    func addRotateMarker()
    func removeMarker()
    func markerList()
    func markerCount()
    func clearAllOverlays()
    func addPopup()
    func addCustomPopup()
    func addHTMLPopup()
    func removePopup()
    func dropMarker()
    func startBounceMarker()
    func stopBounceMarker()
    func moveMarker()
    func followPathMarker()
    func addLocalTag()
    func addLongdoTag()
    func addTagWithOption()
    func addTagWithGeocode()
    func removeTag()
    func clearAllTag()
    func addLine()
    func removeLine()
    func addLineWithOption()
    func addDashLine()
    func addCurve()
    func addPolygon()
    func addCircle()
    func addDot()
    func addDonut()
    func addRectangle()
    func geometryLocation()
    func addBangkok()
    func addEastRegion()
    func addBangkokDistrict()
    func addMultipleSubdistrict()
    func addProvinceWithOption()
    func addSubdistrictByName()
    func addLongdoPlace()
    func removeGeometryObject()
    func getRoute()
    func autoReroute()
    func getRouteByCost()
    func getRouteByDistance()
    func getRouteWithoutTollway()
    func getRouteWithMotorcycle()
    func getRouteGuide()
    func clearRoute()
    func searchCentral()
    func searchInEnglish()
    func suggestCentral()
    func clearSearch()
    func getGeoCode()
    func locationEvent()
    func zoomEvent()
    func zoomRangeEvent()
//    func readyEvent()
    func resizeEvent()
    func clickEvent()
    func dragEvent()
    func dropEvent()
    func layerChangeEvent()
    func toolbarChangeEvent()
    func clearMeasureEvent()
    func overlayClickEvent()
    func overlayChangeEvent()
    func overlaySelectEvent()
    func overlayLoadEvent()
    func overlayMoveEvent()
    func overlayDropEvent()
    func setCustomLocation()
    func setGeoLocation()
    func getLocation()
    func setZoom()
    func zoomIn()
    func zoomOut()
    func setZoomRange()
    func getZoomRange()
    func setBound()
    func getBound()
    func toggleDPad()
    func toggleZoombar()
//    func toggleToolbar()
    func toggleLayerSelector()
//    func toggleCrosshair()
    func toggleScale()
    func toggleTouchAndDrag()
//    func toggleTouch()
    func toggleDrag()
//    func toggleInertia()
    func addButtonMenu()
//    func addDropdownMenu()
//    func addTagPanel()
//    func addTagPanelWithOption()
    func addCustomMenu()
    func removeMenu()
    func getOverlayType()
    func getDistance()
    func getContain()
    func nearPOI()
//    func locationBound()
    func addHeatMap()
    func addClusterMap()
    
}

class ViewController: UIViewController, MenuDelegate, CLLocationManagerDelegate {
    @IBOutlet weak var map: LongdoMap!
    @IBOutlet weak var displayTextField: UITextField!
    let locationManager = CLLocationManager()
    let loc = CLLocationCoordinate2D(latitude: 13.7, longitude: 100.5)
    var home: LongdoMap.LDObject?
    var marker: LongdoMap.LDObject?
    var layer: LongdoMap.LDObject?
    var popup: LongdoMap.LDObject?
    var geom: LongdoMap.LDObject?
    var object: LongdoMap.LDObject?
    var menu: LongdoMap.LDObject?
    var searchPoi: [LongdoMap.LDObject] = []
    var moveTimer: Timer?
    var followPathTimer: Timer?
    var guideTimer: Timer?
    var currentMethod: String?

    override func viewDidLoad() {
        super.viewDidLoad()
#warning("Please insert your Longdo Map API key.")
        map.apiKey = "***REMOVED***"
        map.options.layer = map.ldstatic("Layers", with: "NORMAL")
        map.options.location = CLLocationCoordinate2D(latitude: 15, longitude: 102)
        map.options.zoomRange = 1...18
        map.options.zoom = 10
        readyEvent()
        map.render()
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if currentMethod == "location" {
            let _ = self.map.call(method: "location", args: [
                locations[0].coordinate
            ])
        }
        locationManager.stopUpdatingLocation()
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print(error)
    }
    
    @IBAction func selectMenu() {
        performSegue(withIdentifier: "menu", sender: nil)
    }
    
    @IBAction func clearAll() {
        let _ = map.call(method: "Layers.setBase", args: [map.ldstatic("Layers", with: "NORMAL")])
        let _ = map.call(method: "language", args: [LongdoLocale.Thai])
        displayTextField.isHidden = true
        clearAllLayer()
        clearAllOverlays()
        clearAllTag()
        removeEventsAndCameras()
        removeGeometryObject()
        clearRoute()
        clearSearch()
        removeMenu()
    }
    
    func alert(message: String, placeholder: String?, completionHandler: ((String) -> Void)?) {
        let alert = UIAlertController(
            title: NSLocalizedString("Longdo Map", comment: ""),
            message: message,
            preferredStyle: .alert
        )
        alert.addAction(UIAlertAction(
            title: NSLocalizedString("OK", comment: ""),
            style: .default
        ) { action -> Void in
            if let c = completionHandler {
                let firstTextField = alert.textFields!.first
                c(firstTextField?.text ?? "")
            }
        })
        if let p = placeholder {
            alert.addTextField { (textField : UITextField!) -> Void in
                textField.placeholder = p
            }
        }
        present(alert, animated: true, completion: nil)
    }
    
    // MARK: - Map Layers
    func selectLanguage() {
        let _ = map.call(method: "language", args: [LongdoLocale.English])
    }
    
    func setBaseLayer() {
        let _ = map.call(method: "Layers.setBase", args: [map.ldstatic("Layers", with: "GRAY")])
    }
    
    func addLayer() {
        let _ = map.call(method: "Layers.add", args: [map.ldstatic("Layers", with: "TRAFFIC")])
    }
    
    func removeTrafficLayer() {
        let _ = map.call(method: "Layers.remove", args: [map.ldstatic("Layers", with: "TRAFFIC")])
    }
    
    func clearAllLayer() {
        let _ = map.call(method: "Layers.clear", args: nil)
    }
    
    func addEventsAndCameras() {
        let _ = map.call(method: "Overlays.load", args: [map.ldstatic("Overlays", with: "events")])
        let _ = map.call(method: "Overlays.load", args: [map.ldstatic("Overlays", with: "cameras")])
    }
    
    func removeEventsAndCameras() {
        let _ = map.call(method: "Overlays.unload", args: [map.ldstatic("Overlays", with: "events")])
        let _ = map.call(method: "Overlays.unload", args: [map.ldstatic("Overlays", with: "cameras")])
    }
    
    func addWMSLayer() {
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
    }
    
    func addTMSLayer() {
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
    }
    
    func addWTMSLayer() {
        layer = map.ldobject("Layer", with: [
            "bluemarble_terrain",
            [
                "type": map.ldstatic("LayerType", with: "WMTS_REST"),
                "url": "https://ms.longdo.com/mapproxy/wmts",
                "srs": "GLOBAL_WEBMERCATOR",
            ]
        ])
        let _ = map.call(method: "Layers.add", args: [layer!])
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
                        "url": "https://map.longdo.com/mmmap/images/pin_mark.png",
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
    }
    
    func removeMarker() {
        if let m = marker {
            moveTimer?.invalidate()
            followPathTimer?.invalidate()
            let _ = map.call(method: "Overlays.remove", args: [m])
        }
    }
    
    func markerList() {
        let result = map.call(method: "Overlays.list", args: nil)
        alert(message: "\(result ?? "no result")", placeholder: nil, completionHandler: nil)
    }
    
    func markerCount() {
        let result = map.call(method: "Overlays.size", args: nil)
        alert(message: "\(result ?? "no result")", placeholder: nil, completionHandler: nil)
    }
    
    func clearAllOverlays() {
        moveTimer?.invalidate()
        followPathTimer?.invalidate()
        let _ = map.call(method: "Overlays.clear", args: nil)
    }
    
    func addHeatMap(){
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
    }
    
    func addClusterMap(){
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
                    "text-font": ["noto"],
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
    }
    
    func addHTMLPopup() {
        popup = map.ldobject("Popup", with: [
            CLLocationCoordinate2D(latitude: 14, longitude: 102),
            [
                "html": "<div style=\"background: #eeeeff;\">popup</div>"
            ]
        ])
        let _ = map.call(method: "Overlays.add", args: [popup!])
    }
    
    func removePopup() {
        if let p = popup {
            let _ = map.call(method: "Overlays.remove", args: [p])
        }
    }
    
    //Not Available
    func dropMarker() {
        marker = map.ldobject("Marker", with: [
            CLLocationCoordinate2D(latitude: 14.525007, longitude: 100.643005)
        ])
        let _ = map.call(method: "Overlays.drop", args: [marker!])
    }
    
    func startBounceMarker() {
        marker = map.ldobject("Marker", with: [
            CLLocationCoordinate2D(latitude: 14.525007, longitude: 101.643005)
        ])
        let _ = map.call(method: "Overlays.add", args: [marker!])
        let _ = map.call(method: "Overlays.bounce", args: [marker!])
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
    }
    
    @objc func moveOut() {
        let _ = map.objectCall(ldobject: marker!, method: "move", args: [
            CLLocationCoordinate2D(latitude: 15, longitude: 102),
            true
        ])
        moveTimer = Timer.scheduledTimer(timeInterval: 5.0, target: self, selector: #selector(self.moveBack), userInfo: nil, repeats: false)
    }
    
    @objc func moveBack() {
        let _ = map.objectCall(ldobject: marker!, method: "move", args: [
            CLLocationCoordinate2D(latitude: 15.525007, longitude: 100.643005),
            true
        ])
        moveTimer = Timer.scheduledTimer(timeInterval: 5.0, target: self, selector: #selector(self.moveOut), userInfo: nil, repeats: false)
    }
    
    //Not available
    func followPathMarker() {
        marker = map.ldobject("Marker", with: [
            CLLocationCoordinate2D(latitude: 15.525007, longitude: 101.643005)
        ])
        let _ = map.call(method: "Overlays.add", args: [marker!])
        followPathTimer = Timer.scheduledTimer(timeInterval: 5.0, target: self, selector: #selector(self.followPath), userInfo: nil, repeats: true)
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
    }
    
    func addLongdoTag() {
        let _ = map.call(method: "Tags.add", args: ["shopping"])
    }
    
    func addTagWithOption() {
        let _ = map.call(method: "Tags.add", args: [
            "hotel",
            [
                "visibleRange": 10...20,
                "icon": [
                    "big" //URL icon in Tags.add is not available for now.
                ]
            ]
        ])
    }
    
    func addTagWithGeocode() {
        let _ = map.call(method: "Tags.add", args: [
            "shopping",
            [
                "area": 10
            ]
        ])
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
    }
    
    func removeLine() {
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
    }
    
    //Not Available
    func addCurve() {
        geom = map.ldobject("Polycurve", with: [
            [
                CLLocationCoordinate2D(latitude: 13.5, longitude: 99),
                CLLocationCoordinate2D(latitude: 14.5, longitude: 100),
                CLLocationCoordinate2D(latitude: 12.5, longitude: 100),
                CLLocationCoordinate2D(latitude: 13.5, longitude: 101)
            ],
            [
                "title": "Polycurve",
                "detail": "-",
                "label": "Polycurve",
                "lineWidth": 4,
                "lineColor": UIColor.systemBlue,
                "weight": map.ldstatic("OverlayWeight", with: "Top")
            ]
        ])
        let _ = map.call(method: "Overlays.add", args: [geom!])
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
                "visibleRange": 7...18,
                "editable": true,
                "weight": map.ldstatic("OverlayWeight", with: "Top")
            ]
        ])
        let _ = map.call(method: "Overlays.add", args: [geom!])
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
    }
    
    func geometryLocation() {
        if let g = geom {
            let location = map.objectCall(ldobject: g, method: "location", args: nil)
            alert(message: "\(location ?? "N/A")", placeholder: nil, completionHandler: nil)
        }
    }
    
    func addBangkok() {
        object = map.ldobject("Overlays.Object", with: [
            10,
            "IG"
        ])
        let _ = map.call(method: "Overlays.load", args: [object!])
    }
    
    // MARK: - Administration
    func addEastRegion() {
        object = map.ldobject("Overlays.Object", with: [
            "2_",
            "IG"
        ])
        let _ = map.call(method: "Overlays.load", args: [object!])
    }
    
    func addBangkokDistrict() {
        object = map.ldobject("Overlays.Object", with: [
            "10__",
            "IG"
        ])
        let _ = map.call(method: "Overlays.load", args: [object!])
    }
    
    func addMultipleSubdistrict() {
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
    }
    
    func addProvinceWithOption() {
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
    }
    
    func addSubdistrictByName() {
        object = map.ldobject("Overlays.Object", with: [
            "นนทบุรี",
            "ADM"
        ])
        let _ = map.call(method: "Overlays.load", args: [object!])
    }
    
    func addLongdoPlace() {
        object = map.ldobject("Overlays.Object", with: [
            "A10000001",
            "LONGDO"
        ])
        let _ = map.call(method: "Overlays.load", args: [object!])
    }
    
    func removeGeometryObject() {
        if let o = object {
            let _ = map.call(method: "Overlays.unload", args: [o])
        }
    }
    
    // MARK: - Route
    func getRoute() {
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
    
    func getRouteGuide() {
        clearRoute()
        unbind()
        let _ = map.call(method: "Event.bind", args: [
            "pathComplete",
            {
                (guide: Any?) -> Void in
                print(guide ?? "no data")
            }
        ])
        let _ = map.call(method: "Event.bind", args: [
            "guideComplete",
            {
                (guide: Any?) -> Void in
                if let g = guide as? [[String: Any]], g.count > 0,
                    let turn = g[0]["guide"] as? [[String: Any?]],
                    let data = g[0]["data"] as? [String: Any] {
                    var str = ["ออกจาก จุดเริ่มต้น \(round(data["fdistance"] as? Double ?? 0) / 1000) กม."]
                    let turnText = ["เลี้ยวซ้ายสู่", "เลี้ยวขวาสู่", "เบี่ยงซ้ายสู่", "เบี่ยงขวาสู่", "ไปตาม", "ตรงไปตาม", "เข้าสู่", "", "", "ถึง", "", "", "", "", ""]
                    for i in turn {
                        str.append("\(turnText[(i["turn"] as? LongdoTurn ?? .Unknown).rawValue]) \(i["name"] as? String ?? "") \(round(i["distance"] as? Double ?? 0) / 1000) กม.")
                    }
                    str.append("รวมระยะทาง \(round(data["distance"] as? Double ?? 0) / 1000) กม. เวลา \(Int(floor((data["interval"] as? Double ?? 0) / 3600))) ชม. \(Int(ceil(Double((data["interval"] as? Int ?? 0) % 3600) / 60))) น.")
                    self.alert(message: "\(str.joined(separator: "\n"))", placeholder: nil, completionHandler: nil)
                }
            }
        ])
        getRoute()
    }
    
    func clearRoute() {
        let _ = map.call(method: "Route.clear", args: nil)
    }
    
    // MARK: - Search
    func searchCentral() {
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
    
    func searchInEnglish() {
        let _ = map.call(method: "Search.language", args: [LongdoLocale.English])
        searchCentral()
    }
    
    func suggestCentral() {
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
                self.alert(message: str.joined(separator: "\n"), placeholder: nil, completionHandler: nil)
            }
        }
    }
    
    func clearSearch() {
        for m in searchPoi {
            let _ = map.call(method: "Overlays.remove", args: [m])
        }
    }
    
    // MARK: - Conversion
    func getGeoCode() {
        if let pos = map.call(method: "location", args: nil) {
            let _ = map.call(method: "Search.address", args: [pos])
            {
                (data: Any?) -> Void in
                self.alert(message: "\(data ?? "no data")", placeholder: nil, completionHandler: nil)
            }
        }
    }
    
    // MARK: - Events
    func locationEvent() {
        displayTextField.isHidden = false
        unbind()
        let _ = map.call(method: "Event.bind", args: [
            "location",
            {
                () -> Void in
                if let pos = self.map.call(method: "location", args: nil) {
                    self.displayTextField.text = "\(pos)"
                }
            }
        ])
    }
    
    func zoomEvent() {
        displayTextField.isHidden = false
        unbind()
        let _ = map.call(method: "Event.bind", args: [
            "zoom",
            {
                () -> Void in
                if let zoom = self.map.call(method: "zoom", args: nil) {
                    self.displayTextField.text = "\(zoom)"
                }
            }
        ])
    }
    
    func zoomRangeEvent() {
        displayTextField.isHidden = false
        unbind()
        let _ = map.call(method: "Event.bind", args: [
            "zoomRange",
            {
                () -> Void in
                if let zr = self.map.call(method: "zoomRange", args: nil) {
                    self.displayTextField.text = "\(zr)"
                }
            }
        ])
        let _ = map.call(method: "zoomRange", args: [1...10])
    }
    
    func readyEvent() {
        //Call before map.render()
        map.options.onReady = {
            () -> Void in
            self.alert(message: "Map is ready.", placeholder: nil, completionHandler: nil)
        }
    }
    
    func resizeEvent() {
        displayTextField.isHidden = false
        unbind()
        let _ = self.map.call(method: "Event.bind", args: [
            "resize",
            {
                () -> Void in
                if let bound = self.map.call(method: "bound", args: nil) {
                    self.displayTextField.text = "\(bound)"
                }
            }
        ])
    }
    
    func clickEvent() {
        unbind()
        let _ = self.map.call(method: "Event.bind", args: [
            "click",
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
    
    func dragEvent() {
        displayTextField.isHidden = false
        unbind()
        let _ = self.map.call(method: "Event.bind", args: [
            "drag",
            {
                (result: Any?) -> Void in
                self.displayTextField.text = "Drag event triggered."
            }
        ])
    }
    
    func dropEvent() {
        displayTextField.isHidden = false
        unbind()
        let _ = self.map.call(method: "Event.bind", args: [
            "drop",
            {
                (result: Any?) -> Void in
                self.displayTextField.text = "Drop event triggered."
            }
        ])
    }
    
    func layerChangeEvent() {
        unbind()
        let _ = self.map.call(method: "Event.bind", args: [
            "layerChange",
            {
                (result: Any?) -> Void in
                self.alert(message: "\(result ?? "no data")", placeholder: nil, completionHandler: nil)
            }
        ])
        addLayer()
    }
    
    func toolbarChangeEvent() {
        //Not implemented now.
    }
    
    func clearMeasureEvent() {
        //Not implemented now.
    }
    
    func overlayClickEvent() {
        unbind()
        let _ = self.map.call(method: "Event.bind", args: [
            "overlayClick",
            {
                (result: Any?) -> Void in
                self.alert(message: "\(result ?? "no data")", placeholder: nil, completionHandler: nil)
            }
        ])
        addURLMarker()
    }
    
    func overlayChangeEvent() {
        unbind()
        let _ = self.map.call(method: "Event.bind", args: [
            "overlayChange",
            {
                (result: Any?) -> Void in
                self.alert(message: "\(result ?? "no data")", placeholder: nil, completionHandler: nil)
            }
        ])
        addURLMarker()
    }
    
    func overlaySelectEvent() {
        //Not implemented now.
        unbind()
        let _ = self.map.call(method: "Event.bind", args: [
            "overlaySelect",
            {
                (result: Any?) -> Void in
                self.alert(message: "\(result ?? "no data")", placeholder: nil, completionHandler: nil)
            }
        ])
        addURLMarker()
    }
    
    func overlayLoadEvent() {
        unbind()
        let _ = self.map.call(method: "Event.bind", args: [
            "overlayLoad",
            {
                (result: Any?) -> Void in
                self.alert(message: "\(result ?? "no data")", placeholder: nil, completionHandler: nil)
            }
        ])
        addBangkok()
    }
    
    func overlayMoveEvent() {
        //Not implemented now.
        unbind()
        let _ = self.map.call(method: "Event.bind", args: [
            "overlayMove",
            {
                (result: Any?) -> Void in
                self.alert(message: "\(result ?? "no data")", placeholder: nil, completionHandler: nil)
            }
        ])
        addURLMarker()
    }
    
    // FIXME: ??
    func overlayDropEvent() {
        unbind()
        let _ = self.map.call(method: "Event.bind", args: [
            "overlayDrop",
            {
                (result: Any?) -> Void in
                self.alert(message: "\(result ?? "no data")", placeholder: nil, completionHandler: nil)
            }
        ])
        addURLMarker()
    }
    
    func unbind() {
        let event = ["pathComplete", "guideComplete", "location", "zoom", "zoomRange", "resize", "click", "drag", "drop", "layerChange", "overlayClick", "overlayChange", "overlaySelect", "overlayLoad", "overlayMove", "overlayDrop"]
        for i in event {
            let _ = self.map.call(method: "Event.unbind", args: [i])
        }
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
        locationManager.requestWhenInUseAuthorization()
        if CLLocationManager.locationServicesEnabled() {
            locationManager.delegate = self
            locationManager.startUpdatingLocation()
        }
    }
    
    func getLocation() {
        let location = map.call(method: "location", args: nil)
        alert(message: "\(location ?? "no data")", placeholder: nil, completionHandler: nil)
    }
    
    func setZoom() {
        let _ = map.call(method: "zoom", args: [14, true])
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
    
    func getZoomRange() {
        let zoomRange = map.call(method: "zoomRange", args: nil)
        alert(message: "\(zoomRange ?? "no data")", placeholder: nil, completionHandler: nil)
    }
    
    func setBound() {
        let _ = map.call(method: "bound", args: [[
            "minLat": 13,
            "maxLat": 14,
            "minLon": 100,
            "maxLon": 101
        ]])
    }
    
    func getBound() {
        let bound = map.call(method: "bound", args: nil)
        alert(message: "\(bound ?? "no data")", placeholder: nil, completionHandler: nil)
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
    
    //Not available
    func toggleToolbar() {
        let _ = map.call(method: "Ui.Toolbar.visible", args: [
            !(map.call(method: "Ui.Toolbar.visible", args: nil) as? Bool ?? false)
        ])
    }
    
    func toggleLayerSelector() {
        let _ = map.call(method: "Ui.LayerSelector.visible", args: [
            !(map.call(method: "Ui.LayerSelector.visible", args: nil) as? Bool ?? false)
        ])
    }
    
    //Not available
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
    
    func toggleTouchAndDrag() {
        map.isUserInteractionEnabled = !map.isUserInteractionEnabled
    }
    
    //Not available
    func toggleTouch() {
        let _ = map.call(method: "Ui.Mouse.enableClick", args: [
            !(map.call(method: "Ui.Mouse.enableClick", args: nil) as? Bool ?? false)
        ])
    }
    
    func toggleDrag() {
        let _ = map.call(method: "Ui.Mouse.enableDrag", args: [
            !(map.call(method: "Ui.Mouse.enableDrag", args: nil) as? Bool ?? false)
        ])
    }
    
    //Not available
    func toggleInertia() {
        let _ = map.call(method: "Ui.Mouse.enableInertia", args: [
            !(map.call(method: "Ui.Mouse.enableInertia", args: nil) as? Bool ?? false)
        ])
    }
    
    func addButtonMenu() {
        menu = map.ldobject("MenuBar", with: [[
            "button": [
                [
                    "label": "first",
                    "value": 1
                ],
                [
                    "label": "second",
                    "value": 2
                ]
            ],
            "change": {
                (from: [String: Any?]?, to: [String: Any?]?) in
                let fromStr = from != nil ? (from!["value"] ?? "-") : "-"
                let toStr = to != nil ? (to!["value"] ?? "-") : "-"
                self.alert(message: "from: \(fromStr!) to: \(toStr!)", placeholder: nil, completionHandler: nil)
            }
        ]])
        let _ = map.call(method: "Ui.add", args: [menu!])
    }
    
    //Not available
    func addDropdownMenu() {
        menu = map.ldobject("MenuBar", with: [[
            "dropdown": [
                [
                    "label": "Group",
                    "value": map.ldstatic("ButtonType", with: "Group")
                ],
                [
                    "label": "Normal"
                ],
                [
                    "label": "<div style=\"padding: 8px; text-align: center;\">custom<br/>HTML</div>",
                    "value": map.ldstatic("ButtonType", with: "Custom")
                ]
            ],
            "dropdownLabel": "more",
            "change": {
                (from: [String: Any?]?, to: [String: Any?]?) in
                let fromStr = from != nil ? (from!["value"] ?? "-") : "-"
                let toStr = to != nil ? (to!["value"] ?? "-") : "-"
                self.alert(message: "from: \(fromStr!) to: \(toStr!)", placeholder: nil, completionHandler: nil)
            }
        ]])
        let _ = map.call(method: "Ui.add", args: [menu!])
    }
    
    //Not available
    func addTagPanel() {
        menu = map.ldobject("TagPanel", with: [])
        let _ = map.call(method: "Ui.add", args: [menu!])
    }
    
    //Not available
    func addTagPanelWithOption() {
        menu = map.ldobject("TagPanel", with: [[
            "tag": ["temple", "sizzler"]
        ]])
        let _ = map.call(method: "Ui.add", args: [menu!])
    }
    
    func addCustomMenu() {
        menu = map.ldobject("CustomControl", with: ["<button>go</button>"])
        let _ = map.call(method: "Ui.add", args: [menu!])
    }
    
    func removeMenu() {
        if let m = menu {
            let _ = map.call(method: "Ui.remove", args: [m])
        }
    }
    
    // MARK: - Etc.
    func getOverlayType() {
        unbind()
        let _ = self.map.call(method: "Event.bind", args: [
            "overlayClick",
            {
                (result: Any?) -> Void in
                if let overlay = result as? LongdoMap.LDObject {
                    self.alert(message: "\(overlay.type)", placeholder: nil, completionHandler: nil)
                }
            }
        ])
        DispatchQueue.main.async {
            self.marker = self.map.ldobject("Marker", with: [
                CLLocationCoordinate2D(latitude: 12.8, longitude: 101.2)
            ])
            let _ = self.map.call(method: "Overlays.add", args: [self.marker!])
        }
    }
    
    func getDistance() {
        var markerCar1: LongdoMap.LDObject?
        var markerCar2: LongdoMap.LDObject?
        var geom1: LongdoMap.LDObject?
        
        unbind()
        let _ = self.map.call(method: "Event.bind", args: [
            "overlayDrop",
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
                    self.alert(message: "ระยะกระจัด \(round(distance) / 1000.0) กิโลเมตร", placeholder: nil, completionHandler: nil)
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
                self.alert(message: "ระยะกระจัด \(round(distance) / 1000.0) กิโลเมตร", placeholder: nil, completionHandler: nil)
            }
        }
    }
    
    func getContain() {
        var dropMarker: LongdoMap.LDObject?
        var geom1: LongdoMap.LDObject?
        var geom2: LongdoMap.LDObject?
        
        unbind()
        let _ = self.map.call(method: "Event.bind", args: [
            "overlayDrop",
            {
                (result: Any?) -> Void in
                if let c = self.map.objectCall(ldobject: geom1!, method: "contains", args: [dropMarker!]) as? Bool, c {
                    self.alert(message: "อยู่บนพื้นที่สีเหลือง", placeholder: nil, completionHandler: nil)
                }
                else if let c = self.map.objectCall(ldobject: geom2!, method: "contains", args: [dropMarker!]) as? Bool, c {
                    self.alert(message: "อยู่บนพื้นที่สีแดง", placeholder: nil, completionHandler: nil)
                }
                else {
                    self.alert(message: "ไม่อยู่บนพื้นที่สีใดเลย", placeholder: nil, completionHandler: nil)
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
                    "title": "เหลือง",
                    "lineWidth": 1,
                    "lineColor": UIColor.black.withAlphaComponent(0.7),
                    "fillColor": UIColor.init(red: 246 / 255.0, green: 210 / 255.0, blue: 88 / 255.0, alpha: 0.6),
                    "label": "เหลือง"
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
                    "title": "แดง",
                    "lineWidth": 1,
                    "lineColor": UIColor.black.withAlphaComponent(0.7),
                    "fillColor": UIColor.init(red: 209 / 255.0, green: 47 / 255.0, blue: 47 / 255.0, alpha: 0.6),
                    "label": "แดง"
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
    
    //Not Available or use map.isUserInteractionEnabled instead.
    func lockMap() {
        let _ = map.call(method: "Ui.lockMap", args: nil)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "menu" {
            guard let vc = segue.destination as? MenuTableViewController else { return }
            vc.delegate = self
        }
    }
}

