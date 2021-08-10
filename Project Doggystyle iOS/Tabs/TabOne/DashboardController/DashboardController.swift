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

final class DashboardViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource {
    
    
    var observingRefOne = Database.database().reference(),
        handleOne = DatabaseHandle(),
        childCounter : Int = 0,
        homeController: HomeViewController?
        
    private let package = Package.examplePackage
    private let databaseRef = Database.database().reference()
    private let pets: [Pet] = [Pet.allPets, Pet.petOne, Pet.petTwo, Pet.petThree, Pet.petFour]
    private let appointment = Appointment.exampleAppointment
    
    private let logo = LogoImageView(frame: .zero)
    private let appointmentHeader = DSBoldLabel(title: "Upcoming Appointment", size: 22.0)
    private let serviceHeader = DSBoldLabel(title: "Service of the Week", size: 22.0)
    private let appointmentContainer = DSContainerView(frame: .zero)
    private let servicesContainer = DSContainerView(frame: .zero)
    
    var doggyProfileDataSource = [DoggyProfileDataSource]()
    
    lazy var referButton : UIButton = {
        
        let cbf = UIButton(type: .system)
        cbf.translatesAutoresizingMaskIntoConstraints = false
        cbf.backgroundColor = .clear
        cbf.tintColor = UIColor.dsOrange
        cbf.contentMode = .scaleAspectFill
        let image = UIImage(named: "ReFur Icon")?.withRenderingMode(.alwaysOriginal)
        cbf.setImage(image, for: .normal)
        cbf.addTarget(self, action: #selector(self.didTapRefur), for: UIControl.Event.touchUpInside)
        cbf.clipsToBounds = false
        cbf.layer.masksToBounds = false
        cbf.layer.shadowColor = UIColor.black.cgColor
        cbf.layer.shadowOpacity = 0.1
        cbf.layer.shadowOffset = CGSize(width: 2, height: 3)
        cbf.layer.shadowRadius = 9
        cbf.layer.shouldRasterize = false
        return cbf
        
    }()
    
    lazy var notificationIcon : UIButton = {
        
        let dcl = UIButton(type: .system)
        dcl.translatesAutoresizingMaskIntoConstraints = false
        dcl.backgroundColor = .clear
        dcl.contentMode = .scaleAspectFit
        dcl.isUserInteractionEnabled = true
        dcl.clipsToBounds = false
        dcl.titleLabel?.font = UIFont.fontAwesome(ofSize: 20, style: .solid)
        dcl.setTitle(String.fontAwesomeIcon(name: .bell), for: .normal)
        dcl.tintColor = dividerGrey
        dcl.addTarget(self, action: #selector(self.handleNotificationsController), for: .touchUpInside)
        
        return dcl
    }()
    
    let notificationBubble : UILabel = {
        
        let nb = UILabel()
        nb.backgroundColor = UIColor.red
        nb.translatesAutoresizingMaskIntoConstraints = false
        nb.isUserInteractionEnabled = false
        nb.layer.masksToBounds = true
        nb.font = UIFont(name: dsHeaderFont, size: 11)
        nb.textAlignment = .center
        nb.layer.borderColor = coreWhiteColor.cgColor
        nb.layer.borderWidth = 1.5
        nb.text = "1"
        nb.textColor = coreWhiteColor
        
       return nb
    }()
    
    let dsCompanyLogoImage : UIImageView = {
        
        let dcl = UIImageView()
        dcl.translatesAutoresizingMaskIntoConstraints = false
        dcl.backgroundColor = .clear
        dcl.contentMode = .scaleAspectFit
        dcl.isUserInteractionEnabled = false
        let image = UIImage(named: Constants.dsLogo)?.withRenderingMode(.alwaysOriginal)
        dcl.image = image
        
        return dcl
    }()
    
    let headerLabel : UILabel = {
        
        let hl = UILabel()
        hl.translatesAutoresizingMaskIntoConstraints = false
        hl.backgroundColor = .clear
        hl.text = "Welcome"
        hl.font = UIFont(name: dsHeaderFont, size: 24)
        hl.numberOfLines = 1
        hl.adjustsFontSizeToFitWidth = true
        hl.textAlignment = .left
        
       return hl
    }()
   
    lazy var emptyStateOne : EmptyStateOne = {
        
        let eso = EmptyStateOne(frame: .zero)
        eso.dashboardController = self
        
       return eso
        
    }()
    
    lazy var emptyStateTwo : EmptyStateTwo = {
        
        let eso = EmptyStateTwo(frame: .zero)
        eso.dashboardController = self
        
       return eso
        
    }()
    
    lazy var dashMainView : DashMainView = {
        
        let eso = DashMainView(frame: .zero)
        eso.dashboardController = self
        
       return eso
        
    }()
    
    lazy var todaysDashView : TodaysDashView = {
        
        let eso = TodaysDashView(frame: .zero)
        eso.dashboardController = self
        
       return eso
        
    }()
  
    override func viewDidLoad() {
        
        self.navigationController?.navigationBar.isHidden = false
        self.view.backgroundColor = .dsViewBackground
        
        self.fillValues()
        Service.shared.fetchCurrentUser()
        self.addViews()
        
        self.emptyStateOne.isHidden = true
        self.emptyStateTwo.isHidden = true
        self.dashMainView.isHidden = true
        self.todaysDashView.isHidden = true
        
        self.callDataEngine()
       
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.navigationController?.navigationBar.isHidden = true
        Service.shared.fetchCurrentUser()
        self.fillValues()
        
    }
    
    func callDataEngine() {
        
        self.fetchDataSource { isSuccess in
            
            if isSuccess {
                self.handleDatasourceSuccess()
            } else {
                self.handleDatasourceFailure()
            }
        }
    }
  
    func fetchDataSource(completion : @escaping (_ isSuccess : Bool)->()) {
        
        guard let user_uid = Auth.auth().currentUser?.uid else {return}
        let countingRef = self.databaseRef.child("doggy_profile_builder").child(user_uid)
        self.observingRefOne = self.databaseRef.child("doggy_profile_builder").child(user_uid)
        
        countingRef.observeSingleEvent(of: .value) { snapCount in
            
            if snapCount.exists() {
                
                let childrenCount = Int(snapCount.childrenCount)

                self.handleOne = self.observingRefOne.observe(.childAdded, with: { snapLoop in
                    
                    self.childCounter += 1
                    
                    guard let JSON = snapLoop.value as? [String : Any] else {return}
                    
                    let post = DoggyProfileDataSource(json: JSON)
                    
                    self.doggyProfileDataSource.append(post)
                    
                    if childrenCount == self.childCounter {
                        completion(true)
                    }
                })
                
            } else {
                completion(false)
            }
        }
    }
    
    func handleDatasourceFailure() {
        
        print("Failed to grab a profile, show empty state one")
        
        self.emptyStateOne.isHidden = false
        self.emptyStateTwo.isHidden = true
        self.dashMainView.isHidden = true
        self.todaysDashView.isHidden = true
        
        self.observingRefOne.removeObserver(withHandle: self.handleOne)
        self.childCounter = 0
        
        self.dashMainView.mainDashCollectionView.doggyProfileDataSource.removeAll()
        
        DispatchQueue.main.async {
            self.dashMainView.mainDashCollectionView.reloadData()
        }
    }
    
    func handleDatasourceSuccess() {
        
        print("Success, show the dash view")
        
        self.emptyStateOne.isHidden = true
        self.emptyStateTwo.isHidden = true
        self.dashMainView.isHidden = false
        self.todaysDashView.isHidden = true
        
        self.observingRefOne.removeObserver(withHandle: self.handleOne)
        self.childCounter = 0
        
        self.dashMainView.mainDashCollectionView.doggyProfileDataSource = self.doggyProfileDataSource
        
        DispatchQueue.main.async {
            self.dashMainView.mainDashCollectionView.reloadData()
        }
    }
    
    func fillValues() {
        let usersFirstName = userProfileStruct.user_first_name ?? "Dog Lover"
        self.headerLabel.text = "Welcome, \(usersFirstName)"
    }
    
    func addViews() {
        
        //HEADER
        self.view.addSubview(self.referButton)
        self.view.addSubview(self.dsCompanyLogoImage)
        self.view.addSubview(self.notificationIcon)
        self.view.addSubview(self.notificationBubble)
        self.view.addSubview(self.headerLabel)
        
        //EMPTY STATE ONE
        self.view.addSubview(self.emptyStateOne)
        self.view.addSubview(self.emptyStateTwo)
        
        //DASH VIEWS
        self.view.addSubview(self.dashMainView)
        self.view.addSubview(self.todaysDashView)

        self.referButton.topAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.topAnchor, constant: 0).isActive = true
        self.referButton.leftAnchor.constraint(equalTo: self.view.leftAnchor, constant: 30).isActive = true
        self.referButton.heightAnchor.constraint(equalToConstant: 44).isActive = true
        self.referButton.widthAnchor.constraint(equalToConstant: 44).isActive = true
        
        self.dsCompanyLogoImage.centerYAnchor.constraint(equalTo: self.referButton.centerYAnchor, constant: 0).isActive = true
        self.dsCompanyLogoImage.centerXAnchor.constraint(equalTo: self.view.centerXAnchor, constant: 0).isActive = true
        self.dsCompanyLogoImage.heightAnchor.constraint(equalToConstant: 26).isActive = true
        
        self.notificationIcon.centerYAnchor.constraint(equalTo: self.referButton.centerYAnchor, constant: 0).isActive = true
        self.notificationIcon.rightAnchor.constraint(equalTo: self.view.rightAnchor, constant: -30).isActive = true
        self.notificationIcon.heightAnchor.constraint(equalToConstant: 54).isActive = true
        self.notificationIcon.widthAnchor.constraint(equalToConstant: 54).isActive = true
        
        self.notificationBubble.topAnchor.constraint(equalTo: self.notificationIcon.topAnchor, constant: 7).isActive = true
        self.notificationBubble.rightAnchor.constraint(equalTo: self.notificationIcon.rightAnchor, constant: -7).isActive = true
        self.notificationBubble.heightAnchor.constraint(equalToConstant: 23).isActive = true
        self.notificationBubble.widthAnchor.constraint(equalToConstant: 23).isActive = true
        self.notificationBubble.layer.cornerRadius = 23/2
        
        self.headerLabel.topAnchor.constraint(equalTo: self.dsCompanyLogoImage.bottomAnchor, constant: 50).isActive = true
        self.headerLabel.leftAnchor.constraint(equalTo: self.referButton.leftAnchor, constant: 5).isActive = true
        self.headerLabel.rightAnchor.constraint(equalTo: self.view.rightAnchor, constant: -30).isActive = true
        self.headerLabel.heightAnchor.constraint(equalToConstant: 30).isActive = true
        
        self.emptyStateOne.topAnchor.constraint(equalTo: self.headerLabel.bottomAnchor, constant: 10).isActive = true
        self.emptyStateOne.leftAnchor.constraint(equalTo: self.view.leftAnchor, constant: 0).isActive = true
        self.emptyStateOne.rightAnchor.constraint(equalTo: self.view.rightAnchor, constant: 0).isActive = true
        self.emptyStateOne.bottomAnchor.constraint(equalTo: self.view.bottomAnchor, constant: 0).isActive = true
        
        self.emptyStateTwo.topAnchor.constraint(equalTo: self.headerLabel.bottomAnchor, constant: 10).isActive = true
        self.emptyStateTwo.leftAnchor.constraint(equalTo: self.view.leftAnchor, constant: 0).isActive = true
        self.emptyStateTwo.rightAnchor.constraint(equalTo: self.view.rightAnchor, constant: 0).isActive = true
        self.emptyStateTwo.bottomAnchor.constraint(equalTo: self.view.bottomAnchor, constant: 0).isActive = true
        
        self.dashMainView.topAnchor.constraint(equalTo: self.headerLabel.topAnchor, constant: -10).isActive = true
        self.dashMainView.leftAnchor.constraint(equalTo: self.view.leftAnchor, constant: 0).isActive = true
        self.dashMainView.rightAnchor.constraint(equalTo: self.view.rightAnchor, constant: 0).isActive = true
        self.dashMainView.bottomAnchor.constraint(equalTo: self.view.bottomAnchor, constant: 0).isActive = true
        
        self.todaysDashView.topAnchor.constraint(equalTo: self.headerLabel.topAnchor, constant: -10).isActive = true
        self.todaysDashView.leftAnchor.constraint(equalTo: self.view.leftAnchor, constant: 0).isActive = true
        self.todaysDashView.rightAnchor.constraint(equalTo: self.view.rightAnchor, constant: 0).isActive = true
        self.todaysDashView.bottomAnchor.constraint(equalTo: self.view.bottomAnchor, constant: 0).isActive = true
        
        
        
    }
    
    @objc func handleReferAFriendButton() {
        self.didTapRefur()
    }
    
    @objc func handleNewDogFlow() {
        
        let newDogEntry = NewDogEntry()
        let navigationController = UINavigationController(rootViewController: newDogEntry)
        navigationController.modalPresentationStyle = .fullScreen
        navigationController.navigationBar.isHidden = true
        self.navigationController?.present(navigationController, animated: true, completion: nil)
    }
    
    @objc private func didTapRefur() {
        let refurVC = RefurAFriendController()
        self.present(refurVC, animated: true)
    }
    
    @objc func handleNotificationsController() {
        let notificationVC = YourNotificationController()
        self.navigationController?.pushViewController(notificationVC, animated: true)
    }
    
    @objc func handleTourTruckButton() {
        print("Handle tour")
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



































//
//        self.welcomeContainerCreateDoggyprofileButton.leftAnchor.constraint(equalTo: self.welcomeContainer.leftAnchor, constant: 30).isActive = true
//        self.welcomeContainerCreateDoggyprofileButton.topAnchor.constraint(equalTo: self.welcomeContainer.topAnchor, constant: 28).isActive = true
//        self.welcomeContainerCreateDoggyprofileButton.heightAnchor.constraint(equalToConstant: 98).isActive = true
//        self.welcomeContainerCreateDoggyprofileButton.widthAnchor.constraint(equalToConstant: 98).isActive = true
//        self.welcomeContainerCreateDoggyprofileButton.layer.cornerRadius = 98/2
//
//        self.welcomeContainerLabel.leftAnchor.constraint(equalTo: self.welcomeContainerCreateDoggyprofileButton.rightAnchor, constant: 15).isActive = true
//        self.welcomeContainerLabel.rightAnchor.constraint(equalTo: self.welcomeContainer.rightAnchor, constant: -10).isActive = true
//        self.welcomeContainerLabel.topAnchor.constraint(equalTo: self.welcomeContainer.topAnchor, constant: 5).isActive = true
//        self.welcomeContainerLabel.bottomAnchor.constraint(equalTo: self.welcomeContainer.bottomAnchor, constant: -5).isActive = true
//
//        self.welcomeContainerAddIcon.centerYAnchor.constraint(equalTo: self.welcomeContainerCreateDoggyprofileButton.centerYAnchor, constant: 0).isActive = true
//        self.welcomeContainerAddIcon.centerXAnchor.constraint(equalTo: self.welcomeContainerCreateDoggyprofileButton.centerXAnchor, constant: 0).isActive = true
//        self.welcomeContainerAddIcon.heightAnchor.constraint(equalToConstant: 30).isActive = true
//        self.welcomeContainerAddIcon.widthAnchor.constraint(equalToConstant: 30).isActive = true


//        self.petCollectionView.topAnchor.constraint(equalTo: self.dsCompanyLogoImage.bottomAnchor, constant: 30).isActive = true
//        self.petCollectionView.leftAnchor.constraint(equalTo: self.view.leftAnchor, constant: 0).isActive = true
//        self.petCollectionView.rightAnchor.constraint(equalTo: self.view.rightAnchor, constant: 0).isActive = true
//        self.petCollectionView.heightAnchor.constraint(equalToConstant: 120).isActive = true
//
//        self.appointmentHeader.left(to: view, offset: 30.0)
//        self.appointmentHeader.right(to: view, offset: -30.0)
//        self.appointmentHeader.topToBottom(of: petCollectionView, offset: 24)
//
//        self.appointmentContainer.topToBottom(of: appointmentHeader, offset: 10.0)
//        self.appointmentContainer.left(to: appointmentHeader)
//        self.appointmentContainer.height(152)
//        self.appointmentContainer.right(to: appointmentHeader)



//
//
//let imageViewOne = UIImageView(frame: .zero)
//imageViewOne.sd_setImage(with: URL(string: pets[1].imageURL), placeholderImage: UIImage(named: Constants.petProfilePlaceholder), options: .continueInBackground, context: nil)
//imageViewOne.contentMode = .scaleToFill
//imageViewOne.clipsToBounds = true
//imageViewOne.layer.cornerRadius = 23
//
//self.appointmentContainer.addSubview(imageViewOne)
//imageViewOne.height(46)
//imageViewOne.width(46)
//imageViewOne.top(to: appointmentContainer, offset: 20)
//imageViewOne.left(to: appointmentContainer, offset: 20)
//
////Must check if user numberOfPets > 2 before displaying this
//let imageViewTwo = UIImageView(frame: .zero)
//imageViewTwo.sd_setImage(with: URL(string: pets[2].imageURL), placeholderImage: UIImage(named: Constants.petProfilePlaceholder), options: .continueInBackground, context: nil)
//imageViewTwo.contentMode = .scaleToFill
//imageViewTwo.clipsToBounds = true
//imageViewTwo.layer.cornerRadius = 23
//
//self.appointmentContainer.addSubview(imageViewTwo)
//imageViewTwo.height(46)
//imageViewTwo.width(46)
//imageViewTwo.top(to: imageViewOne)
//imageViewTwo.leftToRight(of: imageViewOne, offset: 10)
//
//self.appointmentContainer.addSubview(editAppointmentButton)
//editAppointmentButton.top(to: imageViewOne)
//editAppointmentButton.right(to: appointmentContainer, offset: -20)
//editAppointmentButton.height(38)
//editAppointmentButton.width(38)
//
//self.appointmentContainer.addSubview(appointmentDate)
//appointmentDate.topToBottom(of: imageViewOne, offset: 12)
//appointmentDate.left(to: imageViewOne)
//
//self.appointmentContainer.addSubview(appointmentTime)
//appointmentTime.top(to: appointmentDate)
//appointmentTime.right(to: editAppointmentButton)
//
//self.appointmentContainer.addSubview(appointmentCycle)
//appointmentCycle.left(to: appointmentDate)
//appointmentCycle.topToBottom(of: appointmentDate, offset: 5)
//
//self.view.addSubview(viewAllAppointmentsButton)
//viewAllAppointmentsButton.centerX(to: appointmentContainer)
//viewAllAppointmentsButton.topToBottom(of: appointmentContainer, offset: 2.0)
//viewAllAppointmentsButton.width(150)
//
// self.view.addSubview(serviceHeader)
// serviceHeader.topToBottom(of: viewAllAppointmentsButton, offset: 12.0)
// serviceHeader.left(to: appointmentHeader)
//
// self.view.addSubview(servicesContainer)
// servicesContainer.topToBottom(of: serviceHeader, offset: 10.0)
// servicesContainer.left(to: appointmentContainer)
// servicesContainer.right(to: appointmentContainer)
// servicesContainer.height(152)
//
// self.view.addSubview(viewAllServicesButton)
// viewAllServicesButton.centerX(to: servicesContainer)
// viewAllServicesButton.topToBottom(of: servicesContainer, offset: 2.0)
// viewAllServicesButton.width(150)
//
// let serviceView = ServiceOfTheWeekView(package: package)
// servicesContainer.addSubview(serviceView)
// serviceView.edgesToSuperview()



//    let welcomeContainerAddIcon : UIButton = {
//
//        let dcl = UIButton(type: .system)
//        dcl.translatesAutoresizingMaskIntoConstraints = false
//        dcl.backgroundColor = .clear
//        dcl.contentMode = .scaleAspectFit
//        dcl.isUserInteractionEnabled = true
//        dcl.clipsToBounds = true
//
//        return dcl
//    }()
    
    
//    private let petCollectionView: UICollectionView = {
//
//        let layout = UICollectionViewFlowLayout()
//        layout.itemSize = CGSize(width: 74, height: 74)
//        layout.scrollDirection = .horizontal
//        layout.sectionInset = UIEdgeInsets(top: 0, left: 16, bottom: 0, right: 16)
//
//        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
//        collectionView.register(PetCollectionViewCell.self, forCellWithReuseIdentifier: PetCollectionViewCell.reuseIdentifier)
//        collectionView.showsHorizontalScrollIndicator = false
//        collectionView.backgroundColor = .dsViewBackground
//        collectionView.translatesAutoresizingMaskIntoConstraints = false
//        return collectionView
//
//    }()
