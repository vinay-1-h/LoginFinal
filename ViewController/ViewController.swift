//
//  ViewController.swift
//  LoginFinal
//
//  Created by Vinay on 18/12/23.
//

import UIKit
import AVKit

class MainViewController: UIViewController {
    
    @IBOutlet weak var loginButton: UIButton!
    @IBOutlet weak var signButton: UIButton!
    var videoPlayer:AVPlayer?
    
    var videoPlayerLayer:AVPlayerLayer?

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        Helper.styleHollowButton(loginButton)
        Helper.styleHollowButton(signButton)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
        // Set up video in the background
        setUpVideo()
    }


    @IBAction func loginAction(_ sender: Any) {
     logonScreen()
    }
    
    @IBAction func signUPAction(_ sender: Any) {
       signUpScreen()
    }
}


extension MainViewController {
    
    func logonScreen() {
        let vc = (UIStoryboard(name: "LogonViewController", bundle: Bundle.main).instantiateViewController(withIdentifier: "LogonViewController") as? LogonViewController)!
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    func signUpScreen() {
        let vc = (UIStoryboard(name: "SignUpViewController", bundle: Bundle.main).instantiateViewController(withIdentifier: "SignUpViewController") as? SignUpViewController)!
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    func setUpVideo() {
        
        // Get the path to the resource in the bundle
        let bundlePath = Bundle.main.path(forResource: "loginbg", ofType: "mp4")
        
        guard bundlePath != nil else {
            return
        }
        
        // Create a URL from it
        let url = URL(fileURLWithPath: bundlePath!)
        
        // Create the video player item
        let item = AVPlayerItem(url: url)
        
        // Create the player
        videoPlayer = AVPlayer(playerItem: item)
        
        // Create the layer
        videoPlayerLayer = AVPlayerLayer(player: videoPlayer!)
        
        // Adjust the size and frame
        videoPlayerLayer?.frame = CGRect(x: -self.view.frame.size.width*1.5, y: 0, width: self.view.frame.size.width*4, height: self.view.frame.size.height)
        
        view.layer.insertSublayer(videoPlayerLayer!, at: 0)
        
        // Add it to the view and play it
        videoPlayer?.playImmediately(atRate: 0.3)
    }
}

