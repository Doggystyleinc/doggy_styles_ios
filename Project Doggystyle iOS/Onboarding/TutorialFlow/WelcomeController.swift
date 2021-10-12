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

class WelcomePageController: UIPageViewController, UIPageViewControllerDataSource, UIPageViewControllerDelegate, UITextViewDelegate {
    
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
    
    private let topContainer : UIView = {
        
        let oc = UIView()
        oc.translatesAutoresizingMaskIntoConstraints = false
        oc.backgroundColor = .dsOrange
        oc.isUserInteractionEnabled = false
        
        return oc
        
    }()
    
    var bottomContainer : UIView = {
        
        let tc = UIView()
        tc.translatesAutoresizingMaskIntoConstraints = false
        tc.backgroundColor = coreBackgroundWhite
        tc.isUserInteractionEnabled = true
        
       return tc
    }()
    
    lazy var registrationButton : UIButton = {
        
        let cbf = UIButton(type: .system)
        cbf.translatesAutoresizingMaskIntoConstraints = false
        cbf.setTitle("Sign up with email", for: UIControl.State.normal)
        cbf.titleLabel?.font = UIFont.init(name: dsHeaderFont, size: 18)
        cbf.titleLabel?.adjustsFontSizeToFitWidth = true
        cbf.titleLabel?.numberOfLines = 1
        cbf.titleLabel?.adjustsFontForContentSizeCategory = true
        cbf.titleLabel?.textColor = coreBlackColor
        cbf.backgroundColor = coreOrangeColor
        cbf.layer.cornerRadius = 15
        cbf.layer.masksToBounds = true
        cbf.tintColor = coreWhiteColor
        cbf.addTarget(self, action: #selector(self.handleSignUpButton), for: UIControl.Event.touchUpInside)
        
        return cbf
        
    }()
    
    lazy var applyButton : UIButton = {
        
        let cbf = UIButton(type: .system)
        cbf.translatesAutoresizingMaskIntoConstraints = false
        cbf.setTitle("Login with email", for: UIControl.State.normal)
        cbf.titleLabel?.font = UIFont.init(name: dsHeaderFont, size: 18)
        cbf.titleLabel?.adjustsFontSizeToFitWidth = true
        cbf.titleLabel?.numberOfLines = 1
        cbf.titleLabel?.adjustsFontForContentSizeCategory = true
        cbf.backgroundColor = coreOrangeColor.withAlphaComponent(0.2)
        cbf.layer.cornerRadius = 15
        cbf.layer.masksToBounds = true
        cbf.tintColor = coreOrangeColor
        cbf.addTarget(self, action: #selector(self.handleLoginButton), for: UIControl.Event.touchUpInside)

        return cbf
        
    }()
    
    let dsLogoImage : UIImageView = {
        
        let dcl = UIImageView()
        dcl.translatesAutoresizingMaskIntoConstraints = false
        dcl.backgroundColor = .clear
        dcl.contentMode = .scaleAspectFit
        dcl.isUserInteractionEnabled = false
        let image = UIImage(named: "DS Logo White")?.withRenderingMode(.alwaysOriginal)
        dcl.image = image
        
        return dcl
    }()
    
    let welcomeLabel : UILabel = {
        
        let thl = UILabel()
        thl.translatesAutoresizingMaskIntoConstraints = false
        thl.textAlignment = .left
        thl.text = "Welcome to the Doggystyle app!"
        thl.font = UIFont(name: dsHeaderFont, size: 28)
        thl.numberOfLines = 2
        thl.adjustsFontSizeToFitWidth = false
        thl.textColor = coreWhiteColor
        return thl
        
    }()
    
    let vanImage : UIImageView = {
        
        let dcl = UIImageView()
        dcl.translatesAutoresizingMaskIntoConstraints = false
        dcl.backgroundColor = .clear
        dcl.contentMode = .scaleAspectFill
        dcl.isUserInteractionEnabled = false
        let image = UIImage(named: "stylist_van_image")?.withRenderingMode(.alwaysOriginal)
        dcl.image = image
        
        return dcl
    }()
    
    lazy var termsTextView : UITextView = {
        
        let tv = UITextView()
        
        tv.translatesAutoresizingMaskIntoConstraints = false
        tv.backgroundColor = UIColor .clear
        
        var myMutableString = NSMutableAttributedString()
        
        let partOne = "Inquiring?"
        let partTwo = " Get the Stylist app"
        
        let screenHeight = UIScreen.main.bounds.height
        var fontSize : CGFloat = 12
        
        myMutableString = NSMutableAttributedString(string: partOne + partTwo as String, attributes: [NSAttributedString.Key.font:UIFont(name: rubikRegular, size: 14)!])
        
        myMutableString.addAttribute(NSAttributedString.Key.foregroundColor, value: dsDeepBlue.withAlphaComponent(1.0), range: NSRange(location:0,length:partOne.count))
        
        myMutableString.addAttribute(NSAttributedString.Key.font, value: UIFont(name: rubikRegular, size: fontSize)!, range: NSRange(location: 0,length:partOne.count))
        
        myMutableString.addAttribute(NSAttributedString.Key.foregroundColor, value: dsDeepBlue.withAlphaComponent(1.0), range: NSRange(location:partOne.count,length:partTwo.count))
        
        myMutableString.addAttribute(NSAttributedString.Key.font, value: UIFont(name: rubikRegular, size: fontSize)!, range: NSRange(location: partOne.count,length:partTwo.count))
        
        myMutableString.addAttribute(NSAttributedString.Key.underlineStyle, value: NSUnderlineStyle.single.rawValue, range: NSRange(location: partOne.count,length:partTwo.count))
       
        _ = myMutableString.setAsLink(textToFind: "Get the Stylist app", linkURL: Statics.DOGGYSTYLE_STYLIST_APP_URL)
        
        tv.linkTextAttributes = [
            .foregroundColor: dsDeepBlue,
            .underlineColor: dsDeepBlue,
            .underlineStyle: NSUnderlineStyle.single.rawValue,
            .font : dsHeaderFont
        ]
        
        tv.attributedText = myMutableString
        tv.layer.masksToBounds = true
        tv.textAlignment = .center
        tv.delegate = self
        tv.isUserInteractionEnabled = true
        tv.isScrollEnabled = true
        tv.isEditable = false
        tv.isSelectable = true
        
        return tv
        
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
        
        self.view.addSubview(self.topContainer)
        self.topContainer.addSubview(self.dsLogoImage)
        self.topContainer.addSubview(self.welcomeLabel)
        self.topContainer.addSubview(self.vanImage)
        
        self.view.addSubview(self.bottomContainer)
        self.bottomContainer.addSubview(self.registrationButton)
        self.bottomContainer.addSubview(self.applyButton)
        self.bottomContainer.addSubview(self.termsTextView)

        self.view.addSubview(self.pageControl)

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
        
        self.bottomContainer.bottomAnchor.constraint(equalTo: self.view.bottomAnchor, constant: 0).isActive = true
        self.bottomContainer.leftAnchor.constraint(equalTo: self.view.leftAnchor, constant: 0).isActive = true
        self.bottomContainer.rightAnchor.constraint(equalTo: self.view.rightAnchor, constant: 0).isActive = true
        self.bottomContainer.heightAnchor.constraint(equalToConstant: self.view.frame.height / 3).isActive = true

        self.topContainer.topAnchor.constraint(equalTo: self.view.topAnchor, constant: 0).isActive = true
        self.topContainer.leftAnchor.constraint(equalTo: self.view.leftAnchor, constant: 0).isActive = true
        self.topContainer.rightAnchor.constraint(equalTo: self.view.rightAnchor, constant: 0).isActive = true
        self.topContainer.bottomAnchor.constraint(equalTo: self.bottomContainer.topAnchor, constant: 0).isActive = true
        
        self.pageControl.centerXAnchor.constraint(equalTo: self.view.centerXAnchor, constant: 0).isActive = true
        self.pageControl.widthAnchor.constraint(equalTo: self.view.widthAnchor, constant: -20).isActive = true
        self.pageControl.bottomAnchor.constraint(equalTo: self.topContainer.bottomAnchor, constant: -26).isActive = true
        
        self.registrationButton.topAnchor.constraint(equalTo: self.bottomContainer.topAnchor, constant: 25).isActive = true
        self.registrationButton.leftAnchor.constraint(equalTo: self.bottomContainer.leftAnchor, constant: 30).isActive = true
        self.registrationButton.rightAnchor.constraint(equalTo: self.bottomContainer.rightAnchor, constant: -30).isActive = true
        self.registrationButton.heightAnchor.constraint(equalToConstant: 60).isActive = true
        
        self.applyButton.topAnchor.constraint(equalTo: self.registrationButton.bottomAnchor, constant: 20).isActive = true
        self.applyButton.leftAnchor.constraint(equalTo: self.bottomContainer.leftAnchor, constant: 30).isActive = true
        self.applyButton.rightAnchor.constraint(equalTo: self.bottomContainer.rightAnchor, constant: -30).isActive = true
        self.applyButton.heightAnchor.constraint(equalToConstant: 60).isActive = true
        
        self.registrationButton.topAnchor.constraint(equalTo: self.bottomContainer.topAnchor, constant: 25).isActive = true
        self.registrationButton.leftAnchor.constraint(equalTo: self.bottomContainer.leftAnchor, constant: 30).isActive = true
        self.registrationButton.rightAnchor.constraint(equalTo: self.bottomContainer.rightAnchor, constant: -30).isActive = true
        self.registrationButton.heightAnchor.constraint(equalToConstant: 60).isActive = true
        
        self.applyButton.topAnchor.constraint(equalTo: self.registrationButton.bottomAnchor, constant: 20).isActive = true
        self.applyButton.leftAnchor.constraint(equalTo: self.bottomContainer.leftAnchor, constant: 30).isActive = true
        self.applyButton.rightAnchor.constraint(equalTo: self.bottomContainer.rightAnchor, constant: -30).isActive = true
        self.applyButton.heightAnchor.constraint(equalToConstant: 60).isActive = true
        
        self.dsLogoImage.topAnchor.constraint(equalTo: self.topContainer.topAnchor, constant: 108).isActive = true
        self.dsLogoImage.leftAnchor.constraint(equalTo: self.topContainer.leftAnchor, constant: 59).isActive = true
        self.dsLogoImage.widthAnchor.constraint(equalToConstant: 106).isActive = true
        self.dsLogoImage.heightAnchor.constraint(equalToConstant: 26).isActive = true
        
        self.welcomeLabel.topAnchor.constraint(equalTo: self.dsLogoImage.bottomAnchor, constant: 20).isActive = true
        self.welcomeLabel.leftAnchor.constraint(equalTo: self.dsLogoImage.leftAnchor, constant: 0).isActive = true
        self.welcomeLabel.rightAnchor.constraint(equalTo: self.topContainer.rightAnchor, constant: -30).isActive = true
        self.welcomeLabel.sizeToFit()
        
        self.vanImage.topAnchor.constraint(equalTo: self.dsLogoImage.bottomAnchor, constant: 0).isActive = true
        self.vanImage.leftAnchor.constraint(equalTo: self.topContainer.leftAnchor, constant: 0).isActive = true
        self.vanImage.rightAnchor.constraint(equalTo: self.topContainer.rightAnchor, constant: 0).isActive = true
        self.vanImage.bottomAnchor.constraint(equalTo: self.topContainer.bottomAnchor, constant: -40).isActive = true
        
        self.termsTextView.bottomAnchor.constraint(equalTo: self.bottomContainer.bottomAnchor, constant: -30).isActive = true
        self.termsTextView.leftAnchor.constraint(equalTo: self.bottomContainer.leftAnchor, constant: 30).isActive = true
        self.termsTextView.rightAnchor.constraint(equalTo: self.bottomContainer.rightAnchor, constant: -30).isActive = true
        self.termsTextView.heightAnchor.constraint(equalToConstant: 30).isActive = true
        
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
