//
//  MenuView.swift
//  Longdo Map Demo
//
//  Created by กมลภพ จารุจิตต์ on 4/8/2567 BE.
//

import SwiftUI

struct MethodSection: Identifiable {
    let name: String
    let method: [Method]
    let id = UUID()
}

struct Method: Identifiable {
    let name: String
    let id = UUID()
}

let menu = [
    MethodSection(
        name: "Map Layers",
        method: [
            Method(name: "Set Map Language to English"),
            Method(name: "Set Base Layer to Gray"),
            Method(name: "Add Traffic Layer"),
            Method(name: "Remove Traffic Layer"),
            Method(name: "Clear All Layers"),
            Method(name: "Add Cameras and Events"),
            Method(name: "Remove Cameras and Events"),
            Method(name: "Add WMS Layer"),
            Method(name: "Add TMS Layer"),
            Method(name: "Add WTMS Layer"),
            Method(name: "Enable Filter"),
            Method(name: "Remove Last Custom Layer")
        ]
    ),
    MethodSection(
        name: "Marker",
        method: [
            Method(name: "Add Marker from URL"),
            Method(name: "Add Marker from HTML with Popup"),
            Method(name: "Add Rotate Marker"),
            Method(name: "Remove Last Marker"),
            Method(name: "List All Markers"),
            Method(name: "Number of Markers"),
            Method(name: "Clear All Overlays"),
            Method(name: "Add Popup"),
            Method(name: "Add Custom Popup"),
            Method(name: "Add Popup from HTML"),
            Method(name: "Remove Last Popup"),
            Method(name: "Drop Marker"),
            Method(name: "Start Bounce Marker"),
            Method(name: "Stop Bounce Marker"),
            Method(name: "Move Marker"),
            Method(name: "Rotate Marker")
        ]
    ),
    MethodSection(
        name: "Tag",
        method: [
            Method(name: "Add Local Tags"),
            Method(name: "Add Longdo Tags"),
            Method(name: "Add Tags with Options"),
            Method(name: "Add Tags with Geocode"),
            Method(name: "Remove Longdo Tags"),
            Method(name: "Clear all tags")
        ]
    ),
    MethodSection(
        name: "Geometry",
        method: [
            Method(name: "Add Line"),
            Method(name: "Remove Last Geometry"),
            Method(name: "Add Line with Options"),
            Method(name: "Add Dash Line"),
            Method(name: "Add Polygon"),
            Method(name: "Add Circle"),
            Method(name: "Add Dot"),
            Method(name: "Add Donut"),
            Method(name: "Add Rectangle"),
            Method(name: "Add Image as Layer"),
            Method(name: "Location of Geometry")
        ]
    ),
    MethodSection(
        name: "Administration",
        method: [
            Method(name: "Add Bangkok Geometry"),
            Method(name: "Add East Region of Thailand Geometry"),
            Method(name: "Add District in Bangkok Geometry"),
            Method(name: "Add Multiple Subdistrict Geometry"),
            Method(name: "Add Province Geometry with Options"),
            Method(name: "Add Subdistrict Geometry by Name"),
            Method(name: "Add Longdo Place"),
            Method(name: "Remove Last Geometry Object")
        ]
    ),
    MethodSection(
        name: "Route",
        method: [
            Method(name: "Get Route"),
            Method(name: "Auto Re-Route"),
            Method(name: "Get Route by Cost"),
            Method(name: "Get Route by Distance"),
            Method(name: "Get Route Without Tollway"),
            Method(name: "Get Route With Motorcycle"),
            Method(name: "Get Route Guide"),
            Method(name: "Clear Route")
        ]
    ),
    MethodSection(
        name: "Search",
        method: [
            Method(name: "Search 'Central'"),
            Method(name: "Search and Get Result in English"),
            Method(name: "Suggest 'Central'"),
            Method(name: "Clear Search Result")
        ]
    ),
    MethodSection(
        name: "Conversion",
        method: [
            Method(name: "Reverse Geocode"),
            Method(name: "Get Latitude Length")
        ]
    ),
    MethodSection(
        name: "Events",
        method: [
            Method(name: "When Location Changed"),
            Method(name: "When Zoom Changed"),
            Method(name: "When Zoom Range Changed"),
            Method(name: "When Map is Resized"),
            Method(name: "When Click"),
            Method(name: "When Long Tap"),
            Method(name: "When Drag"),
            Method(name: "When Drop"),
            Method(name: "When Layer Changed"),
            Method(name: "When Clicked Overlay"),
            Method(name: "When Change Overlay"),
            Method(name: "When Load Overlay"),
            Method(name: "When Drop Overlay")
        ]
    ),
    MethodSection(
        name: "User Interface",
        method: [
            Method(name: "Set Custom Location"),
            Method(name: "Set Geolocation"),
            Method(name: "Get Location"),
            Method(name: "Set Zoom"),
            Method(name: "Set Location and Zoom"),
            Method(name: "Set Rotate"),
            Method(name: "Set Pitch"),
            Method(name: "Zoom In"),
            Method(name: "Zoom Out"),
            Method(name: "Set Zoom Range"),
            Method(name: "Get Zoom Range"),
            Method(name: "Set Bound"),
            Method(name: "Get Bound"),
            Method(name: "Toggle DPad"),
            Method(name: "Toggle Zoombar"),
            Method(name: "Toggle Layer Selector"),
            Method(name: "Toggle Crosshair"),
            Method(name: "Toggle Scale"),
            Method(name: "Toggle Terrain"),
            Method(name: "Toggle Touch Map"),
            Method(name: "Toggle Drag Map")
        ]
    ),
    MethodSection(
        name: "Etc.",
        method: [
            Method(name: "Click and Get Overlay Type"),
            Method(name: "Get Distance"),
            Method(name: "Get Contain"),
            Method(name: "Get Near POI"),
            Method(name: "Add HeatMap"),
            Method(name: "Add Cluster Marker"),
            Method(name: "Add 3D object")
        ]
    )
]

struct MenuView: View {
    @Environment(\.dismiss) var dismiss
    var callback: (String) -> Void
    
    var body: some View {
        NavigationView {
            List(menu) { section in
                Section(header: Text(section.name)) {
                    ForEach(section.method) { method in
                        Button {
                            callback(method.name)
                            dismiss()
                        } label: {
                            Text(method.name)
                                .foregroundColor(Color(UIColor.label))
                        }
                    }
                }
            }
        }
        .navigationTitle("Select a method.")
    }
}

#Preview {
    MenuView(){ _ in }
}
