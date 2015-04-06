//
//  PlaySoundsViewController.swift
//  Pitch Perfect
//
//  Created by Brian Lindemann on 3/29/15.
//  Copyright (c) 2015 Brian Lindemann. All rights reserved.
//

import UIKit
import AVFoundation
let RunOnSimulator=false
// Development envrionment doesn't have audio input; do the movie quote in that environment. Swift doesn't have sophisticated pre-processor in the compile phase.

class PlaySoundsViewController: UIViewController {

    var audioPlayer:AVAudioPlayer!
    var receivedAudio:RecordedAudio!
    var audioEngine:AVAudioEngine!
    var audioFile:AVAudioFile!
    var filePathURL:NSURL!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        println("viewDidLoad")
        if (RunOnSimulator){
            if var filePath = NSBundle.mainBundle().pathForResource("movie_quote", ofType: "mp3"){
                filePathURL = NSURL.fileURLWithPath(filePath)
            }
            else {
                println("Unable to open movie_quote")
            }
        }
            
        else {
            
            filePathURL = receivedAudio.filePathUrl
        }
        
        println(filePathURL)
        audioPlayer = AVAudioPlayer(contentsOfURL: filePathURL, error: nil)
        audioPlayer.enableRate = true
        println("Playing")
        println(filePathURL)
        
        audioEngine = AVAudioEngine()
        audioFile = AVAudioFile(forReading: filePathURL, error: nil)
        
    }
    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(animated)
        // Code taken from: http://discussions.udacity.com/t/deleting-recorded-audio-files/12678/2
        stopPlayback()      //stops all playback prior to deleting file
        if receivedAudio.filePathUrl != nil{
            var paths = NSSearchPathForDirectoriesInDomains(.DocumentDirectory, .UserDomainMask, true)[0] as String
            var fileName = receivedAudio.title! as String!
            var fullFilePath = paths.stringByAppendingPathComponent(fileName)
            NSFileManager.defaultManager().removeItemAtPath(fullFilePath, error: nil)
            println("Deleting \(fullFilePath)")
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    func stopPlayback(){
        // Added based on usage suggested in viewWillDisappear; refactored other code to call this. Also part of Task 3.
        audioPlayer.stop()
        // Perform fixes for "Task 3"
        audioEngine.stop()
        audioEngine.reset()
        
    }
    @IBAction func StopAudio(sender: UIButton) {
        stopPlayback()
    }
    
    //Task 3: We found a bug in your app. Here is how to replicate it. Record a message for about 10 seconds. Then play it with the chipmunk effect. Soon after the audio starts playing, click the rabbit button to play it really fast. You will find that the chipmunk and the fast effect will overlap.
//    To fix this bug you will need to stop and reset the audioEngine from within the actions playSlowAudio and playFastAudio
    
    @IBAction func PlayFast(sender: UIButton) {
        stopPlayback()
        audioPlayer.rate = 2.0
        audioPlayer.play()
   }
       @IBAction func PlaySlow(sender: UIButton) {
        stopPlayback()
        audioPlayer.rate = 0.5
        audioPlayer.play()
    }
    func playAudioWithVariablePitch(pitch: Float){
        stopPlayback()
        
        var audioPlayerNode = AVAudioPlayerNode()
        audioEngine.attachNode(audioPlayerNode)
        
        var changePitchEffect = AVAudioUnitTimePitch()
        changePitchEffect.pitch = pitch
        audioEngine.attachNode(changePitchEffect)
        
        audioEngine.connect(audioPlayerNode, to: changePitchEffect, format: nil)
        audioEngine.connect(changePitchEffect, to: audioEngine.outputNode, format: nil)
        
        audioPlayerNode.scheduleFile(audioFile, atTime: nil, completionHandler: nil)
        audioEngine.startAndReturnError(nil)
        
        audioPlayerNode.play()
    }
    
    @IBAction func playDarthVader(sender: UIButton) {
        println("Playing DarthVader")
        playAudioWithVariablePitch(-1000)
    }
    @IBAction func playChipmunk(sender: UIButton) {
        println("Playing Chipmunk")
        playAudioWithVariablePitch(1000)
    }

}
