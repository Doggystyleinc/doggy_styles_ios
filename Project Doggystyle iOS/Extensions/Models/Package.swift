//
//  Package.swift
//  Project Doggystyle iOS
//
//  Created by Stanley Miller on 6/16/21.
//

import Foundation

struct Package {
    let name: String
    let briefDescription: String
    let fullDescription: String
    let price: Int
    let duration: Int
    
    static let examplePackage = Package(name: "The Full Package", briefDescription: "Lorem ipsum dolor sit amet, consectetur adipiscing elit. Integer dignissim metus non ultricies.", fullDescription: "Lorem ipsum dolor sit amet, consectetur adipiscing elit. Cras porttitor arcu non odio elementum, a tempor enim cursus. In hac habitasse platea dictumst. Maecenas tincidunt lectus id nibh convallis, at interdum augue euismod.", price: 999, duration: 99)
}
