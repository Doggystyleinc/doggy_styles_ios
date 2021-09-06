//
//  UnavailbleAptScreen.swift
//  Project Doggystyle iOS
//
//  Created by Charlie Arcodia on 9/6/21.
//

import Foundation
import UIKit

class UnavailableAptController : UIViewController {
    
    lazy var stackView : UIStackView = {
        
        let sv = UIStackView()
        sv.translatesAutoresizingMaskIntoConstraints = false
        sv.axis = .horizontal
        sv.distribution = .equalSpacing
        sv.alignment = .center
        sv.isHidden = true
        
        return sv
    }()

    let headerBarOne : UIView = {
        
        let hbo = UIView()
        hbo.translatesAutoresizingMaskIntoConstraints = false
        hbo.backgroundColor = coreOrangeColor
        hbo.layer.masksToBounds = true
        
        return hbo
    }()

    let headerBarTwo : UIView = {
        
        let hbo = UIView()
        hbo.translatesAutoresizingMaskIntoConstraints = false
        hbo.backgroundColor = coreOrangeColor
        return hbo
    }()

    let headerBarThree : UIView = {
        
        let hbo = UIView()
        hbo.translatesAutoresizingMaskIntoConstraints = false
        hbo.backgroundColor = coreOrangeColor
        return hbo
    }()

    let headerBarFour : UIView = {
        
        let hbo = UIView()
        hbo.translatesAutoresizingMaskIntoConstraints = false
        hbo.backgroundColor = coreOrangeColor
        return hbo
    }()

    let timeCover : UIView = {
        
        let tc = UIView()
        tc.translatesAutoresizingMaskIntoConstraints = false
        tc.backgroundColor = coreBackgroundWhite
        
        return tc
    }()

    let wereSorrylabel : UILabel = {
        
        let nl = UILabel()
        nl.translatesAutoresizingMaskIntoConstraints = false
        nl.backgroundColor = .clear
        nl.text = "We’re sorry"
        nl.font = UIFont(name: dsHeaderFont, size: 24)
        nl.textColor = coreBlackColor
        nl.textAlignment = .left
        nl.adjustsFontSizeToFitWidth = true
        
        return nl
    }()

    lazy var cancelButton : UIButton = {
        
        let cbf = UIButton(type: .system)
        cbf.translatesAutoresizingMaskIntoConstraints = false
        cbf.backgroundColor = .clear
        cbf.tintColor = UIColor.dsOrange
        cbf.contentMode = .scaleAspectFill
        cbf.titleLabel?.font = UIFont.fontAwesome(ofSize: 20, style: .solid)
        cbf.setTitle(String.fontAwesomeIcon(name: .chevronLeft), for: .normal)
        cbf.isHidden = true
        cbf.addTarget(self, action: #selector(self.handleCancelButton), for: UIControl.Event.touchUpInside)
        return cbf
        
    }()

    lazy var xButton : UIButton = {
        
        let cbf = UIButton(type: .system)
        cbf.translatesAutoresizingMaskIntoConstraints = false
        cbf.backgroundColor = .clear
        cbf.contentMode = .scaleAspectFill
        cbf.titleLabel?.font = UIFont.fontAwesome(ofSize: 20, style: .solid)
        cbf.setTitle(String.fontAwesomeIcon(name: .times), for: .normal)
        cbf.setTitleColor(dsRedColor, for: .normal)
        cbf.addTarget(self, action: #selector(self.handleBackButton), for: UIControl.Event.touchUpInside)
        return cbf
        
    }()

    var headerContainer : UIView = {
        
        let hc = UIView()
        hc.translatesAutoresizingMaskIntoConstraints = false
        hc.backgroundColor = .clear
        hc.isUserInteractionEnabled = false
        
        return hc
    }()
    
    let sorrySubHeaderLabel : UILabel = {
        
        let nl = UILabel()
        nl.translatesAutoresizingMaskIntoConstraints = false
        nl.backgroundColor = .clear
        nl.text = "We’re sorry this appointment has been claimed already. Sucks right?! We’ll let you know if another becomes available again."
        nl.font = UIFont(name: rubikRegular, size: 16)
        nl.textColor = coreBlackColor
        nl.textAlignment = .left
        nl.numberOfLines = -1
        
        return nl
    }()
    
    lazy var returnToDashboardButton: UIButton = {
        
        let cbf = UIButton(type: .system)
        cbf.translatesAutoresizingMaskIntoConstraints = false
        cbf.setTitle("Back to Dashboard", for: UIControl.State.normal)
        cbf.titleLabel?.font = UIFont.init(name: dsHeaderFont, size: 18)
        cbf.titleLabel?.adjustsFontSizeToFitWidth = true
        cbf.titleLabel?.numberOfLines = 1
        cbf.titleLabel?.adjustsFontForContentSizeCategory = true
        cbf.layer.cornerRadius = 12
        cbf.layer.masksToBounds = true
        cbf.tintColor = coreWhiteColor
        cbf.backgroundColor = coreOrangeColor
        cbf.isHidden = false
        cbf.addTarget(self, action: #selector(self.handleCancelButton), for: .touchUpInside)
        
        return cbf
        
    }()
    
    let puppyImage : UIImageView = {
        
        let pii = UIImageView()
        pii.translatesAutoresizingMaskIntoConstraints = false
        pii.isUserInteractionEnabled = false
        pii.contentMode = .scaleAspectFill
        pii.layer.masksToBounds = true
        pii.backgroundColor = coreBackgroundWhite
        let image = UIImage(named: "sorry_dog_image")?.withRenderingMode(.alwaysOriginal)
        pii.image = image
        
       return pii
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.backgroundColor = coreBackgroundWhite
        self.addViews()
        
    }

    func addViews() {
        
        self.view.addSubview(self.stackView)
        
        self.stackView.addArrangedSubview(self.headerBarOne)
        self.stackView.addArrangedSubview(self.headerBarTwo)
        self.stackView.addArrangedSubview(self.headerBarThree)
        self.stackView.addArrangedSubview(self.headerBarFour)
        
        self.view.addSubview(self.headerContainer)
        self.view.addSubview(self.cancelButton)
        self.view.addSubview(self.xButton)
        self.view.addSubview(self.wereSorrylabel)
        self.view.addSubview(self.timeCover)
        self.view.addSubview(self.sorrySubHeaderLabel)
        self.view.addSubview(self.returnToDashboardButton)
        self.view.addSubview(self.puppyImage)

        self.headerBarOne.widthAnchor.constraint(equalToConstant: 9).isActive = true
        self.headerBarOne.heightAnchor.constraint(equalToConstant: 9).isActive = true
        self.headerBarOne.layer.cornerRadius = 4.5
        
        self.headerBarTwo.widthAnchor.constraint(equalToConstant: 9).isActive = true
        self.headerBarTwo.heightAnchor.constraint(equalToConstant: 9).isActive = true
        self.headerBarTwo.layer.cornerRadius = 4.5
        
        self.headerBarThree.widthAnchor.constraint(equalToConstant: 9).isActive = true
        self.headerBarThree.heightAnchor.constraint(equalToConstant: 9).isActive = true
        self.headerBarThree.layer.cornerRadius = 4.5
        
        self.headerBarFour.widthAnchor.constraint(equalToConstant: 9).isActive = true
        self.headerBarFour.heightAnchor.constraint(equalToConstant: 9).isActive = true
        self.headerBarFour.layer.cornerRadius = 4.5
        
        self.headerContainer.topAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.topAnchor, constant: 25).isActive = true
        self.headerContainer.leftAnchor.constraint(equalTo: self.view.leftAnchor, constant: 0).isActive = true
        self.headerContainer.rightAnchor.constraint(equalTo: self.view.rightAnchor, constant: 0).isActive = true
        self.headerContainer.heightAnchor.constraint(equalToConstant: 100).isActive = true
        
        self.cancelButton.centerYAnchor.constraint(equalTo: self.headerContainer.centerYAnchor, constant: -20).isActive = true
        self.cancelButton.leftAnchor.constraint(equalTo: self.headerContainer.leftAnchor, constant: 11).isActive = true
        self.cancelButton.heightAnchor.constraint(equalToConstant: 54).isActive = true
        self.cancelButton.widthAnchor.constraint(equalToConstant: 54).isActive = true
        
        self.wereSorrylabel.topAnchor.constraint(equalTo: self.cancelButton.bottomAnchor, constant: 25).isActive = true
        self.wereSorrylabel.leftAnchor.constraint(equalTo: self.view.leftAnchor, constant: 30).isActive = true
        self.wereSorrylabel.sizeToFit()
        
        self.xButton.centerYAnchor.constraint(equalTo: self.headerContainer.centerYAnchor, constant: -20).isActive = true
        self.xButton.rightAnchor.constraint(equalTo: self.headerContainer.rightAnchor, constant: -11).isActive = true
        self.xButton.heightAnchor.constraint(equalToConstant: 54).isActive = true
        self.xButton.widthAnchor.constraint(equalToConstant: 54).isActive = true
        
        self.stackView.centerYAnchor.constraint(equalTo: self.wereSorrylabel.centerYAnchor, constant: 0).isActive = true
        self.stackView.rightAnchor.constraint(equalTo: self.headerContainer.rightAnchor, constant: -30).isActive = true
        self.stackView.heightAnchor.constraint(equalToConstant: 14).isActive = true
        self.stackView.widthAnchor.constraint(equalToConstant: 60).isActive = true
        
        self.sorrySubHeaderLabel.topAnchor.constraint(equalTo: self.wereSorrylabel.bottomAnchor, constant: 14).isActive = true
        self.sorrySubHeaderLabel.leftAnchor.constraint(equalTo: self.view.leftAnchor, constant: 30).isActive = true
        self.sorrySubHeaderLabel.rightAnchor.constraint(equalTo: self.view.rightAnchor, constant: -30).isActive = true
        self.sorrySubHeaderLabel.sizeToFit()
        
        self.returnToDashboardButton.bottomAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.bottomAnchor, constant: -27).isActive = true
        self.returnToDashboardButton.leftAnchor.constraint(equalTo: self.view.leftAnchor, constant: 30).isActive = true
        self.returnToDashboardButton.rightAnchor.constraint(equalTo: self.view.rightAnchor, constant: -30).isActive = true
        self.returnToDashboardButton.heightAnchor.constraint(equalToConstant: 60).isActive = true
        
        self.puppyImage.topAnchor.constraint(equalTo: self.sorrySubHeaderLabel.bottomAnchor, constant: 40).isActive = true
        self.puppyImage.leftAnchor.constraint(equalTo: self.view.leftAnchor).isActive = true
        self.puppyImage.rightAnchor.constraint(equalTo: self.view.rightAnchor, constant: 0).isActive = true
        self.puppyImage.bottomAnchor.constraint(equalTo: self.returnToDashboardButton.topAnchor, constant: -50).isActive = true
        
    }
    
    @objc func handleCancelButton() {
        self.navigationController?.dismiss(animated: true, completion: nil)
    }
    
    @objc func handleBackButton() {
        self.navigationController?.dismiss(animated: true, completion: nil)
    }
}
