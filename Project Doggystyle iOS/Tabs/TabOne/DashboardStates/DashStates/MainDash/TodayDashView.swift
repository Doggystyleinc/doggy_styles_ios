//
//  TodayDashView.swift
//  Project Doggystyle iOS
//
//  Created by Charlie Arcodia on 8/2/21.
//

import Foundation
import UIKit

class CustomSlider: UISlider {
    
    @IBInspectable var sliderTrackHeight : CGFloat = 40
    
    override func trackRect(forBounds bounds: CGRect) -> CGRect {
        let originalRect = super.trackRect(forBounds: bounds)
        return CGRect(origin: CGPoint(x: originalRect.origin.x, y: originalRect.origin.y + (sliderTrackHeight / 2)), size: CGSize(width: bounds.width, height: sliderTrackHeight))
    }
}

class TodaysDashView : UIView {
    
    var dashboardController : DashboardViewController?
    
    var hasViewsBeenLaidOut : Bool = false
    
    let headerLabel : UILabel = {
        
        let hl = UILabel()
        hl.translatesAutoresizingMaskIntoConstraints = false
        hl.backgroundColor = .clear
        hl.text = "Today's Appointment"
        hl.font = UIFont(name: dsHeaderFont, size: 24)
        hl.numberOfLines = 1
        hl.adjustsFontSizeToFitWidth = true
        hl.textAlignment = .left
        
        return hl
    }()
    
    let container : UIView = {
        
        let cv = UIView()
        cv.translatesAutoresizingMaskIntoConstraints = false
        cv.backgroundColor = coreWhiteColor
        cv.layer.masksToBounds = true
        cv.layer.cornerRadius = 20
        cv.clipsToBounds = false
        cv.layer.masksToBounds = false
        cv.layer.shadowColor = coreBlackColor.withAlphaComponent(0.8).cgColor
        cv.layer.shadowOpacity = 0.05
        cv.layer.shadowOffset = CGSize(width: 2, height: 3)
        cv.layer.shadowRadius = 9
        cv.layer.shouldRasterize = false
        
        return cv
    }()
    
    let topSubContainer : UIView = {
        
        let cv = UIView()
        cv.translatesAutoresizingMaskIntoConstraints = false
        cv.backgroundColor = .clear
        
        return cv
        
    }()
    
    let middleSubContainer : UIView = {
        
        let cv = UIView()
        cv.translatesAutoresizingMaskIntoConstraints = false
        cv.backgroundColor = .clear
        return cv
    }()
    
    let bottomSubContainer : UIView = {
        
        let cv = UIView()
        cv.translatesAutoresizingMaskIntoConstraints = false
        cv.backgroundColor = .clear
        return cv
    }()
    
    
    let dogOneImage : UIImageView = {
        
        let vi = UIImageView()
        vi.translatesAutoresizingMaskIntoConstraints = false
        vi.backgroundColor = .clear
        vi.contentMode = .scaleAspectFill
        vi.isUserInteractionEnabled = false
        vi.backgroundColor = coreOrangeColor.withAlphaComponent(0.1)
        vi.layer.masksToBounds = true
        let image = UIImage(named: "filler-one")?.withRenderingMode(.alwaysOriginal)
        vi.image = image
        
        return vi
    }()
    
    let dogTwoImage : UIImageView = {
        
        let vi = UIImageView()
        vi.translatesAutoresizingMaskIntoConstraints = false
        vi.backgroundColor = .clear
        vi.contentMode = .scaleAspectFill
        vi.isUserInteractionEnabled = false
        vi.backgroundColor = coreOrangeColor.withAlphaComponent(0.1)
        vi.layer.masksToBounds = true
        let image = UIImage(named: "filler-two")?.withRenderingMode(.alwaysOriginal)
        vi.image = image
        return vi
    }()
    
    let dateLabel : UILabel = {
        
        let hl = UILabel()
        hl.translatesAutoresizingMaskIntoConstraints = false
        hl.backgroundColor = .clear
        hl.text = "Mon, Jan 3rd, 2022"
        hl.font = UIFont(name: dsSubHeaderFont, size: 18)
        hl.numberOfLines = 2
        hl.adjustsFontSizeToFitWidth = true
        hl.textAlignment = .left
        hl.textColor = coreBlackColor
        
        return hl
    }()
    
    let timeLabel : UILabel = {
        
        let hl = UILabel()
        hl.translatesAutoresizingMaskIntoConstraints = false
        hl.backgroundColor = .clear
        hl.text = "12:30 PM"
        hl.font = UIFont(name: dsSubHeaderFont, size: 18)
        hl.numberOfLines = 2
        hl.adjustsFontSizeToFitWidth = true
        hl.textAlignment = .right
        hl.textColor = coreBlackColor
        
        return hl
    }()
    
    let recurringLabel : UILabel = {
        
        let hl = UILabel()
        hl.translatesAutoresizingMaskIntoConstraints = false
        hl.backgroundColor = .clear
        hl.text = "Recurring - 8 weeks"
        hl.font = UIFont(name: rubikRegular, size: 16)
        hl.numberOfLines = 2
        hl.adjustsFontSizeToFitWidth = true
        hl.textAlignment = .left
        hl.textColor = chatTimeGrey
        
        return hl
    }()
    
    lazy var editButton : UIButton = {
        
        let cbf = UIButton(type: .system)
        cbf.translatesAutoresizingMaskIntoConstraints = false
        cbf.backgroundColor = .clear
        cbf.tintColor = coreOrangeColor
        cbf.titleLabel?.font = UIFont.fontAwesome(ofSize: 16, style: .solid)
        cbf.setTitle(String.fontAwesomeIcon(name: .pencilAlt), for: .normal)
        
        return cbf
        
    }()
    
    let statusLabel : UILabel = {
        
        let hl = UILabel()
        hl.translatesAutoresizingMaskIntoConstraints = false
        hl.backgroundColor = .clear
        hl.text = "Status"
        hl.font = UIFont(name: rubikRegular, size: 16)
        hl.numberOfLines = 1
        hl.adjustsFontSizeToFitWidth = true
        hl.textAlignment = .center
        hl.textColor = coreOrangeColor
        
        return hl
    }()
    
    let greetingsLabel : UILabel = {
        
        let hl = UILabel()
        hl.translatesAutoresizingMaskIntoConstraints = false
        hl.backgroundColor = .clear
        hl.text = "Ready to greet Rex $ Jolene"
        hl.font = UIFont(name: dsHeaderFont, size: 18)
        hl.numberOfLines = 2
        hl.adjustsFontSizeToFitWidth = true
        hl.textAlignment = .center
        hl.textColor = coreBlackColor
        
        return hl
    }()
    
    let descriptionLabel : UILabel = {
        
        let hl = UILabel()
        hl.translatesAutoresizingMaskIntoConstraints = false
        hl.backgroundColor = .clear
        hl.text = "The groomer is waiting for you at the van, please drop off Ref & Jolene"
        hl.font = UIFont.poppinsRegular(size: 15)
        hl.numberOfLines = 2
        hl.adjustsFontSizeToFitWidth = true
        hl.textAlignment = .center
        hl.textColor = coreBlackColor
        
        return hl
    }()
    
    lazy var detailsButton: UIButton = {
        
        let cbf = UIButton(type: .system)
        cbf.translatesAutoresizingMaskIntoConstraints = false
        cbf.setTitle("Details", for: UIControl.State.normal)
        cbf.titleLabel?.font = UIFont.init(name: dsHeaderFont, size: 18)
        cbf.titleLabel?.adjustsFontSizeToFitWidth = true
        cbf.titleLabel?.numberOfLines = 1
        cbf.titleLabel?.adjustsFontForContentSizeCategory = true
        cbf.layer.cornerRadius = 15
        cbf.layer.masksToBounds = true
        cbf.tintColor = coreWhiteColor
        cbf.backgroundColor = coreOrangeColor
        cbf.addTarget(self, action: #selector(self.handleDetailsButton), for: .touchUpInside)
        
        return cbf
        
    }()
    
    lazy var chatButton: UIButton = {
        
        let cbf = UIButton(type: .system)
        cbf.translatesAutoresizingMaskIntoConstraints = false
        cbf.titleLabel?.adjustsFontSizeToFitWidth = true
        cbf.titleLabel?.numberOfLines = 1
        cbf.titleLabel?.adjustsFontForContentSizeCategory = true
        cbf.layer.cornerRadius = 15
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
        cbf.addTarget(self, action: #selector(self.handleChatButton), for: .touchUpInside)
        
        let str = String.fontAwesomeIcon(name: .comments) + "   Chat"
        let attributedStr = NSMutableAttributedString(string: str)
        
        let range1 = NSRange(location: 0, length: 1)
        attributedStr.addAttribute(.font,
                                   value: UIFont.fontAwesome(ofSize: 18, style: .solid),
                                   range: range1)
        
        let range2 = NSRange(location: 1, length: (str as NSString).length - 1)
        attributedStr.addAttribute(.font,
                                   value: UIFont(name: dsHeaderFont, size: 18)!,
                                   range: range2)
        
        cbf.setAttributedTitle(attributedStr, for: .normal)
        
        return cbf
        
    }()
    
    let bottomSpacer : UIView = {
        let bs = UIView()
        bs.backgroundColor = .clear
        bs.translatesAutoresizingMaskIntoConstraints = false
        return bs
    }()
    
    let dropOffLabel : UILabel = {
        
        let hl = UILabel()
        hl.translatesAutoresizingMaskIntoConstraints = false
        hl.backgroundColor = .clear
        hl.text = "Drop off"
        hl.font = UIFont.poppinsSemiBold(size: 11)
        hl.numberOfLines = 1
        hl.adjustsFontSizeToFitWidth = true
        hl.textAlignment = .center
        hl.textColor = coreBlackColor
        
        return hl
    }()
    
    let groomingLabel : UILabel = {
        
        let hl = UILabel()
        hl.translatesAutoresizingMaskIntoConstraints = false
        hl.backgroundColor = .clear
        hl.text = "Grooming"
        hl.font = UIFont.poppinsSemiBold(size: 11)
        hl.numberOfLines = 1
        hl.adjustsFontSizeToFitWidth = true
        hl.textAlignment = .center
        hl.textColor = coreBlackColor
        
        return hl
    }()
    
    let readyInTenLabel : UILabel = {
        
        let hl = UILabel()
        hl.translatesAutoresizingMaskIntoConstraints = false
        hl.backgroundColor = .clear
        hl.text = "Ready in 10"
        hl.font = UIFont.poppinsSemiBold(size: 11)
        hl.numberOfLines = 1
        hl.adjustsFontSizeToFitWidth = true
        hl.textAlignment = .center
        hl.textColor = coreBlackColor
        
        return hl
    }()
    
    let pickUpLabel : UILabel = {
        
        let hl = UILabel()
        hl.translatesAutoresizingMaskIntoConstraints = false
        hl.backgroundColor = .clear
        hl.text = "Pick up"
        hl.font = UIFont.poppinsSemiBold(size: 11)
        hl.numberOfLines = 1
        hl.adjustsFontSizeToFitWidth = true
        hl.textAlignment = .center
        hl.textColor = coreBlackColor
        
        return hl
    }()
    
    lazy var stackView : UIStackView = {
        
        let sv = UIStackView()
        sv.translatesAutoresizingMaskIntoConstraints = false
        sv.axis = .horizontal
        sv.distribution = .equalCentering
        sv.alignment = .center
        sv.spacing = 2
        
        return sv
    }()
    
    let progressSlider : UISlider = {
        
        let ps = UISlider()
        ps.translatesAutoresizingMaskIntoConstraints = false
        ps.minimumValue = 0
        ps.maximumValue = 1
        ps.backgroundColor = .clear
        ps.layer.masksToBounds = true
        ps.setThumbImage(UIImage(), for: .normal)
        ps.minimumTrackTintColor = coreGreenColor
        ps.maximumTrackTintColor = dividerGrey.withAlphaComponent(0.3)
        ps.value = 0.25
        
        return ps
    }()
    
    let startingTimeLabel : UILabel = {
        
        let hl = UILabel()
        hl.translatesAutoresizingMaskIntoConstraints = false
        hl.backgroundColor = .clear
        hl.text = "11:05am"
        hl.font = UIFont.poppinsRegular(size: 9.5)
        hl.numberOfLines = 2
        hl.adjustsFontSizeToFitWidth = true
        hl.textAlignment = .left
        hl.textColor = coreBlackColor
        
        return hl
    }()
    
    let endingTimeLabel : UILabel = {
        
        let hl = UILabel()
        hl.translatesAutoresizingMaskIntoConstraints = false
        hl.backgroundColor = .clear
        hl.text = "est 12:05pm"
        hl.font = UIFont.poppinsRegular(size: 9.5)
        hl.numberOfLines = 2
        hl.adjustsFontSizeToFitWidth = true
        hl.textAlignment = .right
        hl.textColor = coreBlackColor
        
        return hl
    }()
    
    let stageOneDivider : UIView = {
        
        let sod = UIView()
        sod.translatesAutoresizingMaskIntoConstraints = false
        sod.backgroundColor = dividerGrey.withAlphaComponent(0.2)
        
        return sod
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.backgroundColor = coreBackgroundWhite
        self.translatesAutoresizingMaskIntoConstraints = false
        self.addViews()
        
    }
    
    func addViews() {
        
        self.addSubview(self.headerLabel)
        self.addSubview(self.container)
        
        
        self.headerLabel.topAnchor.constraint(equalTo: self.topAnchor, constant: 5).isActive = true
        self.headerLabel.leftAnchor.constraint(equalTo: self.leftAnchor, constant: 30).isActive = true
        self.headerLabel.rightAnchor.constraint(equalTo: self.rightAnchor, constant: -30).isActive = true
        self.headerLabel.heightAnchor.constraint(equalToConstant: 30).isActive = true
        
        self.container.topAnchor.constraint(equalTo: self.headerLabel.bottomAnchor, constant: 20).isActive = true
        self.container.leftAnchor.constraint(equalTo: self.leftAnchor, constant: 30).isActive = true
        self.container.rightAnchor.constraint(equalTo: self.rightAnchor, constant: -30).isActive = true
        self.container.bottomAnchor.constraint(equalTo: self.safeAreaLayoutGuide.bottomAnchor, constant: -50).isActive = true
        
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        if self.hasViewsBeenLaidOut == true {return}
        
        self.hasViewsBeenLaidOut = true
        
        self.container.addSubview(self.topSubContainer)
        self.container.addSubview(self.middleSubContainer)
        self.container.addSubview(self.bottomSubContainer)
        
        self.container.addSubview(self.stageOneDivider)
        
        self.topSubContainer.topAnchor.constraint(equalTo: self.container.topAnchor, constant: 0).isActive = true
        self.topSubContainer.leftAnchor.constraint(equalTo: self.container.leftAnchor, constant: 0).isActive = true
        self.topSubContainer.rightAnchor.constraint(equalTo: self.container.rightAnchor, constant: 0).isActive = true
        self.topSubContainer.heightAnchor.constraint(equalToConstant: self.container.frame.size.height / 3).isActive = true
        
        self.middleSubContainer.topAnchor.constraint(equalTo: self.topSubContainer.bottomAnchor, constant: 0).isActive = true
        self.middleSubContainer.leftAnchor.constraint(equalTo: self.container.leftAnchor, constant: 0).isActive = true
        self.middleSubContainer.rightAnchor.constraint(equalTo: self.container.rightAnchor, constant: 0).isActive = true
        self.middleSubContainer.heightAnchor.constraint(equalToConstant: self.container.frame.size.height / 3).isActive = true
        
        self.bottomSubContainer.topAnchor.constraint(equalTo: self.middleSubContainer.bottomAnchor, constant: 0).isActive = true
        self.bottomSubContainer.leftAnchor.constraint(equalTo: self.container.leftAnchor, constant: 0).isActive = true
        self.bottomSubContainer.rightAnchor.constraint(equalTo: self.container.rightAnchor, constant: 0).isActive = true
        self.bottomSubContainer.heightAnchor.constraint(equalToConstant: self.container.frame.size.height / 3).isActive = true
        
        //MARK: - TOP CONTAINER
        self.topSubContainer.addSubview(self.dogOneImage)
        self.topSubContainer.addSubview(self.dogTwoImage)
        self.topSubContainer.addSubview(self.dateLabel)
        self.topSubContainer.addSubview(self.timeLabel)
        self.topSubContainer.addSubview(self.recurringLabel)
        self.topSubContainer.addSubview(self.editButton)
        
        self.dogOneImage.topAnchor.constraint(equalTo: self.topSubContainer.topAnchor, constant: 21).isActive = true
        self.dogOneImage.leftAnchor.constraint(equalTo: self.topSubContainer.leftAnchor, constant: 28).isActive = true
        self.dogOneImage.heightAnchor.constraint(equalToConstant: 50).isActive = true
        self.dogOneImage.widthAnchor.constraint(equalToConstant: 50).isActive = true
        self.dogOneImage.layer.cornerRadius = 25
        
        self.dogTwoImage.centerYAnchor.constraint(equalTo: self.dogOneImage.centerYAnchor).isActive = true
        self.dogTwoImage.leftAnchor.constraint(equalTo: self.dogOneImage.rightAnchor, constant: 20).isActive = true
        self.dogTwoImage.heightAnchor.constraint(equalToConstant: 50).isActive = true
        self.dogTwoImage.widthAnchor.constraint(equalToConstant: 50).isActive = true
        self.dogTwoImage.layer.cornerRadius = 25
        
        self.editButton.rightAnchor.constraint(equalTo: self.topSubContainer.rightAnchor, constant: -25).isActive = true
        self.editButton.centerYAnchor.constraint(equalTo: self.dogTwoImage.centerYAnchor, constant: 0).isActive = true
        self.editButton.heightAnchor.constraint(equalToConstant: 44).isActive = true
        self.editButton.heightAnchor.constraint(equalToConstant: 44).isActive = true
        
        self.dateLabel.topAnchor.constraint(equalTo: self.dogOneImage.bottomAnchor, constant: 16).isActive = true
        self.dateLabel.leftAnchor.constraint(equalTo: self.dogOneImage.leftAnchor, constant: 0).isActive = true
        self.dateLabel.widthAnchor.constraint(equalToConstant: UIScreen.main.bounds.width / 2.5).isActive = true
        self.dateLabel.heightAnchor.constraint(equalToConstant: 20).isActive = true
        
        self.timeLabel.topAnchor.constraint(equalTo: self.dogOneImage.bottomAnchor, constant: 16).isActive = true
        self.timeLabel.rightAnchor.constraint(equalTo: self.topSubContainer.rightAnchor, constant: -30).isActive = true
        self.timeLabel.widthAnchor.constraint(equalToConstant: UIScreen.main.bounds.width / 2.5).isActive = true
        self.timeLabel.heightAnchor.constraint(equalToConstant: 20).isActive = true
        
        self.recurringLabel.topAnchor.constraint(equalTo: self.dateLabel.bottomAnchor, constant: 5).isActive = true
        self.recurringLabel.leftAnchor.constraint(equalTo: self.dogOneImage.leftAnchor, constant: 0).isActive = true
        self.recurringLabel.rightAnchor.constraint(equalTo: self.topSubContainer.rightAnchor, constant: -10).isActive = true
        self.recurringLabel.heightAnchor.constraint(equalToConstant: 20).isActive = true
        //MARK: - END TOP CONTAINER
        
        
        //MARK: - MIDDLE CONTAINER
        self.middleSubContainer.addSubview(self.statusLabel)
        self.middleSubContainer.addSubview(self.greetingsLabel)
        self.middleSubContainer.addSubview(self.descriptionLabel)
        
        self.statusLabel.topAnchor.constraint(equalTo: self.middleSubContainer.topAnchor, constant: 10).isActive = true
        self.statusLabel.leftAnchor.constraint(equalTo: self.middleSubContainer.leftAnchor, constant: 20).isActive = true
        self.statusLabel.rightAnchor.constraint(equalTo: self.middleSubContainer.rightAnchor, constant: -20).isActive = true
        self.statusLabel.heightAnchor.constraint(equalToConstant: 20).isActive = true
        
        self.greetingsLabel.topAnchor.constraint(equalTo: self.statusLabel.bottomAnchor, constant: 10).isActive = true
        self.greetingsLabel.leftAnchor.constraint(equalTo: self.middleSubContainer.leftAnchor, constant: 20).isActive = true
        self.greetingsLabel.rightAnchor.constraint(equalTo: self.middleSubContainer.rightAnchor, constant: -20).isActive = true
        self.greetingsLabel.heightAnchor.constraint(equalToConstant: 20).isActive = true
        
        self.descriptionLabel.topAnchor.constraint(equalTo: self.greetingsLabel.bottomAnchor, constant: 10).isActive = true
        self.descriptionLabel.leftAnchor.constraint(equalTo: self.middleSubContainer.leftAnchor, constant: 20).isActive = true
        self.descriptionLabel.rightAnchor.constraint(equalTo: self.middleSubContainer.rightAnchor, constant: -20).isActive = true
        self.descriptionLabel.bottomAnchor.constraint(equalTo: self.middleSubContainer.bottomAnchor, constant: -10).isActive = true
        //MARK: - END MIDDLE CONTAINER
        
        
        //MARK: - BOTTOM CONTAINER
        self.bottomSubContainer.addSubview(self.bottomSpacer)
        self.bottomSubContainer.addSubview(self.detailsButton)
        self.bottomSubContainer.addSubview(self.chatButton)
        self.bottomSubContainer.addSubview(self.stackView)
        self.bottomSubContainer.addSubview(self.progressSlider)
        self.bottomSubContainer.addSubview(self.startingTimeLabel)
        self.bottomSubContainer.addSubview(self.endingTimeLabel)
        
        self.bottomSpacer.centerXAnchor.constraint(equalTo: self.bottomSubContainer.centerXAnchor, constant: 0).isActive = true
        self.bottomSpacer.bottomAnchor.constraint(equalTo: self.bottomSubContainer.bottomAnchor, constant: 0).isActive = true
        self.bottomSpacer.widthAnchor.constraint(equalToConstant: 5).isActive = true
        self.bottomSpacer.heightAnchor.constraint(equalToConstant: 20).isActive = true
        
        self.detailsButton.leftAnchor.constraint(equalTo: self.bottomSubContainer.leftAnchor, constant: 23).isActive = true
        self.detailsButton.bottomAnchor.constraint(equalTo: self.bottomSubContainer.bottomAnchor, constant: -24).isActive = true
        self.detailsButton.heightAnchor.constraint(equalToConstant: 60).isActive = true
        self.detailsButton.rightAnchor.constraint(equalTo: self.bottomSpacer.leftAnchor, constant: -5).isActive = true
        
        self.chatButton.rightAnchor.constraint(equalTo: self.bottomSubContainer.rightAnchor, constant: -23).isActive = true
        self.chatButton.bottomAnchor.constraint(equalTo: self.bottomSubContainer.bottomAnchor, constant: -24).isActive = true
        self.chatButton.heightAnchor.constraint(equalToConstant: 60).isActive = true
        self.chatButton.leftAnchor.constraint(equalTo: self.bottomSpacer.rightAnchor, constant: 5).isActive = true
        
        self.stackView.addArrangedSubview(self.dropOffLabel)
        self.stackView.addArrangedSubview(self.groomingLabel)
        self.stackView.addArrangedSubview(self.readyInTenLabel)
        self.stackView.addArrangedSubview(self.pickUpLabel)
        
        self.stackView.bottomAnchor.constraint(equalTo: self.detailsButton.topAnchor, constant: -10).isActive = true
        self.stackView.leftAnchor.constraint(equalTo: self.detailsButton.leftAnchor, constant: 0).isActive = true
        self.stackView.rightAnchor.constraint(equalTo: self.chatButton.rightAnchor, constant: 0).isActive = true
        self.stackView.heightAnchor.constraint(equalToConstant: 20).isActive = true
        
        self.progressSlider.bottomAnchor.constraint(equalTo: self.stackView.topAnchor, constant: -5).isActive = true
        self.progressSlider.leftAnchor.constraint(equalTo: self.stackView.leftAnchor, constant: 0).isActive = true
        self.progressSlider.rightAnchor.constraint(equalTo: self.stackView.rightAnchor, constant: 0).isActive = true
        
        self.startingTimeLabel.bottomAnchor.constraint(equalTo: self.progressSlider.topAnchor, constant: -5).isActive = true
        self.startingTimeLabel.leftAnchor.constraint(equalTo: self.progressSlider.leftAnchor, constant: 0).isActive = true
        self.startingTimeLabel.sizeToFit()
        
        self.endingTimeLabel.bottomAnchor.constraint(equalTo: self.progressSlider.topAnchor, constant: -5).isActive = true
        self.endingTimeLabel.rightAnchor.constraint(equalTo: self.progressSlider.rightAnchor, constant: 0).isActive = true
        self.endingTimeLabel.sizeToFit()
        //MARK: - BOTTOM CONTAINER
        
        self.stageOneDivider.centerYAnchor.constraint(equalTo: self.topSubContainer.bottomAnchor, constant: -10).isActive = true
        self.stageOneDivider.leftAnchor.constraint(equalTo: self.container.leftAnchor, constant: 0).isActive = true
        self.stageOneDivider.rightAnchor.constraint(equalTo: self.container.rightAnchor, constant: 0).isActive = true
        self.stageOneDivider.heightAnchor.constraint(equalToConstant: 15).isActive = true
        
        
        //MARK: - END BOTTOM CONTAINER
    }
    
    @objc func handleDetailsButton() {
    }
    
    @objc func handleChatButton() {
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
