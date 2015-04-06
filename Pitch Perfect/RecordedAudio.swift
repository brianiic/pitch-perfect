//
//  RecordedAudio.swift
//  Pitch Perfect
//
//  Created by Brian Lindemann on 3/31/15.
//  Copyright (c) 2015 Brian Lindemann. All rights reserved.
//
// Task 1 (a) In the class RecordedAudio, you have currently defined two class variables called title and filePathUrl. The correct way to initialize these is using an initializer, sometimes also called a constructor.  Add an initializer to this class to initialize these properties.

import Foundation

class RecordedAudio: NSObject{
    var filePathUrl: NSURL!
    var title: String!
    init (filePathUrl: NSURL, title : String?)
    {
        self.filePathUrl = filePathUrl
        self.title = title
    }
}