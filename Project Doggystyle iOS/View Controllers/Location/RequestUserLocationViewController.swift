//
//  RequestUserLocationViewController.swift
//  Project Doggystyle iOS
//
//  Created by Stanley Miller on 5/20/21.
//

import UIKit
import CoreLocation
import MapKit
import Firebase

final class RequestUserLocationViewController: UIViewController, MKMapViewDelegate {
    private let locationManager = CLLocationManager()
    private var selectedLocation: CLLocation?
    private var selectedAddress: String?
    private let verticalPadding: CGFloat = 30.0
    private let appointmentsAvailable = false
    private let databaseRef = Database.database().reference()
    
    private let titleLabel: UILabel = {
        let label = UILabel(frame: .zero)
        label.font = UIFont.robotoBold(size: 30)
        label.text = "Grooming location"
        label.textColor = .headerColor
        return label
    }()
    
    private let addressHeaderLabel: UILabel = {
        let label = UILabel(frame: .zero)
        label.font = UIFont.robotoBold(size: 18)
        label.textColor = .textColor
        label.numberOfLines = 0
        label.textAlignment = .center
        label.text = "Locating..."
        return label
    }()
    
    private let physicalAddressLabel: UILabel = {
        let label = UILabel(frame: .zero)
        label.font = UIFont.robotoRegular(size: 18)
        label.textColor = .textColor
        label.numberOfLines = 0
        label.textAlignment = .center
        label.text = ""
        return label
    }()
    
    private let dividerView = DividerView()
    
    private let subTitle: UILabel = {
        let label = UILabel(frame: .zero)
        label.font = UIFont.robotoRegular(size: 18)
        label.numberOfLines = 0
        label.text = NSLocalizedString("ConfirmAddress", comment: "Please confirm your address below or enter a new location.")
        label.textColor = .textColor
        return label
    }()
    
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
    
    private let nextButton: UIButton = {
        let button = DSButton(titleText: "next", backgroundColor: .systemGreen, titleColor: .white)
        button.addTarget(self, action: #selector(didTapNext(_:)), for: .touchUpInside)
        button.alpha = 0.0
        return button
    }()
    
    private let learnMoreButton: DSButton = {
        let button = DSButton(titleText: "Learn More", backgroundColor: .systemGreen, titleColor: .white)
        button.addTarget(self, action: #selector(didTapLearnMore), for: .touchUpInside)
        button.layer.cornerRadius = 5.0
        return button
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
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
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
        titleLabel.top(to: view, offset: 80.0)
        titleLabel.left(to: view, offset: verticalPadding)
        
        self.view.addSubview(dividerView)
        dividerView.height(0.5)
        dividerView.topToBottom(of: titleLabel, offset: 20.0)
        dividerView.left(to: view, offset: verticalPadding)
        dividerView.right(to: view, offset: -verticalPadding)
        
        self.view.addSubview(subTitle)
        subTitle.topToBottom(of: dividerView, offset: 20.0)
        subTitle.left(to: dividerView)
        subTitle.right(to: dividerView)
        
        self.view.addSubview(nextButton)
        nextButton.bottom(to: view, offset: -50)
        nextButton.left(to: dividerView)
        nextButton.right(to: dividerView)
        nextButton.height(44.0)
    }
}

//MARK: - Configure Map + Search TextField
extension RequestUserLocationViewController {
    private func addSearchViews() {
        self.view.addSubview(addressSearchTextField)
        addressSearchTextField.height(44)
        addressSearchTextField.topToBottom(of: subTitle, offset: 30)
        addressSearchTextField.left(to: dividerView)
        addressSearchTextField.right(to: dividerView)
        
        self.view.addSubview(mapView)
        mapView.topToBottom(of: addressSearchTextField, offset: 30)
        mapView.right(to: addressSearchTextField)
        mapView.left(to: addressSearchTextField)
        mapView.height(200)

        self.view.addSubview(addressHeaderLabel)
        addressHeaderLabel.topToBottom(of: mapView, offset: 30)
        addressHeaderLabel.left(to: dividerView)
        addressHeaderLabel.right(to: dividerView)
        
        self.view.addSubview(physicalAddressLabel)
        physicalAddressLabel.topToBottom(of: addressHeaderLabel, offset: 5)
        physicalAddressLabel.left(to: dividerView)
        physicalAddressLabel.right(to: dividerView)
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
            self.learnMoreButton.removeFromSuperview()
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
            self.nudgeForLocationServices()
        }
    }
    
    @objc private func didTapNext(_ sender: UIButton) {
        showLoadingView()
        
        //Check if appointments are available at selected location.
        if appointmentsAvailable {
//            dismissLoadingView()
        } else {
            perform(#selector(showNotServicedVC), with: nil, afterDelay: 2.0)
        }
    }
    
    @objc private func showNotServicedVC() {
        dismissLoadingView()
        let notServicedVC = LocationNotServicedViewController()
        notServicedVC.selectedAddress = selectedAddress
        
        self.navigationController?.pushViewController(notServicedVC, animated: true)
    }
    
    @objc private func didTapLearnMore() {
        let howToView = HowToEnableLocationView(frame: .zero)
        howToView.alpha = 0.0
        
        self.view.addSubview(howToView)
        howToView.edgesToSuperview()
        
        UIView.animate(withDuration: 0.75) {
            howToView.alpha = 1.0
        }
    }
}

//MARK: - Core Location
extension RequestUserLocationViewController: CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if let location = locations.first {
            let latitude = location.coordinate.latitude
            let longitude = location.coordinate.longitude
            
            let databaseLatitude = Double(latitude)
            let databaseLongitude = Double(longitude)
            
            let location = CLLocation(latitude: latitude, longitude: longitude)
            self.selectedLocation = location
            self.centerOnUserLocation()
            
            let geoCoder = CLGeocoder()
            geoCoder.reverseGeocodeLocation(location) { [weak self] placemarks, error in
                guard let self = self else { return }

                if let _ = error {
                    //show alert?
                    return
                }

                guard let placemark = placemarks?.first else {
                    //show alert?
                    return
                }
                
                let streetNumber = placemark.subThoroughfare ?? "n/a"
                let postalCode = placemark.postalCode ?? "n/a"
                let streetName = placemark.thoroughfare ?? "n/a"
                let stateName = placemark.administrativeArea ?? "n/a"
                let cityName = placemark.locality ?? "n/a"
                
                DispatchQueue.main.async {
                    self.addressHeaderLabel.text = "Your Service Location:"
                    self.physicalAddressLabel.text = "\(streetNumber) \(streetName)\n\(cityName), \(stateName) \(postalCode)"
                    self.selectedAddress = self.physicalAddressLabel.text
                }
                
                if let cleanAddress = self.selectedAddress?.replacingOccurrences(of: "\n", with: " ") {
                    Service.shared.uploadAddress(latitude: databaseLatitude, longitude: databaseLongitude, address: cleanAddress) { success in
                        if success {
                            print("Latitude, Longitude & Address Upload Successful")
                        } else {
                            print("Latitude, Longitude & Address Upload Unsuccessful!")
                        }
                    }
                }
            }
        }
    }
    
    func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
        checkLocationAuthorization()
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
            return
        }
        checkLocationAuthorization()
    }
    
    private func checkLocationAuthorization() {
        switch locationManager.authorizationStatus {
        case .authorizedWhenInUse:
            startTrackingUserLocation()
        case .denied:
            nudgeForLocationServices()
        case .notDetermined:
            locationManager.requestWhenInUseAuthorization()
        case .restricted:
            nudgeForLocationServices()
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
        learnMoreButton.removeFromSuperview()
        nextButton.alpha = 1.0
    }
}

//MARK: - Helpers
extension RequestUserLocationViewController {
    //Prompt user to enable location services with a how-to guide
    private func nudgeForLocationServices() {
        self.addressHeaderLabel.text = "Please enter your location above."
        self.physicalAddressLabel.text = "Enabling location services will allow us to better serve your pet needs. Click below to learn how to briefly share your location."
        
        self.view.addSubview(learnMoreButton)
        learnMoreButton.topToBottom(of: physicalAddressLabel, offset: 20.0)
        learnMoreButton.height(44)
        learnMoreButton.width(150)
        learnMoreButton.centerX(to: physicalAddressLabel)
    }
}
