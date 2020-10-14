//
//  HomeViewController.swift
//  labs-ios-starter
//
//  Created by Bharat Kumar on 10/5/20.
//  Copyright © 2020 Spencer Curtis. All rights reserved.
//

import UIKit

class HomeViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
       let customizedBarItem = UIBarButtonItem(customView: settingBarButtonItem)
        navigationItem.rightBarButtonItem = customizedBarItem
        // Do any additional setup after loading the view.
    }
     
    
    var settingBarButtonItem: UIView {
       var view = UILabel()
        view.frame = CGRect(x: 0, y: 0, width: 22, height: 22)
        view.backgroundColor = .white

        view.layer.backgroundColor = UIColor(red: 0.129, green: 0.141, blue: 0.173, alpha: 1).cgColor

        var parent = self.view!
        parent.addSubview(view)
        view.translatesAutoresizingMaskIntoConstraints = false

        return view
    }
    
   
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
