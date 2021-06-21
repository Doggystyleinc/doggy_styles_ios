//
//  LogoImageView.swift
//  Project Doggystyle iOS
//
//  Created by Stanley Miller on 6/15/21.
//

import UIKit

final class LogoImageView: UIImageView {

    override init(frame: CGRect) {
        super.init(frame: frame)
        self.image = UIImage(named: Constants.dsLogo)
        self.contentMode = .scaleAspectFit
        self.width(106)
        self.height(26)
    }
    
    /// Initialize with a logo
    init(withImage: UIImage?) {
        super.init(frame: .zero)
        self.image = withImage
        self.contentMode = .scaleAspectFit
        self.width(106)
        self.height(26)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
