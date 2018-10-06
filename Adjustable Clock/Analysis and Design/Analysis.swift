//
//  AnalysisAndDesign.swift
//  Adjustable Clock
//
//  Created by Matt Roberts on 5/27/18.
//  Copyright © 2018 Matt Roberts. All rights reserved.
//

//import Foundation

/*
 ClockVC
 ClockWC
 
 ColorModel--ClockNSColors, especially as pairs are currently used

 observer
 models
 functions
 
 heights/widths
 
 menu preferences
 
 other clocks
    timer
    alarm
    event
 
 city?
 other colors?
 timed color?
 in app purchases?
 
 readPreferencesModel
 
 have a model
 
 two ways to notify
 
 by searching windows
 
 by observer method
 
 for preferences
 update view
 public methods?
 
 for clock
 update functioning--model object?
 public methods
 
 animatetTimeAndDate
 
 animateJustTime
 
 changeModel
 changes based on prefrences
 animateClock
 
 updatePreferencesInClockModel
 updateClockModelForPreferences
 updateClockModel
 
 clock resize
 important to get label sizes right, so long as fit width and height
 clock resizes to fit width & proportional height
    --individual labels have max width
    --labels as a whole have a height that is less than a proportion of window width
      or less than screen height if that is bigger
    --clock makes a proportional to width for a given supported format
    --right now just have one format for time and one for date
    --called by one master function
 window adapts to clock
    --called by one master function
 
 live resize
 
 regular resize
    clock will get smaller if too big for screen
    will get 90% width untill fits on screen
    so will keep shrinking until fits
    labels will keep fitting width
    will be called in every clock resize
 
 possibilty for live resize
    resizes bigger
        if already if full screen, will prompt normal shrinking
    resizes to fit
        fits right off the bat
        will need to never require being below minimum font?
 
 class that fufills protocol
 
*/
