//
//  PhotoSelectionViewController.swift
//  Naeps
//
//  Created by Mikael on 4/9/18.
//  Copyright © 2018 Mikael-Melkonyan. All rights reserved.
//

import UIKit
import Photos

class PhotoSelectionViewController: UIViewController {
    
    @IBOutlet var cameraView: UIView!
    @IBOutlet var galleryView: UIView!
    @IBOutlet var cameraTitle: UILabel!
    @IBOutlet var galleryTitle: UILabel!
    
    private let picker = UIImagePickerController()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
        
        cameraView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(cameraSelected)))
        galleryView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(gallerySelected)))
        
        picker.delegate = self
    }
    
    @objc func cameraSelected() {
        if UIImagePickerController.isSourceTypeAvailable(.camera) {
            picker.allowsEditing = false
            picker.sourceType = .camera
            picker.cameraCaptureMode = .photo
            picker.modalPresentationStyle = .fullScreen
            present(picker,animated: true,completion: nil)
        }
    }
    
    @objc func gallerySelected() {
        PHPhotoLibrary.requestAuthorization { _ in
            main {
                if PHPhotoLibrary.authorizationStatus() == PHAuthorizationStatus.authorized {
                    self.picker.allowsEditing = false
                    self.picker.sourceType = .photoLibrary
                    self.picker.mediaTypes = UIImagePickerController.availableMediaTypes(for: .photoLibrary)!
                    self.present(self.picker, animated: true, completion: nil)
                } else {
                    let alert = UIAlertController(title: "Помилка", message: "Щоб обробити вибране зображення потрібно отримати доступ до галереї.\nВи можете дати доступ в налаштуваннях телефону", preferredStyle: .alert)
                    alert.addAction(UIAlertAction(title: "Добре", style: .default, handler: nil))
                    self.present(alert, animated: true)
                }
            }
        }
    }
}

extension PhotoSelectionViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        let chosenImage = info[UIImagePickerControllerOriginalImage] as! UIImage
        dismiss(animated: true, completion: {
            let storyboard = UIStoryboard(name: "Result", bundle: nil)
            let resultVC = storyboard.instantiateViewController(withIdentifier: "ResultViewController") as! ResultViewController
            resultVC.initialImage = chosenImage
            self.navigationController?.pushViewController(resultVC, animated: true)
        })
    }
}

// MARK: View building
extension PhotoSelectionViewController {
    
    private func setupView() {
        title = "Оберіть фотографію"
        view.addGradient(colors: (UIColor(hex: 0x008975), UIColor(hex: 0x00BF9A)))
        cameraView.crop(radius: cameraView.frame.height / 2)
        galleryView.crop(radius: galleryView.frame.height / 2)
        cameraView.setBorder(width: 1, color: UIColor.white)
        galleryView.setBorder(width: 1, color: UIColor.white)
        galleryView.backgroundColor = UIColor(hex: 0xFFFFFF, alpha: 0.2)
        cameraTitle.text = "Зробити фотографію"
        galleryTitle.text = "Завантажити з галереї"
        
        setupNavBar()
    }
    override var preferredStatusBarStyle: UIStatusBarStyle { return .lightContent }
    
    private func setupNavBar() {
        let backItem = UIBarButtonItem()
        backItem.title = ""
        navigationItem.backBarButtonItem = backItem
        
        guard let navBar = navigationController?.navigationBar else { return }
        navBar.tintColor = UIColor.white
        navBar.barStyle = .black
        navBar.setBackgroundImage(UIImage(), for: .default)
        navBar.shadowImage = UIImage()
        navBar.isTranslucent = true
        navBar.titleTextAttributes = [NSAttributedStringKey.font: UIFont.systemFont(ofSize: 17, weight: .medium)]
    }
}
