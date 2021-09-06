//
//  ConfirmBookingCollection.swift
//  Project Doggystyle iOS
//
//  Created by Charlie Arcodia on 9/6/21.
//
import Foundation
import UIKit

class ConfirmBookingCollection : UICollectionView, UICollectionViewDelegateFlowLayout, UICollectionViewDataSource, UIScrollViewDelegate, UIGestureRecognizerDelegate, UITextFieldDelegate {
    
    private let confirmBookingCollectionID = "confirmBookingCollectionID"
    private let confirmFooterCollectionID = "confirmFooterCollectionID"

    var confirmBookingController : ConfirmBookingController?
    
    override init(frame: CGRect, collectionViewLayout layout: UICollectionViewLayout) {
        super.init(frame: frame, collectionViewLayout: layout)
        
        self.backgroundColor = coreBackgroundWhite
        self.translatesAutoresizingMaskIntoConstraints = false
        self.dataSource = self
        self.delegate = self
        
        self.isPrefetchingEnabled = false
        self.keyboardDismissMode = UIScrollView.KeyboardDismissMode.interactive
        self.alwaysBounceVertical = true
        self.alwaysBounceHorizontal = false
        self.showsVerticalScrollIndicator = false
        self.showsHorizontalScrollIndicator = false
        self.allowsMultipleSelection = true
        self.canCancelContentTouches = false
        self.contentInsetAdjustmentBehavior = .never
        self.delaysContentTouches = true
        self.contentInset = UIEdgeInsets(top: 180, left: 0, bottom: 0, right: 0)
        
        self.register(ConfirmBookingFeeder.self, forCellWithReuseIdentifier: self.confirmBookingCollectionID)
        self.register(ConfirmBookingFooterFeeder.self, forCellWithReuseIdentifier: self.confirmFooterCollectionID)

    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        return 3
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        switch indexPath.item {
        
        case 0,1 :
            return CGSize(width: UIScreen.main.bounds.width, height: 320)
        default:
            return CGSize(width: UIScreen.main.bounds.width, height: 640)

        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        switch indexPath.item {
        
        case 0,1 :
            
            let cell = self.dequeueReusableCell(withReuseIdentifier: self.confirmBookingCollectionID, for: indexPath) as! ConfirmBookingFeeder
            
            cell.confirmBookingCollection = self
            
            return cell
            
        default:
            
            let cell = self.dequeueReusableCell(withReuseIdentifier: self.confirmFooterCollectionID, for: indexPath) as! ConfirmBookingFooterFeeder
            
            cell.confirmBookingCollection = self
            
            return cell
        
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 10
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 10
    }
    
    @objc func handleNextButton(sender: UIButton) {
        print("handle nect button")
        self.confirmBookingController?.handleEndAptDecisionController()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

class ConfirmBookingFeeder : UICollectionViewCell {
    
    var confirmBookingCollection : ConfirmBookingCollection?
    
    var mainContainer : UIView = {
        
        let adc = UIView()
        adc.translatesAutoresizingMaskIntoConstraints = false
        adc.backgroundColor = coreWhiteColor
        adc.clipsToBounds = false
        adc.layer.masksToBounds = false
        adc.layer.shadowColor = coreBlackColor.withAlphaComponent(0.8).cgColor
        adc.layer.shadowOpacity = 0.05
        adc.layer.shadowOffset = CGSize(width: 2, height: 3)
        adc.layer.shadowRadius = 9
        adc.layer.shouldRasterize = false
        adc.layer.cornerRadius = 15
        
       return adc
    }()
    
    lazy var pencilIcon : UIButton = {
        
        let cbf = UIButton()
        cbf.translatesAutoresizingMaskIntoConstraints = false
        cbf.backgroundColor = .clear
        cbf.contentMode = .scaleAspectFill
        cbf.titleLabel?.font = UIFont.fontAwesome(ofSize: 16, style: .solid)
        cbf.setTitle(String.fontAwesomeIcon(name: .pencilAlt), for: .normal)
        cbf.setTitleColor(coreOrangeColor, for: .normal)
//        cbf.addTarget(self, action: #selector(self.handleBackButton), for: UIControl.Event.touchUpInside)
        return cbf
        
    }()
    
    let profileImageIcon : UIImageView = {
        
        let pii = UIImageView()
        pii.translatesAutoresizingMaskIntoConstraints = false
        pii.isUserInteractionEnabled = false
        pii.contentMode = .scaleAspectFill
        pii.layer.masksToBounds = true
        pii.backgroundColor = dividerGrey
        
       return pii
    }()
    
    let nameLabel : UILabel = {
        
        let nl = UILabel()
        nl.translatesAutoresizingMaskIntoConstraints = false
        nl.backgroundColor = .clear
        nl.text = "Name"
        nl.font = UIFont(name: rubikBold, size: 18)
        nl.textColor = coreBlackColor
        nl.textAlignment = .left
        nl.adjustsFontSizeToFitWidth = true
        
        return nl
    }()
    
    let dateLabel : UILabel = {
        
        let nl = UILabel()
        nl.translatesAutoresizingMaskIntoConstraints = false
        nl.backgroundColor = .clear
        nl.text = "Date:"
        nl.font = UIFont(name: rubikRegular, size: 18)
        nl.textColor = dsGreyMedium
        nl.textAlignment = .left
        nl.adjustsFontSizeToFitWidth = true
        
        return nl
    }()
    
    let finalDateLabel : UILabel = {
        
        let nl = UILabel()
        nl.translatesAutoresizingMaskIntoConstraints = false
        nl.backgroundColor = .clear
        nl.text = "Tuesday Dec 1, 2021"
        nl.font = UIFont(name: rubikRegular, size: 18)
        nl.textColor = coreBlackColor
        nl.textAlignment = .right
        nl.adjustsFontSizeToFitWidth = true
        
        return nl
    }()
    
    let timeLabel : UILabel = {
        
        let nl = UILabel()
        nl.translatesAutoresizingMaskIntoConstraints = false
        nl.backgroundColor = .clear
        nl.text = "Time:"
        nl.font = UIFont(name: rubikRegular, size: 18)
        nl.textColor = dsGreyMedium
        nl.textAlignment = .left
        nl.adjustsFontSizeToFitWidth = true
        
        return nl
    }()
    
    let finalTimeLabel : UILabel = {
        
        let nl = UILabel()
        nl.translatesAutoresizingMaskIntoConstraints = false
        nl.backgroundColor = .clear
        nl.text = "Approx 9:00AM"
        nl.font = UIFont(name: rubikRegular, size: 18)
        nl.textColor = coreBlackColor
        nl.textAlignment = .right
        nl.adjustsFontSizeToFitWidth = true
        
        return nl
    }()
    
    let servicesLabel : UILabel = {
        
        let nl = UILabel()
        nl.translatesAutoresizingMaskIntoConstraints = false
        nl.backgroundColor = .clear
        nl.text = "Services:"
        nl.font = UIFont(name: rubikRegular, size: 18)
        nl.textColor = dsGreyMedium
        nl.textAlignment = .left
        nl.adjustsFontSizeToFitWidth = true
        
        return nl
    }()
    
    let servicesTimeLabel : UILabel = {
        
        let nl = UILabel()
        nl.translatesAutoresizingMaskIntoConstraints = false
        nl.backgroundColor = .clear
        nl.text = " Full package"
        nl.font = UIFont(name: rubikRegular, size: 18)
        nl.textColor = coreBlackColor
        nl.textAlignment = .right
        nl.adjustsFontSizeToFitWidth = true
        
        return nl
    }()
    
    let showAllButton : UIButton = {
        
        let nl = UIButton()
        nl.translatesAutoresizingMaskIntoConstraints = false
        nl.setTitle("Show all", for: .normal)
        nl.titleLabel?.textColor = coreOrangeColor
        nl.tintColor = coreOrangeColor
        nl.titleLabel?.font = UIFont(name: rubikRegular, size: 18)
        nl.titleLabel?.textColor = coreOrangeColor
        
        return nl
    }()
    
    let yourAttributes: [NSAttributedString.Key: Any] = [
        .font: UIFont(name: rubikRegular, size: 18)!,
         .foregroundColor: coreOrangeColor,
         .underlineStyle: NSUnderlineStyle.single.rawValue
     ]
    
    let dogTotalLabel : UILabel = {
        
        let nl = UILabel()
        nl.translatesAutoresizingMaskIntoConstraints = false
        nl.backgroundColor = .clear
        nl.text = "Name Total:"
        nl.font = UIFont(name: rubikRegular, size: 18)
        nl.textColor = dsGreyMedium
        nl.textAlignment = .left
        nl.adjustsFontSizeToFitWidth = true
        
        return nl
    }()
    
    let dogTotalCostLabel : UILabel = {
        
        let nl = UILabel()
        nl.translatesAutoresizingMaskIntoConstraints = false
        nl.backgroundColor = .clear
        nl.text = "$219.00"
        nl.font = UIFont(name: rubikRegular, size: 18)
        nl.textColor = coreBlackColor
        nl.textAlignment = .right
        nl.adjustsFontSizeToFitWidth = true
        
        return nl
    }()
            
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.backgroundColor = coreBackgroundWhite
        self.addViews()
        
        let attributeString = NSMutableAttributedString(
               string: "Show all",
               attributes: yourAttributes
        )
        
        self.showAllButton.setAttributedTitle(attributeString, for: .normal)
        
    }
    
    func addViews() {
        
        self.addSubview(self.mainContainer)
        self.addSubview(self.pencilIcon)
        
        self.addSubview(self.profileImageIcon)
        self.addSubview(self.nameLabel)
        
        self.addSubview(self.dateLabel)
        self.addSubview(self.finalDateLabel)
        
        self.addSubview(self.timeLabel)
        self.addSubview(self.finalTimeLabel)
        
        self.addSubview(self.servicesLabel)
        self.addSubview(self.servicesTimeLabel)

        self.addSubview(self.showAllButton)
        
        self.addSubview(self.dogTotalLabel)
        self.addSubview(self.dogTotalCostLabel)

        self.mainContainer.topAnchor.constraint(equalTo: self.topAnchor, constant: 8).isActive = true
        self.mainContainer.leftAnchor.constraint(equalTo: self.leftAnchor, constant: 30).isActive = true
        self.mainContainer.rightAnchor.constraint(equalTo: self.rightAnchor, constant: -30).isActive = true
        self.mainContainer.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -8).isActive = true
        
        self.pencilIcon.topAnchor.constraint(equalTo: self.mainContainer.topAnchor, constant: 25).isActive = true
        self.pencilIcon.rightAnchor.constraint(equalTo: self.mainContainer.rightAnchor, constant: -20).isActive = true
        self.pencilIcon.heightAnchor.constraint(equalToConstant: 18).isActive = true
        self.pencilIcon.widthAnchor.constraint(equalToConstant: 18).isActive = true
        
        self.profileImageIcon.topAnchor.constraint(equalTo: self.mainContainer.topAnchor, constant: 25).isActive = true
        self.profileImageIcon.leftAnchor.constraint(equalTo: self.mainContainer.leftAnchor, constant: 27).isActive = true
        self.profileImageIcon.heightAnchor.constraint(equalToConstant: 33).isActive = true
        self.profileImageIcon.widthAnchor.constraint(equalToConstant: 33).isActive = true
        self.profileImageIcon.layer.cornerRadius = 33/2
        
        self.nameLabel.leftAnchor.constraint(equalTo: self.profileImageIcon.rightAnchor, constant: 14).isActive = true
        self.nameLabel.centerYAnchor.constraint(equalTo: self.profileImageIcon.centerYAnchor, constant: 0).isActive = true
        self.nameLabel.rightAnchor.constraint(equalTo: self.pencilIcon.leftAnchor, constant: -20).isActive = true
        self.nameLabel.sizeToFit()
        
        self.dateLabel.leftAnchor.constraint(equalTo: self.mainContainer.leftAnchor, constant: 27).isActive = true
        self.dateLabel.topAnchor.constraint(equalTo: self.nameLabel.bottomAnchor, constant: 26).isActive = true
        self.dateLabel.heightAnchor.constraint(equalToConstant: 20).isActive = true
        self.dateLabel.widthAnchor.constraint(equalToConstant: 60).isActive = true
        
        self.finalDateLabel.rightAnchor.constraint(equalTo: self.mainContainer.rightAnchor, constant: -30).isActive = true
        self.finalDateLabel.leftAnchor.constraint(equalTo: self.dateLabel.rightAnchor, constant: 20).isActive = true
        self.finalDateLabel.centerYAnchor.constraint(equalTo: self.dateLabel.centerYAnchor, constant: 0).isActive = true
        self.finalDateLabel.heightAnchor.constraint(equalToConstant: 25).isActive = true
        
        self.timeLabel.leftAnchor.constraint(equalTo: self.mainContainer.leftAnchor, constant: 27).isActive = true
        self.timeLabel.topAnchor.constraint(equalTo: self.dateLabel.bottomAnchor, constant: 26).isActive = true
        self.timeLabel.heightAnchor.constraint(equalToConstant: 20).isActive = true
        self.timeLabel.widthAnchor.constraint(equalToConstant: 60).isActive = true
        
        self.finalTimeLabel.rightAnchor.constraint(equalTo: self.mainContainer.rightAnchor, constant: -30).isActive = true
        self.finalTimeLabel.leftAnchor.constraint(equalTo: self.timeLabel.rightAnchor, constant: 20).isActive = true
        self.finalTimeLabel.centerYAnchor.constraint(equalTo: self.timeLabel.centerYAnchor, constant: 0).isActive = true
        self.finalTimeLabel.heightAnchor.constraint(equalToConstant: 25).isActive = true
        
        self.servicesLabel.leftAnchor.constraint(equalTo: self.mainContainer.leftAnchor, constant: 27).isActive = true
        self.servicesLabel.topAnchor.constraint(equalTo: self.timeLabel.bottomAnchor, constant: 26).isActive = true
        self.servicesLabel.heightAnchor.constraint(equalToConstant: 20).isActive = true
        self.servicesLabel.widthAnchor.constraint(equalToConstant: 85).isActive = true
        
        self.servicesTimeLabel.rightAnchor.constraint(equalTo: self.mainContainer.rightAnchor, constant: -30).isActive = true
        self.servicesTimeLabel.leftAnchor.constraint(equalTo: self.servicesLabel.rightAnchor, constant: 20).isActive = true
        self.servicesTimeLabel.centerYAnchor.constraint(equalTo: self.servicesLabel.centerYAnchor, constant: 0).isActive = true
        self.servicesTimeLabel.heightAnchor.constraint(equalToConstant: 25).isActive = true
        
        self.showAllButton.rightAnchor.constraint(equalTo: self.mainContainer.rightAnchor, constant: -30).isActive = true
        self.showAllButton.topAnchor.constraint(equalTo: self.servicesLabel.bottomAnchor, constant: 11).isActive = true
        self.showAllButton.heightAnchor.constraint(equalToConstant: 25).isActive = true
        self.showAllButton.sizeToFit()
        
        self.dogTotalLabel.leftAnchor.constraint(equalTo: self.mainContainer.leftAnchor, constant: 27).isActive = true
        self.dogTotalLabel.topAnchor.constraint(equalTo: self.showAllButton.bottomAnchor, constant: 26).isActive = true
        self.dogTotalLabel.heightAnchor.constraint(equalToConstant: 20).isActive = true
        self.dogTotalLabel.sizeToFit()
        
        self.dogTotalCostLabel.rightAnchor.constraint(equalTo: self.mainContainer.rightAnchor, constant: -30).isActive = true
        self.dogTotalCostLabel.leftAnchor.constraint(equalTo: self.dogTotalLabel.rightAnchor, constant: 20).isActive = true
        self.dogTotalCostLabel.centerYAnchor.constraint(equalTo: self.dogTotalLabel.centerYAnchor, constant: 0).isActive = true
        self.dogTotalCostLabel.heightAnchor.constraint(equalToConstant: 25).isActive = true
        
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

class ConfirmBookingFooterFeeder : UICollectionViewCell, UITextFieldDelegate {
    
    var confirmBookingCollection : ConfirmBookingCollection?
    
    let addAppointmentsLabel : UILabel = {
        
        let nl = UILabel()
        nl.translatesAutoresizingMaskIntoConstraints = false
        nl.backgroundColor = .clear
        nl.text = "Add appointments to calendar"
        nl.font = UIFont(name: rubikRegular, size: 18)
        nl.textColor = coreBlackColor
        nl.textAlignment = .left
        nl.adjustsFontSizeToFitWidth = true
        
        return nl
    }()
    
    lazy var appointmentsSwitch : UISwitch = {
        
        let bs = UISwitch()
        bs.translatesAutoresizingMaskIntoConstraints = false
        bs.tintColor = UIColor .lightGray
        bs.onTintColor = dsLimegreen
        bs.thumbTintColor = UIColor .white
        bs.setOn(true, animated: false)
        bs.isUserInteractionEnabled = true
        bs.addTarget(self, action: #selector(self.handleToggle), for: .touchUpInside)
        bs.transform = CGAffineTransform(scaleX: 0.75, y: 0.75)
        
        return bs
        
    }()
    
    let paymentMethod : UILabel = {
        
        let nl = UILabel()
        nl.translatesAutoresizingMaskIntoConstraints = false
        nl.backgroundColor = .clear
        nl.text = "Payment Method"
        nl.font = UIFont(name: rubikMedium, size: 21)
        nl.textColor = coreBlackColor
        nl.textAlignment = .left
        nl.adjustsFontSizeToFitWidth = true
        
        return nl
    }()
    
    var creditCardContainer : UIView = {
        
        let adc = UIView()
        adc.translatesAutoresizingMaskIntoConstraints = false
        adc.backgroundColor = coreWhiteColor
        adc.clipsToBounds = false
        adc.layer.masksToBounds = false
        adc.layer.shadowColor = coreBlackColor.withAlphaComponent(0.8).cgColor
        adc.layer.shadowOpacity = 0.05
        adc.layer.shadowOffset = CGSize(width: 2, height: 3)
        adc.layer.shadowRadius = 9
        adc.layer.shouldRasterize = false
        adc.layer.cornerRadius = 15
        
       return adc
    }()
    
    let creditCardLabel : UILabel = {
        
        let nl = UILabel()
        nl.translatesAutoresizingMaskIntoConstraints = false
        nl.backgroundColor = .clear
        nl.text = "Credit Card ending in 5342"
        nl.font = UIFont(name: rubikMedium, size: 16)
        nl.textColor = coreBlackColor
        nl.textAlignment = .left
        nl.numberOfLines = 1
        nl.adjustsFontSizeToFitWidth = true

        return nl
    }()
    
    let importantInfoLabel : UILabel = {
        
        let nl = UILabel()
        nl.translatesAutoresizingMaskIntoConstraints = false
        nl.backgroundColor = .clear
        nl.text = "Important Information"
        nl.font = UIFont(name: rubikMedium, size: 21)
        nl.textColor = coreBlackColor
        nl.textAlignment = .left
        nl.adjustsFontSizeToFitWidth = true
        
        return nl
    }()
    
    let importantInfoSubheader : UILabel = {
        
        let nl = UILabel()
        nl.translatesAutoresizingMaskIntoConstraints = false
        nl.backgroundColor = .clear
        nl.text = "Dematting as a service is up to the doggystylist to determine. They may choose to charge or refund the service at the time of the appointment."
        nl.font = UIFont(name: rubikRegular, size: 16)
        nl.textColor = coreBlackColor
        nl.textAlignment = .left
        nl.numberOfLines = -1
        
        return nl
    }()
    
    let referralCodeLabel : UILabel = {
        
        let nl = UILabel()
        nl.translatesAutoresizingMaskIntoConstraints = false
        nl.backgroundColor = .clear
        nl.text = "Referral Code"
        nl.font = UIFont(name: rubikMedium, size: 21)
        nl.textColor = coreBlackColor
        nl.textAlignment = .left
        nl.adjustsFontSizeToFitWidth = true
        
        return nl
    }()
    
    let referralCodeSubheader : UILabel = {
        
        let nl = UILabel()
        nl.translatesAutoresizingMaskIntoConstraints = false
        nl.backgroundColor = .clear
        nl.text = "Enter it here to get a discount off your first appointment!"
        nl.font = UIFont(name: rubikRegular, size: 16)
        nl.textColor = coreBlackColor
        nl.textAlignment = .left
        nl.numberOfLines = -1

        return nl
    }()
    
    lazy var enterCodeTextField: CustomCardNumberTextField = {
        
        let etfc = CustomCardNumberTextField()
        let placeholder = NSAttributedString(string: "Enter code", attributes: [NSAttributedString.Key.foregroundColor: dsFlatBlack.withAlphaComponent(0.4)])
        etfc.attributedPlaceholder = placeholder
        etfc.translatesAutoresizingMaskIntoConstraints = false
        etfc.textAlignment = .left
        etfc.textColor = coreBlackColor
        etfc.font = UIFont(name: rubikMedium, size: 18)
        etfc.allowsEditingTextAttributes = false
        etfc.autocorrectionType = .no
        etfc.delegate = self
        etfc.backgroundColor = coreWhiteColor
        etfc.keyboardAppearance = UIKeyboardAppearance.light
        etfc.returnKeyType = UIReturnKeyType.done
        etfc.keyboardType = .alphabet
        etfc.layer.masksToBounds = true
        etfc.layer.cornerRadius = 8
        etfc.leftViewMode = .always
        etfc.layer.borderColor = UIColor.clear.cgColor
        etfc.layer.borderWidth = 1
        etfc.leftView = UIView(frame: CGRect(x: 0, y: 0, width: 20, height: 20))
        etfc.clipsToBounds = false
        etfc.layer.masksToBounds = false
        etfc.layer.shadowColor = coreBlackColor.withAlphaComponent(0.8).cgColor
        etfc.layer.shadowOpacity = 0.05
        etfc.layer.shadowOffset = CGSize(width: 2, height: 3)
        etfc.layer.shadowRadius = 9
        etfc.layer.shouldRasterize = false
        etfc.isSecureTextEntry = false
        etfc.setRightPaddingPoints(50)

        return etfc
        
    }()
    
    lazy var nextButton: UIButton = {
        
        let cbf = UIButton(type: .system)
        cbf.translatesAutoresizingMaskIntoConstraints = false
        cbf.setTitle("Next", for: UIControl.State.normal)
        cbf.titleLabel?.font = UIFont.init(name: dsHeaderFont, size: 18)
        cbf.titleLabel?.adjustsFontSizeToFitWidth = true
        cbf.titleLabel?.numberOfLines = 1
        cbf.titleLabel?.adjustsFontForContentSizeCategory = true
        cbf.layer.cornerRadius = 12
        cbf.layer.masksToBounds = true
        cbf.tintColor = coreWhiteColor
        cbf.backgroundColor = coreOrangeColor
        cbf.isHidden = false
        cbf.addTarget(self, action: #selector(self.handleNextButton(sender:)), for: .touchUpInside)
        
        return cbf
        
    }()
    
    lazy var downArrowButton : UIButton = {
        
        let cbf = UIButton()
        cbf.translatesAutoresizingMaskIntoConstraints = false
        cbf.backgroundColor = .clear
        cbf.contentMode = .scaleAspectFill
        cbf.titleLabel?.font = UIFont.fontAwesome(ofSize: 20, style: .solid)
        cbf.setTitle(String.fontAwesomeIcon(name: .chevronDown), for: .normal)
        cbf.setTitleColor(coreBlackColor, for: .normal)
        
        return cbf
        
    }()
    
   
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.backgroundColor = coreBackgroundWhite
        self.addViews()
        
    }
    
    func addViews() {
        
        self.addSubview(self.addAppointmentsLabel)
        self.addSubview(self.appointmentsSwitch)
        self.addSubview(self.paymentMethod)
        self.addSubview(self.creditCardContainer)
        
        self.creditCardContainer.addSubview(self.downArrowButton)
        self.creditCardContainer.addSubview(self.creditCardLabel)
        
        self.addSubview(self.importantInfoLabel)
        self.addSubview(self.importantInfoSubheader)
        self.addSubview(self.referralCodeLabel)
        self.addSubview(self.referralCodeSubheader)
        self.addSubview(self.enterCodeTextField)
        self.addSubview(self.nextButton)

        self.appointmentsSwitch.centerYAnchor.constraint(equalTo: self.addAppointmentsLabel.centerYAnchor, constant: 0).isActive = true
        self.appointmentsSwitch.rightAnchor.constraint(equalTo: self.rightAnchor, constant: -30).isActive = true
        self.appointmentsSwitch.sizeToFit()
        
        self.addAppointmentsLabel.topAnchor.constraint(equalTo: self.topAnchor, constant: 18).isActive = true
        self.addAppointmentsLabel.leftAnchor.constraint(equalTo: self.leftAnchor, constant: 30).isActive = true
        self.addAppointmentsLabel.heightAnchor.constraint(equalToConstant: 20).isActive = true
        self.addAppointmentsLabel.rightAnchor.constraint(equalTo: self.appointmentsSwitch.leftAnchor, constant: -15).isActive = true
        
        self.paymentMethod.topAnchor.constraint(equalTo: self.addAppointmentsLabel.bottomAnchor, constant: 39).isActive = true
        self.paymentMethod.leftAnchor.constraint(equalTo: self.leftAnchor, constant: 30).isActive = true
        self.paymentMethod.heightAnchor.constraint(equalToConstant: 20).isActive = true
        self.paymentMethod.rightAnchor.constraint(equalTo: self.rightAnchor, constant: -30).isActive = true
        
        self.creditCardContainer.topAnchor.constraint(equalTo: self.paymentMethod.bottomAnchor, constant: 20).isActive = true
        self.creditCardContainer.leftAnchor.constraint(equalTo: self.leftAnchor, constant: 30).isActive = true
        self.creditCardContainer.rightAnchor.constraint(equalTo: self.rightAnchor, constant: -30).isActive = true
        self.creditCardContainer.heightAnchor.constraint(equalToConstant: 63).isActive = true
        
        self.downArrowButton.rightAnchor.constraint(equalTo: self.creditCardContainer.rightAnchor, constant: -27).isActive = true
        self.downArrowButton.centerYAnchor.constraint(equalTo: self.creditCardContainer.centerYAnchor, constant: 0).isActive = true
        self.downArrowButton.heightAnchor.constraint(equalToConstant: 16).isActive = true
        self.downArrowButton.widthAnchor.constraint(equalToConstant: 16).isActive = true

        self.creditCardLabel.leftAnchor.constraint(equalTo: self.creditCardContainer.leftAnchor, constant: 27).isActive = true
        self.creditCardLabel.centerYAnchor.constraint(equalTo: self.creditCardContainer.centerYAnchor).isActive = true
        self.creditCardLabel.heightAnchor.constraint(equalToConstant: 25).isActive = true
        self.creditCardLabel.rightAnchor.constraint(equalTo: self.downArrowButton.leftAnchor, constant: -20).isActive = true
        
        self.importantInfoLabel.topAnchor.constraint(equalTo: self.creditCardContainer.bottomAnchor, constant: 30).isActive = true
        self.importantInfoLabel.leftAnchor.constraint(equalTo: self.leftAnchor, constant: 30).isActive = true
        self.importantInfoLabel.heightAnchor.constraint(equalToConstant: 20).isActive = true
        self.importantInfoLabel.rightAnchor.constraint(equalTo: self.rightAnchor, constant: -30).isActive = true
        
        self.importantInfoSubheader.topAnchor.constraint(equalTo: self.importantInfoLabel.bottomAnchor, constant: 30).isActive = true
        self.importantInfoSubheader.leftAnchor.constraint(equalTo: self.leftAnchor, constant: 30).isActive = true
        self.importantInfoSubheader.rightAnchor.constraint(equalTo: self.rightAnchor, constant: -30).isActive = true
        self.importantInfoSubheader.sizeToFit()
        
        self.referralCodeLabel.topAnchor.constraint(equalTo: self.importantInfoSubheader.bottomAnchor, constant: 30).isActive = true
        self.referralCodeLabel.leftAnchor.constraint(equalTo: self.leftAnchor, constant: 30).isActive = true
        self.referralCodeLabel.heightAnchor.constraint(equalToConstant: 20).isActive = true
        self.referralCodeLabel.rightAnchor.constraint(equalTo: self.rightAnchor, constant: -30).isActive = true
        
        self.referralCodeSubheader.topAnchor.constraint(equalTo: self.referralCodeLabel.bottomAnchor, constant: 14).isActive = true
        self.referralCodeSubheader.leftAnchor.constraint(equalTo: self.leftAnchor, constant: 30).isActive = true
        self.referralCodeSubheader.rightAnchor.constraint(equalTo: self.rightAnchor, constant: -30).isActive = true
        self.referralCodeSubheader.sizeToFit()
        
        self.enterCodeTextField.topAnchor.constraint(equalTo: self.referralCodeSubheader.bottomAnchor, constant: 20).isActive = true
        self.enterCodeTextField.leftAnchor.constraint(equalTo: self.leftAnchor, constant: 30).isActive = true
        self.enterCodeTextField.rightAnchor.constraint(equalTo: self.rightAnchor, constant: -30).isActive = true
        self.enterCodeTextField.heightAnchor.constraint(equalToConstant: 70).isActive = true
        
        self.nextButton.topAnchor.constraint(equalTo: self.enterCodeTextField.bottomAnchor, constant: 40).isActive = true
        self.nextButton.leftAnchor.constraint(equalTo: self.leftAnchor, constant: 30).isActive = true
        self.nextButton.rightAnchor.constraint(equalTo: self.rightAnchor, constant: -30).isActive = true
        self.nextButton.heightAnchor.constraint(equalToConstant: 60).isActive = true

    }
    
    @objc func handleNextButton(sender: UIButton) {
        
        self.confirmBookingCollection?.handleNextButton(sender: sender)
        
    }
    
    @objc func handleToggle(sender : UISwitch) {

        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

