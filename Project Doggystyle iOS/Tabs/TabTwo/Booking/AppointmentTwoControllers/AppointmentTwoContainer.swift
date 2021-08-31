//
//  AppointmentOneContainer.swift
//  Project Doggystyle iOS
//
//  Created by Charlie Arcodia on 8/23/21.
//

import Foundation
import UIKit


class AppointmentTwoContainer : UIView, UIScrollViewDelegate {
    
    var appointmentTwo : AppointmentTwo?
    private let pageControl = UIPageControl()
    var initialPage = 0
    
    lazy var scrollView : UIScrollView = {
        
        let sv = UIScrollView()
        sv.translatesAutoresizingMaskIntoConstraints = false
        sv.backgroundColor = coreBackgroundWhite
        sv.isScrollEnabled = true
        sv.minimumZoomScale = 1.0
        sv.maximumZoomScale = 1.0
        sv.bounces = true
        sv.bouncesZoom = true
        sv.isHidden = false
        sv.delegate = self
        sv.contentMode = .scaleAspectFit
        sv.isUserInteractionEnabled = true
        sv.delaysContentTouches = false
        return sv
        
    }()
    
    let topDescriptionLevel : UILabel = {
        
        let nl = UILabel()
        nl.translatesAutoresizingMaskIntoConstraints = false
        nl.backgroundColor = .clear
        nl.text = "Please select which date you’d like to begin your grooming cycle on:"
        nl.font = UIFont(name: rubikRegular, size: 16)
        nl.textColor = coreBlackColor
        nl.textAlignment = .left
        nl.adjustsFontSizeToFitWidth = true
        nl.numberOfLines = -1
        
       return nl
    }()
    
    let selectionContainerOne : UIView = {
        
        let co = UIView()
        co.translatesAutoresizingMaskIntoConstraints = false
        co.backgroundColor = coreWhiteColor
        co.layer.masksToBounds = true
        co.layer.cornerRadius = 15
        
       return co
    }()
    
    let selectionContainerTwo : UIView = {
        
        let co = UIView()
        co.translatesAutoresizingMaskIntoConstraints = false
        co.backgroundColor = coreWhiteColor
        co.layer.masksToBounds = true
        co.layer.cornerRadius = 15
        
       return co
    }()
    
    let containerOneCircleView : UIView = {
        
        let co = UIView()
        co.translatesAutoresizingMaskIntoConstraints = false
        co.backgroundColor = coreWhiteColor
        co.layer.masksToBounds = true
        co.layer.cornerRadius = 15
        co.layer.borderWidth = 4
        co.layer.borderColor = circleGrey.cgColor
        co.layer.cornerRadius = 29/2
        
        return co
    }()
    
    let containerTwoCircleView : UIView = {
        
        let co = UIView()
        co.translatesAutoresizingMaskIntoConstraints = false
        co.backgroundColor = coreWhiteColor
        co.layer.masksToBounds = true
        co.layer.cornerRadius = 15
        co.layer.borderWidth = 4
        co.layer.borderColor = circleGrey.cgColor
        co.layer.cornerRadius = 29/2
        
        return co
    }()
    
    let containerOneLabel : UILabel = {
        
        let nl = UILabel()
        nl.translatesAutoresizingMaskIntoConstraints = false
        nl.backgroundColor = .clear
        nl.text = "Date transfers: 1"
        nl.font = UIFont(name: rubikMedium, size: 16)
        nl.textColor = coreBlackColor
        nl.textAlignment = .left
        nl.adjustsFontSizeToFitWidth = true
        nl.numberOfLines = -1
        
       return nl
    }()
    
    let containerTwoLabel : UILabel = {
        
        let nl = UILabel()
        nl.translatesAutoresizingMaskIntoConstraints = false
        nl.backgroundColor = .clear
        nl.text = "Date transfers: 2"
        nl.font = UIFont(name: rubikMedium, size: 16)
        nl.textColor = coreBlackColor
        nl.textAlignment = .left
        nl.adjustsFontSizeToFitWidth = true
        nl.numberOfLines = -1
        
       return nl
    }()
    
    let bottomDescriptionLevel : UILabel = {
        
        let nl = UILabel()
        nl.translatesAutoresizingMaskIntoConstraints = false
        nl.backgroundColor = .clear
        nl.text = "Select your desired grooming service time. *Note times are rough approximations only."
        nl.font = UIFont(name: rubikRegular, size: 16)
        nl.textColor = coreBlackColor
        nl.textAlignment = .left
        nl.adjustsFontSizeToFitWidth = true
        nl.numberOfLines = -1
        
       return nl
    }()
    
    let swipeForMoreTimesLevel : UILabel = {
        
        let nl = UILabel()
        nl.translatesAutoresizingMaskIntoConstraints = false
        nl.backgroundColor = .clear
        nl.text = "Swipe for more times"
        nl.font = UIFont(name: rubikItalic, size: 12)
        nl.textColor = dsFontGreyPageControl
        nl.textAlignment = .center
        nl.adjustsFontSizeToFitWidth = true
        nl.numberOfLines = 1
        
       return nl
    }()
    
    lazy var appointmentTwoCollection : AppointmentTwoCollection = {
        
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        let act = AppointmentTwoCollection(frame: .zero, collectionViewLayout: layout)
        act.appointmentTwoContainer = self
        
       return act
    }()
    
    lazy var nextButton: UIButton = {
        
        let cbf = UIButton(type: .system)
        cbf.translatesAutoresizingMaskIntoConstraints = false
        cbf.setTitle("Next", for: UIControl.State.normal)
        cbf.titleLabel?.font = UIFont.init(name: dsHeaderFont, size: 18)
        cbf.titleLabel?.adjustsFontSizeToFitWidth = true
        cbf.titleLabel?.numberOfLines = 1
        cbf.titleLabel?.adjustsFontForContentSizeCategory = true
        cbf.layer.cornerRadius = 12
        cbf.layer.masksToBounds = true
        cbf.tintColor = coreWhiteColor
        cbf.backgroundColor = coreOrangeColor
        cbf.isHidden = false
        cbf.addTarget(self, action: #selector(self.handleNextButton), for: .touchUpInside)
        
        return cbf
        
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.backgroundColor = coreBackgroundWhite
        self.translatesAutoresizingMaskIntoConstraints = false
        self.scrollView.keyboardDismissMode = .interactive
        self.addViews()
        
    }
    
    func addViews() {
        
        self.addSubview(self.scrollView)
        
        self.scrollView.addSubview(self.topDescriptionLevel)
        self.scrollView.addSubview(self.selectionContainerOne)
        self.scrollView.addSubview(self.selectionContainerTwo)
        
        self.selectionContainerOne.addSubview(self.containerOneCircleView)
        self.selectionContainerOne.addSubview(self.containerOneLabel)

        self.selectionContainerTwo.addSubview(self.containerTwoCircleView)
        self.selectionContainerTwo.addSubview(self.containerTwoLabel)
        
        self.scrollView.addSubview(self.bottomDescriptionLevel)
        self.scrollView.addSubview(self.appointmentTwoCollection)
        self.scrollView.addSubview(self.pageControl)
        self.scrollView.addSubview(self.swipeForMoreTimesLevel)
        self.scrollView.addSubview(self.nextButton)
        
        self.scrollView.topAnchor.constraint(equalTo: self.topAnchor, constant: 0).isActive = true
        self.scrollView.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: 0).isActive = true
        self.scrollView.leftAnchor.constraint(equalTo: self.leftAnchor, constant: 0).isActive = true
        self.scrollView.rightAnchor.constraint(equalTo: self.rightAnchor, constant: 0).isActive = true
        
        let screenHeight = UIScreen.main.bounds.height
        print("Screen height is: \(screenHeight)")
        
        switch screenHeight {
        
        //MANUAL CONFIGURATION - REFACTOR FOR UNNIVERSAL FITMENT
        case 926 : scrollView.contentSize = CGSize(width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height - 175)
        case 896 : scrollView.contentSize = CGSize(width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height - 175)
        case 844 : scrollView.contentSize = CGSize(width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height - 175)
        case 812 : scrollView.contentSize = CGSize(width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height - 140)
        case 736 : scrollView.contentSize = CGSize(width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height - 140)
        case 667 : scrollView.contentSize = CGSize(width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height - 140)
        case 568 : scrollView.contentSize = CGSize(width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height - 140)
        case 480 : scrollView.contentSize = CGSize(width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height - 140)
            
        default : scrollView.contentSize = CGSize(width: UIScreen.main.bounds.height, height: UIScreen.main.bounds.height * 1.5)
            
        }
        
        self.scrollView.isScrollEnabled = true

        self.topDescriptionLevel.topAnchor.constraint(equalTo: self.scrollView.topAnchor, constant: 0).isActive = true
        self.topDescriptionLevel.leftAnchor.constraint(equalTo: self.leftAnchor, constant: 30).isActive = true
        self.topDescriptionLevel.rightAnchor.constraint(equalTo: self.rightAnchor, constant: -30).isActive = true
        self.topDescriptionLevel.sizeToFit()
        
        self.selectionContainerOne.topAnchor.constraint(equalTo: self.topDescriptionLevel.bottomAnchor, constant: 30).isActive = true
        self.selectionContainerOne.leftAnchor.constraint(equalTo: self.topDescriptionLevel.leftAnchor, constant: 0).isActive = true
        self.selectionContainerOne.rightAnchor.constraint(equalTo: self.topDescriptionLevel.rightAnchor, constant: 0).isActive = true
        self.selectionContainerOne.heightAnchor.constraint(equalToConstant: 63).isActive = true

        self.selectionContainerTwo.topAnchor.constraint(equalTo: self.selectionContainerOne.bottomAnchor, constant: 20).isActive = true
        self.selectionContainerTwo.leftAnchor.constraint(equalTo: self.topDescriptionLevel.leftAnchor, constant: 0).isActive = true
        self.selectionContainerTwo.rightAnchor.constraint(equalTo: self.topDescriptionLevel.rightAnchor, constant: 0).isActive = true
        self.selectionContainerTwo.heightAnchor.constraint(equalToConstant: 63).isActive = true
        
        self.containerOneCircleView.centerYAnchor.constraint(equalTo: self.selectionContainerOne.centerYAnchor, constant: 0).isActive = true
        self.containerOneCircleView.leftAnchor.constraint(equalTo: self.selectionContainerOne.leftAnchor, constant: 17).isActive = true
        self.containerOneCircleView.heightAnchor.constraint(equalToConstant: 29).isActive = true
        self.containerOneCircleView.widthAnchor.constraint(equalToConstant: 29).isActive = true

        self.containerTwoCircleView.centerYAnchor.constraint(equalTo: self.selectionContainerTwo.centerYAnchor, constant: 0).isActive = true
        self.containerTwoCircleView.leftAnchor.constraint(equalTo: self.selectionContainerTwo.leftAnchor, constant: 17).isActive = true
        self.containerTwoCircleView.heightAnchor.constraint(equalToConstant: 29).isActive = true
        self.containerTwoCircleView.widthAnchor.constraint(equalToConstant: 29).isActive = true
        
        self.containerOneLabel.leftAnchor.constraint(equalTo: self.containerOneCircleView.rightAnchor, constant: 10).isActive = true
        self.containerOneLabel.rightAnchor.constraint(equalTo: self.selectionContainerOne.rightAnchor, constant: -30).isActive = true
        self.containerOneLabel.topAnchor.constraint(equalTo: self.selectionContainerOne.topAnchor, constant: 0).isActive = true
        self.containerOneLabel.bottomAnchor.constraint(equalTo: self.selectionContainerOne.bottomAnchor, constant: 0).isActive = true
      
        self.containerTwoLabel.leftAnchor.constraint(equalTo: self.containerTwoCircleView.rightAnchor, constant: 10).isActive = true
        self.containerTwoLabel.rightAnchor.constraint(equalTo: self.selectionContainerTwo.rightAnchor, constant: -30).isActive = true
        self.containerTwoLabel.topAnchor.constraint(equalTo: self.selectionContainerTwo.topAnchor, constant: 0).isActive = true
        self.containerTwoLabel.bottomAnchor.constraint(equalTo: self.selectionContainerTwo.bottomAnchor, constant: 0).isActive = true
        
        self.bottomDescriptionLevel.topAnchor.constraint(equalTo: self.selectionContainerTwo.bottomAnchor, constant: 30).isActive = true
        self.bottomDescriptionLevel.leftAnchor.constraint(equalTo: self.leftAnchor, constant: 30).isActive = true
        self.bottomDescriptionLevel.rightAnchor.constraint(equalTo: self.rightAnchor, constant: -30).isActive = true
        self.bottomDescriptionLevel.sizeToFit()
        
        self.appointmentTwoCollection.topAnchor.constraint(equalTo: self.bottomDescriptionLevel.bottomAnchor, constant: 30).isActive = true
        self.appointmentTwoCollection.leftAnchor.constraint(equalTo: self.leftAnchor, constant: 30).isActive = true
        self.appointmentTwoCollection.rightAnchor.constraint(equalTo: self.rightAnchor, constant: -30).isActive = true
        self.appointmentTwoCollection.heightAnchor.constraint(equalToConstant: 150).isActive = true
        
        self.pageControl.currentPageIndicatorTintColor = .orange
        self.pageControl.pageIndicatorTintColor = circleGrey
        self.pageControl.numberOfPages = 3
        self.pageControl.currentPage = initialPage
        self.pageControl.translatesAutoresizingMaskIntoConstraints = false
        
        self.pageControl.topAnchor.constraint(equalTo: self.appointmentTwoCollection.bottomAnchor, constant: 15).isActive = true
        self.pageControl.leftAnchor.constraint(equalTo: self.appointmentTwoCollection.leftAnchor, constant: 30).isActive = true
        self.pageControl.rightAnchor.constraint(equalTo: self.appointmentTwoCollection.rightAnchor, constant: -30).isActive = true
        self.pageControl.heightAnchor.constraint(equalToConstant: 30).isActive = true
        
        self.swipeForMoreTimesLevel.topAnchor.constraint(equalTo: self.pageControl.bottomAnchor, constant: 10).isActive = true
        self.swipeForMoreTimesLevel.leftAnchor.constraint(equalTo: self.leftAnchor, constant: 30).isActive = true
        self.swipeForMoreTimesLevel.rightAnchor.constraint(equalTo: self.rightAnchor, constant: -30).isActive = true
        self.swipeForMoreTimesLevel.sizeToFit()
        
        self.nextButton.topAnchor.constraint(equalTo: self.swipeForMoreTimesLevel.bottomAnchor, constant: 53).isActive = true
        self.nextButton.leftAnchor.constraint(equalTo: self.leftAnchor, constant: 30).isActive = true
        self.nextButton.rightAnchor.constraint(equalTo: self.rightAnchor, constant: -30).isActive = true
        self.nextButton.heightAnchor.constraint(equalToConstant: 60).isActive = true
        
    }
    
    @objc func handleNextButton() {
        self.appointmentTwo?.handleNextButton()
    }
    
    required init?(coder: NSCoder) {
        fatalError("coder error \(coder)")
    }
    
}
