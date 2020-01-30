//
//  AlarmsStorage.swift
//  Adjustable Clock
//
//  Created by Matt Roberts on 1/22/20.
//  Copyright © 2020 Matt Roberts. All rights reserved.
//
import AppKit
class AlarmCenter: NSObject {
	static let sharedInstance=AlarmCenter()
	let userDefaults=UserDefaults()
	let alarmsKey="savedAlarms"
	let jsonEncoder=JSONEncoder()
	let jsonDecoder=JSONDecoder()
	private var alarmProtocol: NSObjectProtocol?
	private let calendar=Calendar.current
	private var alarmTimers=[DispatchSourceTimer]()
	private let timeFormatter=DateFormatter()
	private let appObject = NSApp as NSApplication
	override private init() {
		super.init()
		timeFormatter.locale=Locale(identifier: "en_US")
		timeFormatter.setLocalizedDateFormatFromTemplate("hmm")
		jsonEncoder.outputFormatting = .prettyPrinted
		loadAlarms()
		setAlarms()
	}
	func saveAlarms() {
		do {
			let alarmData=try jsonEncoder.encode(alarms)
			userDefaults.setValue(alarmData, forKeyPath: alarmsKey)
		} catch {
			print("Error encoding data")
		}
	}
	func loadAlarms() {
		do {
			if let alarmsData=userDefaults.data(forKey: alarmsKey) {
				let savedAlarms=try jsonDecoder.decode([Alarm].self, from: alarmsData)
				alarms=savedAlarms
				count+=alarms.count
			}
		} catch {
			print("Error encoding data")
		}
	}
	private var alarms=[Alarm]()
	func addAlarm(alarm: Alarm) {
		alarms.insert(alarm, at: 0)
		count+=1
		saveAlarms()
		getActiveAlarms()
	}
	func removeAlarm(index: Int) {
		alarms.remove(at: index)
		count-=1
		saveAlarms()
		getActiveAlarms()
	}
	func getAlarm(index: Int) -> Alarm {
		getActiveAlarms()
		return alarms[index]
	}
	@objc dynamic var activeAlarms=0
	func getActiveAlarms() -> Int {
		var activeCount=0
		for alarm in alarms where alarm.active {
			activeCount+=1
		}
		activeAlarms=activeCount
		return activeCount
	}
	private func scheduleAlarms() {
		for alarm in alarms where alarm.active {
			scheduleAlarm(alarm: alarm)
		}
	}
	private func scheduleAlarm(alarm: Alarm) {
		if alarm.active {
			var hasError=false
			let alarmTimer=DispatchSource.makeTimerSource(flags: [], queue: DispatchQueue.main)
			print("abcd"+String(getTimeInterval(alarm: alarm)))
			alarmTimer.schedule(deadline: .now()+getTimeInterval(alarm: alarm), repeating: .never, leeway: .milliseconds(0))
			alarmTimer.setEventHandler {
				if alarm.repeats != true {
					alarm.active=false
				}
					if let alarmViewController: AlarmsViewController=AlarmsWindowController.alarmsObject.contentViewController as? AlarmsViewController {
						let row = self.alarms.firstIndex(where: { (alarmInstance) -> Bool in
							return alarmInstance.date==alarm.date })					
						let tableView=alarmViewController.tableView
						tableView?.reloadData(forRowIndexes: [(row ?? 0)], columnIndexes: [0, 1])
					}
				let alarmSound=NSSound(named: NSSound.Name(alarm.alertString))
				if !alarm.usesSong {
					alarmSound?.loops=true
					alarmSound?.play()
				} else {
					print("should play music")
					let playlistName=alarm.song
					let appleScript =
					"""
					tell application "Music"
						play playlist "\(playlistName ?? "")"
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
				let alarmAlert=NSAlert()
				alarmAlert.messageText="Alarm for \(self.timeFormatter.string(from: alarm.date))  has gone off."
				alarmAlert.addButton(withTitle: "Dismiss")
				alarmAlert.icon=DockClockController.dockClockObject.getFreezeView(time: alarm.date).image()
				AlarmsWindowController.alarmsObject.showAlarms()
				if alarm.usesSong && !hasError {
					alarmAlert.addButton(withTitle: "Stop Music")
				} else if (alarm.usesSong) {
					alarmAlert.messageText+="""
					  A playlist was supposed to play.  Please check your internet connection and that automation \
					of Music is allowed in Settings->Security and Privacy->Automation->Clock Suite.
					"""
				}
				alarmAlert.beginSheetModal(for: AlarmsWindowController.alarmsObject.window ?? NSWindow()) { (modalResponse) in
					if !alarm.usesSong {
						alarmSound?.stop()
						alarmTimer.cancel()
					} else {
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
						alarmSound?.stop()
					}
					self.scheduleAlarms()
				}
			}
			alarmTimer.resume()
			alarmTimers.append(alarmTimer)
		}
	}
	func replaceAlarm(date: Date, alarm: Alarm) {
		if let index=self.alarms.firstIndex(where: { (alarmInstance) -> Bool in
			return alarmInstance.date==date }) {
			alarms[index]=alarm
		}
		saveAlarms()
		getActiveAlarms()
	}
	private func getTimeInterval(alarm: Alarm) -> TimeInterval {
		var tomorrow=false
		let now=Date()
		let hour=calendar.dateComponents([.hour], from: now).hour ?? 0
		let minute=calendar.dateComponents([.minute], from: now).minute ?? 0
		let second=calendar.dateComponents([.second], from: now).second ?? 0
		let nanoseconds=calendar.dateComponents([.nanosecond], from: now).nanosecond ?? 0
		let alarmHour=calendar.dateComponents([.hour], from: alarm.date).hour ?? 0
		let alarmMinute=calendar.dateComponents([.minute], from: alarm.date).minute ?? 0
		let alarmSecond=calendar.dateComponents([.second], from: alarm.date).second ?? 0
		if hour>alarmHour {
			tomorrow=true
		}
		if hour==alarmHour && minute>=alarmMinute {
			tomorrow=true
		}
		var totalSeconds: Double=0
		totalSeconds+=Double((alarmHour-hour)*60*60)
		totalSeconds+=Double((alarmMinute-minute)*60)
		totalSeconds+=Double((alarmSecond-second))
		totalSeconds += Double(0-nanoseconds/1_000_000_000)
		if tomorrow {
			totalSeconds *= -1
			totalSeconds+=24*3600
		}
		return TimeInterval(exactly: totalSeconds) ?? 0
	}
	@objc dynamic var count=0
	func setAlarms() {
		for timer in alarmTimers {
			timer.cancel()
		}
		alarmTimers=[DispatchSourceTimer]()
		if getActiveAlarms() > 0 {
			alarmProtocol = ProcessInfo().beginActivity(options: .idleSystemSleepDisabled, reason: "So alarms can go off")
		} else {
			alarmProtocol=nil
		}
		scheduleAlarms()
	}
}
