//
//  TutorialController.swift
//  DSGroomer
//
//  Created by Charlie Arcodia on 5/30/21.
//

import UIKit
import UserNotifications

class WelcomePageController: UIPageViewController, UIPageViewControllerDataSource, UIPageViewControllerDelegate {
    private let backImage = UIImage(named: Constants.backIcon)?.withRenderingMode(.alwaysOriginal)
    private var pages = [UIViewController]()
    private var isNotificationsEnabled : Bool = false
    private var gradientLayer: CAGradientLayer!
    private var hasViewBeenLaidOut : Bool = false
    
    private let pageControl = UIPageControl()
    private let initialPage = 0
    private let page1 = SlideOne()
    private let page2 = SlideTwo()
    private let page3 = SlideThree()
    
    private lazy var signUpButton: DSButton = {
        let cbf = DSButton(titleText: "Sign Up", backgroundColor: .dsOrange, titleColor: .white)
        cbf.addTarget(self, action: #selector(self.handleSignUpButton), for: UIControl.Event.touchUpInside)
        return cbf
    }()
    
    private lazy var loginButton: DSButton = {
        let cbf = DSButton(titleText: "Login", backgroundColor: .white, titleColor: .dsOrange)
        cbf.addTarget(self, action: #selector(self.handleLoginButton), for: UIControl.Event.touchUpInside)
        return cbf
    }()
    
    private let dsCompanyLogoImage = LogoImageView(withImage: UIImage(named: Constants.dsLogoWhite))
    
    private let registerWithfacebookButton : UIButton = {
        let cbf = UIButton(type: .system)
        cbf.backgroundColor = .clear
        let image = UIImage(named: "Facebook Connect")?.withRenderingMode(.alwaysOriginal)
        cbf.setImage(image, for: .normal)
        cbf.imageView?.contentMode = .scaleAspectFit
        //cbf.addTarget(self, action: #selector(self.handleFacebookRegistration), for: UIControl.Event.touchUpInside)
        return cbf
        
    }()
    
    private let registerWithGoogleButton : UIButton = {
        let cbf = UIButton(type: .system)
        cbf.backgroundColor = .clear
        let image = UIImage(named: "Google Connect")?.withRenderingMode(.alwaysOriginal)
        cbf.setImage(image, for: .normal)
        cbf.imageView?.contentMode = .scaleAspectFit
        //cbf.addTarget(self, action: #selector(self.handleGoogleRegistration), for: UIControl.Event.touchUpInside)
        return cbf
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.configureVC()
        self.addViews()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(true)
        navigationController?.navigationBar.barStyle = .black
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        self.navigationController?.navigationBar.isHidden = true
        self.navigationController?.navigationBar.barStyle = .default
        self.navigationItem.setHidesBackButton(true, animated: false)
    }
    
    override init(transitionStyle style: UIPageViewController.TransitionStyle, navigationOrientation: UIPageViewController.NavigationOrientation, options: [UIPageViewController.OptionsKey : Any]? = nil) {
        
        super.init(transitionStyle: .scroll, navigationOrientation: .horizontal, options: options)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

//MARK: - Configure View Controller
extension WelcomePageController {
    private func configureVC() {
        self.view.backgroundColor = .white
//        self.navigationController?.navigationBar.backIndicatorImage = backImage
//        self.navigationController?.navigationBar.backIndicatorTransitionMaskImage = backImage
        self.navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
        self.dataSource = self
        self.delegate = self
        
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
    }
}

//MARK: - Configure Views
extension WelcomePageController {
    private func addViews() {
        self.view.addSubview(self.dsCompanyLogoImage)
        self.dsCompanyLogoImage.topAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.topAnchor, constant: 15).isActive = true
        self.dsCompanyLogoImage.leftAnchor.constraint(equalTo: self.view.leftAnchor, constant: 120).isActive = true
        self.dsCompanyLogoImage.rightAnchor.constraint(equalTo: self.view.rightAnchor, constant: -120).isActive = true
        self.dsCompanyLogoImage.heightAnchor.constraint(equalToConstant: 50).isActive = true
        
        self.view.addSubview(self.pageControl)
        self.pageControl.bottomAnchor.constraint(equalTo: self.view.centerYAnchor, constant: 60).isActive = true
        self.pageControl.centerXAnchor.constraint(equalTo: self.view.centerXAnchor, constant: 0).isActive = true
        self.pageControl.widthAnchor.constraint(equalTo: self.view.widthAnchor, constant: -20).isActive = true
        self.pageControl.heightAnchor.constraint(equalToConstant: 30).isActive = true
        
        self.view.addSubview(self.signUpButton)
        signUpButton.topToBottom(of: pageControl, offset: 40)
        signUpButton.left(to: view, offset: 30)
        signUpButton.height(60)
        signUpButton.right(to: view, offset: -30)
        
        self.view.addSubview(self.loginButton)
        loginButton.topToBottom(of: signUpButton, offset: 25)
        loginButton.left(to: signUpButton)
        loginButton.height(60)
        loginButton.right(to: signUpButton)
        
        self.view.addSubview(self.registerWithGoogleButton)
        registerWithGoogleButton.topToBottom(of: loginButton, offset: 25)
        registerWithGoogleButton.left(to: signUpButton)
        registerWithGoogleButton.height(50)
        registerWithGoogleButton.right(to: signUpButton)
        
        self.view.addSubview(self.registerWithfacebookButton)
        registerWithfacebookButton.topToBottom(of: registerWithGoogleButton, offset: 4)
        registerWithfacebookButton.left(to: signUpButton)
        registerWithfacebookButton.height(50)
        registerWithfacebookButton.right(to: signUpButton)
    }
}

//MARK: - PageViewController DataSource & Delegate
extension WelcomePageController {
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
}
//MARK: - Helpers
extension WelcomePageController { }

//MARK: - @objc
extension WelcomePageController {
    @objc func handleSignUpButton() {
        let registrationController = RegistrationController()
        self.navigationController?.pushViewController(registrationController, animated: true)
    }
    
    @objc func handleLoginButton() {
        let loginController = LoginController()
        self.navigationController?.pushViewController(loginController, animated: true)
    }
}
