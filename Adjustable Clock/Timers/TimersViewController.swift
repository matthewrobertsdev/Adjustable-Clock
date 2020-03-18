//
//  TimersViewController.swift
//  Adjustable Clock
//
//  Created by Matt Roberts on 2/4/20.
//  Copyright © 2020 Celeritas Apps. All rights reserved.
//
import Cocoa
import AVFoundation
class TimersViewController: ColorfulViewController, NSCollectionViewDataSource, NSCollectionViewDelegate {
	private let timeFormatter=DateFormatter()
	private let stopTimeFormatter=DateFormatter()
	let popover = NSPopover()
	var dockDisplay=false
	var player: AVAudioPlayer?
	@IBOutlet weak var titleTextField: NSTextField!
	@IBOutlet weak var collectionView: NSCollectionView!
	@IBOutlet weak var timerActiveLabel: NSTextField!
	override func viewDidLoad() {
        super.viewDidLoad()
		//collectionView.indexPathForItem(at: NSPoint)
		collectionView.dataSource=self
		collectionView.delegate=self
		popover.appearance=NSAppearance(named: NSAppearance.Name.vibrantDark)
		collectionView.register(TimerCollectionViewItem.self, forItemWithIdentifier: NSUserInterfaceItemIdentifier(rawValue: "TimerCollectionViewItem"))
		update()
		timeFormatter.locale=Locale(identifier: "en_US")
		timeFormatter.setLocalizedDateFormatFromTemplate("hmm")
		NotificationCenter.default.addObserver(self, selector: #selector(showHideTimerActiveLabel), name: NSNotification.Name.activeCountChanged, object: nil)
		showHideTimerActiveLabel()
    }
	@objc func showHideTimerActiveLabel() {
		if (TimersCenter.sharedInstance.activeTimers)>0 {
			self.timerActiveLabel.isHidden=false
		} else {
			self.timerActiveLabel.isHidden=true
		}
	}
	func update() {
		applyColorScheme(views: [ColorView](), labels: [titleTextField, timerActiveLabel])
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
	func collectionView(_ collectionView: NSCollectionView, itemForRepresentedObjectAt indexPath: IndexPath) -> NSCollectionViewItem {
		guard let timerCollectionViewItem=collectionView.makeItem(withIdentifier: NSUserInterfaceItemIdentifier(rawValue: "TimerCollectionViewItem"), for: indexPath) as? TimerCollectionViewItem else {
			return NSCollectionViewItem()
		}
		timerCollectionViewItem.titleTextField.textColor=textColor
		timerCollectionViewItem.countdownTextField.textColor=textColor
		let title=TimersCenter.sharedInstance.timers[indexPath.item].title
		timerCollectionViewItem.titleTextField.stringValue=title=="" ? "Timer \(indexPath.item+1)" : title
		timerCollectionViewItem.stopTimeTextField.textColor=textColor
		timerCollectionViewItem.countdownTextField.stringValue=dockDisplay ? "--" : TimersCenter.sharedInstance.getCountDownString(index: indexPath.item)
		timerCollectionViewItem.startPauseButton.action=#selector(startPauseAction(sender:))
		timerCollectionViewItem.startPauseButton.tag=indexPath.item
		timerCollectionViewItem.settingsButton.tag=indexPath.item
		timerCollectionViewItem.settingsButton.action=#selector(showPopover(sender:))
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
		return "Ends: "+stopTimeFormatter.string(from: Date().addingTimeInterval(TimeInterval(TimersCenter.sharedInstance.timers[timerIndex].secondsRemaining)))
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
		collectionView.scrollToItems(at: [IndexPath(item: index, section: 0)], scrollPosition: NSCollectionView.ScrollPosition.centeredVertically)
	}
	func animateTimer(index: Int) {
		let timerCollectionViewItem=collectionView.item(at: IndexPath(item: index, section: 0)) as? TimerCollectionViewItem
		timerCollectionViewItem?.stopTimeTextField.isHidden=false
		timerCollectionViewItem?.stopTimeTextField.stringValue=getStopTimeString(timerIndex: index)
		
		TimersCenter.sharedInstance.activeTimers+=1
		TimersCenter.sharedInstance.timers[index].going=true
		displayTimer(index: index)
		TimersCenter.sharedInstance.gcdTimers[index].schedule(deadline: .now(), repeating: .milliseconds(1000), leeway: .milliseconds(0))
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
					}
				}
				self.timerStopped(index: index)
			}
		}
		TimersCenter.sharedInstance.gcdTimers[index].resume()
	}
	func timerStopped(index: Int) {
		let timerCollectionViewItem=collectionView.item(at: IndexPath(item: index, section: 0)) as? TimerCollectionViewItem
		timerCollectionViewItem?.stopTimeTextField.isHidden=true
		TimersCenter.sharedInstance.activeTimers-=1
		let timer=TimersCenter.sharedInstance.timers[index]
		timer.going=false
		let alertSound=NSSound(named: NSSound.Name(timer.alertString))
		if timer.alertStyle==AlertStyle.sound {
			alertSound?.loops=true
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
				alertSound?.loops=true
				alertSound?.play()
			}
		}
		let timerAlert=NSAlert()
		timerAlert.messageText="Timer has gone off at \(self.timeFormatter.string(from: Date()))."
		timerAlert.addButton(withTitle: "Dismiss")
		timerAlert.icon=DockClockController.dockClockObject.getFreezeView(time: Date()).image()
		TimersWindowController.timersObject.showTimers()
		timerAlert.beginSheetModal(for: TimersWindowController.timersObject.window ?? NSWindow()) { (modalResponse) in
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
			TimersCenter.sharedInstance.activeTimers-=1
			TimersCenter.sharedInstance.timers[index].active=false
			TimersCenter.sharedInstance.gcdTimers[index].suspend()
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
			editableTimerViewController.closeAction = { () -> Void in
				self.collectionView.reloadItems(at: [IndexPath(item: index, section: 0)])
				self.popover.close()
			}
			popover.contentViewController = editableTimerViewController
			editableTimerViewController.index=index
			popover.show(relativeTo: settingsButton.bounds, of: settingsButton, preferredEdge: NSRectEdge.minY)
		}
	}
}
