//
//  RecordSoundsViewController.swift
//  Pitch Perfect
//
//  Created by Brian Lindemann on 3/10/15.
//  Copyright (c) 2015 Brian Lindemann. All rights reserved.


import UIKit
import AVFoundation

class RecordSoundsViewController: UIViewController, AVAudioRecorderDelegate {
    //Declared Globally
    var audioRecorder:AVAudioRecorder!
    var recordedAudio:RecordedAudio!

    @IBOutlet weak var recordingInProgress: UILabel!
    @IBOutlet weak var tapToRecord: UILabel!
    
    @IBOutlet weak var stopButton: UIButton!
    
    @IBOutlet weak var recordButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    //Task 4: Always design UI assuming it will be used by someone who knows nothing about this app. This means you should always provide meaningful info on screen that will guide the user.
    //For example your landing page provides no information on how to use the application except a microphone icon. Adding just small message below the icon like “Tap to Record” would give a lot of help in using the application.
    // For task 4, added a new label with text "Tap to Record" - constrained to be vertically and horizontally alligned with the "Recording" label. One or the other will always be hidden and the other shown; created setRecordingText to switch between.
    // Putting this into the function setRecordingText will allow for easy refactoring in the case that a single label should be used, and only the text is changed between the two instances
    func setRecordingText(recording : Bool){
        recordingInProgress.hidden = !recording
        tapToRecord.hidden = recording
    }
    @IBAction func recordAudio(sender: UIButton) {
        setRecordingText(true)
        
        stopButton.hidden = false
        recordButton.enabled = false
        
        println("In Record")
        //Inside func recordAudio(sender: UIButton)
        let dirPath = NSSearchPathForDirectoriesInDomains(.DocumentDirectory, .UserDomainMask, true)[0] as String
        
        let currentDateTime = NSDate()
        let formatter = NSDateFormatter()
        formatter.dateFormat = "ddMMyyyy-HHmmss"
        let recordingName = formatter.stringFromDate(currentDateTime)+".wav"
        let pathArray = [dirPath, recordingName]
        let filePath = NSURL.fileURLWithPathComponents(pathArray)
        println(filePath)
        
        var session = AVAudioSession.sharedInstance()
        session.setCategory(AVAudioSessionCategoryPlayAndRecord, error: nil)
        
        audioRecorder = AVAudioRecorder(URL: filePath, settings: nil, error: nil)
        audioRecorder.meteringEnabled = true
        audioRecorder.delegate = self
        audioRecorder.prepareToRecord()
        audioRecorder.record()

    
    }
    //Task 1 (b) Then in RecordSoundsViewController, in the function audioRecorderDidFinishRecording, around line 66, call the initializer for RecordedAudio.

    func audioRecorderDidFinishRecording(recorder: AVAudioRecorder!, successfully flag: Bool) {
        if(flag) {
            recordedAudio = RecordedAudio(filePathUrl:recorder.url, title:recorder.url.lastPathComponent)
            
            self.performSegueWithIdentifier("stoprecording", sender: recordedAudio)
        }
        else {
            println("Recording was not successful")
            setRecordingText(false)
            
            tapToRecord.hidden = false
            stopButton.hidden = true
            
        }
    }
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if (segue.identifier == "stoprecording" ) {
            let playSoundsVC:PlaySoundsViewController = segue.destinationViewController as PlaySoundsViewController
            let data = sender as RecordedAudio
            playSoundsVC.receivedAudio = data
            
        }
    }

    @IBAction func stopRecording(sender: UIButton) {
        //setRecordingText(false)
        
        stopButton.hidden = true
        audioRecorder.stop()
        var session = AVAudioSession.sharedInstance()
        session.setActive(false,error: nil)
        
        
    }
    override func viewWillAppear(animated: Bool) {
        stopButton.hidden = true
        setRecordingText(false)
        recordButton.enabled = true
    }
}

