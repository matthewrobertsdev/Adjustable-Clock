//
//  AlarmsStorage.swift
//  Adjustable Clock
//
//  Created by Matt Roberts on 1/22/20.
//  Copyright © 2020 Matt Roberts. All rights reserved.
//
import AppKit
import AVFoundation
class AlarmCenter: NSObject, NSSoundDelegate {
	static let sharedInstance=AlarmCenter()
	let userDefaults=UserDefaults()
	let alarmsKey="savedAlarms"
	let jsonEncoder=JSONEncoder()
	let jsonDecoder=JSONDecoder()
	@objc dynamic var count=0
	@objc dynamic var activeAlarms=0
	private var alarmProtocol: NSObjectProtocol?
	private let calendar=Calendar.autoupdatingCurrent
	private var alarmTimers=[DispatchSourceTimer]()
	private let timeFormatter=DateFormatter()
	private let appObject = NSApp as NSApplication
	private let notifcationCenter=NotificationCenter.default
	private var player: AVAudioPlayer?
	private var soundCount=0
	override private init() {
		super.init()
		setUp()
	}
	func setUp() {
		notifcationCenter.addObserver(self, selector: #selector(scheduleAlarms),
									  name: NSNotification.Name.NSSystemClockDidChange, object: nil)
		notifcationCenter.addObserver(self, selector: #selector(scheduleAlarms),
									  name: NSNotification.Name.NSSystemTimeZoneDidChange, object: nil)
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
		count=0
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
	func getActiveAlarms() -> Int {
		var activeCount=0
		for alarm in alarms where alarm.active {
			activeCount+=1
		}
		activeAlarms=activeCount
		NotificationCenter.default.post(name: Notification.Name.activeCountChanged, object: nil)
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
				if let alarmViewController: AlarmsViewController=AlarmsWindowController.alarmsObject.contentViewController
					as? AlarmsViewController {
					let tableView=alarmViewController.collectionView
					tableView?.reloadData()
				}
				return
			}
			let alarmTimer=DispatchSource.makeTimerSource(flags: [], queue: DispatchQueue.main)
			print("abcd"+String(getTimeInterval(alarm: alarm)))
			alarmTimer.schedule(deadline: .now()+getTimeInterval(alarm: alarm), repeating: .never, leeway: .milliseconds(0))
			alarmTimer.setEventHandler {
				if alarm.repeats != true {
					alarm.active=false
				}
					if let alarmViewController: AlarmsViewController=AlarmsWindowController.alarmsObject.contentViewController
						as? AlarmsViewController {
						let tableView=alarmViewController.collectionView
						tableView?.reloadData()
					}
				let alarmSound=NSSound(named: NSSound.Name(alarm.alertString))
				alarmSound?.delegate=self
				if !alarm.usesSong {
					self.soundCount=0
					//alarmSound?.loops=true
					alarmSound?.play()
				} else {
					do {
						var saveURL=FileManager.default.urls(for: .applicationSupportDirectory, in: .userDomainMask).first
						saveURL=saveURL?.appendingPathComponent("Clock Suite")
						guard var validSaveURL=saveURL else {
							return
						}
						validSaveURL=validSaveURL.appendingPathComponent(alarm.song)
						self.player=try AVAudioPlayer(contentsOf: URL(fileURLWithPath: validSaveURL.path))
						self.player?.prepareToPlay()
						self.player?.volume = 1.0
						self.player?.play()
					} catch {
						//alarmSound?.loops=true
						self.soundCount=0
						alarmSound?.play()
					}
				}
				let alarmAlert=NSAlert()
				alarmAlert.messageText="Alarm for \( alarm.timeString)  has gone off."
				alarmAlert.addButton(withTitle: "Dismiss")
				alarmAlert.icon=imageFromView(view: DockClockController.dockClockObject.getFreezeView(time: alarm.time))
				AlarmsWindowController.alarmsObject.showAlarms()

				alarmAlert.beginSheetModal(for: AlarmsWindowController.alarmsObject.window ?? NSWindow()) { (_) in
					alarmTimer.cancel()
					self.player?.stop()
					alarmSound?.stop()
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
	func getAlarmIndex(alarm: Alarm) -> Int {
		if let index=self.alarms.firstIndex(where: { (alarmInstance) -> Bool in
			alarmInstance.time==alarm.time }) {
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
		let dateComponents=calendar.dateComponents([.hour, .minute,
													.second, .nanosecond], from: Date(), to: (alarmDate ?? Date()))
		var totalSeconds: Double=0
		totalSeconds+=Double((dateComponents.hour ?? 0)*60*60)
		totalSeconds+=Double((dateComponents.minute ?? 0)*60)
		totalSeconds+=Double(dateComponents.second ?? 0)
		totalSeconds += Double((Double(dateComponents.nanosecond ?? 0))/Double(1_000_000_000))
		return TimeInterval(exactly: totalSeconds) ?? 0
	}
	func setAlarms() {
		for timer in alarmTimers {
			timer.cancel()
		}
		alarmTimers=[DispatchSourceTimer]()
		scheduleAlarms()
		if getActiveAlarms() > 0 {
			alarmProtocol = ProcessInfo().beginActivity(options: .idleSystemSleepDisabled, reason: "So alarms can go off")
		} else {
			alarmProtocol=nil
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
extension Notification.Name {
    static let activeCountChanged = Notification.Name("activeCountChanged")
}
