//
//  ViewController.swift
//  TastyRecipes
//
//  Created by Daria Zugravu on 4/4/20.
//  Copyright © 2020 Daria Zugravu. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    
    @IBOutlet weak var mainLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(ViewController.tapFunction))
        mainLabel.isUserInteractionEnabled = true
        mainLabel.addGestureRecognizer(tap)
    }

   @IBAction func tapFunction(sender: UITapGestureRecognizer) {
        performSegue(withIdentifier: "startExploring", sender: self)
    }
    
    
}

