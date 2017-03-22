//
//  moviesViewController.swift
//  Lab4
//
//  Created by RoYzH on 2/15/17.
//  Copyright © 2017 RoYzH. All rights reserved.
//

import UIKit

var favMovies = [Movies]()
var favMoviesImage = [UIImage]()

class moviesViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource {
    
    @IBOutlet weak var moviesCV: UICollectionView!
    
    var movieTitle = [String]()
    
    var filtered = [Movies]()
    
    var theImageCache: [UIImage] = []
    
    //var activityIndicator: UIActivityIndicatorView = UIActivityIndicatorView()
    
    var view1 = UIView()
    
    // Search using Name
    @IBOutlet weak var searchText: UITextField!
    
    @IBAction func searchButton(_ sender: Any) {
        self.view.addSubview(view1)
        
        movieTitle.removeAll()
        filtered.removeAll()
        theImageCache.removeAll()
        
        self.moviesCV.reloadData()
        
        let backgroundQueue = DispatchQueue.global()
        backgroundQueue.async {
            self.retrieveMoviesByTerm(searchTerm: self.searchText.text!, tag: 1)
            if(self.filtered.count > 0) {
                self.cacheImages()
            }
            
            let test = DispatchQueue.main
            test.async {
                self.moviesCV.reloadData()
                for subview in self.view.subviews {
                    if (subview.tag == 1000) {
                        subview.removeFromSuperview()
                    }
                }
            }
        }
    }
    
    // Search by ID
    @IBOutlet weak var searchID: UITextField!
    
    @IBAction func searchIDButton(_ sender: Any) {
        self.view.addSubview(view1)
        
        movieTitle.removeAll()
        filtered.removeAll()
        theImageCache.removeAll()
        
        self.moviesCV.reloadData()
        
        let backgroundQueue = DispatchQueue.global()
        backgroundQueue.async {
            self.retrieveMoviesByTerm(searchTerm: self.searchID.text!, tag: 2)
            if(self.filtered.count > 0) {
                self.cacheImages()
            }
            
            let test = DispatchQueue.main
            test.async {
                self.moviesCV.reloadData()
                for subview in self.view.subviews {
                    if (subview.tag == 1000) {
                        subview.removeFromSuperview()
                    }
                }
            }
        }
    }
    
    // Initialize the Spinner
    func initializeSpinner() {
        view1 = UIView(frame: CGRect(x: 0, y: 0, width: 250, height: 50))
        view1.backgroundColor = UIColor.cyan
        view1.layer.cornerRadius = 10
        let wait = UIActivityIndicatorView(frame: CGRect(x: 0, y: 0, width: 50, height: 50))
        wait.color = UIColor.black
        wait.hidesWhenStopped = false
        wait.startAnimating()
        
        let text = UILabel(frame: CGRect(x: 60, y: 0, width: 200, height: 50))
        text.text = "Please wait......"
        
        view1.addSubview(wait)
        view1.addSubview(text)
        view1.center = self.view.center
        view1.tag = 1000
    }
    
    // Cache the Images
    private func cacheImages() {
        for item in filtered {
            if(item.poster != "N/A") {
                let url = URL(string: item.poster)
                let data = try? Data(contentsOf: url!)
                let image = UIImage(data: data!)
                theImageCache.append(image!)
            }
            else {
                theImageCache.append(UIImage(named: "noImage")!)
            }
        }
    }
    
    // Navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let svc = segue.destination as! detailsViewController
        let buttonSender = sender as! UIButton
        let index = buttonSender.tag
        svc.movie = filtered[index]
        svc.image = theImageCache[index]
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        self.moviesCV.delegate = self
        self.moviesCV.dataSource = self
        initializeSpinner()
        
        // Core Date Manager
        //CoreDataManager.storeObj(title:"YZH", poster: "N/A", released: "N/A", rated: "N/A", score: "N/A")
        favMovies = CoreDataManager.fetchObj()
        for movies in favMovies {
            if(movies.poster != "N/A") {
                let url = URL(string: movies.poster)
                let data = try? Data(contentsOf: url!)
                let image = UIImage(data: data!)
                favMoviesImage.append(image!)
            }
            else {
                favMoviesImage.append(UIImage(named: "noImage")!)
            }
        }
        filtered = favMovies
        theImageCache = favMoviesImage
        self.moviesCV.reloadData()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    // Collection View
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return filtered.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "moviesCell", for: indexPath) as! moviesCollectionViewCell
        
        let btnImage = theImageCache[indexPath.row]
        cell.imageButton.setBackgroundImage(btnImage, for: UIControlState.normal)
        cell.imageButton.tag = indexPath.row
        cell.imageLabel.text = filtered[indexPath.row].title
        return cell
    }
    
    // JSON
    private func getJSON(path: String) -> JSON {
        guard let url = URL(string: path) else { return JSON.null }
        do {
            let data = try Data(contentsOf: url)
            return JSON(data: data)
        } catch {
            return JSON.null
        }
    }
    
    func retrieveMoviesByTerm(searchTerm: String, tag: Int) {
        var Url = ""
        if(tag == 1) {
            Url = "https://www.omdbapi.com/?s=\(searchTerm)&r=json"
        }
        else if(tag == 2) {
            Url = "https://www.omdbapi.com/?i=\(searchTerm)&r=json"
        }
        let Json = getJSON(path: Url)
        
        let ifFound = Json["Response"].stringValue
        if(ifFound != "False") {
            // Search by Name
            if(tag == 1) {
                for item in Json["Search"].arrayValue {
                    movieTitle.append(item["imdbID"].stringValue)
                }
                for ID in movieTitle {
                    let url = "https://www.omdbapi.com/?i=\(ID)&type=movie&r=json"
                    let json = getJSON(path: url)
                    let title = json["Title"].stringValue
                    let poster = json["Poster"].stringValue
                    let released = json["Released"].stringValue
                    let rated = json["Rated"].stringValue
                    let score = json["Metascore"].stringValue
                    filtered.append(Movies(title: title, poster: poster, released: released, rated: rated, score: score))
                }
            }
            // Search by ID
            else if(tag == 2) {
                let title = Json["Title"].stringValue
                let poster = Json["Poster"].stringValue
                let released = Json["Released"].stringValue
                let rated = Json["Rated"].stringValue
                let score = Json["Metascore"].stringValue
                filtered.append(Movies(title: title, poster: poster, released: released, rated: rated, score: score))
            }
        }
    }
}
