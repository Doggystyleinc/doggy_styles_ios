//
//  LocationNotServicedViewController.swift
//  Project Doggystyle iOS
//
//  Created by Stanley Miller on 5/20/21.
//

import UIKit
import CoreLocation

final class LocationNotServicedViewController: UIViewController {
    private let scrollView = UIScrollView(frame: .zero)
    private let scrollViewContainer = UIView(frame: .zero)
    private let verticalPadding: CGFloat = 30.0
    var selectedAddress: String!
    
    private let titleLabel: UILabel = {
        let label = UILabel(frame: .zero)
        label.font = UIFont.robotoBold(size: 30)
        label.text = "Grooming location"
        label.textColor = .headerColor
        return label
    }()
    
    private let dividerView = DividerView()
    
    private let selectedLocationLabel: UILabel = {
        let label = UILabel(frame: .zero)
        label.textAlignment = .center
        label.font = UIFont.robotoMedium(size: 17)
        label.textColor = .textColor
        label.numberOfLines = 0
        return label
    }()
    
    private let errorImageContainerView: UIView = {
        let view = UIView(frame: .zero)
        view.backgroundColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 0.65)
        view.layer.cornerRadius = 10.0
        return view
    }()
    
    private let tempLabel: UILabel = {
        let label = UILabel(frame: .zero)
        label.font = UIFont.robotoBold(size: 20)
        label.text = "sad puppy face :("
        label.textColor = .white
        return label
    }()
    
    private let serviceUnavailableImage: UIImageView = {
        let imageView = UIImageView()
        
        return imageView
    }()
    
    private let apologyLabel: UILabel = {
        let label = UILabel(frame: .zero)
        label.font = UIFont.robotoRegular(size: 18)
        label.textColor = .textColor
        label.numberOfLines = 0
        label.text = "We’re sorry, no appointments are currently available. We will send you an email once we begin servicing your area."
        return label
    }()
    
    private let receiveNotificationsLabel: UILabel = {
        let label = UILabel(frame: .zero)
        label.font = UIFont.robotoRegular(size: 18)
        label.textColor = .textColor
        label.numberOfLines = 0
        label.text = "Want to receive additional notifications? Choose your preferred contact method."
        return label
    }()
    
    private let whatsAppButton: UIButton = {
        let button = DSButton(titleText: "whatsapp", backgroundColor: .dsGrey, titleColor: .white)
        button.addTarget(self, action: #selector(didTapButton(_:)), for: .touchUpInside)
        button.layer.cornerRadius = 5.0
        button.tag = 1
        return button
    }()
    
    private let smsButton: UIButton = {
        let button = DSButton(titleText: "sms", backgroundColor: .dsGrey, titleColor: .white)
        button.addTarget(self, action: #selector(didTapButton(_:)), for: .touchUpInside)
        button.layer.cornerRadius = 5.0
        button.tag = 2
        return button
    }()
    
    private let confirmButton: UIButton = {
        let button = DSButton(titleText: "confirm", backgroundColor: .dsGrey, titleColor: .white)
        button.addTarget(self, action: #selector(didTapButton(_:)), for: .touchUpInside)
        button.layer.cornerRadius = 5.0
        button.tag = 3
        button.alpha = 0.0
        return button
    }()
    
    private let mobileTextField: UITextField = {
        let textField = UITextField(frame: .zero)
        textField.alpha = 0.0
        textField.placeholder = ""
        textField.borderStyle = .none
        textField.setLeftPaddingPoints(10)
        textField.layer.cornerRadius = 10.0
        textField.backgroundColor = .textFieldBackground
        textField.keyboardType = .numbersAndPunctuation
        textField.returnKeyType = .done
        
        return textField
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        configureVC()
        addViews()
    }
}

//MARK: - Configure View Controller
extension LocationNotServicedViewController {
    private func configureVC() {
        self.view.backgroundColor = .white
        self.navigationController?.navigationBar.isHidden = false
        self.selectedLocationLabel.text = selectedAddress
    }
}

//MARK: - Configure Views
extension LocationNotServicedViewController {
    private func addViews() {
        self.view.addSubview(titleLabel)
        titleLabel.topToSuperview(usingSafeArea: true)
        titleLabel.left(to: view, offset: verticalPadding)
        
        self.view.addSubview(dividerView)
        dividerView.height(0.5)
        dividerView.topToBottom(of: titleLabel, offset: 20.0)
        dividerView.left(to: view, offset: verticalPadding)
        dividerView.right(to: view, offset: -verticalPadding)
        
        self.view.addSubview(errorImageContainerView)
        errorImageContainerView.height(200)
        errorImageContainerView.topToBottom(of: dividerView, offset: 20.0)
        errorImageContainerView.left(to: dividerView)
        errorImageContainerView.right(to: dividerView)
        
        self.errorImageContainerView.addSubview(tempLabel)
        tempLabel.centerInSuperview()
        
        self.view.addSubview(selectedLocationLabel)
        selectedLocationLabel.topToBottom(of: errorImageContainerView, offset: 20.0)
        selectedLocationLabel.left(to: dividerView)
        selectedLocationLabel.right(to: dividerView)
        
        self.view.addSubview(scrollView)
        scrollView.topToBottom(of: selectedLocationLabel, offset: 20.0)
        scrollView.left(to: dividerView)
        scrollView.right(to: dividerView)
        scrollView.bottom(to: view, offset: -40)
        
        self.scrollView.addSubview(scrollViewContainer)
        scrollViewContainer.edgesToSuperview()
        scrollViewContainer.width(to: scrollView)
        scrollViewContainer.height(400)
        
        self.scrollViewContainer.addSubview(apologyLabel)
        apologyLabel.top(to: scrollViewContainer)
        apologyLabel.left(to: scrollViewContainer)
        apologyLabel.right(to: scrollViewContainer)
        
        self.scrollViewContainer.addSubview(receiveNotificationsLabel)
        receiveNotificationsLabel.topToBottom(of: apologyLabel, offset: 20.0)
        receiveNotificationsLabel.left(to: scrollViewContainer)
        receiveNotificationsLabel.right(to: scrollViewContainer)
        
        self.scrollViewContainer.addSubview(whatsAppButton)
        whatsAppButton.width(150)
        whatsAppButton.height(44)
        whatsAppButton.topToBottom(of: receiveNotificationsLabel, offset: 20.0)
        whatsAppButton.left(to: scrollViewContainer)
        
        self.scrollViewContainer.addSubview(smsButton)
        smsButton.width(to: whatsAppButton)
        smsButton.height(to: whatsAppButton)
        smsButton.top(to: whatsAppButton)
        smsButton.right(to: scrollViewContainer)
        
        self.scrollViewContainer.addSubview(mobileTextField)
        mobileTextField.topToBottom(of: whatsAppButton, offset: 20.0)
        mobileTextField.left(to: scrollViewContainer)
        mobileTextField.right(to: scrollViewContainer)
        mobileTextField.height(44)
        
        self.scrollViewContainer.addSubview(confirmButton)
        confirmButton.topToBottom(of: mobileTextField, offset: 20.0)
        confirmButton.left(to: scrollViewContainer)
        confirmButton.right(to: scrollViewContainer)
        confirmButton.height(44)
    }
}


//MARK: - @objc Functions
extension LocationNotServicedViewController {
    @objc private func didTapButton(_ sender: UIButton) {
        switch sender.tag {
        case 1:
            print("WhatsApp Tapped")
            UIView.animate(withDuration: 0.80) {
                self.mobileTextField.alpha = 0.0
                self.mobileTextField.alpha = 1.0
                self.mobileTextField.placeholder = "Enter WhatsApp number"
                
                self.confirmButton.alpha = 1.0
            }
        case 2:
            print("SMS Tapped")
            UIView.animate(withDuration: 0.80) {
                self.mobileTextField.alpha = 0.0
                self.mobileTextField.alpha = 1.0
                self.mobileTextField.placeholder = "Enter mobile number"
                
                self.confirmButton.alpha = 1.0
            }
        case 3:
            print("Confirm Tapped")
            showLoadingView()
            perform(#selector(presentNumberSubmittedVC), with: nil, afterDelay: 1.0)
        default:
            break
        }
    }
    
    @objc private func presentNumberSubmittedVC() {
        dismissLoadingView()
        let contactLaterVC = NotServicedNumberSubmittedViewController()
        self.navigationController?.pushViewController(contactLaterVC, animated: true)
    }
}


//MARK: - Helpers
extension LocationNotServicedViewController {
    
}