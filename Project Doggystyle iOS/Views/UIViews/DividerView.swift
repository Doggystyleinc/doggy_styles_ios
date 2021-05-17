//
//  DividerView.swift
//  Project Doggystyle
//
//  Created by Stanley Miller on 5/3/21.
//

import UIKit

final class DividerView: UIView {
    
    ///Divider background color + 0.5 height
    init() {
        super.init(frame: .zero)
        self.backgroundColor = .divider
        self.height(0.5)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
