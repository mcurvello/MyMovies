//
//  MoviesViewController.swift
//  MyMovies
//
//  Created by Marcio Curvello on 12/08/23.
//

import UIKit

class MoviesViewController: UITableViewController {

    var movies: [Movie] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        loadMovies()
    }

    // MARK: - Table view data source
    func loadMovies() {
        
        guard let fileURL = Bundle.main.url(forResource: "movies", withExtension: "json") else {return}
        
        do {
            let data = try Data(contentsOf: fileURL)
            
            movies = try JSONDecoder().decode([Movie].self, from: data)
            
            for movie in movies {
                print (movie.title, "-", movie.duration)
            }
        } catch {
            print(error.localizedDescription)
        }
    }

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return movies.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! MovieTableViewCell

        // Configure the cell...
        let movie = movies[indexPath.row]
        
        cell.ivMovie.image = UIImage(named: movie.image)
        cell.lbTitle.text = movie.title
        cell.lbSummary.text = movie.summary

        return cell
    }

}
