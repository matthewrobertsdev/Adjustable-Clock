//
//  AppDelegate.swift
//  Digital Clock
//
//  Created by Matt Roberts on 7/14/17.
//  Copyright © 2017 Matt Roberts. All rights reserved.
//

/*
 Dseign
 Design/Analysis
    App must handle opening, closing, resuming, and clicking on dock icon
        To open must handle initial state and reloading old windows
        Closing should always save the window state
        Resuming should not need programming
        Clkicking on the dock icon should bring the app to focus, make any clock window key and front, and, if no clock window is present, make one and mnake it keyn and front
    App must have a resizable window containing a digitalClock and possibly the date
        App must have a minimum window size (absolute)
        App must have a maximum window size (based on screen the clock window is in)
        Clock window must be resizable by dragging corner
        Clock must automatically size itself based on initial or previous window size and screen size
    App must have preferences that let user
        let clock window float on top
        show/hide seconds
        use AM/Pm or 24 hour clock
        show/hide date
        choose color scheme
    App must have a main menu with preferences, about, show clock, make fullscreen, minimize, leave fullscreen, and show clock, (as well as defualt features).  It should have under the main menu the app menu, a window menu, a view menu, and a help menu
    App prefrences, once selected must save to preferences, update the clock, and the preferences window must display the last selected preferences when opened
        App must float/not float
        App must show seconds/not show seconds and have AM/PM and 24 hour mode, updating window size to be the same width but not different height, provided the height fits, and with the same top left corner place on screen
        App must show/hide date.  This can be done by changing alpha to 1 or 0, but a flag must also be set, so that alpha does not necssarily mean that date is off (in case the clock is just "paused", with no visible date
 
 Pseudocode
    App Delegate
 */
/*
 starting and stopping the app
 --save all necessary data before terminateing
 */


import Cocoa

@NSApplicationMain
//app delegate
class AppDelegate: NSObject, NSApplicationDelegate {
    
    var colorsMenuController: ColorsMenuController!

    
    func applicationDidFinishLaunching(_ aNotification: Notification) {
        
        let fontManager=NSFontManager()
        print("The available fonts are "+fontManager.availableFontFamilies.count.description)
        
        ClockPreferencesStorage.sharedInstance.loadUserPreferences()
        let appObject = NSApp as NSApplication
        let mainMenu=appObject.mainMenu as! MainMenu
        colorsMenuController=ColorsMenuController(colorsMenu: mainMenu.colorsMenu)
        
        
    }
    
    //if the dock icon is clicked or the app icon is double clicked
    func applicationShouldHandleReopen(_ sender: NSApplication,
                                                hasVisibleWindows flag: Bool) -> Bool{
        if(!isThereADigitalClockWindow()){
            let appObject = NSApp as NSApplication
            let mainMenu=appObject.mainMenu as! MainMenu
            mainMenu.showDigitalClock()
        }

        return false
    }

    func applicationWillTerminate(_ aNotification: Notification) {
        
        ifAppropriateClockSaveState()
        ifAppropriatePreferencesSaveState()
        // Insert code here to tear down your application
    }
}

/*
 design:
 basic
 a digital clock made with a window and an animated label
 preferences
 can change preferences
 size
 maybe can change with slider, radio, +/-, or number entry
 maybe can change if window can be made smaller than string/image
 style?
 24 hour/am or pm
 include date sometimes?
 format of date
 prominence
 can make always on top
 can make other windows go over it too
 other possibilities that could be done too//possibly from the same app:
 --a analog clock
 --a stopwatch
 --a timer
 
 design of preferences
 --toolbar--for sizing?
 --need what presented preferences
 --need sizing preference?
 
 window and size
 
 floats above all other windows
 
 size automatically shrinks to fit content
 
 content automatically fits window
 
 make very small
 make small
 make medium
 make large
 make extra-large
 make extra-extra-large
 
 content adjusts to window size
 
 scroller and/or number sizer
 
 command keys
 
 has maximum size equal to content size
 has minimum size equal to content size
 
 content
 min
 max
 adjusts absolute
 adjusts relative
 
 am pm/24 hour
 seconds
 date
 none
 short
 long
 
 content
 sizing
 minimum
 
 design ideas
 sizing
 --
 
 content
 shows seconds
 24 hour/versus am/pm
 show date
 type
 short
 long
 position
 all in one line?
 above?
 below
 style
 text color
 background color
 
 pseudocode
 use timer
 update label with current system time once a second
 use a new date each time
 make resizable
 have different options for what to display
 other possibility that could be done too:
 make it pretty
 
 preferences window
 --have only one size
 
 pseudocode overview
 launch digitalClock window
 if stored values are bad, load either small size clock, or very large size clock
 use size to fit function
 use timer to animate time
 use stackview to switch in and out date
 use size to fit function
 
 preferences
 adjust preferences
 
 when app terminates, save state
 
 old design:
 primary need: a digital clock of larger size then the OS clock
 possible designs
 resizable to fill window
 clock of certain sizes
 --a few options
 --multiple sizes
 clock of various precedences
 --can always *except in special circumstances* go on top of other windows
 --can hide behind other windows
 
 other possibilities that could be done too//possibly from the same app:
 --a analog clock
 --a stopwatch
 --a timer
 
 new code
 
 streamline preferences
 
 summary
 
 digital clock w and vc
 show seconds
 am/pm versus 24 hour
 show day of week
 show date
 make preferences appear once
 change colors
 click on dock or menu to make clock w reapear
 fullscreen
 get date display and preferences right
 fullscreen preferences
 
 change colors
 handle too tall windows
 initial load
 preferences window save origin?
 screens
 older computers
 timer
 help option
 close window
 key combos
 website
 name
 */
