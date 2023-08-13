//
//  ViewController.swift
//  MyMovies
//
//  Created by Marcio Curvello on 11/08/23.
//

import UIKit

class ViewController: UIViewController {
    
    var movie: Movie?
    var trailer: String = ""
    
    @IBOutlet weak var ivMovie: UIImageView!
    @IBOutlet weak var lbTitle: UILabel!
    @IBOutlet weak var lbCategories: UILabel!
    @IBOutlet weak var lbDuration: UILabel!
    @IBOutlet weak var lbRating: UILabel!
    @IBOutlet weak var tvSummary: UITextView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let title = movie?.title {
            loadTrailers(title: title)
        }
    }
    
    func loadTrailers(title: String) {
        
        API.loadTrailers(title: title) { (apiResult) in
            guard let results = apiResult?.results, let trailer = results.first else {return}
            
            DispatchQueue.main.async {
                self.trailer = trailer.previewUrl
                print("URL do Trailer", trailer.previewUrl)
            }
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        if let movie = movie {
            ivMovie.image = movie.image as? UIImage
            lbTitle.text = movie.title
            lbCategories.text = movie.categories
            lbDuration.text = movie.duration
            lbRating.text = "⭐️ \(movie.rating)/10"
            tvSummary.text = movie.summary
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let vc = segue.destination as? AddEditViewController {
            vc.movie = movie
        }
    }
    
}
