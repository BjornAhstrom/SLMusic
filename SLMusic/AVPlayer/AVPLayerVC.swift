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
    @IBOutlet weak var tripTimeLeft: UILabel!
    
    var timer = Timer()
    var isTimerRunning = false
    var counter = 0.0
    
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
//        let urlstring = URL(string: "http://api.sr.se/api/v2/channels/\(luanURL ?? 132)?format=json")
        guard let urlstring = URL(string: "http://sverigesradio.se/topsy/direkt/srapi/\(luanURL ?? 164).mp3") else { return }
//        print("playing \(String(describing: url))")
        
        avPlayerItem = AVPlayerItem.init(url: urlstring)
        avPlayer = AVPlayer.init(playerItem: avPlayerItem)
        avPlayer.volume = 1.0
        avPlayer.play()
        
        // starts timer //
        startTimer()
        // plays music //
        //playMusik(url: urlstring)
        // shows time //
        MusikTimerMainLbl.text = luanTime! + " min"
       
    
    }
    
    func startTimer() {
        if !isTimerRunning {
            timer = Timer.init(timeInterval: 0.1, target: self, selector: #selector(runTimer), userInfo: nil, repeats: true)
            isTimerRunning = true
        
        }
    }
    
    @objc func runTimer() {
        
        let currentTime = (luanTime! as NSString).integerValue
        print(currentTime)
        
        counter -= 0.1
        
        // hh: mm: ss
        let flooredCounter = Int(floor(counter))
        let hour = flooredCounter / 3600
        let minute = (flooredCounter % 3600) / 60
        var minuteString = "\(minute)"
        if minute < 10 {
            minuteString = "0\(minute)"
        }
        let second = (flooredCounter % 3600) % 60
        var secondString = "\(second)"
        if second < 10 {
            secondString = "0\(second)"
        }
        
        let decisecond = String(format: "%.1f", counter).components(separatedBy: ".").last!
        print("\(hour):\(minute):\(second)")
        
        tripTimeLeft.text = "\(counter)"
        
        
        
        if counter == 0 {
            timer.invalidate()
            self.avPlayer.pause()
//            let alertController = UIAlertController(title: "Resan är avslutad, message: Vill du avsluta musik?: OK":, preferredStyle: .alert)
//            let defaultAction = UIAlertAction(title: "Forstätta", style: .cancel, handler: nil)
//            let defaultAction = UIAlertAction(title: "OK", style: .cancel) { (UIAlertAction) in
//                self.navigationController!.popViewController(animated: true)
//            }
//
//            alertController.addAction(defaultAction)
//            self.present(alertController, animated: true, completion: nil)
//
            
            
            let alert = UIAlertController(title: "Resan är slut", message: "Vill du fortsätta musiken?", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { action in
                switch action.style{
                case .default:
                    self.avPlayer.play()
                    
                case .cancel:
                    self.navigationController!.popViewController(animated: true)
    
                    
                case .destructive:
                   print("destructive")
                @unknown default:
                    print("default")
                }}))
            self.present(alert, animated: true, completion: nil)
            
        }
        
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
