//
//  HomeViewController.swift
//  Project Doggystyle
//
//  Created by Stanley Miller on 5/3/21.
//

import UIKit
import Firebase
import UniformTypeIdentifiers

final class HomeViewController: UIViewController, UINavigationControllerDelegate {
    private let profileImageView: UIImageView = {
        let imageView = UIImageView(frame: .zero)
        imageView.backgroundColor = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
        imageView.clipsToBounds = true
        imageView.layer.borderColor = UIColor.systemBlue.cgColor
        imageView.layer.borderWidth = 0.5
        imageView.layer.cornerRadius = 57
        imageView.contentMode = .scaleAspectFill
        return imageView
    }()
    
    private let infoLabel: UILabel = {
        let label = UILabel(frame: .zero)
        return label
    }()
    
    private let addButton: UIButton = {
        let button = UIButton(frame: .zero)
        button.tag = 0
        button.setImage(UIImage(systemName: "plus"), for: .normal)
        button.backgroundColor = .systemGreen
        button.tintColor = .white
        button.layer.cornerRadius = 17
        button.addTarget(self, action: #selector(didTapButton(_:)), for: .touchUpInside)
        return button
    }()
    
    private let uploadVideoButton: UIButton = {
        let button = UIButton(type: .system)
        button.tag = 1
        button.setTitle("Upload Video", for: .normal)
        button.backgroundColor = .white
        button.tintColor = .systemBlue
        button.layer.cornerRadius = 5
        button.layer.borderWidth = 0.5
        button.layer.borderColor = UIColor.lightGray.cgColor
        button.leftImage(image: UIImage(systemName: "video.bubble.left.fill")!, renderMode: .alwaysTemplate)
        button.addTarget(self, action: #selector(didTapButton(_:)), for: .touchUpInside)
        return button
    }()
    
    private let uploadDocumentButton: UIButton = {
        let button = UIButton(type: .system)
        button.tag = 2
        button.setTitle("Upload Document", for: .normal)
        button.backgroundColor = .white
        button.tintColor = .systemBlue
        button.layer.cornerRadius = 5
        button.layer.borderWidth = 0.5
        button.layer.borderColor = UIColor.lightGray.cgColor
        button.leftImage(image: UIImage(systemName: "doc.fill.badge.plus")!, renderMode: .alwaysTemplate)
        button.addTarget(self, action: #selector(didTapButton(_:)), for: .touchUpInside)
        return button
    }()
    
    private let uploadImageButton: UIButton = {
        let button = UIButton(type: .system)
        button.isEnabled = false
        button.tag = 3
        button.setTitle("Upload Image", for: .normal)
        button.backgroundColor = .white
        button.tintColor = .lightGray
        button.layer.cornerRadius = 5
        button.layer.borderWidth = 0.5
        button.layer.borderColor = UIColor.lightGray.cgColor
        button.leftImage(image: UIImage(systemName: "photo.fill")!, renderMode: .alwaysTemplate)
        button.addTarget(self, action: #selector(didTapButton(_:)), for: .touchUpInside)
        return button
    }()
    
    private lazy var imagePickerController: UIImagePickerController = {
        let controller = UIImagePickerController()
        controller.delegate = self
        return controller
    }()
    
    private lazy var documentPicker: UIDocumentPickerViewController = {
        let supportedTypes: [UTType] = [UTType.image, UTType.pdf, UTType.png, UTType.jpeg]
        let controller = UIDocumentPickerViewController(forOpeningContentTypes: supportedTypes)
        controller.allowsMultipleSelection = false
        controller.shouldShowFileExtensions = true
        controller.delegate = self
        return controller
    }()
    
    private var signOutButton : UIButton = {
        let sob = UIButton(type: .system)
        let buttonTitle = NSLocalizedString("LogOut", comment: "Log Out")
        sob.backgroundColor = .orange
        sob.tintColor = .white
        sob.setTitle(buttonTitle, for: .normal)
        sob.addTarget(self, action: #selector(handleLogOut), for: .touchUpInside)
        sob.layer.cornerRadius = 5.0
        return sob
    }()
    
    override func viewDidLoad() {
        self.view.backgroundColor = .white
        self.addViews()
        self.displayUserInfo()
    }
}


//MARK: - Configure Views
extension HomeViewController {
    private func addViews() {
        self.view.addSubview(profileImageView)
        profileImageView.height(114)
        profileImageView.width(114)
        profileImageView.top(to: view, offset: 150)
        profileImageView.centerX(to: view)
        
        self.view.addSubview(addButton)
        addButton.topToBottom(of: profileImageView, offset: -18)
        addButton.centerX(to: profileImageView)
        addButton.height(34)
        addButton.width(34)
        
        self.view.addSubview(uploadVideoButton)
        uploadVideoButton.topToBottom(of: addButton, offset: 60)
        uploadVideoButton.height(44)
        uploadVideoButton.width(200)
        uploadVideoButton.centerX(to: view)
        
        self.view.addSubview(uploadDocumentButton)
        uploadDocumentButton.topToBottom(of: uploadVideoButton, offset: 30)
        uploadDocumentButton.height(44)
        uploadDocumentButton.width(200)
        uploadDocumentButton.centerX(to: view)
        
        self.view.addSubview(uploadImageButton)
        uploadImageButton.topToBottom(of: uploadDocumentButton, offset: 30)
        uploadImageButton.height(44)
        uploadImageButton.width(200)
        uploadImageButton.centerX(to: view)
        
        self.view.addSubview(signOutButton)
        signOutButton.bottom(to: view, offset: -50)
        signOutButton.height(44)
        signOutButton.width(160)
        signOutButton.centerX(to: view)
    }
}


//MARK: - @objc Functions
extension HomeViewController {
    @objc func handleLogOut() {
        do {
            try Auth.auth().signOut()
        } catch let logoutError {
            print(logoutError)
        }
        
        //Logging out, remove all database observers.
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
            present(imagePickerController, animated: true)
        case 1:
            print("Upload Video Tapped!")
        case 2:
            self.uploadDocumentButton.isEnabled = false
            self.showLoadingView()
            present(documentPicker, animated: true)
        case 3:
            self.showLoadingView()
            
            guard let image = profileImageView.image, let data = image.pngData() else {
                self.dismissLoadingView()
                self.presentAlertOnMainThread(title: "Something went wrong...", message: "Please try again.", buttonTitle: "Ok")
                return
            }
            
            Service.shared.uploadProfileImageData(data: data) { success in
                self.dismissLoadingView()
                self.presentAlertOnMainThread(title: success ? "Upload Successful!" : "Something went wrong...", message: success ? "Profile image succesfully uploaded." : "Please try again.", buttonTitle: "Ok")
            }
            
        default:
            break
        }
    }
}

//MARK: - Helpers
extension HomeViewController {
    private func displayUserInfo() {
        profileImageView.sd_setImage(with: URL(string: userProfileStruct.profileURL ?? ""), placeholderImage: UIImage(named: "Temp Placeholder")) { _, _, _, _ in
            self.profileImageView.alpha = 0.0
            UIView.animate(withDuration: 1.0) {
                self.profileImageView.alpha = 1.0
            }
        }
    }
}

//MARK: - Image Picker Delegate
extension HomeViewController: UIImagePickerControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        guard let selectedImage = info[.originalImage] as? UIImage else {
            print("Image not found!")
            return
        }
        
        profileImageView.image = selectedImage
        imagePickerController.dismiss(animated: true)
        
        uploadImageButton.backgroundColor = .systemGreen
        uploadImageButton.tintColor = .white
        uploadImageButton.isEnabled = true
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        imagePickerController.dismiss(animated: true)
    }
}

//MARK: - Document Picker Delegate
extension HomeViewController: UIDocumentPickerDelegate {
    func documentPicker(_ controller: UIDocumentPickerViewController, didPickDocumentsAt urls: [URL]) {
        self.uploadDocumentButton.isEnabled = true
        guard let url = urls.first else {
            self.dismissLoadingView()
            return
        }
        
        Service.shared.uploadDocument(url: url) { success in
            self.dismissLoadingView()
            self.presentAlertOnMainThread(title: success ? "Succesful Upload!" : "Something went wrong...", message: success ? "The document was succesfully uploaded." : "Please try again.", buttonTitle: "Ok")
        }
    }
    
    func documentPickerWasCancelled(_ controller: UIDocumentPickerViewController) {
        self.uploadDocumentButton.isEnabled = true
        self.dismissLoadingView()
    }
}
