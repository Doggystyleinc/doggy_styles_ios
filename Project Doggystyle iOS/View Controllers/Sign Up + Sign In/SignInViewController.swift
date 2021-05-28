//
//  SignInViewController.swift
//  Project Doggystyle
//
//  Created by Stanley Miller on 5/6/21.
//

import UIKit
import GoogleSignIn
import Firebase

final class SignInViewController: UIViewController, GIDSignInDelegate  {
    private let verticalPadding: CGFloat = 30.0
    
    private let welcomeTitle: UILabel = {
        let label = UILabel(frame: .zero)
        label.font = UIFont.robotoBold(size: 30)
        label.text = "Welcome!"
        label.textColor = .headerColor
        return label
    }()
    
    private let welcomeSubTitle: UILabel = {
        let label = UILabel(frame: .zero)
        label.font = UIFont.robotoRegular(size: 18)
        label.text = "Please sign in with:"
        label.textColor = .textColor
        return label
    }()
    
    private let footerText: UILabel = {
        let label = UILabel(frame: .zero)
        label.font = UIFont.robotoRegular(size: 18)
        label.text = "Don't have an account yet?"
        label.textColor = .textColor
        return label
    }()
    
    private let signInButton: UIButton = {
        let button = UIButton(type: .system)
        let attributes: [NSAttributedString.Key : Any] = [
            .font : UIFont.robotoRegular(size: 20.0),
            .foregroundColor : UIColor.textColor,
            .underlineStyle : NSUnderlineStyle.single.rawValue
        ]
        let attributeString = NSMutableAttributedString(string: "SIGN UP", attributes: attributes)
        button.setAttributedTitle(attributeString, for: .normal)
        button.addTarget(self, action: #selector(dismissVC(_:)), for: .touchUpInside)
        return button
    }()
    
    private let dividerView = DividerView()
    
    private let emailButton = DSButton(titleText: "email", backgroundColor: .dsGrey, titleColor: .white)
    private let facebookButton = DSButton(text: "facebook")
    private let appleButton = DSButton(text: "apple")
    
    private let googleButton : GIDSignInButton = {
        let gb = GIDSignInButton()
        gb.translatesAutoresizingMaskIntoConstraints = false
        gb.backgroundColor = .white
        gb.layer.masksToBounds = true
        gb.layer.cornerRadius = 0
        return gb
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.configureVC()
        self.addWelcomeViews()
        self.addSignUpButtons()
        self.addTargets()
    }
}

//MARK: - Configure View Controller
extension SignInViewController {
    private func configureVC() {
        self.view.backgroundColor = .white
        GIDSignIn.sharedInstance().presentingViewController = self
        GIDSignIn.sharedInstance()?.delegate = self
        
        let closeButton = UIBarButtonItem(image: UIImage(systemName: "xmark.circle.fill"), style: .done, target: self, action: #selector(dismissVC(_:)))
        self.navigationItem.rightBarButtonItem = closeButton
    }
}

//MARK: - Configure Welcome Message
extension SignInViewController {
    private func addWelcomeViews() {
        self.view.addSubview(welcomeTitle)
        welcomeTitle.top(to: self.view, offset: 80.0)
        welcomeTitle.left(to: self.view, offset: verticalPadding)
        
        self.view.addSubview(welcomeSubTitle)
        welcomeSubTitle.topToBottom(of: self.welcomeTitle, offset: 20.0)
        welcomeSubTitle.left(to: self.view, offset: verticalPadding)
        welcomeSubTitle.right(to: self.view, offset: -verticalPadding)
        
        self.view.addSubview(dividerView)
        dividerView.height(0.5)
        dividerView.topToBottom(of: self.welcomeSubTitle, offset: 20.0)
        dividerView.left(to: self.view, offset: verticalPadding)
        dividerView.right(to: self.view, offset: -verticalPadding)
    }
}

//MARK: - Configure Sign Up/In Buttons
extension SignInViewController {
    private func addSignUpButtons() {
        self.view.addSubview(emailButton)
        emailButton.topToBottom(of: self.dividerView, offset: verticalPadding)
        emailButton.height(44)
        emailButton.left(to: self.view, offset: verticalPadding)
        emailButton.right(to: self.view, offset: -verticalPadding)
        
        self.view.addSubview(googleButton)
        googleButton.topToBottom(of: self.emailButton, offset: 10.0)
        googleButton.height(44)
        googleButton.left(to: self.view, offset: verticalPadding)
        googleButton.right(to: self.view, offset: -verticalPadding)
        
        self.view.addSubview(facebookButton)
        facebookButton.topToBottom(of: self.googleButton, offset: 10.0)
        facebookButton.height(44)
        facebookButton.left(to: self.view, offset: verticalPadding)
        facebookButton.right(to: self.view, offset: -verticalPadding)
        
        self.view.addSubview(appleButton)
        appleButton.topToBottom(of: self.facebookButton, offset: 10.0)
        appleButton.height(44)
        appleButton.left(to: self.view, offset: verticalPadding)
        appleButton.right(to: self.view, offset: -verticalPadding)
        
        self.view.addSubview(footerText)
        footerText.topToBottom(of: self.appleButton, offset: verticalPadding)
        footerText.centerX(to: self.view)
        
        self.view.addSubview(signInButton)
        signInButton.topToBottom(of: footerText, offset: 24)
        signInButton.centerX(to: self.view)
        signInButton.height(24)
    }
}

//MARK: - Configure Google Sign In
extension SignInViewController {
    
    func sign(_ signIn: GIDSignIn!, didSignInFor user: GIDGoogleUser!, withError error: Error?) {
        
        if let error = error {
            self.presentAlertOnMainThread(title: "Something went wrong...", message: "An error occured with your Google Sign In.\nError: \(error)", buttonTitle: "Ok")
            print("error occured here signing in with google sign in. \(error)")
            return
        }
        
        guard let authentication = user.authentication else {
            print("Authentication error. \(error?.localizedDescription as Any)")
            return
        }
        
        let credential = GoogleAuthProvider.credential(withIDToken: authentication.idToken, accessToken: authentication.accessToken)
        
        let referralCode = "Need to figure this one out"
        
        Service.shared.firebaseGoogleSignIn(credentials: credential, referralCode: referralCode) { (hasSuccess, response) in
            
            if hasSuccess {
                self.presentRequestVC()
            } else {
                self.presentAlertOnMainThread(title: "Something went wrong...", message: "Failed to authenticate.\nError: \(response)", buttonTitle: "Ok")
                print("Failed to authenticate with error: \(response)")
            }
        }
    }
    
    func sign(_ signIn: GIDSignIn!, didDisconnectWith user: GIDGoogleUser!, withError error: Error!) {
        print("bailed from the google sign in process")
    }
}

//MARK: - Add Button Targets
extension SignInViewController {
    private func addTargets() {
        self.emailButton.addTarget(self, action: #selector(presentEmailSignUp(_:)), for: .touchUpInside)
        self.facebookButton.addTarget(self, action: #selector(didTapFacebookButton(_:)), for: .touchUpInside)
        self.appleButton.addTarget(self, action: #selector(didTapAppleButton(_:)), for: .touchUpInside)
    }
}

//MARK: - @objc Functions
extension SignInViewController {
    @objc private func presentEmailSignUp(_ sender: UIButton) {
        let emailVC = EmailSignInViewController()
        self.navigationController?.pushViewController(emailVC, animated: true)
    }
    
    @objc private func didTapFacebookButton(_ sender: UIButton) {
        print(#function)
    }
    
    @objc private func didTapAppleButton(_ sender: UIButton) {
        print(#function)
    }
    
    @objc private func dismissVC(_ sender: UIButton) {
        self.dismiss(animated: true)
    }
    
    @objc func presentHomeController() {
        let homeVC = HomeViewController()
        let navVC = UINavigationController(rootViewController: homeVC)
        
        navVC.navigationBar.isHidden = true
        navVC.modalPresentationStyle = .fullScreen
        self.navigationController?.present(navVC, animated: true)
    }
    
    @objc private func presentRequestVC() {
        self.showLoadingView()
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
            let requestVC = RequestUserLocationViewController()
            let navVC = UINavigationController(rootViewController: requestVC)
            navVC.modalTransitionStyle = .crossDissolve
            navVC.modalPresentationStyle = .fullScreen
            
            self.dismissLoadingView()
            self.navigationController?.present(navVC, animated: true)
        }
    }
}
