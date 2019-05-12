//
//  ViewController.swift
//  player
//
//  Created by Ivan Ignatkov on 2019-04-30.
//  Copyright © 2019 TechCompetence. All rights reserved.
//

import UIKit
import AVFoundation

class AVPLayerVC: UIViewController {
    
    @IBOutlet weak var musikImage: UIImageView!
    @IBOutlet weak var prevBtn: UIButton!
    @IBOutlet weak var nextBtn: UIButton!
    @IBOutlet weak var playBtn: UIButton!
    @IBOutlet weak var musikNameLbl: UILabel!
    @IBOutlet weak var musikSlider: UISlider!
    @IBOutlet weak var musikTimerBeginLbl: UILabel!
    @IBOutlet weak var musikTimerFinishLbl: UILabel!
    @IBOutlet weak var MusikTimerMainLbl: UILabel!
    
  
    
  

    //var player:AVAudioPlayer = AVAudioPlayer()

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
//        do
//        {
//            let audioPath = Bundle.main.path(forResource: "song", ofType: "mp3")
//            try player = AVAudioPlayer(contentsOf:, fileTypeHint: <#T##String?#>)
//        }
//        catch
//        {
//            //ERROR
//        }
    }
    
   
//    
//    func isPlaying() -> Bool {
//        return player?.rate != nil && player?.rate != 0
//    }

    @IBAction func prevBtnClicked(_ sender: Any) {
    }
    
    
    @IBAction func playBtnClicked(_ sender: Any) {
        
//        if player.isPlaying == false {
//            pl.play()
//        }
//
//        if audioPlayer.isPlaying {
//            audioPlayer.pause()
//        }
        
//        if isPlaying {
//            player!.pause()
//        } else {
//            player!.play()
//        }
        
    }
    
    
    @IBAction func nextBtnClicked(_ sender: Any) {
        
        
    }
    
    @IBAction func musikSliderAction(_ sender: Any) {
        
    }
    
    
}

