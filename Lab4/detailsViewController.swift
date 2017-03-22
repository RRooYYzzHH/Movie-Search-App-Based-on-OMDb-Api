//
//  detailsViewController.swift
//  Lab4
//
//  Created by RoYzH on 2/22/17.
//  Copyright © 2017 RoYzH. All rights reserved.
//

import UIKit


class detailsViewController: UIViewController {
    
    @IBOutlet weak var imageLabel: UIImageView!
    
    @IBOutlet weak var releasedLabel: UILabel!
    @IBOutlet weak var ratingLabel: UILabel!
    @IBOutlet weak var scoreLabel: UILabel!
 
    var image: UIImage!
    
    var movie: Movies!
    
    @IBAction func addFavorites(_ sender: Any) {
        favMovies.append(movie)
        favMoviesImage.append(image)
        CoreDataManager.storeObj(title: movie.title, poster: movie.poster, released: movie.released, rated: movie.rated, score: movie.score)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        releasedLabel.text! = movie.released
        ratingLabel.text! = movie.rated
        scoreLabel.text! = movie.score
        imageLabel.image = image
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}
