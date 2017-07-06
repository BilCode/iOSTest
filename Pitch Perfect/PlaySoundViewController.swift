//
//  PlaySoundViewController.swift
//  Pitch Perfect
//
//  Created by Bilal on 6/21/17.
//  Copyright © 2017 Bilal. All rights reserved.
//

import UIKit
import AVFoundation

class PlaySoundViewController: UIViewController {
    
    var audioPlayer: AVAudioPlayer!
    var receiveAudio : RecordedAudio!
    var audioEngine: AVAudioEngine!
    var audioFile: AVAudioFile!
    
    override func viewDidLoad()  {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
//        if var filepath = NSBundle.mainBundle().pathForResource("movie_quote", ofType: "mp3"){
//            var filePathURL = NSURL.fileURLWithPath(filepath)
        
            audioPlayer = try! AVAudioPlayer(contentsOfURL: receiveAudio.filePathUrl) ;
            audioPlayer.enableRate=true;
            
       // }
        
        audioEngine = AVAudioEngine()
        try! audioFile = AVAudioFile(forReading: receiveAudio.filePathUrl)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func slowPlay(sender: AnyObject) {
        audioEngine.reset()
        audioEngine.stop()
        audioPlayer.stop()
        audioPlayer.rate=0.5
        audioPlayer.currentTime=0.0
        audioPlayer.play()
    }
    
    @IBAction func fastPlay(sender: UIButton) {
        audioEngine.reset()
        audioEngine.stop()
        audioPlayer.stop()
        audioPlayer.rate=1.5
        audioPlayer.currentTime=0.0
        audioPlayer.play()
    }

    @IBAction func stopPlay(sender: UIButton) {
        audioPlayer.stop();
        audioPlayer.stop();
        audioEngine.stop()

    }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */
    
    @IBAction func highPitch(sender: UIButton) {
        playWithPitch(1000);
        
    }
    
    func playWithPitch(pitch: Float) {
        let effect = AVAudioUnitTimePitch()
        effect.pitch = pitch
        
        playWithEffect(effect)
    }
    
    func playWithEffect(effect: AVAudioUnit) {
        audioPlayer.stop();
        audioEngine.stop()
        audioEngine.reset()
        let session = AVAudioSession.sharedInstance()
        try! session.overrideOutputAudioPort(AVAudioSessionPortOverride.Speaker)
    
        let audioPlayerNode = AVAudioPlayerNode()
        audioEngine.attachNode(audioPlayerNode)
        audioEngine.attachNode(effect)
        audioEngine.connect(audioPlayerNode, to: effect, format: nil)
        audioEngine.connect(effect, to: audioEngine.outputNode, format: nil)
    
        audioPlayerNode.scheduleFile(audioFile, atTime: nil, completionHandler: nil)
    
        try! audioEngine.start()
    
        audioPlayerNode.play()
    }

    @IBAction func lowPitch(sender: UIButton) {
        playWithPitch(-1000);
    }
}
