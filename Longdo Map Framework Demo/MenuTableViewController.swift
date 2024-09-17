//
//  MenuTableViewController.swift
//  Longdo Map Framework Demo
//
//  Created by กมลภพ จารุจิตต์ on 25/4/2565 BE.
//

import UIKit

class MenuTableViewController: UITableViewController {
    let menu = [
        [
            "Set Map Language to English",
            "Set Base Layer to Gray",
            "Add Traffic Layer",
            "Remove Traffic Layer",
            "Clear All Layers",
            "Add Cameras and Events",
            "Remove Cameras and Events",
            "Add WMS Layer",
            "Add TMS Layer",
            "Add WTMS Layer",
            "Enable Filter",
            "Remove Last Custom Layer"
            //"Add Google Layer",
            //"Map Overview"
        ],
        [
            "Add Marker from URL",
            "Add Marker from HTML with Popup",
            "Add Rotate Marker",
            "Remove Last Marker",
            "List All Markers",
            "Number of Markers",
            "Clear All Overlays",
            "Add Popup",
            "Add Custom Popup",
            "Add Popup from HTML",
            "Remove Last Popup",
            "Drop Marker",
            "Start Bounce Marker",
            "Stop Bounce Marker",
            "Move Marker",
            "Rotate Marker"
        ],
        [
            "Add Local Tags",
            "Add Longdo Tags",
            "Add Tags with Options",
            "Add Tags with Geocode",
            "Remove Longdo Tags",
            "Clear all tags"
        ],
        [
            "Add Line",
            "Remove Last Geometry",
            "Add Line with Options",
            "Add Dash Line",
            "Add Polygon",
            "Add Circle",
            "Add Dot",
            "Add Donut",
            "Add Rectangle",
            "Add Image as Layer",
            "Location of Geometry"
        ],
        [
            "Add Bangkok Geometry",
            "Add East Region of Thailand Geometry",
            "Add District in Bangkok Geometry",
            "Add Multiple Subdistrict Geometry",
            "Add Province Geometry with Options",
            "Add Subdistrict Geometry by Name",
            "Add Longdo Place",
            "Remove Last Geometry Object"
        ],
        [
            "Get Route",
            "Auto Re-Route",
            "Get Route by Cost",
            "Get Route by Distance",
            "Get Route Without Tollway",
            "Get Route With Motorcycle",
            "Get Route Guide",
            "Clear Route"
        ],
        [
            "Search 'Central'",
            "Search and Get Result in English",
            "Suggest 'Central'",
            "Clear Search Result"
        ],
        [
            "Reverse Geocode",
            "Get Latitude Length"
        ],
        [
            "When Location Changed",
            "When Zoom Changed",
            "When Zoom Range Changed",
//            "Map Ready",
            "When Map is Resized",
            "When Click",
            "When Long Tap",
            "When Drag",
            "When Drop",
            "When Layer Changed",
            "When Clicked Overlay",
            "When Change Overlay",
            "When Load Overlay",
            "When Drop Overlay"
        ],
        [
            "Set Custom Location",
            "Set Geolocation",
            "Get Location",
            "Set Zoom",
            "Set Location and Zoom",
            "Set Rotate",
            "Set Pitch",
            "Zoom In",
            "Zoom Out",
            "Set Zoom Range",
            "Get Zoom Range",
            "Set Bound",
            "Get Bound",
            "Toggle DPad",
            "Toggle Zoombar",
            "Toggle Layer Selector",
            "Toggle Crosshair",
            "Toggle Scale",
            "Toggle Terrain",
            "Toggle Touch Map",
            "Toggle Drag Map"
        ],
        [
            "Click and Get Overlay Type",
            "Get Distance",
            "Get Contain",
            "Get Near POI",
            "Add HeatMap",
            "Add Cluster Marker",
            "Add 3D object"
        ]
    ]
    let sectionTitle = [
        "Map Layers",
        "Marker",
        "Tag",
        "Geometry",
        "Administration",
        "Route",
        "Search",
        "Conversion",
        "Events",
        "User Interface",
        "Etc."
    ]
    var delegate: MenuDelegate?

    override func viewDidLoad() {
        super.viewDidLoad()
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return sectionTitle.count
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return menu[section].count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "menu", for: indexPath)
        cell.textLabel?.text = menu[indexPath.section][indexPath.row]

        return cell
    }
    
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return sectionTitle[section]
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.dismiss(animated: true)
        switch (indexPath.section) {
        case 0:
            switch (indexPath.row) {
            case 0:
                delegate?.selectLanguage()
                break
            case 1:
                delegate?.setBaseLayer()
                break
            case 2:
                delegate?.addLayer()
                break
            case 3:
                delegate?.removeTrafficLayer()
                break
            case 4:
                delegate?.clearAllLayer()
                break
            case 5:
                delegate?.addEventsAndCameras()
                break
            case 6:
                delegate?.removeEventsAndCameras()
                break
            case 7:
                delegate?.addWMSLayer()
                break
            case 8:
                delegate?.addTMSLayer()
                break
            case 9:
                delegate?.addWTMSLayer()
                break
            case 10:
                delegate?.enableFilter()
                break
            case 11:
                delegate?.removeLayer()
                break
            default:
                break
            }
        case 1:
            switch (indexPath.row) {
            case 0:
                delegate?.addURLMarker()
                break
            case 1:
                delegate?.addHTMLMarker()
                break
            case 2:
                delegate?.addRotateMarker()
                break
            case 3:
                delegate?.removeMarker()
                break
            case 4:
                delegate?.markerList()
                break
            case 5:
                delegate?.markerCount()
                break
            case 6:
                delegate?.clearAllOverlays()
                break
            case 7:
                delegate?.addPopup()
                break
            case 8:
                delegate?.addCustomPopup()
                break
            case 9:
                delegate?.addHTMLPopup()
                break
            case 10:
                delegate?.removePopup()
                break
            case 11:
                delegate?.dropMarker()
                break
            case 12:
                delegate?.startBounceMarker()
                break
            case 13:
                delegate?.stopBounceMarker()
                break
            case 14:
                delegate?.moveMarker()
                break
            case 15:
                delegate?.rotateMarker()
                break
            default:
                break
            }
        case 2:
            switch (indexPath.row) {
            case 0:
                delegate?.addLocalTag()
                break
            case 1:
                delegate?.addLongdoTag()
                break
            case 2:
                delegate?.addTagWithOption()
                break
            case 3:
                delegate?.addTagWithGeocode()
                break
            case 4:
                delegate?.removeTag()
                break
            case 5:
                delegate?.clearAllTag()
                break
            default:
                break
            }
        case 3:
            switch (indexPath.row) {
            case 0:
                delegate?.addLine()
                break
            case 1:
                delegate?.removeLine()
                break
            case 2:
                delegate?.addLineWithOption()
                break
            case 3:
                delegate?.addDashLine()
                break
            case 4:
                delegate?.addPolygon()
                break
            case 5:
                delegate?.addCircle()
                break
            case 6:
                delegate?.addDot()
                break
            case 7:
                delegate?.addDonut()
                break
            case 8:
                delegate?.addRectangle()
                break
            case 9:
                delegate?.addImageAsLayer()
                break
            case 10:
                delegate?.geometryLocation()
                break
            default:
                break
            }
        case 4:
            switch (indexPath.row) {
            case 0:
                delegate?.addBangkok()
                break
            case 1:
                delegate?.addEastRegion()
                break
            case 2:
                delegate?.addBangkokDistrict()
                break
            case 3:
                delegate?.addMultipleSubdistrict()
                break
            case 4:
                delegate?.addProvinceWithOption()
                break
            case 5:
                delegate?.addSubdistrictByName()
                break
            case 6:
                delegate?.addLongdoPlace()
                break
            case 7:
                delegate?.removeGeometryObject()
                break
            default:
                break
            }
        case 5:
            switch (indexPath.row) {
            case 0:
                delegate?.getRoute()
                break
            case 1:
                delegate?.autoReroute()
                break
            case 2:
                delegate?.getRouteByCost()
                break
            case 3:
                delegate?.getRouteByDistance()
                break
            case 4:
                delegate?.getRouteWithoutTollway()
                break
            case 5:
                delegate?.getRouteWithMotorcycle()
                break
            case 6:
                delegate?.getRouteGuide()
                break
            case 7:
                delegate?.clearRoute()
                break
            default:
                break
            }
        case 6:
            switch (indexPath.row) {
            case 0:
                delegate?.searchCentral()
                break
            case 1:
                delegate?.searchInEnglish()
                break
            case 2:
                delegate?.suggestCentral()
                break
            case 3:
                delegate?.clearSearch()
                break
            default:
                break
            }
        case 7:
            switch (indexPath.row) {
            case 0:
                delegate?.getGeoCode()
                break
            case 1:
                delegate?.getLatitudeLength()
                break
            default:
                break
            }
        case 8:
            switch (indexPath.row) {
            case 0:
                delegate?.locationEvent()
                break
            case 1:
                delegate?.zoomEvent()
                break
            case 2:
                delegate?.zoomRangeEvent()
                break
            case 3:
                delegate?.resizeEvent()
                break
            case 4:
                delegate?.clickEvent()
                break
            case 5:
                delegate?.longTapEvent()
                break
            case 6:
                delegate?.dragEvent()
                break
            case 7:
                delegate?.dropEvent()
                break
            case 8:
                delegate?.layerChangeEvent()
                break
            case 9:
                delegate?.overlayClickEvent()
                break
            case 10:
                delegate?.overlayChangeEvent()
                break
            case 11:
                delegate?.overlayLoadEvent()
                break
            case 12:
                delegate?.overlayDropEvent()
                break
            default:
                break
            }
        case 9:
            switch (indexPath.row) {
            case 0:
                delegate?.setCustomLocation()
                break
            case 1:
                delegate?.setGeoLocation()
                break
            case 2:
                delegate?.getLocation()
                break
            case 3:
                delegate?.setZoom()
                break
            case 4:
                delegate?.setLocationAndZoom()
                break
            case 5:
                delegate?.setRotate()
                break
            case 6:
                delegate?.setPitch()
                break
            case 7:
                delegate?.zoomIn()
                break
            case 8:
                delegate?.zoomOut()
                break
            case 9:
                delegate?.setZoomRange()
                break
            case 10:
                delegate?.getZoomRange()
                break
            case 11:
                delegate?.setBound()
                break
            case 12:
                delegate?.getBound()
                break
            case 13:
                delegate?.toggleDPad()
                break
            case 14:
                delegate?.toggleZoombar()
                break
            case 15:
                delegate?.toggleLayerSelector()
                break
            case 16:
                delegate?.toggleCrosshair()
                break
            case 17:
                delegate?.toggleScale()
                break
            case 18:
                delegate?.toggleTerrain()
                break
            case 19:
                delegate?.toggleTouchAndDrag()
                break
            case 20:
                delegate?.toggleDrag()
                break
            default:
                break
            }
        case 10:
            switch (indexPath.row) {
            case 0:
                delegate?.getOverlayType()
                break
            case 1:
                delegate?.getDistance()
                break
            case 2:
                delegate?.getContain()
                break
            case 3:
                delegate?.nearPOI()
                break
            case 4:
                delegate?.addHeatMap()
                break
            case 5:
                delegate?.addClusterMarker()
                break
            case 6:
                delegate?.add3DObject()
                break
            default:
                break
            }
        default:
            break
        }
    }

}
