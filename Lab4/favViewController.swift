//
//  favViewController.swift
//  Lab4
//
//  Created by RoYzH on 2/24/17.
//  Copyright © 2017 RoYzH. All rights reserved.
//

import UIKit

class favViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    @IBOutlet weak var tableView: UITableView!
    
    override func viewWillAppear(_ animated: Bool) {
        self.tableView.reloadData()
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        tableView.dataSource = self
        tableView.delegate = self
        self.tableView.reloadData()
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == UITableViewCellEditingStyle.delete {
            CoreDataManager.deleteData(title: favMovies[indexPath.row].title)
            favMovies.remove(at: indexPath.row)
            favMoviesImage.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: UITableViewRowAnimation.automatic)
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return favMovies.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "favTableCell", for: indexPath) as! favTableViewCell
        cell.favButton.setTitle(favMovies[indexPath.row].title, for: .normal)
        return cell
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    // MARK: - Navigation
    func findMovies(name: String) -> Int {
        var index: Int = -1
        for i in 0..<favMovies.count {
            if favMovies[i].title == name {
                index = i
            }
        }
        return index
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
        let svc = segue.destination as! favDetailsViewController
        let buttonSender = sender as! UIButton
        let moviesName = buttonSender.titleLabel?.text
        let index = findMovies(name: moviesName!)
        svc.index = index
        svc.movie = favMovies[index]
        svc.image = favMoviesImage[index]
    }
}
