//
//  PetCollectionViewCell.swift
//  Project Doggystyle iOS
//
//  Created by Stanley Miller on 6/16/21.
//

import UIKit
//TODO: - pass in imageURL
class PetCollectionViewCell: UICollectionViewCell {
    static let reuseIdentifier: String = "PetCell"
    
    private let imageView: UIImageView = {
        let imageView = UIImageView(frame: .zero)
        imageView.contentMode = .scaleToFill
        imageView.clipsToBounds = true
        return imageView
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        layoutUI()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        imageView.layer.cornerRadius = imageView.frame.size.width / 2
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func layoutUI() {
        self.addSubview(imageView)
        imageView.edgesToSuperview()
    }
    
    func configure(with pet: Pet) {
        if let imageURL = URL(string: pet.imageURL) {
            imageView.sd_setImage(with: imageURL, placeholderImage: UIImage(named: Constants.petProfilePlaceholder))
        }
        
        let label = DSBoldLabel(title: pet.name, size: 16)
        label.textAlignment = .center
        
        if pet.name == "All" {
            label.textColor = .dsOrange
        }
        
        self.addSubview(label)
        label.topToBottom(of: imageView, offset: 3)
        label.left(to: imageView)
        label.right(to: imageView)
    }
}
