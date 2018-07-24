//
//  NVC.swift
//  PhotoSolutionDemo
//
//  Created by MA XINGCHEN on 24/7/18.
//  Copyright © 2018 mark. All rights reserved.
//

import UIKit

class NVC: UINavigationController {

    override func viewDidLoad() {
        super.viewDidLoad()
        self.performSegue(withIdentifier: "showUserChangeEmailVC", sender: nil)
        
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
