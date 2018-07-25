//
//  AlbumTableViewController.swift
//  PhotoSolutionDemo
//
//  Created by MA XINGCHEN on 25/7/18.
//  Copyright © 2018 mark. All rights reserved.
//

import UIKit

class AlbumTableViewController: UIViewController {
    
    @IBOutlet weak var albumTableView: UITableView!
    private var albums: [Album]!
    private let reuseIdentifier = "AlbumCellIdentifier"
    private let rowHeight = CGFloat(60)
    var photoNavigationController: PhotoNavigationController!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        photoNavigationController = self.navigationController as! PhotoNavigationController
        self.albums = photoNavigationController.albums!
        albumTableView.register(UINib(nibName: "AlbumCell", bundle: nil), forCellReuseIdentifier: reuseIdentifier)
        albumTableView.tableFooterView = UIView()
        albumTableView.separatorColor = UIColor.lightGray
        albumTableView.bounces = false
    }

    @IBAction func cancelClick(_ sender: UIBarButtonItem) {
        photoNavigationController.solutionDelegate?.pickerCancel()
        self.navigationController?.dismiss(animated: true, completion: nil)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "showAlbumPhotos" {
            if let photoCollectionViewController = segue.destination as? PhotoCollectionViewController {
                let selectedIndex = sender as! Int
                photoCollectionViewController.selectedAlbumIndex = selectedIndex
                photoCollectionViewController.title = albums[selectedIndex].getAlbumName()
            }
        }
    }

}

extension AlbumTableViewController: UITableViewDataSource{
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int{
        return albums!.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat{
        return rowHeight
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell=tableView.dequeueReusableCell(withIdentifier: reuseIdentifier, for: indexPath) as! AlbumCell
        cell.configViewWithData(album: albums[indexPath.row])
        return cell
    }
    
}

extension AlbumTableViewController: UITableViewDelegate{
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.performSegue(withIdentifier: "showAlbumPhotos", sender: indexPath.row)
    }
    
}
