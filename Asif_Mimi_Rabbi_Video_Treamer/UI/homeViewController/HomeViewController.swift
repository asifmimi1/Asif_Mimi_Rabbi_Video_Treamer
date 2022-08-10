//
//  ViewController.swift
//  Asif_Mimi_Rabbi_Video_Treamer
//
//  Created by Asif Rabbi on 6/8/22.
//

import UIKit
import AVFoundation

class HomeViewController: UIViewController, UIImagePickerControllerDelegate & UINavigationControllerDelegate {
    
    let picker = UIImagePickerController()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }

    override func viewDidAppear(_ animated: Bool) {
        if Toast.sharedInstance.isToastAvailable {
            showToast(message: Toast.sharedInstance.message ?? "", font: UIFont(name: "Helvetica", size: 12)!)
        }
    }
    
    @IBAction func selectVideoBtn(_ sender: UIButton) {
        openVideoGallery()
    }
    
    func openVideoGallery() {
        picker.delegate = self
        picker.sourceType = .savedPhotosAlbum
        picker.mediaTypes = ["public.movie"]
        picker.allowsEditing = true
        present(picker, animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        
        picker.dismiss(animated: true, completion: nil)
        
        let url = info[UIImagePickerController.InfoKey.mediaURL] as? NSURL
        let asset = AVURLAsset.init(url: url! as URL)
        
        let mainstoryBoard = UIStoryboard(name:"Main", bundle: nil)
        let viewcontroller = mainstoryBoard.instantiateViewController(withIdentifier:"SelectedViewController") as! SelectedViewController
        viewcontroller.url = url
        viewcontroller.asset = asset
        
        viewcontroller.modalPresentationStyle = .fullScreen
        self.present(viewcontroller, animated: true, completion: nil)
        
    }
    
    func showToast(message : String, font: UIFont) {
        
        let toastLabel = UILabel(frame: CGRect(x: self.view.frame.size.width/2 - 75, y: self.view.frame.size.height-100, width: 150, height: 35))
        toastLabel.backgroundColor = UIColor.lightGray
        toastLabel.textColor = UIColor.black
        toastLabel.font = font
        toastLabel.textAlignment = .center;
        toastLabel.text = message
        toastLabel.alpha = 1.0
        toastLabel.layer.cornerRadius = 10;
        toastLabel.clipsToBounds  =  true
        
        self.view.addSubview(toastLabel)
        
        UIView.animate(withDuration: 4.0, delay: 0.1, options: .curveEaseOut, animations: {
            toastLabel.alpha = 0.0
        }, completion: {(isCompleted) in
            toastLabel.removeFromSuperview()
        })
    }
}

//Singleton
class Toast {
    static var sharedInstance = Toast()
    private init() {}
    
    var isToastAvailable: Bool = false
    var message: String?
}
