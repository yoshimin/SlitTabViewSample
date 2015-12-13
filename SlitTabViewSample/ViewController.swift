//
//  ViewController.swift
//  Practice
//
//  Created by Shingai Yoshimi on 10/24/15.
//  Copyright © 2015 Shingai Yoshimi. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    enum Emotion: Int {
        case Happy = 0
        case Angry
        case Sad
    }
    
    @IBOutlet var tabView: SlitTabView!
    @IBOutlet var label: UILabel!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        tabView.setItems(["٩(๑^o^๑)۶", "٩(๑òωó๑)۶", "(˚ ˃̣̣̥ω˂̣̣̥ )"])
        tabView.selectedTabIndex = Emotion.Happy.rawValue
        
        didSelectTab()
    }
    
    @IBAction func didSelectTab() {
        if tabView.selectedTabIndex == Emotion.Happy.rawValue {
            self.label.text = "Happy"
        } else if tabView.selectedTabIndex == Emotion.Angry.rawValue {
            self.label.text = "Angry"
        } else {
            self.label.text = "Sad"
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

