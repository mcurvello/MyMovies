//
//  SettingsViewController.swift
//  MyMovies
//
//  Created by Marcio Curvello on 12/08/23.
//

import UIKit

class SettingsViewController: UIViewController {

    @IBOutlet weak var playSwitch: UISwitch!
    
    override func viewDidLoad() {
        super.viewDidLoad()

    }
    
    override func viewWillAppear(_ animated: Bool) {
        playSwitch.isOn = UserDefaults.standard.bool(forKey: "play")
    }
    
    @IBAction func changePlay(_ sender: Any) {
        UserDefaults.standard.set(playSwitch.isOn, forKey: "play")
    }

}
