//
//  ServicesController.swift
//  Project Doggystyle iOS
//
//  Created by Stanley Miller on 6/2/21.
//

import UIKit

final class ServicesController: UIViewController {
    
    var homeController: HomeViewController?
    
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
        hl.text = "Groomz"
        hl.font = UIFont(name: dsHeaderFont, size: 24)
        hl.numberOfLines = 1
        hl.adjustsFontSizeToFitWidth = true
        hl.textAlignment = .left
        
        return hl
    }()
    
    lazy var servicesCollection : ServicesCollectionview = {
        
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        let sc = ServicesCollectionview(frame: .zero, collectionViewLayout: layout)
        sc.servicesController = self
        
       return sc
    }()
    
    lazy var bookNowButton: UIButton = {
        
        let cbf = UIButton(type: .system)
        cbf.translatesAutoresizingMaskIntoConstraints = false
        cbf.titleLabel?.adjustsFontSizeToFitWidth = true
        cbf.titleLabel?.numberOfLines = 1
        cbf.titleLabel?.adjustsFontForContentSizeCategory = true
        cbf.layer.cornerRadius = 18
        cbf.layer.masksToBounds = true
        cbf.tintColor = coreWhiteColor
        cbf.backgroundColor = coreOrangeColor
        cbf.layer.masksToBounds = false
        cbf.tintColor = coreWhiteColor
        cbf.layer.shadowColor = coreBlackColor.withAlphaComponent(0.8).cgColor
        cbf.layer.shadowOpacity = 0.2
        cbf.layer.shadowOffset = CGSize(width: 2, height: 3)
        cbf.layer.shadowRadius = 4
        cbf.layer.shouldRasterize = false
       
        
        let str = String.fontAwesomeIcon(name: .calendar) + "   Book service"
        let attributedStr = NSMutableAttributedString(string: str)

        //Apply FontAwesome to the first character
        let range1 = NSRange(location: 0, length: 1)
        attributedStr.addAttribute(.font,
                                   value: UIFont.fontAwesome(ofSize: 18, style: .solid),
                                   range: range1)

        //Apply the system font to the rest of the string
        let range2 = NSRange(location: 1, length: (str as NSString).length - 1)
        attributedStr.addAttribute(.font,
                                   value: UIFont(name: dsHeaderFont, size: 18)!,
                                   range: range2)

        //Set the attributed text for the button
        cbf.setAttributedTitle(attributedStr, for: .normal)
        cbf.addTarget(self, action: #selector(self.handleBookingController), for: .touchUpInside)
        
        return cbf
        
    }()
   
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.backgroundColor = coreBackgroundWhite
        self.addViews()
        
    }
    
    func addViews() {
        
        self.view.addSubview(self.dsCompanyLogoImage)
        self.view.addSubview(self.headerLabel)
        self.view.addSubview(self.servicesCollection)
        self.view.addSubview(self.bookNowButton)

        self.dsCompanyLogoImage.topAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.topAnchor, constant: 0).isActive = true
        self.dsCompanyLogoImage.centerXAnchor.constraint(equalTo: self.view.centerXAnchor, constant: 0).isActive = true
        self.dsCompanyLogoImage.heightAnchor.constraint(equalToConstant: 26).isActive = true
        self.dsCompanyLogoImage.sizeToFit()
        
        self.headerLabel.topAnchor.constraint(equalTo: self.dsCompanyLogoImage.bottomAnchor, constant: 53).isActive = true
        self.headerLabel.leftAnchor.constraint(equalTo: self.view.leftAnchor, constant: 30).isActive = true
        self.headerLabel.rightAnchor.constraint(equalTo: self.view.rightAnchor, constant: -30).isActive = true
        self.headerLabel.heightAnchor.constraint(equalToConstant: 28).isActive = true
        
        self.servicesCollection.topAnchor.constraint(equalTo: self.headerLabel.bottomAnchor, constant: 10).isActive = true
        self.servicesCollection.leftAnchor.constraint(equalTo: self.view.leftAnchor, constant: 0).isActive = true
        self.servicesCollection.rightAnchor.constraint(equalTo: self.view.rightAnchor, constant: 0).isActive = true
        self.servicesCollection.bottomAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.bottomAnchor, constant: 0).isActive = true
        
        self.bookNowButton.bottomAnchor.constraint(equalTo: self.view.bottomAnchor, constant: -120).isActive = true
        self.bookNowButton.leftAnchor.constraint(equalTo: self.view.leftAnchor, constant: 30).isActive = true
        self.bookNowButton.rightAnchor.constraint(equalTo: self.view.rightAnchor, constant: -30).isActive = true
        self.bookNowButton.heightAnchor.constraint(equalToConstant: 60).isActive = true
        
    }
    
    @objc func handleBookingController() {
        print("ONE")

        self.homeController?.presentBookingController()
    }
}
