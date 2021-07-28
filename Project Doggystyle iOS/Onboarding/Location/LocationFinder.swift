//
//  LocationFinder.swift
//  Project Doggystyle iOS
//
//  Created by Charlie Arcodia on 7/22/21.
//

import Foundation
import UIKit
import GooglePlaces
import GoogleMaps

struct GoogleMapData {
    
    var locationName : String
    var placeId : String
    
    init(json : [String : Any]) {
        self.locationName = json["locationName"] as? String ?? ""
        self.placeId = json["placeId"] as? String ?? ""
    }
}

class TextFieldWithImage: UITextField {
    
    override func leftViewRect(forBounds bounds: CGRect) -> CGRect {
        let leftViewHeight: CGFloat = 24
        let y = bounds.size.height / 2 - leftViewHeight / 2
        return .init(x: 20, y: y, width: leftViewHeight + 20, height: leftViewHeight)
    }
}

class LocationFinder : UIViewController, UITextFieldDelegate, CLLocationManagerDelegate  {
    
    private enum SearchStates {
        case idle
        case error
        case success
    }
    
    var placesHeightAnchor : NSLayoutConstraint?,
        placesClient: GMSPlacesClient!,
        arrayLocationNames : [String] = [String](),
        locationServicesEnabled : Bool = false,
        mapViewTopLayoutConstraint : NSLayoutConstraint?
    
    private var searchStates = SearchStates.idle
    
    let locationManager = CLLocationManager(),
        mainLoadingScreen = MainLoadingScreen()
    
    lazy var userCurrentLocationIcon: UIButton = {
        
        let cbf = UIButton(type: .system)
        cbf.translatesAutoresizingMaskIntoConstraints = false
        cbf.tintColor = coreOrangeColor
        cbf.backgroundColor = .clear
        let configHome = UIImage.SymbolConfiguration(pointSize: 15, weight: .medium)
        let image = UIImage(systemName: "location.fill", withConfiguration: configHome)?.withTintColor(coreOrangeColor).withRenderingMode(.alwaysOriginal) ?? UIImage(named: "")
        cbf.setImage(image, for: .normal)
        cbf.tintColor = coreOrangeColor
        cbf.contentMode = .scaleAspectFit
        cbf.imageView?.contentMode = .scaleAspectFit
        cbf.isUserInteractionEnabled = false

        return cbf
        
    }()
    
    lazy var userCurrentLocationButton: UIButton = {
        
        let cbf = UIButton(type: .system)
        cbf.translatesAutoresizingMaskIntoConstraints = false
        cbf.setTitle("use current location", for: UIControl.State.normal)
        cbf.titleLabel?.font = UIFont.init(name: dsHeaderFont, size: 13)
        cbf.titleLabel?.adjustsFontSizeToFitWidth = true
        cbf.titleLabel?.numberOfLines = 1
        cbf.titleLabel?.adjustsFontForContentSizeCategory = true
        cbf.layer.masksToBounds = true
        cbf.tintColor = coreOrangeColor
        cbf.backgroundColor = .clear
        cbf.isUserInteractionEnabled = false
        
        return cbf
        
    }()
    let headerLabel : UILabel = {
        
        let thl = UILabel()
        thl.translatesAutoresizingMaskIntoConstraints = false
        thl.textAlignment = .left
        thl.text = "Grooming Location"
        thl.font = UIFont(name: dsHeaderFont, size: 24)
        thl.numberOfLines = 1
        thl.adjustsFontSizeToFitWidth = true
        thl.textColor = coreBlackColor
        
        return thl
        
    }()
    
    let subHeaderLabel : UILabel = {
        
        let thl = UILabel()
        thl.translatesAutoresizingMaskIntoConstraints = false
        thl.textAlignment = .left
        thl.text = "Address"
        thl.font = UIFont(name: dsSubHeaderFont, size: 21)
        thl.numberOfLines = 1
        thl.adjustsFontSizeToFitWidth = true
        thl.textColor = coreBlackColor
        
        return thl
        
    }()
    
    lazy var searchTextField : CustomTextFieldMaps = {
        
        let etfc = CustomTextFieldMaps()
        etfc.translatesAutoresizingMaskIntoConstraints = false
        let placeholder = NSAttributedString(string: "Enter address", attributes: [NSAttributedString.Key.foregroundColor: dividerGrey])
        etfc.attributedPlaceholder = placeholder
        etfc.textAlignment = .left
        etfc.backgroundColor = UIColor .white
        etfc.textColor = coreBlackColor
        etfc.font = UIFont(name: rubikRegular, size: 16)
        etfc.allowsEditingTextAttributes = false
        etfc.autocorrectionType = .no
        etfc.delegate = self
        etfc.layer.cornerRadius = 10
        etfc.layer.masksToBounds = false
        etfc.keyboardAppearance = UIKeyboardAppearance.light
        etfc.returnKeyType = UIReturnKeyType.done
        etfc.clipsToBounds = false
        etfc.layer.masksToBounds = false
        
        etfc.layer.shadowColor = coreBlackColor.withAlphaComponent(0.8).cgColor
        etfc.layer.shadowOpacity = 0.05
        etfc.layer.shadowOffset = CGSize(width: 2, height: 3)
        etfc.layer.shadowRadius = 9
        etfc.layer.shouldRasterize = false
        
//        let configHome = UIImage.SymbolConfiguration(pointSize: 8, weight: .light)
//        let image = UIImage(systemName: "magnifyingglass", withConfiguration: configHome)?.withTintColor(dividerGrey).withRenderingMode(.alwaysOriginal) ?? UIImage(named: "")
//        let imageView = UIImageView()
//        imageView.frame = CGRect(x: 0, y: 0, width: 60, height: 60)
//        imageView.contentMode = .scaleAspectFit
//        imageView.image = image
//        etfc.leftView = imageView
//        etfc.leftViewMode = .always
//
////        etfc.setRightPaddingPoints(50)
//        etfc.setLeftPaddingPoints(10)
        
        etfc.addTarget(self, action: #selector(handleSearchTextFieldChange(textField:)), for: .editingChanged)
        
        return etfc
        
    }()
    
    let orangePinIcon : UIImageView = {
        
        let dcl = UIImageView()
        dcl.translatesAutoresizingMaskIntoConstraints = false
        dcl.backgroundColor = .clear
        dcl.contentMode = .scaleAspectFit
        dcl.isUserInteractionEnabled = false
        let image = UIImage(named: "orange_pin")?.withRenderingMode(.alwaysOriginal)
        dcl.image = image
        
        return dcl
    }()
    
    lazy var errorLabel : UILabel = {
        
        let el = UILabel()
        el.translatesAutoresizingMaskIntoConstraints = false
        el.textAlignment = .center
        el.backgroundColor = .clear
        el.textColor = UIColor .darkGray.withAlphaComponent(1.0)
        el.font = UIFont(name: dsSubHeaderFont, size: 16)
        el.isUserInteractionEnabled = false
        el.numberOfLines = -1
        el.text = "We’re sorry, no appointments are currently available. We will send you an email once we begin servicing your area.\n\nWant to receive additional notifications? Choose your preferred contact method. "
        el.isHidden = true
        
        return el
        
    }()
    
    let errorContainer : UIView = {
        
        let ec = UIView()
        ec.translatesAutoresizingMaskIntoConstraints = false
        ec.backgroundColor = .clear
        ec.isUserInteractionEnabled = false
        ec.isHidden = true
        
        return ec
    }()
    
    lazy var smsButton : UIButton = {
        
        let cbf = UIButton(type: .system)
        cbf.translatesAutoresizingMaskIntoConstraints = false
        cbf.setTitle("SMS", for: UIControl.State.normal)
        cbf.titleLabel?.font = UIFont.init(name: dsHeaderFont, size: 16)
        cbf.titleLabel?.adjustsFontSizeToFitWidth = true
        cbf.titleLabel?.numberOfLines = 1
        cbf.titleLabel?.adjustsFontForContentSizeCategory = true
        cbf.titleLabel?.textColor = coreBlackColor
        cbf.backgroundColor = coreWhiteColor
        cbf.layer.cornerRadius = 14
        cbf.layer.masksToBounds = false
        cbf.tintColor = coreOrangeColor
        cbf.layer.shadowColor = coreBlackColor.withAlphaComponent(0.8).cgColor
        cbf.layer.shadowOpacity = 0.1
        cbf.layer.shadowOffset = CGSize(width: 2, height: 3)
        cbf.layer.shadowRadius = 9
        cbf.layer.shouldRasterize = false
        cbf.addTarget(self, action: #selector(self.handleSMSButton), for: UIControl.Event.touchUpInside)
        
        return cbf
        
    }()
    
    lazy var whatsappButton : UIButton = {
        
        let cbf = UIButton(type: .system)
        cbf.translatesAutoresizingMaskIntoConstraints = false
        cbf.setTitle("WhatsApp", for: UIControl.State.normal)
        cbf.titleLabel?.font = UIFont.init(name: dsHeaderFont, size: 16)
        cbf.titleLabel?.adjustsFontSizeToFitWidth = true
        cbf.titleLabel?.numberOfLines = 1
        cbf.titleLabel?.adjustsFontForContentSizeCategory = true
        cbf.titleLabel?.textColor = coreBlackColor
        cbf.backgroundColor = coreWhiteColor
        cbf.layer.cornerRadius = 14
        cbf.layer.masksToBounds = false
        cbf.tintColor = coreOrangeColor
        cbf.layer.shadowColor = coreBlackColor.withAlphaComponent(0.8).cgColor
        cbf.layer.shadowOpacity = 0.1
        cbf.layer.shadowOffset = CGSize(width: 2, height: 3)
        cbf.layer.shadowRadius = 9
        cbf.layer.shouldRasterize = false
        cbf.addTarget(self, action: #selector(self.handleWhatsAppButton), for: UIControl.Event.touchUpInside)
        
        return cbf
        
    }()
    
    let uhOhLabel : UILabel = {
        
        let thl = UILabel()
        thl.translatesAutoresizingMaskIntoConstraints = false
        thl.textAlignment = .center
        thl.text = "Uh oh..."
        thl.font = UIFont(name: dsHeaderFont, size: 21)
        thl.numberOfLines = 1
        thl.adjustsFontSizeToFitWidth = true
        thl.textColor = coreBlackColor
        
        return thl
        
    }()
    
    let successContainer : UIView = {
        
        let bc = UIView()
        bc.translatesAutoresizingMaskIntoConstraints = false
        bc.backgroundColor = .clear
        bc.isUserInteractionEnabled = true
        
        return bc
    }()
    
    let orangeCheckIcon : UIImageView = {
        
        let dcl = UIImageView()
        dcl.translatesAutoresizingMaskIntoConstraints = false
        dcl.backgroundColor = .clear
        dcl.contentMode = .scaleAspectFit
        dcl.isUserInteractionEnabled = false
        let image = UIImage(named: "orange_check")?.withRenderingMode(.alwaysOriginal)
        dcl.image = image
        
        return dcl
    }()
    
    let locationSupportedLabel : UILabel = {
        
        let thl = UILabel()
        thl.translatesAutoresizingMaskIntoConstraints = false
        thl.textAlignment = .center
        thl.text = "Woo Hoo!"
        thl.font = UIFont(name: dsHeaderFont, size: 24)
        thl.numberOfLines = 1
        thl.adjustsFontSizeToFitWidth = true
        thl.textColor = coreOrangeColor
        thl.backgroundColor = .clear
        
        return thl
        
    }()
    
    lazy var confirmButton : UIButton = {
        
        let cbf = UIButton(type: .system)
        cbf.translatesAutoresizingMaskIntoConstraints = false
        cbf.setTitle("Explore Doggystyle", for: UIControl.State.normal)
        cbf.titleLabel?.font = UIFont.init(name: dsHeaderFont, size: 18)
        cbf.titleLabel?.adjustsFontSizeToFitWidth = true
        cbf.titleLabel?.numberOfLines = 1
        cbf.titleLabel?.adjustsFontForContentSizeCategory = true
        cbf.titleLabel?.textColor = coreWhiteColor
        cbf.backgroundColor = coreOrangeColor
        cbf.layer.cornerRadius = 14
        cbf.layer.masksToBounds = false
        cbf.tintColor = coreWhiteColor
        cbf.layer.shadowColor = coreBlackColor.withAlphaComponent(0.8).cgColor
        cbf.layer.shadowOpacity = 0.05
        cbf.layer.shadowOffset = CGSize(width: 2, height: 3)
        cbf.layer.shadowRadius = 9
        cbf.layer.shouldRasterize = false
        cbf.addTarget(self, action: #selector(self.handleConfirmButton), for: UIControl.Event.touchUpInside)
        
        return cbf
        
    }()
    
    lazy var confirmLocationButton : UIButton = {
        
        let cbf = UIButton(type: .system)
        cbf.translatesAutoresizingMaskIntoConstraints = false
        cbf.setTitle("Continue with this address", for: UIControl.State.normal)
        cbf.titleLabel?.font = UIFont.init(name: dsHeaderFont, size: 18)
        cbf.titleLabel?.adjustsFontSizeToFitWidth = true
        cbf.titleLabel?.numberOfLines = 1
        cbf.titleLabel?.adjustsFontForContentSizeCategory = true
        cbf.titleLabel?.textColor = coreWhiteColor
        cbf.backgroundColor = coreOrangeColor
        cbf.layer.cornerRadius = 14
        cbf.layer.masksToBounds = false
        cbf.tintColor = coreWhiteColor
        cbf.layer.shadowColor = coreBlackColor.withAlphaComponent(0.8).cgColor
        cbf.layer.shadowOpacity = 0.05
        cbf.layer.shadowOffset = CGSize(width: 2, height: 3)
        cbf.layer.shadowRadius = 9
        cbf.layer.shouldRasterize = false
        cbf.isHidden = true
        cbf.addTarget(self, action: #selector(self.handleConfirmAddressButton), for: UIControl.Event.touchUpInside)
        
        return cbf
        
    }()
    
    let successImage : UIImageView = {
        
        let si = UIImageView()
        si.translatesAutoresizingMaskIntoConstraints = false
        si.backgroundColor = .clear
        si.contentMode = .scaleAspectFit
        let image = UIImage(named: "location_success_image")?.withRenderingMode(.alwaysOriginal)
        si.image = image
        si.isUserInteractionEnabled = false
        
       return si
    }()
    
    let getStyledLabel : UILabel = {
        
        let thl = UILabel()
        thl.translatesAutoresizingMaskIntoConstraints = false
        thl.textAlignment = .center
        thl.text = "Let's get Doggystyled!"
        thl.font = UIFont(name: rubikRegular, size: 16)
        thl.numberOfLines = 1
        thl.adjustsFontSizeToFitWidth = true
        thl.textColor = coreBlackColor
        
        return thl
        
    }()
    
    lazy var searchResultsTableView : SearchResultsTableView = {
        
        let mc = SearchResultsTableView()
        mc.groomerLocationOne = self
        return mc
        
    }()
    
    lazy var mapView : MapsSubview = {
        
        let mv = MapsSubview(frame: .zero)
        mv.translatesAutoresizingMaskIntoConstraints = false
        mv.backgroundColor = coreOrangeColor
        mv.isUserInteractionEnabled = true
        mv.layer.masksToBounds = true
        mv.layer.cornerRadius = 12
        mv.locationFinder = self
        
       return mv
    }()
    
    lazy var cancelSearchButton: UIButton = {
        
        let cbf = UIButton(type: .system)
        cbf.translatesAutoresizingMaskIntoConstraints = false
        cbf.backgroundColor = .clear
        cbf.titleLabel?.font = UIFont.fontAwesome(ofSize: 18, style: .solid)
        cbf.setTitle(String.fontAwesomeIcon(name: .timesCircle), for: .normal)
        cbf.tintColor = dividerGrey
        cbf.contentMode = .scaleAspectFit
        cbf.imageView?.contentMode = .scaleAspectFit
        cbf.addTarget(self, action: #selector(self.handleCancelCurrentSearchButton), for: .touchUpInside)
        
        return cbf
        
    }()
    
    lazy var currentUserContainerButton : UIButton = {
        
        let cb = UIButton(type: .system)
        cb.translatesAutoresizingMaskIntoConstraints = false
        cb.backgroundColor = .clear
        cb.addTarget(self, action: #selector(self.grabUsersCurrentLocation), for: .touchUpInside)

       return cb
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.backgroundColor = coreBackgroundWhite
        self.addViews()
        
        self.placesClient = GMSPlacesClient.shared()
        self.searchStates = .idle
        self.listener()
        
        self.successContainer.isHidden = true
        self.errorContainer.isHidden = true
        
        self.handleLocationServicesAuthorization()
        
    }
    
    func addViews() {
        
        self.view.addSubview(self.headerLabel)
        self.view.addSubview(self.subHeaderLabel)
        self.view.addSubview(self.searchTextField)
        self.view.addSubview(self.searchResultsTableView)
        self.view.addSubview(self.errorContainer)
        self.view.addSubview(self.successContainer)
        
        self.view.addSubview(self.currentUserContainerButton)
        self.currentUserContainerButton.addSubview(self.userCurrentLocationButton)
        self.currentUserContainerButton.addSubview(self.userCurrentLocationIcon)
        
        self.view.addSubview(self.confirmLocationButton)

        self.view.addSubview(self.mapView)
        self.view.addSubview(self.cancelSearchButton)
        
        self.errorContainer.addSubview(self.orangePinIcon)
        self.errorContainer.addSubview(self.smsButton)
        self.errorContainer.addSubview(self.whatsappButton)
        self.errorContainer.addSubview(self.uhOhLabel)
        self.errorContainer.addSubview(self.errorLabel)
        
        self.successContainer.addSubview(self.locationSupportedLabel)
        self.successContainer.addSubview(self.successImage)
        self.successContainer.addSubview(self.confirmButton)
        self.successContainer.addSubview(self.getStyledLabel)

        self.headerLabel.topAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.topAnchor, constant: 35).isActive = true
        self.headerLabel.leftAnchor.constraint(equalTo: self.view.leftAnchor, constant: 25).isActive = true
        self.headerLabel.rightAnchor.constraint(equalTo: self.view.rightAnchor, constant: -20).isActive = true
        self.headerLabel.heightAnchor.constraint(equalToConstant: 30).isActive = true
        
        self.subHeaderLabel.topAnchor.constraint(equalTo: self.headerLabel.bottomAnchor, constant: 36).isActive = true
        self.subHeaderLabel.leftAnchor.constraint(equalTo: self.view.leftAnchor, constant: 25).isActive = true
        self.subHeaderLabel.heightAnchor.constraint(equalToConstant: 30).isActive = true
        self.subHeaderLabel.widthAnchor.constraint(equalToConstant: 140).isActive = true

        self.searchTextField.topAnchor.constraint(equalTo: self.subHeaderLabel.bottomAnchor, constant: 20).isActive = true
        self.searchTextField.leftAnchor.constraint(equalTo: self.view.leftAnchor, constant: 25).isActive = true
        self.searchTextField.rightAnchor.constraint(equalTo: self.view.rightAnchor, constant: -25).isActive = true
        self.searchTextField.heightAnchor.constraint(equalToConstant: 60).isActive = true
        
        self.errorContainer.topAnchor.constraint(equalTo: self.searchTextField.bottomAnchor, constant: 5).isActive = true
        self.errorContainer.leftAnchor.constraint(equalTo: self.view.leftAnchor, constant: 0).isActive = true
        self.errorContainer.rightAnchor.constraint(equalTo: self.view.rightAnchor, constant: 0).isActive = true
        self.errorContainer.bottomAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.bottomAnchor, constant: 0).isActive = true
        
        self.orangePinIcon.centerXAnchor.constraint(equalTo: self.errorContainer.centerXAnchor, constant: 0).isActive = true
        self.orangePinIcon.topAnchor.constraint(equalTo: self.errorContainer.topAnchor, constant: 20).isActive = true
        self.orangePinIcon.heightAnchor.constraint(equalToConstant: 50).isActive = true
        self.orangePinIcon.widthAnchor.constraint(equalToConstant: 50).isActive = true
        
        self.uhOhLabel.topAnchor.constraint(equalTo: self.orangePinIcon.bottomAnchor, constant: 5).isActive = true
        self.uhOhLabel.leftAnchor.constraint(equalTo: self.errorContainer.leftAnchor, constant: 20).isActive = true
        self.uhOhLabel.rightAnchor.constraint(equalTo: self.errorContainer.rightAnchor, constant: -20).isActive = true
        self.uhOhLabel.heightAnchor.constraint(equalToConstant: 30).isActive = true
        
        self.smsButton.bottomAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.bottomAnchor, constant: -20).isActive = true
        self.smsButton.leftAnchor.constraint(equalTo: self.view.leftAnchor, constant: 30).isActive = true
        self.smsButton.rightAnchor.constraint(equalTo: self.view.rightAnchor, constant: -30).isActive = true
        self.smsButton.heightAnchor.constraint(equalToConstant: 60).isActive = true
        
        self.whatsappButton.bottomAnchor.constraint(equalTo: self.smsButton.topAnchor, constant: -20).isActive = true
        self.whatsappButton.leftAnchor.constraint(equalTo: self.view.leftAnchor, constant: 30).isActive = true
        self.whatsappButton.rightAnchor.constraint(equalTo: self.view.rightAnchor, constant: -30).isActive = true
        self.whatsappButton.heightAnchor.constraint(equalToConstant: 60).isActive = true
        
        self.errorLabel.topAnchor.constraint(equalTo: self.uhOhLabel.bottomAnchor, constant: 10).isActive = true
        self.errorLabel.leftAnchor.constraint(equalTo: self.errorContainer.leftAnchor, constant: 30).isActive = true
        self.errorLabel.rightAnchor.constraint(equalTo: self.errorContainer.rightAnchor, constant: -30).isActive = true
        self.errorLabel.bottomAnchor.constraint(equalTo: self.whatsappButton.topAnchor, constant: -10).isActive = true
        
        self.successContainer.topAnchor.constraint(equalTo: self.userCurrentLocationButton.bottomAnchor, constant: 0).isActive = true
        self.successContainer.leftAnchor.constraint(equalTo: self.view.leftAnchor, constant: 0).isActive = true
        self.successContainer.rightAnchor.constraint(equalTo: self.view.rightAnchor, constant: 0).isActive = true
        self.successContainer.bottomAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.bottomAnchor, constant: 0).isActive = true
        
        self.locationSupportedLabel.topAnchor.constraint(equalTo: self.successContainer.topAnchor, constant: 0).isActive = true
        self.locationSupportedLabel.leftAnchor.constraint(equalTo: self.view.leftAnchor, constant: 25).isActive = true
        self.locationSupportedLabel.rightAnchor.constraint(equalTo: self.view.rightAnchor, constant: -20).isActive = true
        self.locationSupportedLabel.heightAnchor.constraint(equalToConstant: 30).isActive = true
        
        self.confirmButton.bottomAnchor.constraint(equalTo: self.successContainer.bottomAnchor, constant: -20).isActive = true
        self.confirmButton.leftAnchor.constraint(equalTo: self.view.leftAnchor, constant: 30).isActive = true
        self.confirmButton.rightAnchor.constraint(equalTo: self.view.rightAnchor, constant: -30).isActive = true
        self.confirmButton.heightAnchor.constraint(equalToConstant: 60).isActive = true
        
        self.getStyledLabel.bottomAnchor.constraint(equalTo: self.confirmButton.topAnchor, constant: -20).isActive = true
        self.getStyledLabel.leftAnchor.constraint(equalTo: self.successContainer.leftAnchor, constant: 20).isActive = true
        self.getStyledLabel.rightAnchor.constraint(equalTo: self.successContainer.rightAnchor, constant: -20).isActive = true
        self.getStyledLabel.heightAnchor.constraint(equalToConstant: 20).isActive = true

        self.successImage.topAnchor.constraint(equalTo: self.locationSupportedLabel.bottomAnchor, constant: 10).isActive = true
        self.successImage.leftAnchor.constraint(equalTo: self.successContainer.leftAnchor, constant: 0).isActive = true
        self.successImage.rightAnchor.constraint(equalTo: self.successContainer.rightAnchor, constant: 0).isActive = true
        self.successImage.bottomAnchor.constraint(equalTo: self.getStyledLabel.topAnchor, constant: -10).isActive = true
     
        self.searchResultsTableView.topAnchor.constraint(equalTo: self.searchTextField.bottomAnchor, constant: 10).isActive = true
        self.searchResultsTableView.leftAnchor.constraint(equalTo: self.searchTextField.leftAnchor, constant: 0).isActive = true
        self.searchResultsTableView.rightAnchor.constraint(equalTo: self.searchTextField.rightAnchor, constant: 0).isActive = true
        self.placesHeightAnchor = searchResultsTableView.heightAnchor.constraint(equalToConstant: 0)
        self.placesHeightAnchor?.isActive = true
        
        self.currentUserContainerButton.centerXAnchor.constraint(equalTo: self.view.centerXAnchor, constant: 0).isActive = true
        self.currentUserContainerButton.topAnchor.constraint(equalTo: self.searchResultsTableView.bottomAnchor, constant: 3).isActive = true
        self.currentUserContainerButton.widthAnchor.constraint(equalToConstant: 200).isActive = true
        self.currentUserContainerButton.heightAnchor.constraint(equalToConstant: 44).isActive = true
        
        self.userCurrentLocationIcon.leftAnchor.constraint(equalTo: self.currentUserContainerButton.leftAnchor, constant: 10).isActive = true
        self.userCurrentLocationIcon.centerYAnchor.constraint(equalTo: self.currentUserContainerButton.centerYAnchor, constant: 0).isActive = true
        self.userCurrentLocationIcon.heightAnchor.constraint(equalToConstant: 40).isActive = true
        self.userCurrentLocationIcon.widthAnchor.constraint(equalToConstant: 30).isActive = true
        
        self.userCurrentLocationButton.leftAnchor.constraint(equalTo: self.userCurrentLocationIcon.rightAnchor, constant: 10).isActive = true
        self.userCurrentLocationButton.centerYAnchor.constraint(equalTo: self.currentUserContainerButton.centerYAnchor, constant: 0).isActive = true
        self.userCurrentLocationButton.rightAnchor.constraint(equalTo: self.currentUserContainerButton.rightAnchor, constant: -10).isActive = true
        self.userCurrentLocationButton.heightAnchor.constraint(equalToConstant: 30).isActive = true

        self.mapViewTopLayoutConstraint = self.mapView.topAnchor.constraint(equalTo: self.currentUserContainerButton.bottomAnchor, constant: 10)
        self.mapViewTopLayoutConstraint?.isActive = true
        
        self.mapView.leftAnchor.constraint(equalTo: self.view.leftAnchor, constant: 30).isActive = true
        self.mapView.rightAnchor.constraint(equalTo: self.view.rightAnchor, constant: -30).isActive = true
        self.mapView.bottomAnchor.constraint(equalTo: self.confirmButton.topAnchor, constant: -20).isActive = true
        
        self.cancelSearchButton.centerYAnchor.constraint(equalTo: self.searchTextField.centerYAnchor, constant: 0).isActive = true
        self.cancelSearchButton.rightAnchor.constraint(equalTo: self.searchTextField.rightAnchor, constant: -10).isActive = true
        self.cancelSearchButton.heightAnchor.constraint(equalToConstant: 44).isActive = true
        self.cancelSearchButton.widthAnchor.constraint(equalToConstant: 44).isActive = true
        
        self.confirmLocationButton.bottomAnchor.constraint(equalTo: self.successContainer.bottomAnchor, constant: -20).isActive = true
        self.confirmLocationButton.leftAnchor.constraint(equalTo: self.view.leftAnchor, constant: 30).isActive = true
        self.confirmLocationButton.rightAnchor.constraint(equalTo: self.view.rightAnchor, constant: -30).isActive = true
        self.confirmLocationButton.heightAnchor.constraint(equalToConstant: 60).isActive = true

    }
    
  
    //ENABLE LOCATION SERVICES OR ELSE DISMISS THE CONTROLLER
    @objc func handleLocationServicesAuthorization() {
        
        self.locationManager.delegate = self
        
        if CLLocationManager.locationServicesEnabled() {
            
            switch self.locationManager.authorizationStatus {
            
            case .authorizedAlways, .authorizedWhenInUse:
                
                self.locationServicesEnabled = true
                
            case .notDetermined, .restricted :
                
                self.locationManager.requestWhenInUseAuthorization()
                
            case .denied:
                
                self.askUserForPermissionsAgain()
                
            default : print("Hit an unknown state")
                
            }
            
        } else {
            
            self.askUserForPermissionsAgain()
            
        }
    }
    
    func askUserForPermissionsAgain() {
        
        let activityViewController = UIAlertController(title: "Location Services", message: "Please allow Doggystyle permission to the devices location so we can find nearby Groomers.", preferredStyle: .alert)
        
        let actionOne = UIAlertAction(title: "Cancel", style: .default) { (alert : UIAlertAction) in
            
            self.navigationController?.dismiss(animated: true, completion: nil)
            
        }
        
        let actionTwo = UIAlertAction(title: "Enable", style: .default) { (alert : UIAlertAction) in
            
            guard let settingsUrl = URL(string: UIApplication.openSettingsURLString) else {
                
                return
                
            }
            
            if UIApplication.shared.canOpenURL(settingsUrl) {
                UIApplication.shared.open(settingsUrl, completionHandler: { (success) in
                    
                    print(success)
                    print("Good to go here as well")
                    self.locationServicesEnabled = true
                    
                })
            }
        }
        
        activityViewController.addAction(actionOne)
        activityViewController.addAction(actionTwo)
        self.present(activityViewController, animated: true, completion: nil)
        
    }
    
    func listener() {
        
        switch self.searchStates {
        
        case .idle:
            self.errorContainer.isHidden = true
            self.successContainer.isHidden = true
        case .error:
            self.errorContainer.isHidden = false
            self.successContainer.isHidden = true
        case .success:
            self.errorContainer.isHidden = true
            self.successContainer.isHidden = false
        }
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField == self.searchTextField {
            self.resignation()
            return true
        }
        return false
    }
    
    func resignation() {
        self.searchTextField.resignFirstResponder()
    }
    
    @objc func handleSearchTextFieldChange(textField: UITextField) {
        
        guard let searchTextField = textField.text else {return}
        let safeText = searchTextField.trimmingCharacters(in: .whitespacesAndNewlines)
        
        self.successContainer.isHidden = true
        self.userCurrentLocationIcon.isHidden = false
        self.userCurrentLocationButton.isHidden = false
        
        
        if safeText.count == 0 {
            UIView.animate(withDuration: 0.45) {
                self.placesHeightAnchor?.constant = 0
                self.searchResultsTableView.superview?.layoutIfNeeded()
                self.mapView.animate(toZoom: 5)
                self.mapView.clear()
            }
        } else {
            let currentEnteredText = safeText
            self.placesAutocomplete(passedPlace: currentEnteredText)
        }
    }
    
    func placesAutocomplete(passedPlace:String) {
        
        let token = GMSAutocompleteSessionToken.init(),
            filter = GMSAutocompleteFilter()
        filter.type = .address
        
        placesClient?.findAutocompletePredictions(fromQuery: passedPlace, filter: filter, sessionToken: token, callback: { (results, error) in
            if let error = error {
                print("Autocomplete error: \(error)")
                return
            }
            
            if let results = results {
                
                for result in results {
                    
                    let filteredResults = result.attributedFullText.string
                    
                    self.searchResultsTableView.placesArray.append(filteredResults)
                    
                    let placesId = result.placeID,
                        placeName = filteredResults,
                        dic : [String : Any] = ["locationName" : placeName as Any, "placeName" : placesId as Any],
                        posts = PlacesDictionary(json: dic)
                    
                    //CHECK TO REMOVE DUPLICATES AND FILTER BY MOST RELEVANT
                    if !self.arrayLocationNames.contains(placesId) {
                        self.arrayLocationNames.append(placesId)
                        self.searchResultsTableView.arrayOfDicts.append(posts)
                    }
                    
                    let array = self.searchResultsTableView.arrayOfDicts,
                        arraySlice = array.suffix(3),
                        newArray = Array(arraySlice)
                    
                    self.searchResultsTableView.arrayOfDicts = newArray
                    
                    DispatchQueue.main.async {
                        
                        self.searchResultsTableView.reloadData()
                        
                        UIView.animate(withDuration: 0.2) {
                            self.placesHeightAnchor?.constant = CGFloat(self.searchResultsTableView.arrayOfDicts.count * 50)
                            self.searchResultsTableView.superview?.layoutIfNeeded()
                        }
                    }
                }
            }
        })
    }
    
    func resetTable() {
        self.searchTextField.text = ""
        UIView.animate(withDuration: 0.45) {

        self.placesHeightAnchor?.constant = 0
        self.searchResultsTableView.superview?.layoutIfNeeded()
        
        }
    }
}

extension LocationFinder {
    
    func handleLocationSelection(passedPlaceID : String, passedLocationAddress : String) {
        
        self.placesClient.lookUpPlaceID(passedPlaceID) { place, error in
            
            if let error = error {
                print("lookup place id query error: \(error.localizedDescription)")
                self.handleCancelCurrentSearchButton()
                return
            }
            
            guard let place = place else {
                print("No place details for \(passedPlaceID)")
                self.handleCancelCurrentSearchButton()
                return
            }
            
            let latitude = place.coordinate.latitude
            let longitude = place.coordinate.longitude
            
            self.mapView.clear()
            
            self.mapView.isHidden = false
            
            self.mapView.addCustomMarker(latitude: latitude, longitude: longitude)
            
        }
        
        UIDevice.vibrateLight()
        
        self.currentUserContainerButton.isHidden = true
        UIView.animate(withDuration: 0.45) {
            self.mapViewTopLayoutConstraint?.constant = -30
        }
        self.confirmLocationButton.isHidden = false
        
        self.resignation()
        self.resetTable()
        self.searchTextField.text = passedLocationAddress
        
    }
    
    @objc func grabUsersCurrentLocation() {
        
        self.resignation()
        self.resetTable()
        self.searchTextField.text = ""
        self.mapView.clear()
        self.mapView.isHidden = false
        self.currentUserContainerButton.isHidden = true
        
        let lat = self.locationManager.location?.coordinate.latitude ?? 0.0
        let long = self.locationManager.location?.coordinate.longitude ?? 0.0
        self.mapView.addCustomMarker(latitude: lat, longitude: long)

        let coordinates = CLLocationCoordinate2DMake(lat, long)
            
            UIView.animate(withDuration: 0.45) {
                self.mapViewTopLayoutConstraint?.constant = -30
            }

            self.confirmLocationButton.isHidden = false
            
            let geocoder = GMSGeocoder()
            geocoder.reverseGeocodeCoordinate(coordinates) { response, error in
                if error != nil {
                    return
                }
                
                if let result = response?.firstResult()?.lines {
                    
                    let finalResult = result[0]
                    self.searchTextField.text = "\(finalResult)"
                    print("RESULT: \(finalResult)")
            }
        }
    }
    
    func fetchCountryAndCity(location: CLLocation, completion: @escaping (String, String) -> ()) {
        CLGeocoder().reverseGeocodeLocation(location) { placemarks, error in
            
            if let _ = error {
                
            } else if let country = placemarks?.first?.country,
                let city = placemarks?.first?.locality {
                completion(country, city)
            }
        }
    }
    
    
    @objc func handleCancelCurrentSearchButton() {
        
        self.searchTextField.text = ""
        self.currentUserContainerButton.isHidden = false
        
        UIView.animate(withDuration: 0.25) {
            self.placesHeightAnchor?.constant = 0
            self.searchResultsTableView.superview?.layoutIfNeeded()
            self.mapView.animate(toZoom: 5)
            self.mapView.clear()
        }
        
        self.successContainer.isHidden = true
        self.errorContainer.isHidden = true
        self.confirmLocationButton.isHidden = true
        
        UIView.animate(withDuration: 0.25) {
            self.mapViewTopLayoutConstraint?.constant = 10
        }
    }
    
    @objc func handleConfirmAddressButton() {
        
        self.mapView.isHidden = true
        self.confirmLocationButton.isHidden = true
        self.successContainer.isHidden = false
        
    }
    
    @objc func handleWhatsAppButton() {
        //HERE WE ARE SETTING UP ALERTS IN THE USERS WHATSAPP
    }
    
    @objc func handleSMSButton() {
        //HERE WE ARE SETTING UP THROUGHT SMS
    }
    
    //FINAL STEP
    @objc func handleConfirmButton() {
        
        //FROM HERE WE NEED TO GO THROUGH THE LOCATION SCREENS
        let homeVC = HomeViewController()
        let navVC = UINavigationController(rootViewController: homeVC)
        navVC.modalPresentationStyle = .fullScreen
        navigationController?.present(navVC, animated: true)
        
    }
}



