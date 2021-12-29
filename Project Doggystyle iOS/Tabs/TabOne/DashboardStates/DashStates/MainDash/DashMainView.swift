//
//  DashMainView.swift
//  Project Doggystyle iOS
//
//  Created by Charlie Arcodia on 8/1/21.
//

import Foundation
import UIKit

class DashMainView : UIView {
    
    var dashboardController : DashboardViewController?,
        locationFoundState : Bool = true
    
    lazy var registeredPetCollection : RegisteredPetCollection = {
        
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        let rpc = RegisteredPetCollection(frame: .zero, collectionViewLayout: layout)
        rpc.dashMainView = self
        
        return rpc
    }()
    
    lazy var mainDashCollectionView : MainDashboardCollectionView = {
        
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        let rpc = MainDashboardCollectionView(frame: .zero, collectionViewLayout: layout)
        rpc.dashMainView = self
        
        return rpc
    }()
    
    lazy var selectorSwitch : SelectorSwitch = {
        
        let ss = SelectorSwitch()
        ss.translatesAutoresizingMaskIntoConstraints = false
        return ss
        
    }()
    
    lazy var bookNowButton: UIButton = {
        
        let cbf = UIButton(type: .system)
        cbf.translatesAutoresizingMaskIntoConstraints = false
        cbf.titleLabel?.adjustsFontSizeToFitWidth = true
        cbf.titleLabel?.numberOfLines = 1
        cbf.titleLabel?.adjustsFontForContentSizeCategory = true
        cbf.layer.cornerRadius = 18
        cbf.layer.masksToBounds = true
        cbf.tintColor = coreWhiteColor
        cbf.backgroundColor = coreOrangeColor
        cbf.layer.masksToBounds = false
        cbf.tintColor = coreWhiteColor
        cbf.layer.shadowColor = coreBlackColor.withAlphaComponent(0.8).cgColor
        cbf.layer.shadowOpacity = 0.2
        cbf.layer.shadowOffset = CGSize(width: 2, height: 3)
        cbf.layer.shadowRadius = 4
        cbf.layer.shouldRasterize = false
        
        let str = String.fontAwesomeIcon(name: .calendarPlus) + "   Book now"
        let attributedStr = NSMutableAttributedString(string: str)
        
        let range1 = NSRange(location: 0, length: 1)
        attributedStr.addAttribute(.font,
                                   value: UIFont.fontAwesome(ofSize: 18, style: .solid),
                                   range: range1)
        
        let range2 = NSRange(location: 1, length: (str as NSString).length - 1)
        attributedStr.addAttribute(.font,
                                   value: UIFont(name: dsHeaderFont, size: 18)!,
                                   range: range2)
        
        cbf.setAttributedTitle(attributedStr, for: .normal)
        cbf.addTarget(self, action: #selector(self.handleBookingController), for: .touchUpInside)
        cbf.isHidden = true
        cbf.alpha = 0
        return cbf
        
    }()
    
    let welcomeSubContainer : UIView = {
        
        let wc = UIView()
        wc.translatesAutoresizingMaskIntoConstraints = false
        wc.backgroundColor = coreWhiteColor
        wc.isUserInteractionEnabled = true
        wc.layer.masksToBounds = true
        wc.layer.cornerRadius = 20
        wc.clipsToBounds = false
        wc.layer.masksToBounds = false
        wc.layer.shadowColor = coreBlackColor.withAlphaComponent(0.8).cgColor
        wc.layer.shadowOpacity = 0.05
        wc.layer.shadowOffset = CGSize(width: 2, height: 3)
        wc.layer.shadowRadius = 9
        wc.layer.shouldRasterize = false
        return wc
        
    }()
    
    let headerLabelEmptyStateOne : UILabel = {
        
        let hl = UILabel()
        hl.translatesAutoresizingMaskIntoConstraints = false
        hl.backgroundColor = .clear
        hl.text = "Want Doggystyle in your neighborhood sooner?"
        hl.font = UIFont(name: dsSubHeaderFont, size: 18)
        hl.numberOfLines = 2
        hl.adjustsFontSizeToFitWidth = true
        hl.textAlignment = .left
        hl.textColor = coreBlackColor
        hl.textAlignment = .center
        
        return hl
    }()
    
    lazy var refurFriendButton : UIButton = {
        
        let cbf = UIButton(type: .system)
        cbf.translatesAutoresizingMaskIntoConstraints = false
        cbf.setTitle("Re-fur a friend", for: UIControl.State.normal)
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
        cbf.addTarget(self.dashboardController, action: #selector(self.dashboardController?.handleReferralProgram), for: UIControl.Event.touchUpInside)
        
        return cbf
        
    }()
   
    let vehicleImage : UIImageView = {
        
        let vi = UIImageView()
        vi.translatesAutoresizingMaskIntoConstraints = false
        vi.backgroundColor = .clear
        vi.contentMode = .scaleAspectFit
        vi.isUserInteractionEnabled = false
        let image = UIImage(named: "vehicle_image")?.withRenderingMode(.alwaysOriginal)
        vi.image = image
        
        return vi
    }()
    
    let tourTruckContainer : UIView = {
        
        let wc = UIView()
        wc.translatesAutoresizingMaskIntoConstraints = false
        wc.backgroundColor = coreWhiteColor
        wc.isUserInteractionEnabled = true
        wc.layer.masksToBounds = true
        wc.layer.cornerRadius = 20
        wc.clipsToBounds = false
        wc.layer.masksToBounds = false
        wc.layer.shadowColor = coreBlackColor.withAlphaComponent(0.8).cgColor
        wc.layer.shadowOpacity = 0.05
        wc.layer.shadowOffset = CGSize(width: 2, height: 3)
        wc.layer.shadowRadius = 9
        wc.layer.shouldRasterize = false
        return wc
        
    }()
    
    let tourTruckLabelEmptyStateOne : UILabel = {
        
        let hl = UILabel()
        hl.translatesAutoresizingMaskIntoConstraints = false
        hl.backgroundColor = .clear
        hl.text = "New to Doggystyle?"
        hl.font = UIFont(name: dsSubHeaderFont, size: 18)
        hl.numberOfLines = 2
        hl.adjustsFontSizeToFitWidth = true
        hl.textAlignment = .left
        hl.textColor = coreBlackColor
        hl.textAlignment = .center
        
        return hl
    }()
    
    lazy var tourTruckButton : UIButton = {
        
        let cbf = UIButton(type: .system)
        cbf.translatesAutoresizingMaskIntoConstraints = false
        cbf.setTitle("  Tour the doggystyle truck!  ", for: UIControl.State.normal)
        cbf.titleLabel?.font = UIFont.init(name: dsHeaderFont, size: 16)
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
        cbf.addTarget(self.dashboardController, action: #selector(self.dashboardController?.handleTourTruckButton), for: UIControl.Event.touchUpInside)
        
        return cbf
        
    }()
   
    let dogImage : UIImageView = {
        
        let vi = UIImageView()
        vi.translatesAutoresizingMaskIntoConstraints = false
        vi.backgroundColor = .clear
        vi.contentMode = .scaleAspectFit
        vi.isUserInteractionEnabled = false
        let image = UIImage(named: "doggy_empty_state_two")?.withRenderingMode(.alwaysOriginal)
        vi.image = image
        
        return vi
    }()
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.backgroundColor = .clear
        self.translatesAutoresizingMaskIntoConstraints = false
        self.addViews()
        
    }
    
    func addViews() {
        
        self.addSubview(self.registeredPetCollection)
        self.addSubview(self.selectorSwitch)
        self.addSubview(self.mainDashCollectionView)
        self.addSubview(self.bookNowButton)
        
        //SUBCONTAINER
        self.addSubview(self.welcomeSubContainer)
        self.welcomeSubContainer.addSubview(self.headerLabelEmptyStateOne)
        self.welcomeSubContainer.addSubview(self.refurFriendButton)
        self.welcomeSubContainer.addSubview(self.vehicleImage)
        
        //SECOND SUBCONTAINER
        self.addSubview(self.tourTruckContainer)
        self.tourTruckContainer.addSubview(self.tourTruckLabelEmptyStateOne)
        self.tourTruckContainer.addSubview(self.tourTruckButton)
        self.tourTruckContainer.addSubview(self.dogImage)
       
        self.registeredPetCollection.topAnchor.constraint(equalTo: self.topAnchor, constant: 0).isActive = true
        self.registeredPetCollection.leftAnchor.constraint(equalTo: self.leftAnchor).isActive = true
        self.registeredPetCollection.rightAnchor.constraint(equalTo: self.rightAnchor).isActive = true
        self.registeredPetCollection.heightAnchor.constraint(equalToConstant: 120).isActive = true
        
        self.selectorSwitch.topAnchor.constraint(equalTo: self.registeredPetCollection.bottomAnchor, constant: 15).isActive = true
        self.selectorSwitch.leftAnchor.constraint(equalTo: self.leftAnchor, constant: 30).isActive = true
        self.selectorSwitch.rightAnchor.constraint(equalTo: self.rightAnchor, constant: -30).isActive = true
        self.selectorSwitch.heightAnchor.constraint(equalToConstant: 32).isActive = true
        
        self.mainDashCollectionView.topAnchor.constraint(equalTo: self.selectorSwitch.bottomAnchor, constant: 8).isActive = true
        self.mainDashCollectionView.leftAnchor.constraint(equalTo: self.leftAnchor, constant: 0).isActive = true
        self.mainDashCollectionView.rightAnchor.constraint(equalTo: self.rightAnchor, constant: 0).isActive = true
        self.mainDashCollectionView.bottomAnchor.constraint(equalTo: self.safeAreaLayoutGuide.bottomAnchor, constant: 0).isActive = true
        
        self.bookNowButton.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -110).isActive = true
        self.bookNowButton.leftAnchor.constraint(equalTo: self.leftAnchor, constant: 30).isActive = true
        self.bookNowButton.rightAnchor.constraint(equalTo: self.rightAnchor, constant: -30).isActive = true
        self.bookNowButton.heightAnchor.constraint(equalToConstant: 60).isActive = true
        
        //SUBCONTAINER
        self.welcomeSubContainer.topAnchor.constraint(equalTo: self.registeredPetCollection.bottomAnchor, constant: 15).isActive = true
        self.welcomeSubContainer.leftAnchor.constraint(equalTo: self.leftAnchor, constant: 30).isActive = true
        self.welcomeSubContainer.rightAnchor.constraint(equalTo: self.rightAnchor, constant: -30).isActive = true
        self.welcomeSubContainer.heightAnchor.constraint(equalToConstant: 334).isActive = true
        
        self.headerLabelEmptyStateOne.topAnchor.constraint(equalTo: self.welcomeSubContainer.topAnchor, constant: 30).isActive = true
        self.headerLabelEmptyStateOne.leftAnchor.constraint(equalTo: self.welcomeSubContainer.leftAnchor, constant: 40).isActive = true
        self.headerLabelEmptyStateOne.rightAnchor.constraint(equalTo: self.welcomeSubContainer.rightAnchor, constant: -40).isActive = true
        self.headerLabelEmptyStateOne.heightAnchor.constraint(equalToConstant: 45).isActive = true
        
        self.refurFriendButton.bottomAnchor.constraint(equalTo: self.welcomeSubContainer.bottomAnchor, constant: -20).isActive = true
        self.refurFriendButton.leftAnchor.constraint(equalTo: self.welcomeSubContainer.leftAnchor, constant: 30).isActive = true
        self.refurFriendButton.rightAnchor.constraint(equalTo: self.welcomeSubContainer.rightAnchor, constant: -30).isActive = true
        self.refurFriendButton.heightAnchor.constraint(equalToConstant: 60).isActive = true
        
        self.vehicleImage.bottomAnchor.constraint(equalTo: self.refurFriendButton.topAnchor, constant: -8).isActive = true
        self.vehicleImage.leftAnchor.constraint(equalTo: self.welcomeSubContainer.leftAnchor, constant: 18).isActive = true
        self.vehicleImage.rightAnchor.constraint(equalTo: self.welcomeSubContainer.rightAnchor, constant: -18).isActive = true
        self.vehicleImage.topAnchor.constraint(equalTo: self.headerLabelEmptyStateOne.bottomAnchor, constant: 8).isActive = true
        
        //SECOND SUBCONTAINER
        self.tourTruckContainer.topAnchor.constraint(equalTo: self.registeredPetCollection.bottomAnchor, constant: 15).isActive = true
        self.tourTruckContainer.leftAnchor.constraint(equalTo: self.leftAnchor, constant: 30).isActive = true
        self.tourTruckContainer.rightAnchor.constraint(equalTo: self.rightAnchor, constant: -30).isActive = true
        self.tourTruckContainer.heightAnchor.constraint(equalToConstant: 334).isActive = true
        
        self.tourTruckLabelEmptyStateOne.topAnchor.constraint(equalTo: self.tourTruckContainer.topAnchor, constant: 30).isActive = true
        self.tourTruckLabelEmptyStateOne.leftAnchor.constraint(equalTo: self.tourTruckContainer.leftAnchor, constant: 40).isActive = true
        self.tourTruckLabelEmptyStateOne.rightAnchor.constraint(equalTo: self.tourTruckContainer.rightAnchor, constant: -40).isActive = true
        self.tourTruckLabelEmptyStateOne.heightAnchor.constraint(equalToConstant: 45).isActive = true
        
        self.tourTruckButton.bottomAnchor.constraint(equalTo: self.tourTruckContainer.bottomAnchor, constant: -20).isActive = true
        self.tourTruckButton.leftAnchor.constraint(equalTo: self.tourTruckContainer.leftAnchor, constant: 30).isActive = true
        self.tourTruckButton.rightAnchor.constraint(equalTo: self.tourTruckContainer.rightAnchor, constant: -30).isActive = true
        self.tourTruckButton.heightAnchor.constraint(equalToConstant: 60).isActive = true
        
        self.dogImage.bottomAnchor.constraint(equalTo: self.tourTruckButton.topAnchor, constant: -8).isActive = true
        self.dogImage.leftAnchor.constraint(equalTo: self.tourTruckContainer.leftAnchor, constant: 18).isActive = true
        self.dogImage.rightAnchor.constraint(equalTo: self.tourTruckContainer.rightAnchor, constant: -18).isActive = true
        self.dogImage.topAnchor.constraint(equalTo: self.tourTruckLabelEmptyStateOne.bottomAnchor, constant: 8).isActive = true
        
    }
    
    func runScreenChange() {
        
        if self.locationFoundState == true {
            self.selectorSwitch.isHidden = false
            self.bookNowButton.isHidden = false
            self.welcomeSubContainer.isHidden = true
            self.tourTruckContainer.isHidden = false
        } else {
            self.selectorSwitch.isHidden = true
            self.bookNowButton.isHidden = true
            self.welcomeSubContainer.isHidden = false
            self.tourTruckContainer.isHidden = true

        }
    }
    
    @objc func handleBookingController() {
        
        print("UNCOMMENT WHEN BOOKING IS LIVE")

//        self.dashboardController?.presentAppointmentsController()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
