//
//  RecordSoundViewController.swift
//  Pitch Perfect
//
//  Created by Bilal on 6/12/17.
//  Copyright © 2017 Bilal. All rights reserved.
//

import UIKit
import AVFoundation


class RecordSoundViewController: UIViewController, AVAudioRecorderDelegate {
    
    var audioRecorder:AVAudioRecorder!
    var recordedAudio: RecordedAudio!

    @IBOutlet weak var recodingInProgress: UILabel!
    
    @IBOutlet weak var stopButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    override func viewWillAppear(animated: Bool) {
        stopButton.hidden=true
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBAction func recordAudio(sender: UIButton) {
        print("In record fun")
        recodingInProgress.hidden=false
        stopButton.hidden=false
        //record();
        
        
        //Create the filepath and URL for the audio file we are about to record:
        let dirPath = NSSearchPathForDirectoriesInDomains(.DocumentDirectory, .UserDomainMask, true)[0]
        let recordingName = "my_audio.wav"
        
        //Set the filePath url by loading in pathArray:
        let pathArray = [dirPath, recordingName]
        let filePath = NSURL.fileURLWithPathComponents(pathArray)
        
        //format the audio recorder session:
        let session = AVAudioSession.sharedInstance()
        do {
            try session.setCategory(AVAudioSessionCategoryRecord)
        } catch { print("session.setCategory not set to Record.") }
        
        //Initialize the audioRecorder Object from the filePath URL
        audioRecorder = try? AVAudioRecorder(URL: filePath!, settings: [:])
        
        //Set the delegate of the audioRecorder to the viewController
        audioRecorder.delegate = self
        
        //Prepare then start recording:
        audioRecorder.meteringEnabled = true
        audioRecorder.prepareToRecord()
        audioRecorder.record()
    }

    @IBAction func stopRecord(sender: UIButton) {
        print("audiostop")
        recodingInProgress.hidden=true
        self.audioRecorder.stop()
        let audioSession = AVAudioSession.sharedInstance()
        do {
            try audioSession.setActive(false)
        } catch {
        }
    }
    
    func record() {
        //init
        let audioSession:AVAudioSession = AVAudioSession.sharedInstance()
        
        //ask for permission
        if (audioSession.respondsToSelector("requestRecordPermission:")) {
            AVAudioSession.sharedInstance().requestRecordPermission({(granted: Bool)-> Void in
                if granted {
                    print("granted")

                    //set category and activate recorder session
                    try! audioSession.setCategory(AVAudioSessionCategoryPlayAndRecord)
                    try! audioSession.setActive(true)
                    
                    var documents: AnyObject = NSSearchPathForDirectoriesInDomains( NSSearchPathDirectory.DocumentDirectory,  NSSearchPathDomainMask.UserDomainMask, true)[0]
                    
                    //get documnets directory
                   // let documentsDirectory = NSSearchPathForDirectoriesInDomains(.DocumentDirectory, .UserDomainMask, true)[0]
                    let fullPath = documents.stringByAppendingPathComponent("voiceRecording.mp3")
                    let url = NSURL.fileURLWithPath(fullPath)
                    
                    print(url);
                    
                    //create AnyObject of settings
                    let settings: [String : AnyObject] = [
                        AVFormatIDKey:Int(kAudioFormatAppleIMA4), //Int required in Swift2
                        AVSampleRateKey:44100.0,
                        AVNumberOfChannelsKey:2,
                        AVEncoderBitRateKey:12800,
                        AVLinearPCMBitDepthKey:16,
                        AVEncoderAudioQualityKey:AVAudioQuality.Max.rawValue
                    ]
                    
                    //record
                    try! self.audioRecorder = AVAudioRecorder(URL: url, settings: settings)
                    self.audioRecorder.prepareToRecord()
                    self.audioRecorder.delegate=self;

                } else{
                    print("not granted")
                }
            })
        }
        
    }
    
    func audioRecorderDidFinishRecording(recorder: AVAudioRecorder, successfully flag: Bool) {
      
        if(flag){
            //TODO: Step -1 Save audio file
            recordedAudio=RecordedAudio();
            recordedAudio.filePathUrl = recorder.url;
            recordedAudio.title = recorder.url.lastPathComponent;
        
            //TODO: Step-2 Move next screen perform Sague
        print("Record done")
            self.performSegueWithIdentifier("stopRecording", sender: recordedAudio)
        }else{
            print("Record fail")
            stopButton.hidden=true
        }
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if(segue.identifier=="stopRecording"){
            let playSoundVC : PlaySoundViewController = segue . destinationViewController as! PlaySoundViewController;
            let data = sender as! RecordedAudio;
            playSoundVC.receiveAudio=data
        }
    }


}

