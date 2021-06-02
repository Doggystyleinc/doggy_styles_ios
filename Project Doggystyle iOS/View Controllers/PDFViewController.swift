//
//  PDFViewController.swift
//  Project Doggystyle iOS
//
//  Created by Stanley Miller on 6/2/21.
//

import UIKit
import PDFKit

final class PDFViewController: UIViewController {

    private let pdfView = PDFView()
    var pdfURL: URL!
    
    private let closeButton: UIButton = {
        let button = UIButton(type: .system)
        button.setImage(UIImage(systemName: "xmark.circle.fill"), for: .normal)
        button.addTarget(self, action: #selector(dismissVC(_:)), for: .touchUpInside)
        button.tintColor = .systemOrange
        return button
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureVC()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        Service.shared.fetchCurrentUser()
    }
    
    private func configureVC() {
        self.view.addSubview(pdfView)
        pdfView.edgesToSuperview()
        
        if let document = PDFDocument(url: pdfURL) {
            pdfView.document = document
        }
        
        self.view.addSubview(closeButton)
        closeButton.top(to: view, offset: 30)
        closeButton.right(to: view, offset: -30)
        closeButton.height(34)
        closeButton.width(34)
    }
    
    @objc private func dismissVC(_ sender: UIButton) {
        self.dismiss(animated: true)
    }
}
