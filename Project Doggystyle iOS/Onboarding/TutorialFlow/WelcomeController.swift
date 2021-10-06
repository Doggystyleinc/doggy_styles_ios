//
//  TutorialController.swift
//  DSGroomer
//
//  Created by Charlie Arcodia on 5/30/21.
//

import UIKit
import UserNotifications
import GoogleSignIn
import Firebase
import FBSDKLoginKit

class WelcomePageController: UIPageViewController, UIPageViewControllerDataSource, UIPageViewControllerDelegate {
    
    private var pages = [UIViewController](),
                isNotificationsEnabled : Bool = false,
                gradientLayer: CAGradientLayer!,
                hasViewBeenLaidOut : Bool = false
    
    private let pageControl = UIPageControl(),
                initialPage = 0,
                page1 = SlideOne(),
                page2 = SlideTwo(),
                page3 = SlideThree(),
                mainLoadingScreen = MainLoadingScreen()
    
    private let orangeContainer : UIView = {
        
        let oc = UIView()
        oc.translatesAutoresizingMaskIntoConstraints = false
        oc.backgroundColor = .dsOrange
        oc.isUserInteractionEnabled = false
        
        return oc
        
    }()
    
    private lazy var signUpButton: UIButton = {
        
        let cbf = UIButton(type: .system)
        cbf.translatesAutoresizingMaskIntoConstraints = false
        cbf.backgroundColor = coreOrangeColor
        cbf.setTitle("Sign up with email", for: .normal)
        cbf.titleLabel?.font = UIFont(name: dsHeaderFont, size: 18)
        cbf.tintColor = coreWhiteColor
        cbf.layer.masksToBounds = true
        cbf.layer.cornerRadius = 20
        cbf.addTarget(self, action: #selector(self.handleSignUpButton), for: UIControl.Event.touchUpInside)
        return cbf
    }()
    
    private lazy var loginButton: UIButton = {
        
        let cbf = UIButton(type: .system)
        cbf.translatesAutoresizingMaskIntoConstraints = false
        cbf.backgroundColor = dsTransparentOrange
        cbf.setTitle("Login with email", for: .normal)
        cbf.titleLabel?.font = UIFont(name: dsHeaderFont, size: 18)
        cbf.tintColor = coreOrangeColor
        cbf.layer.masksToBounds = true
        cbf.layer.cornerRadius = 20
        cbf.addTarget(self, action: #selector(self.handleLoginButton), for: UIControl.Event.touchUpInside)
        return cbf
    }()
    
    private let dsCompanyLogoImage = LogoImageView(withImage: UIImage(named: Constants.dsLogoWhite))
    
    lazy var registerWithfacebookButton : UIButton = {
        
        let cbf = UIButton(type: .system)
        cbf.translatesAutoresizingMaskIntoConstraints = false
        cbf.backgroundColor = coreWhiteColor
        cbf.layer.masksToBounds = true
        cbf.layer.borderWidth = 1
        cbf.layer.borderColor = coreBlackColor.withAlphaComponent(0.1).cgColor
        cbf.layer.masksToBounds = true
        cbf.layer.cornerRadius = 20
        let image = UIImage(named: "Facebook Connect")?.withRenderingMode(.alwaysOriginal)
        cbf.setImage(image, for: .normal)
        cbf.imageView?.contentMode = .scaleAspectFit
        cbf.addTarget(self, action: #selector(self.handleFacebookRegistration), for: UIControl.Event.touchUpInside)
        return cbf
        
    }()
    
    lazy var registerWithGoogleButton : UIButton = {
        
        let cbf = UIButton(type: .system)
        cbf.translatesAutoresizingMaskIntoConstraints = false
        cbf.backgroundColor = coreWhiteColor
        cbf.layer.masksToBounds = true
        cbf.layer.borderWidth = 1
        cbf.layer.borderColor = coreBlackColor.withAlphaComponent(0.1).cgColor
        cbf.layer.masksToBounds = true
        cbf.layer.cornerRadius = 20
        let image = UIImage(named: "Google Connect")?.withRenderingMode(.alwaysOriginal)
        cbf.setImage(image, for: .normal)
        cbf.imageView?.contentMode = .scaleAspectFit
        cbf.addTarget(self, action: #selector(self.handleGoogleRegistration), for: UIControl.Event.touchUpInside)
        return cbf
        
    }()
    
    lazy var stackView : UIStackView = {
              
        let sv = UIStackView()
        sv.translatesAutoresizingMaskIntoConstraints = false
        sv.axis = .vertical
        sv.distribution = .equalCentering
        sv.alignment = .center
        sv.spacing = 2
        
        return sv
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.backgroundColor = coreWhiteColor
        self.dataSource = self
        self.delegate = self
        
        self.addViews()
      
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(true)
        
        navigationController?.navigationBar.barStyle = .black
        self.initializeGoogleAuthentication()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        
        self.navigationController?.navigationBar.isHidden = true
        self.navigationController?.navigationBar.barStyle = .default
        self.navigationItem.setHidesBackButton(true, animated: false)
    }
    
    private func addViews() {
        
        self.view.addSubview(self.orangeContainer)
        self.view.addSubview(self.dsCompanyLogoImage)
        self.view.addSubview(self.pageControl)
        self.view.addSubview(self.stackView)
        
        self.stackView.addArrangedSubview(self.signUpButton)
        self.stackView.addArrangedSubview(self.loginButton)
        self.stackView.addArrangedSubview(self.registerWithGoogleButton)
        self.stackView.addArrangedSubview(self.registerWithfacebookButton)
        
        self.signUpButton.heightAnchor.constraint(equalToConstant: (UIScreen.main.bounds.height / 2.3) / 5.5).isActive = true
        self.loginButton.heightAnchor.constraint(equalToConstant: (UIScreen.main.bounds.height / 2.3) / 5.5).isActive = true
        self.registerWithGoogleButton.heightAnchor.constraint(equalToConstant: (UIScreen.main.bounds.height / 2.3) / 6.0).isActive = true
        self.registerWithfacebookButton.heightAnchor.constraint(equalToConstant: (UIScreen.main.bounds.height / 2.3) / 6.0).isActive = true
        
        self.signUpButton.widthAnchor.constraint(equalToConstant: self.view.frame.width / 1.15).isActive = true
        self.loginButton.widthAnchor.constraint(equalToConstant: self.view.frame.width / 1.15).isActive = true
        self.registerWithGoogleButton.widthAnchor.constraint(equalToConstant: self.view.frame.width / 1.15).isActive = true
        self.registerWithfacebookButton.widthAnchor.constraint(equalToConstant: self.view.frame.width / 1.15).isActive = true
        
        self.stackView.topAnchor.constraint(equalTo: self.orangeContainer.bottomAnchor, constant: 20).isActive = true
        self.stackView.bottomAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.bottomAnchor, constant: -10).isActive = true
        self.stackView.leftAnchor.constraint(equalTo: self.view.leftAnchor, constant: 0).isActive = true
        self.stackView.rightAnchor.constraint(equalTo: self.view.rightAnchor, constant: 0).isActive = true

        self.pages.append(self.page1)
        self.pages.append(self.page2)
        self.pages.append(self.page3)
        
        self.setViewControllers([pages[initialPage]], direction: .forward, animated: true, completion: nil)
        
        self.pageControl.currentPageIndicatorTintColor = .white
        self.pageControl.pageIndicatorTintColor = .white.withAlphaComponent(0.2)
        self.pageControl.numberOfPages = self.pages.count
        self.pageControl.currentPage = initialPage
        self.pageControl.translatesAutoresizingMaskIntoConstraints = false
        
        self.page3.tutorialClass = self
        self.page2.tutorialClass = self
        self.page1.tutorialClass = self
        
        self.orangeContainer.topAnchor.constraint(equalTo: self.view.topAnchor, constant: 0).isActive = true
        self.orangeContainer.leftAnchor.constraint(equalTo: self.view.leftAnchor, constant: 0).isActive = true
        self.orangeContainer.rightAnchor.constraint(equalTo: self.view.rightAnchor, constant: 0).isActive = true
        self.orangeContainer.heightAnchor.constraint(equalToConstant: UIScreen.main.bounds.height / 1.7).isActive = true
        
        self.dsCompanyLogoImage.topAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.topAnchor, constant: 15).isActive = true
        self.dsCompanyLogoImage.leftAnchor.constraint(equalTo: self.view.leftAnchor, constant: 120).isActive = true
        self.dsCompanyLogoImage.rightAnchor.constraint(equalTo: self.view.rightAnchor, constant: -120).isActive = true
        self.dsCompanyLogoImage.heightAnchor.constraint(equalToConstant: 50).isActive = true

        self.pageControl.centerXAnchor.constraint(equalTo: self.view.centerXAnchor, constant: 0).isActive = true
        self.pageControl.widthAnchor.constraint(equalTo: self.view.widthAnchor, constant: -20).isActive = true
        self.pageControl.bottomAnchor.constraint(equalTo: self.orangeContainer.bottomAnchor, constant: -36).isActive = true
    }
    
    @objc func presentHomeController() {
        let homeVC = HomeViewController()
        let navVC = UINavigationController(rootViewController: homeVC)
        navVC.modalPresentationStyle = .fullScreen
        navigationController?.present(navVC, animated: true)
    }
    
    @objc func handleSignUpButton() {
        UIDevice.vibrateLight()
        let registrationController = RegistrationController()
        self.navigationController?.pushViewController(registrationController, animated: true)
    }
    
    @objc func handleLoginButton() {
        UIDevice.vibrateLight()
        let loginController = LoginController()
        self.navigationController?.pushViewController(loginController, animated: true)
    }
    
    override init(transitionStyle style: UIPageViewController.TransitionStyle, navigationOrientation: UIPageViewController.NavigationOrientation, options: [UIPageViewController.OptionsKey : Any]? = nil) {
        
        super.init(transitionStyle: .scroll, navigationOrientation: .horizontal, options: options)
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
        
        if let viewControllerIndex = self.pages.firstIndex(of: viewController) {
            if viewControllerIndex > 0 {
                return self.pages[viewControllerIndex - 1]
            }
        }
        return nil
        
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
        
        if let viewControllerIndex = self.pages.firstIndex(of: viewController) {
            if viewControllerIndex < self.pages.count - 1 {
                return self.pages[viewControllerIndex + 1]
            }
        }
        
        return nil
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, didFinishAnimating finished: Bool, previousViewControllers: [UIViewController], transitionCompleted completed: Bool) {
        
        if let viewControllers = pageViewController.viewControllers {
            if let viewControllerIndex = self.pages.firstIndex(of: viewControllers[0]) {
                self.pageControl.currentPage = viewControllerIndex
            }
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

//GOOGLE SIGN IN AND AUTHENTICATION
extension WelcomePageController : GIDSignInDelegate {
    
    @objc func handleGoogleRegistration() {
        UIDevice.vibrateLight()
        self.mainLoadingScreen.callMainLoadingScreen(lottiAnimationName: Statics.PAW_ANIMATION)
        GIDSignIn.sharedInstance().signIn()
    }
    
    func initializeGoogleAuthentication() {
        
        GIDSignIn.sharedInstance().presentingViewController = self
        GIDSignIn.sharedInstance()?.delegate = self
        
    }
    
    func sign(_ signIn: GIDSignIn!, didSignInFor user: GIDGoogleUser!, withError error: Error?) {
        
        if let error = error {
            print(error.localizedDescription as Any)
            self.mainLoadingScreen.cancelMainLoadingScreen()
            return
        }
        
        guard let authentication = user.authentication else {
            self.mainLoadingScreen.cancelMainLoadingScreen()
            return
        }
        
        let credential = GoogleAuthProvider.credential(withIDToken: authentication.idToken, accessToken: authentication.accessToken)
        
        Service.shared.firebaseGoogleSignIn(credentials: credential, referralCode: "nil") { (hasSuccess, response) in
            
            if hasSuccess {
                self.mainLoadingScreen.cancelMainLoadingScreen()
                self.presentHomeController()
            } else {
                self.mainLoadingScreen.cancelMainLoadingScreen()
            }
        }
    }
    
    func sign(_ signIn: GIDSignIn!, didDisconnectWith user: GIDGoogleUser!, withError error: Error!) {
        self.mainLoadingScreen.cancelMainLoadingScreen()
    }
}

//FACEBOOK AUTHENTICATION FLOW
extension WelcomePageController {
    
    @objc func handleFacebookRegistration() {
        
        UIDevice.vibrateLight()

        self.mainLoadingScreen.callMainLoadingScreen(lottiAnimationName: Statics.PAW_ANIMATION)

        let fbLoginManager : LoginManager = LoginManager()
        
        fbLoginManager.logIn(permissions: ["public_profile","email"], from: self) { result, error in
            
            if error != nil {
                print(error?.localizedDescription as Any)
                self.mainLoadingScreen.cancelMainLoadingScreen()
                return
            }
            
            if let token = AccessToken.current {
                
            let credential = FacebookAuthProvider.credential(withAccessToken: token.tokenString)
            
            Service.shared.firebaseGoogleSignIn(credentials: credential, referralCode: "nil") { (hasSuccess, response) in
                
                if hasSuccess {
                    self.mainLoadingScreen.cancelMainLoadingScreen()
                    self.presentHomeController()
                } else {
                    self.mainLoadingScreen.cancelMainLoadingScreen()
                }
            }
                
            } else {
                print("No token present for FB auth, check the developers dashboard.")
                self.mainLoadingScreen.cancelMainLoadingScreen()
            }
        }
    }
}
