//
//  SiteViewController.swift
//  MyMovies
//
//  Created by Marcio Curvello on 13/08/23.
//

import UIKit
import WebKit

class SiteViewController: UIViewController {

    @IBOutlet weak var webview: WKWebView!
    
    var site: String = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let url = URL(string: site) {
            let request = URLRequest(url: url)
            webview.load(request)
        }
    }
    
    @IBAction func close(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
}
