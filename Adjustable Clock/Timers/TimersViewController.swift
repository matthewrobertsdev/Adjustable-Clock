//
//  TimersViewController.swift
//  Adjustable Clock
//
//  Created by Matt Roberts on 2/4/20.
//  Copyright © 2020 Celeritas Apps. All rights reserved.
//
import Cocoa
class TimersViewController: ColorfulViewController, NSCollectionViewDataSource, NSCollectionViewDelegate {
	private let timeFormatter=DateFormatter()
	let popover = NSPopover()
	@IBOutlet weak var titleTextField: NSTextField!
	@IBOutlet weak var collectionView: NSCollectionView!
	var tellingTime: NSObjectProtocol?
	override func viewDidLoad() {
        super.viewDidLoad()
		//collectionView.indexPathForItem(at: NSPoint)
		collectionView.dataSource=self
		collectionView.delegate=self
		popover.appearance=NSAppearance(named: NSAppearance.Name.vibrantDark)
		collectionView.register(TimerCollectionViewItem.self, forItemWithIdentifier: NSUserInterfaceItemIdentifier(rawValue: "TimerCollectionViewItem"))
		update()
		let processOptions: ProcessInfo.ActivityOptions=[ProcessInfo.ActivityOptions.userInitiatedAllowingIdleSystemSleep]
		tellingTime = ProcessInfo().beginActivity(options: processOptions, reason: "Need accurate time for timers")
		timeFormatter.locale=Locale(identifier: "en_US")
		timeFormatter.setLocalizedDateFormatFromTemplate("hmm")
    }
	func update() {
		applyColorScheme(views: [ColorView](), labels: [titleTextField])
		collectionView.reloadData()
	}
	func collectionView(_ collectionView: NSCollectionView, numberOfItemsInSection section: Int) -> Int {
		3
	}
	func collectionView(_ collectionView: NSCollectionView, itemForRepresentedObjectAt indexPath: IndexPath) -> NSCollectionViewItem {
		guard let timerCollectionViewItem=collectionView.makeItem(withIdentifier: NSUserInterfaceItemIdentifier(rawValue: "TimerCollectionViewItem"), for: indexPath) as? TimerCollectionViewItem else {
			return NSCollectionViewItem()
		}
		timerCollectionViewItem.titleTextField.textColor=textColor
		timerCollectionViewItem.countdownTextField.textColor=textColor
		timerCollectionViewItem.stopTimeTextField.textColor=textColor
		timerCollectionViewItem.countdownTextField.stringValue=TimersCenter.sharedInstance.getCountDownString(index: indexPath.item)
		timerCollectionViewItem.startPauseButton.action=#selector(startPauseAction(sender:))
		timerCollectionViewItem.startPauseButton.tag=indexPath.item
		timerCollectionViewItem.settingsButton.tag=indexPath.item
		timerCollectionViewItem.settingsButton.action=#selector(showPopover(sender:))
		return timerCollectionViewItem
	}
	func scrollToTimer(index: Int) {
		collectionView.scrollToItems(at: [IndexPath(item: index, section: 0)], scrollPosition: NSCollectionView.ScrollPosition.centeredVertically)
	}
	func animateTimer(index: Int) {
		TimersCenter.sharedInstance.timers[index].going=true
		displayTimer(index: index)
		TimersCenter.sharedInstance.gcdTimers[index].schedule(deadline: .now(), repeating: .milliseconds(1000), leeway: .milliseconds(0))
		TimersCenter.sharedInstance.gcdTimers[index].setEventHandler {
			TimersCenter.sharedInstance.updateTimer(index: index)
			self.displayTimer(index: index)
			if TimersCenter.sharedInstance.timers[index].secondsRemaining<=0&&TimersCenter.sharedInstance.timers[index].going{
				print("abcd"+TimersCenter.sharedInstance.timers[index].secondsRemaining.description)
				if let timerCollectionViewItem=self.collectionView.item(at: index) as? TimerCollectionViewItem {
					timerCollectionViewItem.startPauseButton.title="Start"
				}
				self.timerStopped(index: index)
			}
		}
		TimersCenter.sharedInstance.gcdTimers[index].resume()
	}
	func timerStopped(index: Int) {
		let timer=TimersCenter.sharedInstance.timers[index]
		timer.going=false
		let alertSound=NSSound(named: NSSound.Name(timer.alertString))
		var hasError=false
		if timer.alertStyle==AlertStyle.sound {
			alertSound?.loops=true
			alertSound?.play()
		} else if timer.alertStyle==AlertStyle.song {
			print("should play music")
			let playlistName=timer.song
			let appleScript =
			"""
			tell application "Music"
				play playlist "\(playlistName)"
			end tell
			"""
			var error: NSDictionary?
			if let scriptObject = NSAppleScript(source: appleScript) {
				if let outputString = scriptObject.executeAndReturnError(&error).stringValue {
					print(outputString)
				} else if error != nil {
					print("Error: ", error ?? "")
					hasError=true
					let alarmSound=NSSound(named: "Ping")
					alarmSound?.loops=true
					alarmSound?.play()
				}
			}
		}
		let timerAlert=NSAlert()
		timerAlert.messageText="Timer has gone off at \(self.timeFormatter.string(from: Date()))."
		timerAlert.addButton(withTitle: "Dismiss")
		timerAlert.icon=DockClockController.dockClockObject.getFreezeView(time: Date()).image()
		TimersWindowController.timersObject.showTimers()
		if timer.alertStyle==AlertStyle.song && !hasError {
			timerAlert.addButton(withTitle: "Stop Music")
		} else if timer.alertStyle==AlertStyle.song {
			timerAlert.messageText+="""
			  A playlist was supposed to play.  Please check your internet connection and that automation \
			of Music is allowed in Settings->Security and Privacy->Automation->Clock Suite.
			"""
		}
		timerAlert.beginSheetModal(for: TimersWindowController.timersObject.window ?? NSWindow()) { (modalResponse) in
			if timer.alertStyle==AlertStyle.sound {
				alertSound?.stop()
			} else if timer.alertStyle==AlertStyle.song{
				if modalResponse==NSApplication.ModalResponse.alertSecondButtonReturn {
					let appleScript =
					"""
					tell application "Music"
						stop
					end tell
					"""
					var error: NSDictionary?
					if let scriptObject = NSAppleScript(source: appleScript) {
						if let outputString = scriptObject.executeAndReturnError(&error).stringValue {
							print(outputString)
						} else if error != nil {
							print("Error: ", error ?? "")
						}
					}
				}
				alertSound?.stop()
			}
		}
	}
	func displayTimer(index: Int) {
		guard let colectionViewItem=collectionView.item(at: index) as? TimerCollectionViewItem else {
			return
		}
		colectionViewItem.countdownTextField.stringValue=TimersCenter.sharedInstance.getCountDownString(index: index)
	}
	@objc func startPauseAction(sender: Any?) {
		guard let startPauseButton=sender as? NSButton else {
			return
		}
		let index=startPauseButton.tag
		guard let timerCollectionViewItem=collectionView.item(at: index) as? TimerCollectionViewItem else {
			return
		}
		if TimersCenter.sharedInstance.timers[index].active {
			TimersCenter.sharedInstance.timers[index].active=false
			TimersCenter.sharedInstance.gcdTimers[index].cancel()
			timerCollectionViewItem.startPauseButton.title="Resume"
		} else {
		TimersCenter.sharedInstance.timers[index].active=true
			animateTimer(index: index)
			timerCollectionViewItem.startPauseButton.title="Pause"
		}
	}
	@objc func showPopover(sender: Any?) {
		guard let settingsButton=sender as? NSButton else {
			return
		}
		if  popover.isShown {
			popover.close()
		} else {
			let mainStoryBoard = NSStoryboard(name: "Main", bundle: nil)
			   guard let editableTimerViewController =
				mainStoryBoard.instantiateController(withIdentifier:
				   "EditableTimerViewController") as? EditableTimerViewController else { return }
		let index=settingsButton.tag
			editableTimerViewController.closeAction = { () -> Void in self.popover.close() }
			popover.contentViewController = editableTimerViewController
			editableTimerViewController.index=index
			popover.show(relativeTo: settingsButton.bounds, of: settingsButton, preferredEdge: NSRectEdge.minY)
		}
	}
}
