////
////  RefurAFriendController.swift
////  Project Doggystyle iOS
////
////  Created by Stanley Miller on 6/20/21.
////
//
//import UIKit
//
//final class RefurAFriendController: UIViewController {
//    private let rightIcon = DSNavButton(imageName: Constants.closeButton, tagNumber: 0)
//    private let backgroundImage: UIImageView = {
//        let imageView = UIImageView(frame: .zero)
//        imageView.image = UIImage(named: Constants.refurBackground)
//        imageView.contentMode = .scaleAspectFill
//        imageView.alpha = 0.30
//        imageView.clipsToBounds = true
//        return imageView
//    }()
//
//    private let titleLabel = DSBoldLabel(title: "Re-fur a Friend!", size: 22.0)
//    private let bodyLabel = DSRegularLabel(title: "Lorem ipsum dolor sit amet, consectetur adipiscing elit. Nullam eleifend velit ex, in porttitor sapien rhoncus eu.", size: 14.0)
//    private let shareLabel = DSSemiBoldLabel(title: "Share to earn rewards", size: 20)
//
//    private let refurCodeContainer = DSContainerView(frame: .zero)
//    private let refurLabel = DSSemiBoldLabel(title: "https://www.doggystyle.com/u0387", size: 14)
//
//    private let refurLabelButton: UIButton = {
//        let button = UIButton(type: .system)
//        button.backgroundColor = .clear
//        button.setTitle("", for: .normal)
//        button.addTarget(self, action: #selector(didTapCopy), for: .touchUpInside)
//        return button
//    }()
//
//    private let tapToCopyButton: UIButton = {
//        let button = UIButton(type: .system)
//        button.setTitle("Tap to copy", for: UIControl.State.normal)
//        button.titleLabel?.font = UIFont.poppinsBold(size: 16)
//        button.titleLabel?.numberOfLines = 1
//        button.titleLabel?.textColor = .dsOrange
//        button.backgroundColor = .clear
//        button.layer.masksToBounds = true
//        button.tintColor = .dsOrange
//        button.addTarget(self, action: #selector(didTapCopy), for: .touchUpInside)
//        return button
//    }()
//
//    private let shareButton: UIButton = {
//        let button = UIButton(type: .system)
//        button.setTitle("Share", for: UIControl.State.normal)
//        button.titleLabel?.font = UIFont.poppinsBold(size: 16)
//        button.titleLabel?.numberOfLines = 1
//        button.titleLabel?.textColor = .white
//        button.backgroundColor = .dsOrange
//        button.layer.cornerRadius = 14
//        button.layer.masksToBounds = true
//        button.tintColor = .white
//        return button
//    }()
//
//    override func viewDidLoad() {
//        super.viewDidLoad()
//        configureVC()
//        addViews()
//    }
//}
//
////MARK: - Configure View Controller
//extension RefurAFriendController {
//    private func configureVC() {
//        view.backgroundColor = .dsViewBackground
//
//        rightIcon.addTarget(self, action: #selector(didTapClose), for: .touchUpInside)
//    }
//}
//
////MARK: - Configure Views
//extension RefurAFriendController {
//    private func addViews() {
//        self.view.addSubview(backgroundImage)
//        backgroundImage.edgesToSuperview()
//
//        self.view.addSubview(rightIcon)
//        rightIcon.right(to: view, offset: -20)
//        rightIcon.topToSuperview(offset: 20, usingSafeArea: true)
//
//        self.view.addSubview(titleLabel)
//        titleLabel.topToBottom(of: rightIcon, offset: 36)
//        titleLabel.left(to: view, offset: 30)
//        titleLabel.right(to: view, offset: -30)
//
//        self.view.addSubview(bodyLabel)
//        bodyLabel.topToBottom(of: titleLabel, offset: 13)
//        bodyLabel.left(to: titleLabel)
//        bodyLabel.right(to: titleLabel)
//
//        self.view.addSubview(shareLabel)
//        shareLabel.topToBottom(of: bodyLabel, offset: 45)
//        shareLabel.left(to: titleLabel)
//        shareLabel.right(to: titleLabel)
//
//        self.view.addSubview(refurCodeContainer)
//        refurCodeContainer.topToBottom(of: shareLabel, offset: 20)
//        refurCodeContainer.left(to: titleLabel)
//        refurCodeContainer.right(to: titleLabel)
//        refurCodeContainer.height(79)
//
//        self.refurCodeContainer.addSubview(refurLabel)
//        refurLabel.centerInSuperview()
//
//        self.refurCodeContainer.addSubview(refurLabelButton)
//        refurLabelButton.edgesToSuperview()
//
//        self.view.addSubview(tapToCopyButton)
//        tapToCopyButton.topToBottom(of: refurCodeContainer, offset: 10)
//        tapToCopyButton.left(to: titleLabel)
//        tapToCopyButton.right(to: titleLabel)
//        tapToCopyButton.height(60)
//
//        self.view.addSubview(shareButton)
//        shareButton.height(60)
//        shareButton.left(to: titleLabel)
//        shareButton.right(to: titleLabel)
//        shareButton.bottom(to: view, offset: -60)
//    }
//}
//
////MARK: - @objc
//extension RefurAFriendController {
//    @objc private func didTapClose() {
//        self.dismiss(animated: true, completion: nil)
//    }
//
//    @objc private func didTapCopy() {
//        let pasteboard = UIPasteboard.general
//        pasteboard.string = refurLabel.text
//    }
//}
