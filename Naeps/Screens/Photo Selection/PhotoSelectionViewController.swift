//
//  PhotoSelectionViewController.swift
//  Naeps
//
//  Created by Mikael on 4/9/18.
//  Copyright © 2018 Mikael-Melkonyan. All rights reserved.
//

import UIKit

class PhotoSelectionViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Оберіть фотографію"
        view.addGradient(colors: (UIColor(hex: 0x008975), UIColor(hex: 0x00BF9A)))
        setupNavBar()
    }
    override var preferredStatusBarStyle: UIStatusBarStyle { return .lightContent }
    
    private func setupNavBar() {
        guard let navBar = navigationController?.navigationBar else { return }
        navBar.tintColor = UIColor.white
        navBar.barStyle = .black
        navBar.setBackgroundImage(UIImage(), for: .default)
        navBar.shadowImage = UIImage()
        navBar.isTranslucent = true
        navBar.titleTextAttributes = [NSAttributedStringKey.font: UIFont.systemFont(ofSize: 17, weight: .medium)]
    }
}
