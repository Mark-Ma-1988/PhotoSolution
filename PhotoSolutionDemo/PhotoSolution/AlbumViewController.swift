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
        if #available(iOS 11.0, *) {
            let window = UIApplication.shared.keyWindow
            safeAreaTopHeight = window!.safeAreaInsets.top
        }else{
            safeAreaTopHeight = 0
        }
        if safeAreaTopHeight == 0{
            safeAreaTopHeight = UIApplication.shared.statusBarFrame.height
        }
        setupTopNavigationBar()
        setupTableView()
    }
    
    private func setupTopNavigationBar(){
        topNavigationBar = UINavigationBar(frame: CGRect(x: 0, y: safeAreaTopHeight, width: self.view.frame.width, height: navigationBarHeight))
        topNavigationBar.barTintColor = backgroundColor
        topNavigationBar.isTranslucent = false
        self.view.addSubview(topNavigationBar);

        let backItem = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.stop, target: self, action: #selector(backClick))
        topNavigationItem = UINavigationItem(title: customiseTitle);
        topNavigationItem.leftBarButtonItem = backItem
        topNavigationBar.setItems([topNavigationItem], animated: false);
    }
    
    private func setupTableView(){
        albumTableView = UITableView()
        albumTableView.frame = CGRect(x: 0, y: topNavigationBar.frame.maxY, width: self.view.frame.size.width, height: self.view.frame.size.height-navigationBarHeight-safeAreaTopHeight)
        albumTableView.register(UINib(nibName: "AlbumCell", bundle: nil), forCellReuseIdentifier: reuseIdentifier)
        albumTableView.tableHeaderView = UIView(frame: CGRect(x: 0, y: 0, width: albumTableView.frame.width, height: 0.5))
        albumTableView.tableHeaderView?.backgroundColor = UIColor.lightGray
        albumTableView.tableFooterView = UIView()
        albumTableView.separatorColor = UIColor.lightGray
        albumTableView.bounces = false
        albumTableView.dataSource =  self
        albumTableView.delegate = self
        self.view.addSubview(albumTableView)
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
