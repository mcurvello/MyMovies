//
//  MovieTableViewCell.swift
//  MyMovies
//
//  Created by Marcio Curvello on 12/08/23.
//

import UIKit

class MovieTableViewCell: UITableViewCell {
    
    @IBOutlet weak var ivMovie: UIImageView!
    @IBOutlet weak var lbTitle: UILabel!
    @IBOutlet weak var lbSummary: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
