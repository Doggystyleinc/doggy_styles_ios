//
//  ProfileViewController.swift
//  Project Doggystyle iOS
//
//  Created by Charlie Arcodia on 5/28/21.
//

import UIKit
import Firebase
import UniformTypeIdentifiers
import MobileCoreServices

class ProfileViewController: UIViewController, UINavigationControllerDelegate {
    var homeController: HomeViewController?
    private let containerHeight: CGFloat = 70
    private let spacing: CGFloat = 22
    private let iconSize: CGFloat = 24
    
    private let rightIcon = DSNavButton(imageName: Constants.signOutNavIcon, tagNumber: 99)
    private let logo = LogoImageView(frame: .zero)
    
    private let dogIcon = UIImage(named: Constants.dogIcon)?.withTintColor(.dsOrange)
    private let paymentIcon = UIImage(named: Constants.paymentIcon)?.withTintColor(.dsOrange)
    private let contactIcon = UIImage(named: Constants.contactIcon)?.withTintColor(.dsOrange)
    private let refurIcon = UIImage(named: Constants.refurIcon)?.withTintColor(.dsOrange)

    private let nameContainer = DSContainerView(frame: .zero)
    private let petContainer = DSContainerView(frame: .zero)
    private let paymentContainer = DSContainerView(frame: .zero)
    private let contactUsContainer = DSContainerView(frame: .zero)
    private let refurContainer = DSContainerView(frame: .zero)
    
    private let profileImageView: UIImageView = {
        let imageView = UIImageView(frame: .zero)
        imageView.clipsToBounds = true
        imageView.contentMode = .scaleAspectFill
        imageView.layer.shouldRasterize = false
        imageView.layer.cornerRadius = 65
        return imageView
    }()
    
    private let nameLabel: UILabel = {
        let label = UILabel()
        label.backgroundColor = .clear
        label.text = "Annie Schultz"
        label.font = UIFont.poppinsBold(size: 20)
        label.textColor = .dsTextColor
        label.textAlignment = .center
        label.adjustsFontSizeToFitWidth = true
        label.numberOfLines = 1
        return label
    }()
    
    private lazy var imagePickerController: UIImagePickerController = {
        let controller = UIImagePickerController()
        controller.delegate = self
        controller.allowsEditing = true
        controller.sourceType = .savedPhotosAlbum
        return controller
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureVC()
        addNavViews()
        addContainers()
        addProfileViews()
        addMyPetViews()
        addPaymentViews()
        addContactViews()
        addRefurViews()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        self.fetchJSON()
    }
}

//MARK: - Configure View Controller
extension ProfileViewController {
    private func configureVC() {
        view.backgroundColor = .dsViewBackground
        self.navigationController?.navigationBar.isHidden = false
    }
}

//MARK: - Configure Views
extension ProfileViewController {
    private func addNavViews() {
        self.navigationItem.titleView = logo
        let rightBarImage = UIImage(named: Constants.signOutNavIcon)?.withRenderingMode(.alwaysOriginal)
        navigationItem.rightBarButtonItem = UIBarButtonItem(image: rightBarImage, landscapeImagePhone: nil, style: .plain, target: self, action: #selector(handleLogout))
    }
        
    private func addContainers() {
        self.view.addSubview(nameContainer)
        nameContainer.height(126)
        nameContainer.left(to: view, offset: 30)
        nameContainer.right(to: view, offset: -30)
        nameContainer.topToSuperview(offset: 95, usingSafeArea: true)
        
        self.view.addSubview(petContainer)
        petContainer.height(containerHeight)
        petContainer.left(to: nameContainer)
        petContainer.right(to: nameContainer)
        petContainer.topToBottom(of: nameContainer, offset: spacing)
        
        self.view.addSubview(paymentContainer)
        paymentContainer.height(containerHeight)
        paymentContainer.left(to: nameContainer)
        paymentContainer.right(to: nameContainer)
        paymentContainer.topToBottom(of: petContainer, offset: spacing)
        
        self.view.addSubview(contactUsContainer)
        contactUsContainer.height(containerHeight)
        contactUsContainer.left(to: nameContainer)
        contactUsContainer.right(to: nameContainer)
        contactUsContainer.topToBottom(of: paymentContainer, offset: spacing)
        
        self.view.addSubview(refurContainer)
        refurContainer.height(containerHeight)
        refurContainer.left(to: nameContainer)
        refurContainer.right(to: nameContainer)
        refurContainer.topToBottom(of: contactUsContainer, offset: spacing)
    }
    
    private func addProfileViews() {
        self.view.addSubview(profileImageView)
        profileImageView.height(130)
        profileImageView.width(130)
        profileImageView.top(to: nameContainer, offset: -65)
        profileImageView.centerX(to: view)
        
        self.nameContainer.addSubview(nameLabel)
        nameLabel.bottom(to: nameContainer, offset: -22)
        nameLabel.left(to: nameContainer, offset: 30)
        nameLabel.right(to: nameContainer, offset: -30)
        
        let action = UIButton(type: .system)
        action.setTitle("", for: .normal)
        action.tag = 0
        action.addTarget(self, action: #selector(didTapButton(_:)), for: .touchUpInside)
        
        nameContainer.addSubview(action)
        action.edgesToSuperview()
    }
    
    private func addMyPetViews() {
        let petLabel = DSBoldLabel(title: "My dogs", size: 16)
        let petImageView = UIImageView(image: dogIcon)
        petImageView.contentMode = .scaleAspectFit
        
        petContainer.addSubview(petImageView)
        petImageView.height(iconSize)
        petImageView.width(iconSize)
        petImageView.left(to: petContainer, offset: 26)
        petImageView.centerY(to: petContainer)
        
        petContainer.addSubview(petLabel)
        petLabel.leftToRight(of: petImageView, offset: 20)
        petLabel.centerY(to: petImageView)
        
        let action = UIButton(type: .system)
        action.setTitle("", for: .normal)
        action.tag = 1
        action.addTarget(self, action: #selector(didTapButton(_:)), for: .touchUpInside)
        
        petContainer.addSubview(action)
        action.edgesToSuperview()
    }
    
    private func addPaymentViews() {
        let paymentLabel = DSBoldLabel(title: "Payment", size: 16)
        let paymentImageView = UIImageView(image: paymentIcon)
        paymentImageView.contentMode = .scaleAspectFit
        
        paymentContainer.addSubview(paymentImageView)
        paymentImageView.height(iconSize)
        paymentImageView.width(iconSize)
        paymentImageView.left(to: paymentContainer, offset: 26)
        paymentImageView.centerY(to: paymentContainer)
        
        paymentContainer.addSubview(paymentLabel)
        paymentLabel.leftToRight(of: paymentImageView, offset: 20)
        paymentLabel.centerY(to: paymentImageView)
        
        let action = UIButton(type: .system)
        action.setTitle("", for: .normal)
        action.tag = 2
        action.addTarget(self, action: #selector(didTapButton(_:)), for: .touchUpInside)
        
        paymentContainer.addSubview(action)
        action.edgesToSuperview()
    }
    
    private func addContactViews() {
        let contactLabel = DSBoldLabel(title: "Contact Us", size: 16)
        let contactImageView = UIImageView(image: contactIcon)
        contactImageView.contentMode = .scaleAspectFit
        
        contactUsContainer.addSubview(contactImageView)
        contactImageView.height(iconSize)
        contactImageView.width(iconSize)
        contactImageView.left(to: contactUsContainer, offset: 26)
        contactImageView.centerY(to: contactUsContainer)
        
        contactUsContainer.addSubview(contactLabel)
        contactLabel.leftToRight(of: contactImageView, offset: 20)
        contactLabel.centerY(to: contactImageView)
        
        let action = UIButton(type: .system)
        action.setTitle("", for: .normal)
        action.tag = 3
        action.addTarget(self, action: #selector(didTapButton(_:)), for: .touchUpInside)
        
        contactUsContainer.addSubview(action)
        action.edgesToSuperview()
    }
    
    private func addRefurViews() {
        let refurLabel = DSBoldLabel(title: "Re-fur a Friend", size: 16)
        let refurImageView = UIImageView(image: refurIcon)
        refurImageView.contentMode = .scaleAspectFit
        
        refurContainer.addSubview(refurImageView)
        refurImageView.height(iconSize)
        refurImageView.width(iconSize)
        refurImageView.left(to: refurContainer, offset: 26)
        refurImageView.centerY(to: refurContainer)
        
        refurContainer.addSubview(refurLabel)
        refurLabel.leftToRight(of: refurImageView, offset: 20)
        refurLabel.centerY(to: refurImageView)
        
        let action = UIButton(type: .system)
        action.setTitle("", for: .normal)
        action.tag = 4
        action.addTarget(self, action: #selector(didTapButton(_:)), for: .touchUpInside)
        
        refurContainer.addSubview(action)
        action.edgesToSuperview()
    }
}

//MARK: - @objc Methods
extension ProfileViewController {
    @objc func handleLogout() {
        do {
            try Auth.auth().signOut()
        } catch let logoutError {
            print(logoutError)
            return
        }

        Database.database().reference().removeAllObservers()

        let decisionController = DecisionController()
        let nav = UINavigationController(rootViewController: decisionController)
        nav.modalPresentationStyle = .fullScreen
        nav.navigationBar.isHidden = true
        self.navigationController?.present(nav, animated: true, completion: nil)
    }
    
    @objc func didTapButton(_ sender: UIButton) {
        switch sender.tag {
        case 0:
            self.imagePickerController.mediaTypes = [kUTTypeImage as String]
            present(imagePickerController, animated: true)
        case 1:
            let petsVC = MyPetsController()
            self.present(petsVC, animated: true)
        case 2:
            let paymentVC = PaymentController()
            self.present(paymentVC, animated: true)
        case 3:
            let contactVC = ContactUsController()
            self.present(contactVC, animated: true)
        case 4:
            let refurVC = RefurAFriendController()
            self.present(refurVC, animated: true)
        default:
            break
        }
    }
}

//MARK: - Helpers
extension ProfileViewController {
    //GOOD IDEA TO CHECK THIS EVERYTIME THE VIEW LOADS, INCASE THEY CHANGE THEIR PHOTO, NAME ETC.
    func fetchJSON() {
        Service.shared.fetchCurrentUser()
        //DATA SHOULD BE FILLED ON APPLICATION LOAD AFTER AUTHENTICATION OR SIGN IN
        self.nameLabel.text = "\(userProfileStruct.firstName ?? "Pet") \(userProfileStruct.lastName ?? "Lover")"
        
        //Set profile image with animation
        profileImageView.sd_setImage(with: URL(string: userProfileStruct.profileURL ?? ""), placeholderImage: UIImage(named: Constants.ownerProfilePlaceholder)) { _, _, _, _ in
            self.profileImageView.alpha = 0.0
            UIView.animate(withDuration: 1.0) {
                self.profileImageView.alpha = 1.0
            }
        }
    }
}

//MARK: - Image Picker Delegate
extension ProfileViewController: UIImagePickerControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        guard let selectedImage = info[.editedImage] as? UIImage else {
            print("Image not found!")
            return
        }
        
        profileImageView.image = selectedImage
        imagePickerController.dismiss(animated: true)
        
        guard let image = profileImageView.image, let imageDataToUpload = image.jpegData(compressionQuality: 0.15) else {
            self.presentAlertOnMainThread(title: "Something went wrong...", message: "Please try again.", buttonTitle: "Ok")
            return
        }
        
        Service.shared.uploadProfileImageData(data: imageDataToUpload) { success in
            print("User: \(Auth.auth().currentUser?.uid ?? "user unknown") Profile Image Uploaded Succesfully!")
        }
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        imagePickerController.dismiss(animated: true)
    }
}
