//
//  ContentView.swift
//  Longdo Map Demo
//
//  Created by กมลภพ จารุจิตต์ on 12/7/2567 BE.
//

import SwiftUI
import LongdoMapFramework
import CoreLocation

struct MapView: View {
    @State private var showingMessage = false
    @State private var message = ""
    @State var showMenu = false
    @StateObject var map = MapController()
    @State private var showingAlert = false
    @State private var alertMessage = ""
    
    var body: some View {
        VStack(spacing: 0) {
            ZStack {
                Map(map: map, option: getMapOption())
                VStack {
                    Spacer()
                    TextField(
                        "",
                        text: $message,
                        axis: .vertical
                    )
                    .lineLimit(1...5)
                    .background(Color.init(red: 0, green: 0, blue: 0, opacity: 0.2))
                    .opacity(showingMessage ? 1 : 0)
                    .multilineTextAlignment(.center)
//                    .frame(height: 34)
                    .padding(.bottom, 24)
                    
                }
            }
            .ignoresSafeArea()
            ZStack {
                Rectangle()
                    .ignoresSafeArea()
                HStack(spacing: 20) {
                    Button {
                        showMenu.toggle()
                    } label: {
                        Text("Select")
                            .frame(maxWidth: .infinity)
                    }
                    .fullScreenCover(isPresented: $showMenu) {
                        MenuView.init(callback: test)
                    }
                    .buttonStyle(.borderedProminent)
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                    Button {
                        map.clearAll()
                        showingMessage = false
                    } label: {
                        Text("Clear All")
                            .frame(maxWidth: .infinity)
                    }
                    .buttonStyle(.borderedProminent)
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                    
                }
                .padding(.horizontal, 20)
            }
            .frame(height: 70)
        }
        .alert("Longdo Map", isPresented: $showingAlert) {
            Button("OK", role: .cancel) { }
        } message: {
            Text(alertMessage)
        }
    }
    
    func getMapOption() -> LongdoMap.Option {
        let mapOption = LongdoMap.Option()
        mapOption.layer = map.getNormalLayer(layerName: "NORMAL")
        mapOption.location = CLLocationCoordinate2D(latitude: 15, longitude: 102)
        mapOption.zoomRange = 1...18
        mapOption.zoom = 10
        mapOption.onReady = {
            alertMessage = "Map is ready."
            showingAlert = true
        }
        return mapOption
    }
    
    func test(method: String) {
        //Map Layers
        if method == "Set Map Language to English" {
            map.selectLanguage()
        }
        else if method == "Set Base Layer to Gray" {
            map.setBaseLayer()
        }
        else if method == "Add Traffic Layer" {
            map.addLayer()
        }
        else if method == "Remove Traffic Layer" {
            map.removeTrafficLayer()
        }
        else if method == "Clear All Layers" {
            map.clearAllLayer()
        }
        else if method == "Add Cameras and Events" {
            map.addEventsAndCameras()
        }
        else if method == "Remove Cameras and Events" {
            map.removeEventsAndCameras()
        }
        else if method == "Add WMS Layer" {
            map.addWMSLayer()
        }
        else if method == "Add TMS Layer" {
            map.addTMSLayer()
        }
        else if method == "Add WTMS Layer" {
            map.addWTMSLayer()
        }
        else if method == "Enable Filter" {
            map.enableFilter()
        }
        else if method == "Remove Last Custom Layer" {
            map.removeLayer()
        }
        
        //Marker
        else if method == "Add Marker from URL" {
            map.addURLMarker()
        }
        else if method == "Add Marker from HTML with Popup" {
            map.addHTMLMarker()
        }
        else if method == "Add Rotate Marker" {
            map.addRotateMarker()
        }
        else if method == "Remove Last Marker" {
            map.removeMarker()
        }
        else if method == "List All Markers" {
            alertMessage = "\(map.markerList())"
            showingAlert = true
        }
        else if method == "Number of Markers" {
            alertMessage = "\(map.markerCount())"
            showingAlert = true
        }
        else if method == "Clear All Overlays" {
            map.clearAllOverlays()
        }
        else if method == "Add Popup" {
            map.addPopup()
        }
        else if method == "Add Custom Popup" {
            map.addCustomPopup()
        }
        else if method == "Add Popup from HTML" {
            map.addHTMLPopup()
        }
        else if method == "Remove Last Popup" {
            map.removePopup()
        }
        else if method == "Drop Marker" {
            map.dropMarker()
        }
        else if method == "Start Bounce Marker" {
            map.startBounceMarker()
        }
        else if method == "Stop Bounce Marker" {
            map.stopBounceMarker()
        }
        else if method == "Move Marker" {
            map.moveMarker()
        }
        else if method == "Rotate Marker" {
            map.rotateMarker()
        }
        
        //Tag
        else if method == "Add Local Tags" {
            map.addLocalTag()
        }
        else if method == "Add Longdo Tags" {
            map.addLongdoTag()
        }
        else if method == "Add Tags with Options" {
            map.addTagWithOption()
        }
        else if method == "Add Tags with Geocode" {
            map.addTagWithGeocode()
        }
        else if method == "Remove Longdo Tags" {
            map.removeTag()
        }
        else if method == "Clear all tags" {
            map.clearAllTag()
        }
        
        //Geometry
        else if method == "Add Line" {
            map.addLine()
        }
        else if method == "Remove Last Geometry" {
            map.removeOverlay()
        }
        else if method == "Add Line with Options" {
            map.addLineWithOption()
        }
        else if method == "Add Dash Line" {
            map.addDashLine()
        }
        else if method == "Add Polygon" {
            map.addPolygon()
        }
        else if method == "Add Circle" {
            map.addCircle()
        }
        else if method == "Add Dot" {
            map.addDot()
        }
        else if method == "Add Donut" {
            map.addDonut()
        }
        else if method == "Add Rectangle" {
            map.addRectangle()
        }
        else if method == "Add Image as Layer" {
            map.addImageAsLayer()
        }
        else if method == "Location of Geometry" {
            alertMessage = "\(map.geometryLocation())"
            showingAlert = true
        }
                
        //Administration
        else if method == "Add Bangkok Geometry" {
            map.addBangkok()
        }
        else if method == "Add East Region of Thailand Geometry" {
            map.addEastRegion()
        }
        else if method == "Add District in Bangkok Geometry" {
            map.addBangkokDistrict()
        }
        else if method == "Add Multiple Subdistrict Geometry" {
            map.addMultipleSubdistrict()
        }
        else if method == "Add Province Geometry with Options" {
            map.addProvinceWithOption()
        }
        else if method == "Add Subdistrict Geometry by Name" {
            map.addSubdistrictByName()
        }
        else if method == "Add Longdo Place" {
            map.addLongdoPlace()
        }
        else if method == "Remove Last Geometry Object" {
            map.removeGeometryObject()
        }
        
        //Route
        else if method == "Get Route" {
            map.getRoute()
        }
        else if method == "Auto Re-Route" {
            map.autoReroute()
        }
        else if method == "Get Route by Cost" {
            map.getRouteByCost()
        }
        else if method == "Get Route by Distance" {
            map.getRouteByDistance()
        }
        else if method == "Get Route Without Tollway" {
            map.getRouteWithoutTollway()
        }
        else if method == "Get Route With Motorcycle" {
            map.getRouteWithMotorcycle()
        }
        else if method == "Get Route Guide" {
            map.getRouteGuide() {
                alertMessage = $0
                showingAlert = true
            }
        }
        else if method == "Clear Route" {
            map.clearRoute()
        }
        
        //Search
        else if method == "Search 'Central'" {
            map.searchCentral()
        }
        else if method == "Search and Get Result in English" {
            map.searchInEnglish()
        }
        else if method == "Suggest 'Central'" {
            map.suggestCentral() {
                alertMessage = $0
                showingAlert = true
            }
        }
        else if method == "Clear Search Result" {
            map.clearSearch()
        }
        
        //Conversion
        else if method == "Reverse Geocode" {
            map.getGeoCode() {
                alertMessage = $0
                showingAlert = true
            }
        }
        else if method == "Get Latitude Length" {
            map.getLatitudeLength {
                alertMessage = $0
                showingAlert = true
            }
        }
        
        //Events
        else if method == "When Location Changed" {
            map.locationEvent {
                message = $0
                showingMessage = true
            }
        }
        else if method == "When Zoom Changed" {
            map.zoomEvent {
                message = $0
                showingMessage = true
            }
        }
        else if method == "When Zoom Range Changed" {
            map.zoomRangeEvent {
                message = $0
                showingMessage = true
            }
        }
        else if method == "When Map is Resized" {
            map.resizeEvent {
                message = $0
                showingMessage = true
            }
        }
        else if method == "When Click" {
            map.clickEvent()
        }
        else if method == "When Long Tap" {
            map.longTapEvent()
        }
        else if method == "When Drag" {
            map.dragEvent {
                message = $0
                showingMessage = true
            }
        }
        else if method == "When Drop" {
            map.dropEvent {
                message = $0
                showingMessage = true
            }
        }
        else if method == "When Layer Changed" {
            map.layerChangeEvent {
                alertMessage = $0
                showingAlert = true
            }
        }
        else if method == "When Clicked Overlay" {
            map.overlayClickEvent {
                alertMessage = $0
                showingAlert = true
            }
        }
        else if method == "When Change Overlay" {
            map.overlayChangeEvent {
                message = $0
                showingMessage = true
            }
        }
        else if method == "When Load Overlay" {
            map.overlayLoadEvent {
                message = $0
                showingMessage = true
            }
        }
        else if method == "When Drop Overlay" {
            map.overlayDropEvent {
                message = $0
                showingMessage = true
            }
        }
        
        //User Interface
        else if method == "Set Custom Location" {
            map.setCustomLocation()
        }
        else if method == "Set Geolocation" {
            map.setGeoLocation()
        }
        else if method == "Get Location" {
            alertMessage = "\(map.getLocation())"
            showingAlert = true
        }
        else if method == "Set Zoom" {
            map.setZoom()
        }
        else if method == "Set Location and Zoom" {
            map.setLocationAndZoom()
        }
        else if method == "Set Rotate" {
            map.setRotate()
        }
        else if method == "Set Pitch" {
            map.setPitch()
        }
        else if method == "Zoom In" {
            map.zoomIn()
        }
        else if method == "Zoom Out" {
            map.zoomOut()
        }
        else if method == "Set Zoom Range" {
            map.setZoomRange()
        }
        else if method == "Get Zoom Range" {
            alertMessage = "\(map.getZoomRange())"
            showingAlert = true
        }
        else if method == "Set Bound" {
            map.setBound()
        }
        else if method == "Get Bound" {
            alertMessage = "\(map.getBound())"
            showingAlert = true
        }
        else if method == "Toggle DPad" {
            map.toggleDPad()
        }
        else if method == "Toggle Zoombar" {
            map.toggleZoombar()
        }
        else if method == "Toggle Layer Selector" {
            map.toggleLayerSelector()
        }
        else if method == "Toggle Crosshair" {
            map.toggleCrosshair()
        }
        else if method == "Toggle Scale" {
            map.toggleScale()
        }
        else if method == "Toggle Terrain" {
            map.toggleTerrain()
        }
        else if method == "Toggle Touch Map" {
            map.toggleTouchAndDrag()
        }
        else if method == "Toggle Drag Map" {
            map.toggleDrag()
        }
        
        //Etc.
        else if method == "Click and Get Overlay Type" {
            map.getOverlayType {
                alertMessage = $0
                showingAlert = true
            }
        }
        else if method == "Get Distance" {
            map.getDistance {
                alertMessage = $0
                showingAlert = true
            }
        }
        else if method == "Get Contain" {
            map.getContain {
                alertMessage = $0
                showingAlert = true
            }
        }
        else if method == "Get Near POI" {
            map.nearPOI()
        }
        else if method == "Add HeatMap" {
            map.addHeatMap()
        }
        else if method == "Add Cluster Marker" {
            map.addClusterMarker()
        }
        else if method == "Add 3D object" {
            map.add3DObject()
        }
        
        else {
            alertMessage = "No method found."
            showingAlert = true
        }
    }
}

#Preview {
    MapView()
}

struct Map: UIViewRepresentable {
    @ObservedObject var map: MapController
    var option: LongdoMap.Option
    
    func makeUIView(context: Context) -> LongdoMap {
        return map.create(option: option)
    }
    
    func updateUIView(_ uiView: LongdoMap, context: Context) {
        
    }
}
