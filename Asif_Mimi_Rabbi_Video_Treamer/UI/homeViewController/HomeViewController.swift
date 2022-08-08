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
    
}

