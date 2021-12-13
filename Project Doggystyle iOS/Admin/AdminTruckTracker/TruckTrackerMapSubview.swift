//
//  TruckTrackerMapSubview.swift
//  Project Doggystyle iOS
//
//  Created by Charlie Arcodia on 12/10/21.
//


import Foundation
import UIKit
import GoogleMaps

class TruckTrackerMapSubview : GMSMapView, CLLocationManagerDelegate {
    
    var truckTracker : TruckTracker?
    let ontario = (Latitude :  50.089240, Longitude :  -86.796880)
    var locationManager = CLLocationManager()
    
    override init(frame: CGRect) {
        super.init(frame: frame)

        self.translatesAutoresizingMaskIntoConstraints = false
        self.layer.masksToBounds = true
        self.isMyLocationEnabled = false
        self.setupMap()
    }
    
    func setupMap() {
        
        let camera = GMSCameraPosition.camera(withLatitude: ontario.Latitude, longitude: ontario.Longitude, zoom: 3)
        GMSMapView.map(withFrame: CGRect.zero, camera: camera)
        self.camera = camera
        self.mapStyle = .none
        self.backgroundColor = coreWhiteColor
    }
    
    //REMOVED FOR VERSION 1 WHEN WE TOOK AWAY MAP TAPS.
    func addCustomMarker(latitude : Double, longitude : Double, image : UIImage, header : String) {

        let marker = GMSMarker()

        //Dans Custom Marker, adjust width by string length when calling the function
        marker.position = CLLocationCoordinate2DMake(latitude, longitude)
        marker.title = header
        marker.accessibilityLabel = "\(longitude)"
        marker.isDraggable = false
        marker.icon = image
        
        let initialFrame = UIView(frame: CGRect(x: 0, y: 0, width: 40, height: 40))
        initialFrame.translatesAutoresizingMaskIntoConstraints = true
        initialFrame.backgroundColor = .white
        initialFrame.layer.masksToBounds = true
        initialFrame.layer.cornerRadius = 20
        
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.frame = CGRect(x: 2.5, y: 2.5, width: 35, height: 35)
        imageView.backgroundColor = UIColor .lightGray.withAlphaComponent(0.7)
        imageView.layer.masksToBounds = true
        imageView.clipsToBounds = true
        imageView.image = image
        imageView.contentMode = .scaleAspectFill
        imageView.layer.cornerRadius = 35/2
        initialFrame.addSubview(imageView)
        
        UIGraphicsBeginImageContextWithOptions(initialFrame.frame.size, false, UIScreen.main.scale)
        initialFrame.layer.render(in: UIGraphicsGetCurrentContext()!)

        let finalOutput: UIImage = UIGraphicsGetImageFromCurrentImageContext()!
        UIGraphicsEndImageContext()

        marker.icon = finalOutput
        marker.map = self
        
    }
    
    //REMOVED FOR VERSION 1 WHEN WE TOOK AWAY MAP TAPS.
    func addCustomMarkerImageNormal(latitude : Double, longitude : Double, image : UIImage, header : String) {

        let marker = GMSMarker()
        marker.position = CLLocationCoordinate2DMake(latitude, longitude)
        marker.title = header
        marker.accessibilityLabel = "\(longitude)"
        marker.isDraggable = false
        marker.icon = image
        marker.map = self
        
    }
 
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
