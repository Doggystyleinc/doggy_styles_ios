//
//  UIButton+Ext.swift
//  Project Doggystyle iOS
//
//  Created by Stanley Miller on 5/18/21.
//

import UIKit

extension UIButton {
    //Switch background + enable/disable button
    func enable(_ enable: Bool) {
        self.isEnabled = enable ? true : false
        self.backgroundColor = enable ? UIColor.systemGreen : UIColor.dsGrey
    }
    
    func leftImage(image: UIImage, renderMode: UIImage.RenderingMode) {
        self.setImage(image.withRenderingMode(renderMode), for: .normal)
        self.imageEdgeInsets = UIEdgeInsets(top: 0, left: 10, bottom: 0, right: image.size.width / 2)
        self.titleEdgeInsets.left = 30
        self.contentHorizontalAlignment = .left
        self.imageView?.contentMode = .scaleAspectFit
    }
    
    func rightImage(image: UIImage, renderMode: UIImage.RenderingMode){
        self.setImage(image.withRenderingMode(renderMode), for: .normal)
        self.imageEdgeInsets = UIEdgeInsets(top: 0, left: image.size.width / 2, bottom: 0, right: 0)
        self.contentHorizontalAlignment = .right
        self.imageView?.contentMode = .scaleAspectFit
    }
}
