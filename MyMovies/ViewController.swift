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
    var datePicker = UIDatePicker()
    var alert: UIAlertController!
    
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
        
        datePicker.minimumDate = Date()
        
        datePicker.addTarget(self, action: #selector(changeDate), for: .valueChanged)
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
    
    @objc func changeDate() {
        
        let dateFormatter = DateFormatter()
        
        dateFormatter.dateFormat = "dd/MM/yyyy HH:mm'h"
        
        alert.textFields?.first?.text = dateFormatter.string(from: datePicker.date)
    }
    
    @IBAction func scheduleNotifications(_ sender: Any) {
        
        alert = UIAlertController(title: "Lembrete", message: "Quando deseja ser lembrado de assistir o filme?", preferredStyle: .alert)
        
        alert.addTextField { (textField) in
            textField.placeholder = "Data do lembrete"
            self.datePicker.date = Date()
            self.datePicker.preferredDatePickerStyle = .wheels
            textField.inputView = self.datePicker
        }
        
        let okAction = UIAlertAction(title: "Agendar", style: .default) { (action) in
            self.schedule()
        }
        
        let cancelAction = UIAlertAction(title: "Cancelar", style: .cancel, handler: nil)
        
        alert.addAction(okAction)
        alert.addAction(cancelAction)
        
        present(alert, animated: true, completion: nil)
        
    }
    
    func schedule() {
        print("Usuário agendou o lembrete")
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
    
}
