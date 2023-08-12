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
    
    override func viewDidLoad() {
        super.viewDidLoad()

        if let movie = movie {
            ivMovie.image = movie.image as? UIImage
            tfTitle.text = movie.title
            tfCategories.text = movie.categories
            tfDuration.text = movie.duration
            tfRating.text = "⭐️ \(movie.rating)/10"
            tvSummary.text = movie.summary
        }
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        view.endEditing(true)
    }

    @IBAction func addEditMovie(_ sender: UIButton) {
        
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
