//
//  TimersViewController.swift
//  Adjustable Clock
//
//  Created by Matt Roberts on 2/4/20.
//  Copyright © 2020 Celeritas Apps. All rights reserved.
//
import Cocoa
import AVFoundation
class TimersViewController: ColorfulViewController,
	NSCollectionViewDataSource, NSCollectionViewDelegate, NSSoundDelegate {
	@IBOutlet weak var titleTextField: NSTextField!
	@IBOutlet weak var collectionView: NSCollectionView!
	@IBOutlet weak var timerActiveLabel: NSTextField!
	@IBOutlet weak var clickRecognizer: NSClickGestureRecognizer!
	private let timeFormatter=DateFormatter()
	private let stopTimeFormatter=DateFormatter()
	private let popover = NSPopover()
	private var dockDisplay=false
	private var player: AVAudioPlayer?
	private var soundCount=0
	let workspaceNotifcationCenter=NSWorkspace.shared.notificationCenter
	override func viewDidLoad() {
        super.viewDidLoad()
		collectionView.dataSource=self
		collectionView.delegate=self
		//popover.appearance=NSAppearance(named: NSAppearance.Name.vibrantDark)
		collectionView.register(TimerCollectionViewItem.self,
								forItemWithIdentifier: NSUserInterfaceItemIdentifier(rawValue: "TimerCollectionViewItem"))
		update()
		timeFormatter.locale=Locale(identifier: "en_US")
		timeFormatter.setLocalizedDateFormatFromTemplate("hmm")
		NotificationCenter.default.addObserver(self,
											   selector: #selector(showHideTimerActiveLabel), name: NSNotification.Name.activeCountChanged, object: nil)
		showHideTimerActiveLabel()
		clickRecognizer.isEnabled=false
		workspaceNotifcationCenter.addObserver(self, selector: #selector(updateForWake),
			name: NSWorkspace.screensDidWakeNotification, object: nil)
    }
	@objc func updateForWake() {
		collectionView.reloadData()
	}
	@IBAction func click(_ sender: Any) {
		popover.close()
		clickRecognizer.isEnabled=false
	}
	@objc func showHideTimerActiveLabel() {
		if TimersCenter.sharedInstance.activeTimers==0 {
			timerActiveLabel.isHidden=true
		} else {
			timerActiveLabel.isHidden=false
			var activeTimerString=String(TimersCenter.sharedInstance.activeTimers)
			if TimersCenter.sharedInstance.activeTimers<2 {
				activeTimerString+=" Timer Active: "
				activeTimerString+=DONTSTRING
				timerActiveLabel.stringValue=activeTimerString
			} else {
				activeTimerString+=" Timers Active: "
				activeTimerString+=DONTSTRING
				timerActiveLabel.stringValue=activeTimerString
			}
		}
	}
	@objc func resetTimer(sender: Any?) {
		guard let resetButton=sender as? NSButton else {
			return
		}
		let index=resetButton.tag
		guard let timerCollectionViewItem=collectionView.item(at: index) as? TimerCollectionViewItem else {
			return
		}
		if TimersCenter.sharedInstance.timers[index].reset {
			timerCollectionViewItem.startPauseButton.isHidden=true
			TimersCenter.sharedInstance.timers[index]=CountDownTimer()
			collectionView.reloadItems(at: [IndexPath(item: index, section: 0)])
			timerCollectionViewItem.countdownTextField.stringValue=TimersCenter.sharedInstance.getCountDownString(index: index)
		} else {
			timerCollectionViewItem.startPauseButton.isHidden=false
			TimersCenter.sharedInstance.timers[index].reset=true
			TimersCenter.sharedInstance.resetTimer(index: index)
			timerCollectionViewItem.countdownTextField.stringValue=TimersCenter.sharedInstance.getCountDownString(index: index)
			timerCollectionViewItem.stopTimeTextField.isHidden=true
		}
		timerCollectionViewItem.startPauseButton.title="Start"
		timerCollectionViewItem.resetButton.title="Clear"
	}
	func update() {
		applyColorScheme(views: [ColorView](), labels: [titleTextField, timerActiveLabel])
		if let timerWindowController=view.window?.windowController as? TimersWindowController {
			if !timerWindowController.fullscreen {
				timerWindowController.applyFloatState()
			}
		}
		if GeneralPreferencesStorage.sharedInstance.use24Hours {
			stopTimeFormatter.setLocalizedDateFormatFromTemplate("HHmmss")
		} else {
			stopTimeFormatter.setLocalizedDateFormatFromTemplate("hmmss")
		}
		collectionView.reloadData()
	}
	func collectionView(_ collectionView: NSCollectionView, numberOfItemsInSection section: Int) -> Int {
		3
	}
	func collectionView(_ collectionView: NSCollectionView, itemForRepresentedObjectAt
		indexPath: IndexPath) -> NSCollectionViewItem {
		guard let timerCollectionViewItem=collectionView.makeItem(withIdentifier:
			NSUserInterfaceItemIdentifier(rawValue: "TimerCollectionViewItem"),
																  for: indexPath) as? TimerCollectionViewItem else {
			return NSCollectionViewItem()
		}
		timerCollectionViewItem.titleTextField.textColor=textColor
		timerCollectionViewItem.countdownTextField.textColor=textColor
		let title=TimersCenter.sharedInstance.timers[indexPath.item].title
		if TimersCenter.sharedInstance.timers[indexPath.item].secondsRemaining<=0 {
			timerCollectionViewItem.startPauseButton.isHidden=true
		} else {
			timerCollectionViewItem.startPauseButton.isHidden=false
		}
		timerCollectionViewItem.titleTextField.stringValue=title=="" ? "Timer" : title
		timerCollectionViewItem.stopTimeTextField.textColor=textColor
		timerCollectionViewItem.countdownTextField.stringValue =
			dockDisplay ? "--" : TimersCenter.sharedInstance.getCountDownString(index: indexPath.item)
		timerCollectionViewItem.startPauseButton.action=#selector(startPauseAction(sender:))
		timerCollectionViewItem.startPauseButton.tag=indexPath.item
		timerCollectionViewItem.setButton.tag=indexPath.item
		timerCollectionViewItem.setButton.action=#selector(showPopover(sender:))
		timerCollectionViewItem.resetButton.tag=indexPath.item
		if TimersCenter.sharedInstance.timers[indexPath.item].reset { timerCollectionViewItem.resetButton.title="Clear"
		} else {
			timerCollectionViewItem.resetButton.title="Reset"
		}
		timerCollectionViewItem.resetButton.action=#selector(resetTimer(sender:))
		let timers=TimersCenter.sharedInstance.timers
		if timers[indexPath.item].active && timers[indexPath.item].going {
			if dockDisplay {
				timerCollectionViewItem.stopTimeTextField.isHidden=true
			} else {
				timerCollectionViewItem.stopTimeTextField.isHidden=false
			}
			timerCollectionViewItem.stopTimeTextField.stringValue=getStopTimeString(timerIndex: indexPath.item)
			timerCollectionViewItem.startPauseButton.title="Pause"
		} else if timers[indexPath.item].active && !timers[indexPath.item].going {
			timerCollectionViewItem.stopTimeTextField.isHidden=true
			timerCollectionViewItem.startPauseButton.title="Resume"
		} else {
			timerCollectionViewItem.stopTimeTextField.isHidden=true
			timerCollectionViewItem.startPauseButton.title="Start"
		}
		return timerCollectionViewItem
	}
	func getStopTimeString(timerIndex: Int) -> String {
		return "Ends: "+stopTimeFormatter.string(from: Date().addingTimeInterval(
			TimeInterval(TimersCenter.sharedInstance.timers[timerIndex].secondsRemaining)))
	}
	func displayForDock() {
		dockDisplay=true
		collectionView.reloadData()
	}
	func displayNormally() {
		dockDisplay=false
		collectionView.reloadData()
	}
	func scrollToTimer(index: Int) {
		collectionView.scrollToItems(at: [IndexPath(item: index, section: 0)],
									 scrollPosition: NSCollectionView.ScrollPosition.centeredVertically)
	}
	func animateTimer(index: Int) {
		TimersCenter.sharedInstance.timers[index].reset=false
		let timerCollectionViewItem=collectionView.item(at: IndexPath(item: index, section: 0)) as? TimerCollectionViewItem
		timerCollectionViewItem?.resetButton.title="Reset"
		timerCollectionViewItem?.stopTimeTextField.isHidden=false
		timerCollectionViewItem?.stopTimeTextField.stringValue=getStopTimeString(timerIndex: index)
		TimersCenter.sharedInstance.activeTimers+=1
		TimersCenter.sharedInstance.timers[index].going=true
		displayTimer(index: index)
		if TimersCenter.sharedInstance.timers[index].secondsRemaining<=0
			&&  TimersCenter.sharedInstance.timers[index].active {
			TimersCenter.sharedInstance.activeTimers-=1
			self.timerStopped(index: index)
			timerCollectionViewItem?.startPauseButton.title="Start"
			return
		}
		TimersCenter.sharedInstance.gcdTimers[index].schedule(deadline: .now()+1, repeating: .milliseconds(1000),
															  leeway: .milliseconds(0))
		TimersCenter.sharedInstance.gcdTimers[index].setEventHandler {
			TimersCenter.sharedInstance.updateTimer(index: index)
			self.displayTimer(index: index)
			if TimersCenter.sharedInstance.timers[index].secondsRemaining<=0&&TimersCenter.sharedInstance.timers[index].going {
				if let timerCollectionViewItem=self.collectionView.item(at: index) as? TimerCollectionViewItem {
					timerCollectionViewItem.startPauseButton.title="Start"
				}
				if TimersCenter.sharedInstance.timers[index].active {
					if let 	timerCollectionViewItem=self.collectionView.item(at: index) as? TimerCollectionViewItem {
						timerCollectionViewItem.startPauseButton.title="Pause"
						timerCollectionViewItem.resetButton.title="Reset"
						self.timerStopped(index: index)
					}
				}
			}
		}
		TimersCenter.sharedInstance.gcdTimers[index].resume()
	}
	func timerStopped(index: Int) {
		let timerCollectionViewItem=collectionView.item(at: IndexPath(item: index, section: 0)) as? TimerCollectionViewItem
		timerCollectionViewItem?.startPauseButton.isHidden=true
		timerCollectionViewItem?.startPauseButton.title="Start"
		if TimersCenter.sharedInstance.timers[index]==CountDownTimer() {
			TimersCenter.sharedInstance.timers[index].reset=true
			timerCollectionViewItem?.resetButton.title="Clear"
		} else {
			timerCollectionViewItem?.resetButton.title="Reset"
		}
		timerCollectionViewItem?.stopTimeTextField.isHidden=true
		TimersCenter.sharedInstance.timers[index].active=false
		let timer=TimersCenter.sharedInstance.timers[index]
		timer.going=false
		let alertSound=NSSound(named: NSSound.Name(timer.alertString))
		alertSound?.delegate=self
		if timer.alertStyle==AlertStyle.sound {
			soundCount=0
			//alertSound?.loops=true
			alertSound?.play()
		} else if timer.alertStyle==AlertStyle.song {
			do {
				var saveURL=FileManager.default.urls(for: .applicationSupportDirectory, in: .userDomainMask).first
				saveURL=saveURL?.appendingPathComponent("Clock Suite")
				guard var validSaveURL=saveURL else {
					return
				}
				validSaveURL=validSaveURL.appendingPathComponent(timer.song)
				player=try AVAudioPlayer(contentsOf: URL(fileURLWithPath: validSaveURL.path))
				player?.prepareToPlay()
				player?.volume = 1.0
				player?.play()
			} catch {
				soundCount=0
				//alertSound?.loops=true
				alertSound?.play()
			}
		}
		let timerAlert=NSAlert()
		timerAlert.messageText = "\(timer.title=="" ? "Timer" : timer.title) " +
		"has gone off at \(self.timeFormatter.string(from: Date()))."
		timerAlert.addButton(withTitle: "Dismiss")
		timerAlert.icon=imageFromView(view: DockClockController.dockClockObject.getFreezeView(time: Date()))
		TimersWindowController.timersObject.showTimers()
		timerAlert.beginSheetModal(for: TimersWindowController.timersObject.window ?? NSWindow()) { (_) in
			if timer.alertStyle==AlertStyle.sound {
				alertSound?.stop()
			} else if timer.alertStyle==AlertStyle.song {
				self.player?.stop()
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
			timerCollectionViewItem.stopTimeTextField.isHidden=true
			TimersCenter.sharedInstance.stopTimer(index: index)
			timerCollectionViewItem.startPauseButton.title="Resume"
		} else {
		TimersCenter.sharedInstance.timers[index].active=true
			animateTimer(index: index)
			timerCollectionViewItem.startPauseButton.title="Pause"
			if TimersCenter.sharedInstance.timers[index].secondsRemaining<=0 {
				timerCollectionViewItem.startPauseButton.title="Start"
			}
		}
	}
	@objc func showPopover(sender: Any?) {
		let debugTimeFormatter=DateFormatter()
		debugTimeFormatter.setLocalizedDateFormatFromTemplate("MMdyyyyhhmmss")
		print("abcd \(debugTimeFormatter.string(from: Date())) popover should show")
		guard let settingsButton=sender as? NSButton else {
				print("abcd \(debugTimeFormatter.string(from: Date())) popover should show, but button was bad")
			return
		}
		print("abcd \(debugTimeFormatter.string(from: Date())) popover should show 2")
		if  popover.isShown {
			popover.close()
			print("abcd \(debugTimeFormatter.string(from: Date())) popover should close")
			clickRecognizer.isEnabled=false
		} else {
			clickRecognizer.isEnabled=true
			print("abcd \(debugTimeFormatter.string(from: Date())) popover should show 3")
			let mainStoryBoard = NSStoryboard(name: "Main", bundle: nil)
			   guard let editableTimerViewController =
				mainStoryBoard.instantiateController(withIdentifier:
				   "EditableTimerViewController") as? EditableTimerViewController else { return }
		let index=settingsButton.tag
			editableTimerViewController.closeAction = { () -> Void in
				self.collectionView.reloadItems(at: [IndexPath(item: index, section: 0)])
				self.popover.close()
				self.clickRecognizer.isEnabled=false
			}
			popover.contentViewController = editableTimerViewController
			editableTimerViewController.index=index
			popover.show(relativeTo: settingsButton.bounds, of: settingsButton, preferredEdge: NSRectEdge.minY)
			print("abcd \(debugTimeFormatter.string(from: Date())) popover should show 4")
		}
	}
	func sound(_ sound: NSSound,
			   didFinishPlaying flag: Bool) {
		if flag && soundCount<300 {
			sound.play()
			soundCount+=1
		}
	}
}
