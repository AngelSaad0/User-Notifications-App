//
//  ViewController.swift
//  UserNotifications
//
//  Created by Engy on 10/31/24.
//

import UIKit
import UserNotifications
import CoreLocation


class ViewController: UIViewController {
    @IBOutlet weak var titleTextField: UITextField!
    @IBOutlet weak var bodyTextField: UITextField!
    @IBOutlet weak var dataField: UIDatePicker!
    let locationManager = CLLocationManager()


    override func viewDidLoad() {
        super.viewDidLoad()
        locationManager.delegate = self
        locationManager.requestWhenInUseAuthorization()

        UNUserNotificationCenter.current().requestAuthorization(options: [.alert,.sound,.badge]) { granted, error in
            if let error = error {
                print("Authorization error: \(error.localizedDescription)")
            }
        }
    }
    @IBAction func setRremainder(_ sender:UIButton) {
        let alert = UIAlertController(title: "set Rremainder", message: "You will be notified", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        present(alert, animated: true, completion: nil)

        let targetData = dataField.date
        let titleText = titleTextField.text
        let bodyText = bodyTextField.text

        // Notification content
        let content = UNMutableNotificationContent()
        content.title = "Notification: \(titleText ?? "")"
        content.body = "Reminder: \(bodyText ?? "")"
        content.badge =  1
        content.sound = UNNotificationSound(named: UNNotificationSoundName(rawValue:"tickle.mp3"))
        // Add multiple image attachments
        var attachments: [UNNotificationAttachment] = []
        // Attach the first image
        //        if let imageURL1 = Bundle.main.url(forResource: "image1", withExtension: "png") {
        //            do {
        //                let attachment1 = try UNNotificationAttachment(identifier: "image1", url: imageURL1, options: nil)
        //                attachments.append(attachment1)
        //            } catch {
        //                print("Attachment 1 could not be loaded.")
        //            }
        //        }

        //        if let audioURL = Bundle.main.url(forResource: "tickle", withExtension: "mp3") {
        //                    do {
        //                        let audioAttachment = try UNNotificationAttachment(identifier: "audio", url: audioURL, options: nil)
        //                        attachments.append(audioAttachment)
        //                    } catch {
        //                        print("Audio attachment could not be loaded.")
        //                    }
        //                }
        if let videoURL = Bundle.main.url(forResource: "videoplayback", withExtension: "mp4") {
            do {
                let videoAttachment = try UNNotificationAttachment(identifier: "video", url: videoURL, options: nil)
                attachments.append(videoAttachment)
            } catch {
                print("video attachment could not be loaded.")
            }
        }
        content.attachments = attachments

        // Trigger for a specific date and time
        let triggerDate = Calendar.current.dateComponents([.year, .month, .day, .hour, .minute/*, .second*/], from: targetData)
        let trigger = UNCalendarNotificationTrigger(dateMatching: triggerDate, repeats: false)

        // Notification request
        let request = UNNotificationRequest(identifier: "setRremainder", content: content, trigger: trigger)

        // Scheduling the notification
        UNUserNotificationCenter.current().add(request)
    }

    @IBAction func setReminderAfter2Sec(_ sender: UIButton) {
        let alert = UIAlertController(title: "set Reminder After 2Sec", message: "You will be notified ", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))

        // Notification content
        let content = UNMutableNotificationContent()
        content.title = "test"
        content.body = "using time interval instead of Calendar "
        content.sound = UNNotificationSound(named: UNNotificationSoundName(rawValue:"tickle.mp3"))

        // Trigger
        let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 2, repeats: false)
        // Notification request
        let request = UNNotificationRequest(identifier: "setRremainder2", content: content, trigger: trigger)
        // Scheduling the notification
        UNUserNotificationCenter.current().add(request)

    }
    @IBAction func onLocationButtonClicked(_ sender: UIButton) {

        // Create a region to monitor
        // Replace with your desired location
        let center = CLLocationCoordinate2D(latitude: 30, longitude: 30)
        let region = CLCircularRegion(center: center, radius: 100, identifier: "LocationReminderRegion")

        region.notifyOnEntry = true
        region.notifyOnExit = true

        // Start monitoring the region
        locationManager.startMonitoring(for: region)

        // Optionally, you can show an alert or feedback to the user
        let alert = UIAlertController(title: "Monitoring Location", message: "You will be notified when you enter the designated area.", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        present(alert, animated: true, completion: nil)
    }
}


extension ViewController:CLLocationManagerDelegate {
    // CLLocationManagerDelegate method
    func locationManager(_ manager: CLLocationManager, didEnterRegion region: CLRegion) {
        // Handle the event when the user enters the monitored region
        let content = UNMutableNotificationContent()
        content.title = "You've entered the area!"
        content.body = "Reminder: \(titleTextField.text ?? "")"
        content.sound = UNNotificationSound(named: UNNotificationSoundName(rawValue: "tickle.mp3"))

        // Create the notification request
        let request = UNNotificationRequest(identifier: "locationEntered", content: content, trigger: nil)

        // Schedule the notification
        UNUserNotificationCenter.current().add(request) { error in
            if let error = error {
                print("Error scheduling location notification: \(error.localizedDescription)")
            }
        }
        // Stop monitoring the region after the notification is triggered
        manager.stopMonitoring(for: region)
    }


    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print("Location manager error: \(error.localizedDescription)")
    }


}

