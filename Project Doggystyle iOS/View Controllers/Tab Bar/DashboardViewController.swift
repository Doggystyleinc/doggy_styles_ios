//
//  DashboardViewController.swift
//  Project Doggystyle iOS
//
//  Created by Stanley Miller on 6/2/21.
//

import UIKit
import Firebase
import SDWebImage

//TODO: - Initialize this view with a user object or fetch on viewDidLoad

final class DashboardViewController: UIViewController {
    var homeController: HomeViewController?
    private let package = Package.examplePackage
    private let pets: [Pet] = [Pet.allPets, Pet.petOne, Pet.petTwo, Pet.petThree, Pet.petFour]
    private let appointment = Appointment.exampleAppointment
    
    private let logo = LogoImageView(frame: .zero)
    
    private let appointmentHeader = DSBoldLabel(title: "Upcoming Appointment", size: 22.0)
    private let serviceHeader = DSBoldLabel(title: "Service of the Week", size: 22.0)
    
    private let appointmentContainer = DSContainerView(frame: .zero)
    private let servicesContainer = DSContainerView(frame: .zero)
    
    private let petCollectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.itemSize = CGSize(width: 74, height: 74)
        layout.scrollDirection = .horizontal
        layout.sectionInset = UIEdgeInsets(top: 0, left: 16, bottom: 0, right: 16)
        
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.register(PetCollectionViewCell.self, forCellWithReuseIdentifier: PetCollectionViewCell.reuseIdentifier)
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.backgroundColor = .dsViewBackground
        return collectionView
    }()
    
    private let notificationsButton: UIButton = {
        let button = UIButton(type: .system)
        let attrString = NSAttributedString(string: "99", attributes: [NSAttributedString.Key.font : UIFont.poppinsSemiBold(size: 11)])
        button.setAttributedTitle(attrString, for: .normal)
        button.backgroundColor = .dsError
        button.layer.cornerRadius = 10.0
        button.tintColor = .white
        return button
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
    
    private let editAppointmentButton: UIButton = {
        let button = UIButton(type: .system)
        button.setImage(UIImage(named: Constants.editIcon)?.withRenderingMode(.alwaysOriginal), for: .normal)
        return button
    }()
    
    private lazy var appointmentDate = DSSemiBoldLabel(title: appointment.date, size: 15)
    private lazy var appointmentTime = DSSemiBoldLabel(title: appointment.time, size: 15)
    private lazy var appointmentCycle = DSRegularLabel(title: "\(appointment.cycle) week cycle", size: 12)
    
    
    override func viewDidLoad() {
        self.configureVC()
        self.addNavViews()
        self.addPetCollectionView()
        self.addAppointmentViews()
        self.addServiceViews()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        Service.shared.fetchCurrentUser()
    }
}

//MARK: - Configure View Controller
extension DashboardViewController {
    private func configureVC() {
        self.navigationController?.navigationBar.isHidden = false
        self.view.backgroundColor = .dsViewBackground
        self.petCollectionView.dataSource = self
        self.petCollectionView.delegate = self
    }
}


//MARK: - Configure Views
extension DashboardViewController {
    private func addNavViews() {
        self.navigationItem.titleView = logo
        
        let leftBarImage = UIImage(named: Constants.refurNavIcon)?.withRenderingMode(.alwaysOriginal)
        navigationItem.leftBarButtonItem = UIBarButtonItem(image: leftBarImage, landscapeImagePhone: nil, style: .plain, target: self, action: #selector(didTapRefur))
        
        let rightBarImage = UIImage(named: Constants.bellIcon)?.withRenderingMode(.alwaysOriginal)
        navigationItem.rightBarButtonItem = UIBarButtonItem(image: rightBarImage, landscapeImagePhone: nil, style: .plain, target: self, action: #selector(didTapNotification))
    }
    
    private func addPetCollectionView() {
        self.view.addSubview(petCollectionView)
        petCollectionView.topToSuperview(offset: 4, usingSafeArea: true)
        petCollectionView.left(to: view, offset: 2)
        petCollectionView.height(120)
        petCollectionView.right(to: view, offset: -2)
    }
    
    private func addAppointmentViews() {
        self.view.addSubview(appointmentHeader)
        appointmentHeader.left(to: view, offset: 30.0)
        appointmentHeader.right(to: view, offset: -30.0)
        appointmentHeader.topToBottom(of: petCollectionView, offset: 24)
        
        self.view.addSubview(appointmentContainer)
        appointmentContainer.topToBottom(of: appointmentHeader, offset: 10.0)
        appointmentContainer.left(to: appointmentHeader)
        appointmentContainer.height(152)
        appointmentContainer.right(to: appointmentHeader)
        
        //Move this once we decided if numberOfPets > 2
        let imageViewOne = UIImageView(frame: .zero)
        imageViewOne.sd_setImage(with: URL(string: pets[1].imageURL), placeholderImage: UIImage(named: Constants.petProfilePlaceholder), options: .continueInBackground, context: nil)
        imageViewOne.contentMode = .scaleToFill
        imageViewOne.clipsToBounds = true
        imageViewOne.layer.cornerRadius = 23
        
        self.appointmentContainer.addSubview(imageViewOne)
        imageViewOne.height(46)
        imageViewOne.width(46)
        imageViewOne.top(to: appointmentContainer, offset: 20)
        imageViewOne.left(to: appointmentContainer, offset: 20)
        
        //Must check if user numberOfPets > 2 before displaying this
        let imageViewTwo = UIImageView(frame: .zero)
        imageViewTwo.sd_setImage(with: URL(string: pets[2].imageURL), placeholderImage: UIImage(named: Constants.petProfilePlaceholder), options: .continueInBackground, context: nil)
        imageViewTwo.contentMode = .scaleToFill
        imageViewTwo.clipsToBounds = true
        imageViewTwo.layer.cornerRadius = 23
        
        self.appointmentContainer.addSubview(imageViewTwo)
        imageViewTwo.height(46)
        imageViewTwo.width(46)
        imageViewTwo.top(to: imageViewOne)
        imageViewTwo.leftToRight(of: imageViewOne, offset: 10)
        
        self.appointmentContainer.addSubview(editAppointmentButton)
        editAppointmentButton.top(to: imageViewOne)
        editAppointmentButton.right(to: appointmentContainer, offset: -20)
        editAppointmentButton.height(38)
        editAppointmentButton.width(38)
        
        self.appointmentContainer.addSubview(appointmentDate)
        appointmentDate.topToBottom(of: imageViewOne, offset: 12)
        appointmentDate.left(to: imageViewOne)
        
        self.appointmentContainer.addSubview(appointmentTime)
        appointmentTime.top(to: appointmentDate)
        appointmentTime.right(to: editAppointmentButton)
        
        self.appointmentContainer.addSubview(appointmentCycle)
        appointmentCycle.left(to: appointmentDate)
        appointmentCycle.topToBottom(of: appointmentDate, offset: 5)
        
        self.view.addSubview(viewAllAppointmentsButton)
        viewAllAppointmentsButton.centerX(to: appointmentContainer)
        viewAllAppointmentsButton.topToBottom(of: appointmentContainer, offset: 2.0)
        viewAllAppointmentsButton.width(150)
    }
    
    private func addServiceViews() {
        self.view.addSubview(serviceHeader)
        serviceHeader.topToBottom(of: viewAllAppointmentsButton, offset: 12.0)
        serviceHeader.left(to: appointmentHeader)
        
        self.view.addSubview(servicesContainer)
        servicesContainer.topToBottom(of: serviceHeader, offset: 10.0)
        servicesContainer.left(to: appointmentContainer)
        servicesContainer.right(to: appointmentContainer)
        servicesContainer.height(152)
        
        self.view.addSubview(viewAllServicesButton)
        viewAllServicesButton.centerX(to: servicesContainer)
        viewAllServicesButton.topToBottom(of: servicesContainer, offset: 2.0)
        viewAllServicesButton.width(150)
        
        let serviceView = ServiceOfTheWeekView(package: package)
        servicesContainer.addSubview(serviceView)
        serviceView.edgesToSuperview()
    }
}

//MARK: - @objc Functions
extension DashboardViewController {
    @objc private func didTapRefur() {
        let refurVC = RefurAFriendController()
        self.present(refurVC, animated: true)
    }
    
    @objc private func didTapNotification() {
        let notificationVC = NotificationController()
        self.present(notificationVC, animated: true)
    }
    
    @objc private func didTapAll() {
        print(#function)
    }
    
    @objc private func didTapViewAllAppointments() {
        homeController?.switchTabs(tabIndex: 2)
    }
    
    @objc private func didTapViewAllServices() {
        homeController?.switchTabs(tabIndex: 1)
    }
}

//MARK: - CollectionView DataSource & Delegate
extension DashboardViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return pets.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: PetCollectionViewCell.reuseIdentifier, for: indexPath) as! PetCollectionViewCell
        let pet = pets[indexPath.row]
        cell.configure(with: pet)
        return cell
    }
    
    
}
