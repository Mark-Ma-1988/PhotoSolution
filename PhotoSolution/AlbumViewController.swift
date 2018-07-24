//
//  AlbumViewController.swift
//  NG POC
//
//  Created by MA XINGCHEN on 7/7/18.
//  Copyright © 2018 mark. All rights reserved.
//

import UIKit

protocol AlbumViewControllerDelegate {
    func selectAlbum(_ selectedindex: Int)
}

class AlbumViewController: UIViewController {
    
    var customiseTitle: String = "Album"
    var backgroundColor: UIColor = UIColor.lightGray
    var albums: [Album]!
    var delegate: AlbumViewControllerDelegate?
    private let navigationBarHeight = CGFloat(40)
    private var safeAreaTopHeight: CGFloat!
    private var topNavigationBar: UINavigationBar!
    private var topNavigationItem: UINavigationItem!
    private var albumTableView: UITableView!
    private let reuseIdentifier = "AlbumCellIdentifier"
    private let rowHeight = CGFloat(60)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = backgroundColor
        setupTopNavigationBar()
        setupTableView()
        setupConstraint()
    }
    
    private func setupTopNavigationBar(){
        topNavigationBar = UINavigationBar()
        topNavigationBar.translatesAutoresizingMaskIntoConstraints = false
        self.view.addSubview(topNavigationBar)
        topNavigationBar.barTintColor = backgroundColor
        topNavigationBar.isTranslucent = false
        let backItem = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.stop, target: self, action: #selector(backClick))
        topNavigationItem = UINavigationItem(title: customiseTitle);
        topNavigationItem.leftBarButtonItem = backItem
        topNavigationBar.setItems([topNavigationItem], animated: false);
    }
    
    private func setupTableView(){
        albumTableView = UITableView()
        albumTableView.translatesAutoresizingMaskIntoConstraints = false
        self.view.addSubview(albumTableView)
        albumTableView.register(UINib(nibName: "AlbumCell", bundle: nil), forCellReuseIdentifier: reuseIdentifier)
        albumTableView.tableFooterView = UIView()
        albumTableView.separatorColor = UIColor.lightGray
        albumTableView.bounces = false
        albumTableView.dataSource =  self
        albumTableView.delegate = self
    }
    
    private func setupConstraint(){
        
        self.view.addConstraint(NSLayoutConstraint(item: topNavigationBar, attribute: .leading, relatedBy: .equal, toItem: self.view , attribute: .leading, multiplier: 1, constant: 0))
        self.view.addConstraint(NSLayoutConstraint(item: topNavigationBar, attribute: .trailing, relatedBy: .equal, toItem: self.view , attribute: .trailing, multiplier: 1, constant: 0))
        if #available(iOS 11.0, *) {
            self.view.addConstraint(NSLayoutConstraint(item: topNavigationBar, attribute: .top, relatedBy: .equal, toItem: self.view, attribute: .topMargin, multiplier: 1, constant: 0))
        } else {
            self.view.addConstraint(NSLayoutConstraint(item: topNavigationBar, attribute: .top, relatedBy: .equal, toItem: UIApplication.shared.keyWindow, attribute: .top, multiplier: 1, constant: UIApplication.shared.statusBarFrame.height))
        }
        self.topNavigationBar.addConstraint(NSLayoutConstraint(item: topNavigationBar, attribute: .height, relatedBy: .equal, toItem: nil , attribute: .notAnAttribute, multiplier: 1, constant: navigationBarHeight))
        
        self.view.addConstraint(NSLayoutConstraint(item: albumTableView, attribute: .leading, relatedBy: .equal, toItem: self.view , attribute: .leading, multiplier: 1, constant: 0))
        self.view.addConstraint(NSLayoutConstraint(item: albumTableView, attribute: .trailing, relatedBy: .equal, toItem: self.view , attribute: .trailing, multiplier: 1, constant: 0))
        self.view.addConstraint(NSLayoutConstraint(item: albumTableView, attribute: .top, relatedBy: .equal, toItem: topNavigationBar, attribute: .bottom, multiplier: 1, constant: 0))
        self.view.addConstraint(NSLayoutConstraint(item: albumTableView, attribute: .bottom, relatedBy: .equal, toItem: self.view , attribute: .bottom, multiplier: 1, constant: 0))
    }
    
    @objc func backClick(){
        self.dismiss(animated: true, completion: nil)
    }
    
}

extension AlbumViewController: UITableViewDataSource{
    
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

extension AlbumViewController: UITableViewDelegate{
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        delegate?.selectAlbum(indexPath.row)
        self.dismiss(animated: true, completion: nil)
    }
}
