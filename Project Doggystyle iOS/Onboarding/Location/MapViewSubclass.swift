//
//  MapViewSubclass.swift
//  Project Doggystyle iOS
//
//  Created by Charlie Arcodia on 7/28/21.
//
//
import Foundation
import UIKit
import GoogleMaps

class MapsSubview : GMSMapView {

    var locationFinder : LocationFinder?
    let tunisia = (Latitude :  43.651070, Longitude : -79.347015)

    override init(frame: CGRect) {
        super.init(frame: frame)

        self.translatesAutoresizingMaskIntoConstraints = false
        self.layer.masksToBounds = true
        self.isUserInteractionEnabled = true
        self.isMyLocationEnabled = false
        self.isUserInteractionEnabled = true

        self.setupMap()

    }

    func setupMap() {

        let camera = GMSCameraPosition.camera(withLatitude: tunisia.Latitude, longitude: tunisia.Longitude, zoom: 5)
        GMSMapView.map(withFrame: CGRect.zero, camera: camera)
        self.camera = camera
        
        self.mapStyle = .none
        //self.mapStyle(withFilename: "NightTimeStyle", andType: "json")

        self.backgroundColor = coreWhiteColor
    }

    func addMapInsets() {

        if UIScreen.main.bounds.height == 896 {

            let mapInsets = UIEdgeInsets(top: -35, left: 175, bottom: 10, right: 155)
            self.padding = mapInsets

        } else if UIScreen.main.bounds.height == 812 {

            let mapInsets = UIEdgeInsets(top: -35, left: 155, bottom: 10, right: 155)
            self.padding = mapInsets

        } else if UIScreen.main.bounds.height == 736 {

            let mapInsets = UIEdgeInsets(top: -35, left: 180, bottom: 10, right: 180)
            self.padding = mapInsets

        } else if UIScreen.main.bounds.height == 667 {


            let mapInsets = UIEdgeInsets(top: -35, left: 155, bottom: 10, right: 155)
            self.padding = mapInsets

        } else if UIScreen.main.bounds.height == 568 {

            let mapInsets = UIEdgeInsets(top: -35, left: 155, bottom: 10, right: 155)
            self.padding = mapInsets

        }

    }

    //REMOVED FOR VERSION 1 WHEN WE TOOK AWAY MAP TAPS.
    func addCustomMarker(latitude : Double, longitude : Double) {
        
        let image = UIImage(named: "map_marker_icon")?.withRenderingMode(.alwaysOriginal)

        let marker = GMSMarker()

        marker.position = CLLocationCoordinate2DMake(latitude, longitude)
        marker.accessibilityLabel = "\(longitude)"
        marker.isDraggable = false
        marker.map = self
        marker.icon = image
        self.moveToCoordinate(latitude: latitude, longitude: longitude)

    }
    
    func moveToCoordinate(latitude : Double, longitude : Double) {
        
        let location = GMSCameraPosition.camera(withLatitude: latitude, longitude: longitude, zoom: 15)
        self.animate(to: location)

    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}

extension GMSMapView {
    func mapStyle(withFilename name: String, andType type: String) {
        do {
            if let styleURL = Bundle.main.url(forResource: name, withExtension: type) {
                self.mapStyle = try GMSMapStyle(contentsOfFileURL: styleURL)
            } else {
                NSLog("Unable to find style.json")
            }
        } catch {
            NSLog("One or more of the map styles failed to load. \(error)")
        }
    }
}



