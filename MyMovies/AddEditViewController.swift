//
//  AddEditViewController.swift
//  MyMovies
//
//  Created by Marcio Curvello on 12/08/23.
//

import UIKit

class AddEditViewController: UIViewController {

    var movie: Movie?
    
    @IBOutlet weak var tfTitle: UITextField!
    @IBOutlet weak var tfCategories: UITextField!
    @IBOutlet weak var tfRating: UITextField!
    @IBOutlet weak var tfDuration: UITextField!
    @IBOutlet weak var tvSummary: UITextView!
    @IBOutlet weak var ivMovie: UIImageView!
    @IBOutlet weak var addEditButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        if let movie = movie {
            ivMovie.image = movie.image as? UIImage
            tfTitle.text = movie.title
            tfCategories.text = movie.categories
            tfDuration.text = movie.duration
            tfRating.text = "⭐️ \(movie.rating)/10"
            tvSummary.text = movie.summary
            
            addEditButton.setTitle("Alterar", for: .normal)
        }
    }
    
    @IBAction func addPoster(_ sender: Any) {
        
        let alert = UIAlertController(title: "Selecionar pôester", message: "De onde você quer escolher o pôster?", preferredStyle: .actionSheet)
        
        if UIImagePickerController.isSourceTypeAvailable(.camera) {
            let cameraAction = UIAlertAction(title: "Câmera", style: .default) { (action) in
                self.selectPicture(source: .camera)
            }
            alert.addAction(cameraAction)
        }
        
        let libraryAction = UIAlertAction(title: "Biblioteca de Fotos", style: .default) { (action) in
            self.selectPicture(source: .photoLibrary)
        }
        alert.addAction(libraryAction)
        let photosAction = UIAlertAction(title: "Álbum de Fotos", style: .default) { (action) in
            self.selectPicture(source: .photoLibrary)
        }
        alert.addAction(photosAction)
        
        let cancelAction = UIAlertAction(title: "Cancelar", style: .cancel, handler: nil)
        alert.addAction(cancelAction)
        
        present(alert, animated: true, completion: nil)
    }
    
    func selectPicture(source: UIImagePickerController.SourceType) {
        
        let imagePicker = UIImagePickerController()
        
        imagePicker.sourceType = source
        imagePicker.delegate = self
        
        present(imagePicker, animated: true, completion: nil)
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        view.endEditing(true)
    }


    @IBAction func addEditMovie(_ sender: Any) {
        if movie == nil {
            movie = Movie(context: context)
        }
        
        movie?.title = tfTitle.text
        movie?.categories = tfCategories.text
        movie?.duration = tfDuration.text
        movie?.rating = Double(tfRating.text!) ?? 0
        movie?.image = ivMovie.image
        movie?.summary = tvSummary.text
        
        do {
            try context.save()
            
            navigationController?.popViewController(animated: true)
        } catch {
            print(error.localizedDescription)
        }
    }
    
}

extension AddEditViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        
        if let image = info[UIImagePickerController.InfoKey.originalImage] as? UIImage {
            
            let aspectRatio = image.size.width / image.size.height
            var smallSize: CGSize
            
            if aspectRatio > 1 {
                smallSize = CGSize(width: 800, height: 800/aspectRatio)
            } else {
                smallSize = CGSize(width: 800*aspectRatio, height: 800)
            }
            
            UIGraphicsBeginImageContext(smallSize)
            image.draw(in: CGRect(x: 0, y: 0, width: smallSize.width, height: smallSize.height))
            
            let smallImage = UIGraphicsGetImageFromCurrentImageContext()
            UIGraphicsEndImageContext()
            
            ivMovie.image = smallImage
            
            dismiss(animated: true, completion: nil)
        }
    }
}
