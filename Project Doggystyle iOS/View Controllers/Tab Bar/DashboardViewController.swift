//
//  DashboardViewController.swift
//  Project Doggystyle iOS
//
//  Created by Stanley Miller on 6/2/21.
//

import UIKit
import Firebase

final class DashboardViewController: UIViewController {
    private let leftIcon = DSNavButton(imageName: Constants.refurIcon)
    private let rightIcon = DSNavButton(imageName: Constants.bellIcon)
    private let logo = LogoImageView(frame: .zero)
    
    private let appointmentHeader = DSHeaderLabel(title: "Upcoming Appointment", size: 22.0)
    private let serviceHeader = DSHeaderLabel(title: "Service of the Week", size: 22.0)
    
    private let notificationsButton: UIButton = {
        let button = UIButton(type: .system)
        let attrString = NSAttributedString(string: "99", attributes: [NSAttributedString.Key.font : UIFont.poppinsSemiBold(size: 11)])
        button.setAttributedTitle(attrString, for: .normal)
        button.backgroundColor = .dsError
        button.layer.cornerRadius = 10.0
        button.tintColor = .white
        return button
    }()
    
    private let viewAllPetsButton: UIButton = {
        let button = UIButton(type: .system)
        button.setImage(UIImage(named: Constants.dogIcon), for: .normal)
        button.backgroundColor = .dsOrange
        button.tintColor = .white
        button.layer.cornerRadius = 37.0
        button.addTarget(self, action: #selector(didTapAll), for: .touchUpInside)
        return button
    }()
    
    private let viewAllLabel: UILabel = {
        let label = UILabel(frame: .zero)
        label.text = "All"
        label.font = UIFont.poppinsBold(size: 16)
        label.textColor = .dsOrange
        return label
    }()
    
    private let appointmentContainer: UIView = {
        let view = UIView(frame: .zero)
        view.backgroundColor = .white
        view.layer.cornerRadius = 20.0
        view.layer.shadowOpacity = 1
        view.layer.shadowOffset = CGSize(width: 0, height: 4)
        view.layer.shadowRadius = 8
        view.layer.shadowColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.10).cgColor
        return view
    }()
    
    private let servicesContainer: UIView = {
        let view = UIView(frame: .zero)
        view.backgroundColor = .white
        view.layer.cornerRadius = 20.0
        view.layer.shadowOpacity = 1
        view.layer.shadowOffset = CGSize(width: 0, height: 4)
        view.layer.shadowRadius = 8
        view.layer.shadowColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.10).cgColor
        return view
    }()
    
    private let viewAllAppointmentsButton: UIButton = {
        let button = UIButton(type: .system)
        let attrString = NSAttributedString(string: "View all", attributes: [NSAttributedString.Key.font : UIFont.poppinsSemiBold(size: 18.0)])
        button.setAttributedTitle(attrString, for: .normal)
        button.backgroundColor = .clear
        button.tintColor = .dsGray
        button.setTitle("View all", for: .normal)
        button.addTarget(self, action: #selector(didTapViewAllAppointments), for: .touchUpInside)
        return button
    }()
    
    private let viewAllServicesButton: UIButton = {
        let button = UIButton(type: .system)
        let attrString = NSAttributedString(string: "View all", attributes: [NSAttributedString.Key.font : UIFont.poppinsSemiBold(size: 18.0)])
        button.setAttributedTitle(attrString, for: .normal)
        button.backgroundColor = .clear
        button.tintColor = .dsGray
        button.setTitle("View all", for: .normal)
        button.addTarget(self, action: #selector(didTapViewAllServices), for: .touchUpInside)
        return button
    }()
    
    private let package = Package.examplePackage
    
    override func viewDidLoad() {
        self.configureVC()
        self.addNavViews()
        self.addViewAllPetsView()
        self.addAppointmentViews()
        self.addServiceViews()
    }
}

//MARK: - Configure View Controller
extension DashboardViewController {
    private func configureVC() {
        self.view.backgroundColor = .dsViewBackground
    }
}


//MARK: - Configure Views
extension DashboardViewController {
    private func addNavViews() {
        self.view.addSubview(logo)
        logo.topToSuperview(offset: 26, usingSafeArea: true)
        logo.centerX(to: view)
        
        self.view.addSubview(leftIcon)
        leftIcon.rightToLeft(of: logo, offset: -70)
        leftIcon.topToSuperview(offset: 14, usingSafeArea: true)
        
        self.view.addSubview(rightIcon)
        rightIcon.leftToRight(of: logo, offset: 70)
        rightIcon.top(to: leftIcon)
        
        rightIcon.addSubview(notificationsButton)
        notificationsButton.height(20)
        notificationsButton.width(20)
        notificationsButton.top(to: rightIcon, offset: 4)
        notificationsButton.right(to: rightIcon, offset: -4)
    }
    
    private func addViewAllPetsView() {
        self.view.addSubview(viewAllPetsButton)
        viewAllPetsButton.topToBottom(of: leftIcon, offset: 24)
        viewAllPetsButton.height(74)
        viewAllPetsButton.width(74)
        viewAllPetsButton.left(to: leftIcon, offset: 8)
        
        self.view.addSubview(viewAllLabel)
        viewAllLabel.centerX(to: viewAllPetsButton)
        viewAllLabel.topToBottom(of: viewAllPetsButton, offset: 6)
    }
    
    private func addPetCollectionView() {
        
    }
    
    private func addAppointmentViews() {
        self.view.addSubview(appointmentHeader)
        appointmentHeader.left(to: viewAllPetsButton)
        appointmentHeader.topToBottom(of: viewAllLabel, offset: 16)
        
        self.view.addSubview(appointmentContainer)
        appointmentContainer.topToBottom(of: appointmentHeader, offset: 10.0)
        appointmentContainer.left(to: viewAllPetsButton)
        appointmentContainer.height(152)
        appointmentContainer.right(to: notificationsButton)
        
        self.view.addSubview(viewAllAppointmentsButton)
        viewAllAppointmentsButton.centerX(to: appointmentContainer)
        viewAllAppointmentsButton.topToBottom(of: appointmentContainer, offset: 6.0)
        viewAllAppointmentsButton.width(150)
    }
    
    private func addServiceViews() {
        self.view.addSubview(serviceHeader)
        serviceHeader.topToBottom(of: viewAllAppointmentsButton, offset: 20.0)
        serviceHeader.left(to: appointmentHeader)
        
        self.view.addSubview(servicesContainer)
        servicesContainer.topToBottom(of: serviceHeader, offset: 10.0)
        servicesContainer.left(to: appointmentContainer)
        servicesContainer.right(to: appointmentContainer)
        servicesContainer.height(152)
        
        self.view.addSubview(viewAllServicesButton)
        viewAllServicesButton.centerX(to: servicesContainer)
        viewAllServicesButton.topToBottom(of: servicesContainer, offset: 6.0)
        viewAllServicesButton.width(150)
        
        let serviceView = ServiceOfTheWeekView(package: package)
        servicesContainer.addSubview(serviceView)
        serviceView.edgesToSuperview()
    }
}

//MARK: - @objc Functions
extension DashboardViewController {
    @objc private func didTapAll() {
        print(#function)
    }
    
    @objc private func didTapViewAllAppointments() {
        print(#function)
    }
    
    @objc private func didTapViewAllServices() {
        print(#function)
    }
}
