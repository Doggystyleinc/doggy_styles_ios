//
//  RequestUserLocationViewController.swift
//  Project Doggystyle iOS
//
//  Created by Stanley Miller on 5/20/21.
//

import UIKit
import CoreLocation
import MapKit

final class RequestUserLocationViewController: UIViewController, MKMapViewDelegate {
    private let locationManager = CLLocationManager()
    private var currentLocation: CLLocation?
    private let verticalPadding: CGFloat = 30.0
    
    private let titleLabel: UILabel = {
        let label = UILabel(frame: .zero)
        label.font = UIFont.robotoBold(size: 30)
        label.text = "Grooming location"
        label.textColor = .headerColor
        return label
    }()
    
    private let physicalAddressLabel: UILabel = {
        let label = UILabel(frame: .zero)
        label.font = UIFont.robotoBold(size: 18)
        label.textColor = .headerColor
        label.numberOfLines = 0
        label.text = "Address: "
        return label
    }()
    
    private let dividerView = DividerView()
    
    private let containerView: UIView = {
        let view = UIView(frame: .zero)
        view.backgroundColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 0.8)
        return view
    }()
    
    private let permissionView: UIView = {
        let view = UIView(frame: .zero)
        view.backgroundColor = .white
        view.layer.borderColor = UIColor.black.cgColor
        view.layer.borderWidth = 0.5
        view.layer.cornerRadius = 16.0
        return view
    }()
    
    private let permissionTitle: UILabel = {
        let titleLabel = UILabel(frame: .zero)
        titleLabel.text = "Request Permission Title"
        titleLabel.textAlignment = .center
        titleLabel.font = UIFont.robotoBold(size: 26.0)
        titleLabel.textColor = .headerColor
        return titleLabel
    }()
    
    private let permissionBody: UILabel = {
        let label = UILabel(frame: .zero)
        label.text = "If you would like to find the services near by, please allow Doggystyle access to your location while using the app."
        label.textAlignment = .center
        label.numberOfLines = 0
        label.font = UIFont.robotoRegular(size: 16.0)
        label.textColor = .textColor
        return label
    }()
    
    private let allowButton: UIButton = {
        let button = UIButton(type: .system)
        button.layer.cornerRadius = 5.0
        button.setTitleColor(.white, for: .normal)
        button.backgroundColor = .systemGreen
        button.setTitle("Allow", for: .normal)
        button.addTarget(self, action: #selector(didTapAllow(_:)), for: .touchUpInside)
        return button
    }()
    
    private let notNowButton: UIButton = {
        let button = UIButton(type: .system)
        button.backgroundColor = .white
        button.setTitle("Not Now", for: .normal)
        button.addTarget(self, action: #selector(didTapNotNow(_:)), for: .touchUpInside)
        button.setTitleColor(.lightGray, for: .normal)
        return button
    }()
    
    private let addressSearchTextField: UITextField = {
        let textField = UITextField(frame: .zero)
        textField.borderStyle = .none
        textField.layer.cornerRadius = 10.0
        textField.setLeftPaddingPoints(10)
        textField.backgroundColor = .textFieldBackground
        textField.placeholder = "Address"
        textField.returnKeyType = .done
        textField.spellCheckingType = .no
        textField.setupLeftImage(imageName: "magnifyingglass")
        return textField
    }()
    
    private let mapView: MKMapView = {
        let map = MKMapView(frame: .zero)
        map.layer.cornerRadius = 10.0
        return map
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        self.configureVC()
        self.addTitleViews()
        self.addSearchViews()
        self.checkAuthorizationStatus()
    }
}

//MARK: - Configure View Controller
extension RequestUserLocationViewController {
    private func configureVC() {
        view.backgroundColor = .white
        mapView.delegate = self
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
    }
}

//MARK: - Configure Title Labels
extension RequestUserLocationViewController {
    private func addTitleViews() {
        self.view.addSubview(titleLabel)
        titleLabel.top(to: self.view, offset: 80.0)
        titleLabel.left(to: self.view, offset: verticalPadding)
        
        self.view.addSubview(dividerView)
        dividerView.height(0.5)
        dividerView.topToBottom(of: self.titleLabel, offset: 20.0)
        dividerView.left(to: self.view, offset: verticalPadding)
        dividerView.right(to: self.view, offset: -verticalPadding)
    }
}

//MARK: - Configure Map + Search TextField
extension RequestUserLocationViewController {
    private func addSearchViews() {
        self.view.addSubview(addressSearchTextField)
        addressSearchTextField.height(44)
        addressSearchTextField.topToBottom(of: self.dividerView, offset: 30)
        addressSearchTextField.left(to: self.dividerView)
        addressSearchTextField.right(to: self.dividerView)
        
        self.view.addSubview(mapView)
        mapView.topToBottom(of: self.addressSearchTextField, offset: 30)
        mapView.right(to: self.addressSearchTextField)
        mapView.left(to: self.addressSearchTextField)
        mapView.height(200)

        self.view.addSubview(physicalAddressLabel)
        physicalAddressLabel.topToBottom(of: mapView, offset: 30)
        physicalAddressLabel.left(to: self.dividerView)
        physicalAddressLabel.right(to: self.dividerView)
    }
}

//MARK: - Configure Permission Container
extension RequestUserLocationViewController {
    private func addPermissionContainer() {
        self.view.addSubview(containerView)
        containerView.edgesToSuperview()
        
        self.containerView.addSubview(permissionView)
        permissionView.top(to: self.view, offset: 180)
        permissionView.bottom(to: self.view, offset: -180)
        permissionView.right(to: self.view, offset: -20)
        permissionView.left(to: self.view, offset: 20)
    }
}

//MARK: - Configure Permission View
extension RequestUserLocationViewController {
    private func addPermissionViews() {
        let padding: CGFloat = 20.0
        
        self.permissionView.addSubview(permissionTitle)
        permissionTitle.left(to: permissionView, offset: padding)
        permissionTitle.top(to: permissionView, offset: padding)
        permissionTitle.right(to: permissionView, offset: -padding)
        
        let imageContainer = UIView(frame: .zero)
        imageContainer.backgroundColor = .lightGray
        imageContainer.layer.cornerRadius = 10.0
        
        permissionView.addSubview(imageContainer)
        imageContainer.topToBottom(of: permissionTitle, offset: padding)
        imageContainer.left(to: permissionTitle, offset: 5.0)
        imageContainer.right(to: permissionTitle, offset: -5.0)
        imageContainer.height(150.0)
        
        let imageItem = UIImageView(frame: .zero)
        imageItem.contentMode = .scaleAspectFit
        imageItem.image = UIImage(systemName: "photo.on.rectangle.angled")

        imageContainer.addSubview(imageItem)
        imageItem.centerInSuperview()
        imageItem.height(75.0)
        imageItem.width(75.0)
        
        self.permissionView.addSubview(permissionBody)
        permissionBody.topToBottom(of: imageContainer, offset: padding)
        permissionBody.left(to: imageContainer)
        permissionBody.right(to: imageContainer)
        
        self.permissionView.addSubview(allowButton)
        allowButton.topToBottom(of: permissionBody, offset: 40)
        allowButton.centerX(to: permissionView)
        allowButton.height(44)
        allowButton.width(180)
        
        permissionView.addSubview(notNowButton)
        notNowButton.topToBottom(of: allowButton, offset: padding)
        notNowButton.centerX(to: permissionView)
        notNowButton.height(44)
        notNowButton.width(180)
    }
}

//MARK: - @objc Functions
extension RequestUserLocationViewController {
    @objc private func didTapAllow(_ sender: UIButton) {
        UIView.animate(withDuration: 1.0, delay: 0.0, options: .curveEaseInOut) {
            self.containerView.alpha = 0.0
        } completion: { _ in
            //User enabled location services
            self.containerView.removeFromSuperview()
            self.checkLocationServices()
        }
    }
    
    @objc private func didTapNotNow(_ sender: UIButton) {
        UIView.animate(withDuration: 1.0, delay: 0.0, options: .curveEaseInOut) {
            self.containerView.alpha = 0.0
        } completion: { _ in
            //User did not enable location services
            self.containerView.removeFromSuperview()
            
        }
    }
}

//MARK: - Core Location
extension RequestUserLocationViewController: CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if let location = locations.first {
            let latitude = location.coordinate.latitude
            let longitude = location.coordinate.longitude
            let address = CLLocation(latitude: latitude, longitude: longitude)
            self.currentLocation = address
            self.centerOnUserLocation()
            
            let geoCoder = CLGeocoder()
            geoCoder.reverseGeocodeLocation(address) { [weak self] placemarks, error in
                guard let self = self else { return }

                if let _ = error {
                    //Show alert
                    return
                }

                guard let placemark = placemarks?.first else {
                    //show alert
                    return
                }
                //handle if fields are unavailable
                let streetNumber = placemark.subThoroughfare ?? ""
                let postalCode = placemark.postalCode ?? ""
                let streetName = placemark.thoroughfare ?? ""
                let stateName = placemark.administrativeArea ?? ""
                let cityName = placemark.locality ?? ""
                
                DispatchQueue.main.async {
                    self.physicalAddressLabel.text = "User Address:\n\(streetNumber) \(streetName)\n\(cityName), \(stateName) \(postalCode)"
                }
            }
        }
    }
    
    func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
        checkLocationAuthorization()
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
//        presentAlertOnMainThread(title: "Something went wrong...", message: "Unable able to locate your location", buttonTitle: "Ok")
    }
}

//MARK: - Location Helpers
extension RequestUserLocationViewController {
    private func checkAuthorizationStatus() {
        if locationManager.authorizationStatus == .authorizedWhenInUse || locationManager.authorizationStatus == .authorizedAlways {
            //Check if system wide Location Services are enabled.
            checkLocationServices()
        } else {
            //Present permission request prompt
            addPermissionContainer()
            addPermissionViews()
        }
    }
    
    private func checkLocationServices() {
        guard CLLocationManager.locationServicesEnabled() else {
            //Show alert letting user know to turn this on
            //direct user to Settings app if possible
            //This is device wide Location Services
            return
        }
        checkLocationAuthorization()
    }
    
    private func checkLocationAuthorization() {
        switch locationManager.authorizationStatus {
        case .authorizedWhenInUse:
            startTrackingUserLocation()
        case .denied:
            //show alert to turn on permissions
            //direct user to Settings app if possible
            break
        case .notDetermined:
            locationManager.requestWhenInUseAuthorization()
        case .restricted:
            //show alert that user cannot access modify location status
            //direct user to Settings app if possible
            break
        case .authorizedAlways:
            startTrackingUserLocation()
        @unknown default:
            break
        }
    }
    
    private func centerOnUserLocation() {
        if let location = locationManager.location?.coordinate {
            let region = MKCoordinateRegion(center: location, latitudinalMeters: 700, longitudinalMeters: 700)
            self.mapView.setRegion(region, animated: true)
        }
    }
    
    private func startTrackingUserLocation() {
        mapView.showsUserLocation = true
        locationManager.startUpdatingLocation()
        centerOnUserLocation()
    }
}
