//
//  favDetailsViewController.swift
//  Lab4
//
//  Created by RoYzH on 3/2/17.
//  Copyright © 2017 RoYzH. All rights reserved.
//

import UIKit

class favDetailsViewController: UIViewController {

    @IBOutlet weak var movieImage: UIImageView!
    
    @IBOutlet weak var releasedLabel: UILabel!
    @IBOutlet weak var scoreLabel: UILabel!
    @IBOutlet weak var ratingLabel: UILabel!
    
    var index = 0
    
    var image: UIImage!
    
    var movie: Movies!
    
    @IBAction func deleteFav(_ sender: Any) {
        favMovies.remove(at: index)
        favMoviesImage.remove(at: index)
        CoreDataManager.deleteData(title: movie.title)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        releasedLabel.text! = movie.released
        ratingLabel.text! = movie.rated
        scoreLabel.text! = movie.score
        movieImage.image = image
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
