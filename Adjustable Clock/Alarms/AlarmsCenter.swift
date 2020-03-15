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
	private let calendar=Calendar.autoupdatingCurrent
	private var alarmTimers=[DispatchSourceTimer]()
	private let timeFormatter=DateFormatter()
	private let appObject = NSApp as NSApplication
	private let notifcationCenter=NotificationCenter.default
	override private init() {
		super.init()
		notifcationCenter.addObserver(self, selector: #selector(scheduleAlarms), name: NSNotification.Name.NSSystemClockDidChange, object: nil)
		notifcationCenter.addObserver(self, selector: #selector(scheduleAlarms), name: NSNotification.Name.NSSystemTimeZoneDidChange, object: nil)
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
	@objc private func scheduleAlarms() {
		for timer in alarmTimers {
			timer.cancel()
		}
		for alarm in alarms where alarm.active {
			scheduleAlarm(alarm: alarm)
		}
		if let alarmsViewController=AlarmsWindowController.alarmsObject.contentViewController as? AlarmsViewController {
			//alarmsViewController.collectionView.reloadData()
		}
	}
	private func scheduleAlarm(alarm: Alarm) {
		if alarm.active {
			alarm.updateExpirationDate()
			let dateFormatter=DateFormatter()
			dateFormatter.setLocalizedDateFormatFromTemplate("MMdyyyyhhmm")
			print("abcd"+dateFormatter.string(from: alarm.expiresDate))
			if !alarm.repeats && alarm.expiresDate<Date() {
				alarm.active=false
				if let alarmViewController: AlarmsViewController=AlarmsWindowController.alarmsObject.contentViewController as? AlarmsViewController {
					let row = self.alarms.firstIndex(where: { (alarmInstance) -> Bool in
						return alarmInstance.time==alarm.time })
					let tableView=alarmViewController.collectionView
					tableView?.reloadData()
				}
				return
			}
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
							return alarmInstance.time==alarm.time })
						let tableView=alarmViewController.collectionView
						tableView?.reloadData()
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
				alarmAlert.messageText="Alarm for \( alarm.timeString)  has gone off."
				alarmAlert.addButton(withTitle: "Dismiss")
				alarmAlert.icon=DockClockController.dockClockObject.getFreezeView(time: alarm.time).image()
				AlarmsWindowController.alarmsObject.showAlarms()
				if alarm.usesSong && !hasError {
					alarmAlert.addButton(withTitle: "Stop Music")
				} else if alarm.usesSong {
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
			return alarmInstance.time==date }) {
			alarms[index]=alarm
		}
		saveAlarms()
		getActiveAlarms()
	}
	func getAlarmIndex(alarm: Alarm) -> Int{
		if let index=self.alarms.firstIndex(where: { (alarmInstance) -> Bool in
			alarmInstance.time==alarm.time })
		{
			return index
		}
		return 0
	}
	private func getTimeInterval(alarm: Alarm) -> TimeInterval {
		let now=Date()
		let timeFormatter=DateFormatter()
		timeFormatter.setLocalizedDateFormatFromTemplate("hmm")
		let alarmTime=timeFormatter.date(from: alarm.timeString) ?? Date()
		let month=calendar.dateComponents([.month], from: now).month
		let day=calendar.dateComponents([.day], from: now).day
		let year=calendar.dateComponents([.year], from: now).year
		let hour=calendar.dateComponents([.hour], from: alarmTime).hour ?? 0
		let minute=calendar.dateComponents([.minute], from: alarmTime).minute ?? 0
		var alarmDate=calendar.date(from: DateComponents(calendar: calendar, timeZone:
			nil, era: nil, year: year, month: month, day: day, hour: hour, minute: minute, second: 0,
				 nanosecond: 0, weekday: nil, weekdayOrdinal: nil, quarter: nil, weekOfMonth: nil,
				 weekOfYear: nil, yearForWeekOfYear: nil))
		if (alarmDate ?? Date())<now {
			alarmDate=calendar.date(byAdding: DateComponents(calendar: calendar, timeZone:
			nil, era: nil, year: 0, month: 0, day: 1, hour: 0, minute: 0, second: 0,
				 nanosecond: 0, weekday: nil, weekdayOrdinal: nil, quarter: nil, weekOfMonth: nil,
				 weekOfYear: nil, yearForWeekOfYear: nil), to: (alarmDate ?? Date()), wrappingComponents: false)
		}
		let dateComponents=calendar.dateComponents([.hour, .minute, .second, .nanosecond], from: Date(), to: (alarmDate ?? Date()))
		var totalSeconds: Double=0
		totalSeconds+=Double((dateComponents.hour ?? 0)*60*60)
		totalSeconds+=Double((dateComponents.minute ?? 0)*60)
		totalSeconds+=Double(dateComponents.second ?? 0)
		totalSeconds += Double((Double(dateComponents.nanosecond ?? 0))/Double(1_000_000_000))
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
