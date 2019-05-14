//
//  ViewController.swift
//  player
//
//  Created by Ivan Ignatkov on 2019-04-30.
//  Copyright © 2019 TechCompetence. All rights reserved.
//

import UIKit
import AVFoundation
import Kingfisher

class AVPLayerVC: UIViewController {
    
    @IBOutlet weak var musikImage: UIImageView!
    @IBOutlet weak var playBtn: UIButton!
    @IBOutlet weak var pauseBtn: UIButton!
    @IBOutlet weak var musikNameLbl: UILabel!
    @IBOutlet weak var musikSlider: UISlider!
    @IBOutlet weak var MusikTimerMainLbl: UILabel!
    
    
    var avPlayer = AVPlayer()
    var audioStuffed = false
    var avPlayerItem:AVPlayerItem?
    var luanURL: Int?
    var luanTime: String?
    var player = [PlayerModel]()
   //var currentURL = URL(string: "")
  

    //var player:AVAudioPlayer = AVAudioPlayer()

    override func viewDidLoad() {
        super.viewDidLoad()
        // gets channel id //
        getAPI(id: luanURL ?? 132)
        ///////////////////////
        let urlstring = URL(string: "http://api.sr.se/api/v2/channels/\(luanURL ?? 132)?format=json")
       // let urlstring = "http://sverigesradio.se/topsy/direkt/srapi/\(String(describing: luanURL)).mp3"
        let url = urlstring
        print("playing \(String(describing: url))")
        avPlayerItem = AVPlayerItem.init(url: url! as URL)
        avPlayer = AVPlayer.init(playerItem: avPlayerItem)
        avPlayer.volume = 1.0
        avPlayer.play()
        
        // plays music //
        playMusik(url: urlstring!)
        // shows time //
        MusikTimerMainLbl.text = luanTime! + " min"
       
        
     
    }
    
   
    @IBAction func sliderAction(_ sender: AnyObject) {
        if avPlayer != nil {
            avPlayer.volume = musikSlider.value
        }
    }
    
    

    @IBAction func play(_ sender: Any)
    {//        if audioStuffed == true && avPlayer.isPlaying == false//        {
//            avPlayer.play()
//        }
        avPlayer.play()
        pauseBtn.alpha = 1
        playBtn.alpha = 0.4
       
    }
    
    
    @IBAction func pause(_ sender: Any)
    {
//        if audioStuffed == true && avPlayer.isPlaying
//        {
//            avPlayer.pause()
//        }
        avPlayer.pause()
        playBtn.alpha = 1
        pauseBtn.alpha = 0.4
       
    }
    
    func playMusik(url:URL) {
        print("playing \(url)")

//let url = NSURL(string: urlstring)
            avPlayerItem = AVPlayerItem.init(url: url)
            avPlayer = AVPlayer.init(playerItem: avPlayerItem)
            avPlayer.volume = 1.0
            avPlayer.play()
    }
    

    
func getAPI (id: Int) {
    guard let urlstring = URL(string: "http://api.sr.se/api/v2/channels/\(id)?format=json") else {return}
   
//    let url = urlstring
//            print("playing \(String(describing: url))")
//            avPlayerItem = AVPlayerItem.init(url: url)
//            avPlayer = AVPlayer.init(playerItem: avPlayerItem)
//            avPlayer.volume = 1.0
//            avPlayer.play()
    
    let session = URLSession.shared
    session.dataTask(with: urlstring) { (data, response, error) in
    
        if let data = data {
            do {
                guard let json = try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any] else {return}
                
               print(json)
                
                guard let channel = json["channel"] as? [String: Any] else {return}
                guard let name = channel["name"] as? String else {return}
                guard let image = channel["image"] as? String else {return}
                
                print("!!!!!!!!!!!!! \(name)")
                print("!!!!!!!!!!!!! \(image)")
                
                
                
                let save = PlayerModel(json: channel)
                self.player.append(save)
                
                let url = URL(string: image)
                self.musikImage.kf.setImage(with: url)
                
                DispatchQueue.main.async {
                self.musikNameLbl.text = name
                }
                
            } catch {
                print("error\(error)")
            }
            
        }
    }.resume()

}
    
}


// fixa en timer som räknar ut tiden och skriver ut en notification om man ska fortsätta spela musik eller avsluta och gå tillbaka till första view//
