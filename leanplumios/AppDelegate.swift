//
//  AppDelegate.swift
//  leanplumios
//
//  Created by hadia.andar on 3/17/22.
//

import UIKit
import UserNotifications

#if DEBUG
    import AdSupport
#endif
import Leanplum //using 3.2.1
import CleverTapSDK

@main
class AppDelegate: UIResponder, UIApplicationDelegate { //}, CleverTapInAppNotificationDelegate { //}, CleverTapPushNotificationDelegate { //}, CleverTapURLDelegate {
    
    var cleverTapInstance: CleverTap?
    
   /* func shouldHandleCleverTap(_ url: URL?, for channel: CleverTapChannel) -> Bool {
        return false
    } */
    
   /* func pushNotificationTapped(withCustomExtras customExtras: [AnyHashable : Any]!) {
        openURL(withCustomExtras: customExtras)
    } */
    /*func inAppNotificationButtonTapped(withCustomExtras customExtras: [AnyHashable : Any]!) {
        openURL(withCustomExtras: customExtras)
    }*/
    
   /* func openURL(withCustomExtras customExtras: [AnyHashable : Any]!) {
        guard
            let deeplink = customExtras[AnyHashable("wzrk_dl")] as? String,
                       let url = URL(string: deeplink) else {
                       return
        }
        
        //UIApplication.shared.open(deeplink)
        
        UIApplication.shared.open(url, options: [:], completionHandler: nil)
    } */
        
        
        // You may notice two different Leanplum apps on your App Settings page, one for development and one for production. To reduce the risk of using the wrong key in your development cycle, we have created two apps for you. We would recommend in while you are in your development phase, using the API keys from the development version of your Leanplum App. Once you are ready to go-live, switch over to the API and production key from the production LP app
        
        // When you're ready for final QA, you can switch to the live app, but use the app in Development mode. This is where you copy over your messages, sync new variables, or move other content from your test app to the live app.
        
        var debugAppId: String = "app_xvhLIDh3sIs71lx6yMYEW8LhhodWlFwvAUPeM4JoCSQ"
        var debugDevKey: String = "dev_nUVY7kDD4NFROS0HSBB8c1UDnRwb17tb5d1smWQI93o"
        var prodAppId: String = "app_xvhLIDh3sIs71lx6yMYEW8LhhodWlFwvAUPeM4JoCSQ"
        var prodProdKey: String = "prod_wu6BfCX0f4MY6lRgqDytTUWPxDYZOIEbS0MqZgIFKGk" //devKey, does the production app come with a dev key so you can test before pushing to live?
        
        // Development mode keeps your team's user activity out of Analytics. This allows you to try things out in Leanplum without worrying about polluting your actual user data in Analytics. You can view your team's testing activity in the "Developer Activity" section of analytics.
        
        
        func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
            // Override point for customization after application launch.
            
            //UNUserNotificationCenter.current().delegate = self
            //application.applicationIconBadgeNumber = 0
            
            //Leanplum.setDeviceId(ASIdentifierManager.shared().advertisingIdentifier.uuidString)
            Leanplum.setAppId(debugAppId,
                              productionKey:debugDevKey)
            
            print("🔥 AppDelegate is running!")
            
            let ctCallback = CleverTapInstanceCallback(callback: { cleverTapInstance in
                print("CleverTapInstance created")
                
                // Enable IP location
                cleverTapInstance.enableDeviceNetworkInfoReporting(true)
                //cleverTapInstance.setPushNotificationDelegate(self)
                CleverTap.setDebugLevel(3)
                //CleverTap.setDebugLevel(CleverTapLogLevel.debug.rawValue)
                
                // Store instance in class property
                self.cleverTapInstance = cleverTapInstance
                
                // Now initialize the inbox when CleverTapInstance is available
                //self.initializeInbox()
                self.initializeInbox(callback: { success in
                    print("Inbox initialized: \(success)")
                })
                
                // Call function to print messages
                self.printInboxMessages()

            })
            Leanplum.addCleverTapInstance(callback: ctCallback)
            

            
            // this is what stock x is doing ignore
            //CleverTap.autoIntegrate()
            //CleverTap.sharedInstance()?.setPushNotificationDelegate(self)
            //CleverTap.sharedInstance()?.setInAppNotificationDelegate(self)
            //CleverTap.sharedInstance()?.setUrlDelegate(self)
            CleverTap.sharedInstance()?.enableDeviceNetworkInfoReporting(true)
            CleverTap.setDebugLevel(CleverTapLogLevel.debug.rawValue)
            
            //CT App Inbox
            //Initialize the CleverTap App Inbox
            /*CleverTap.sharedInstance()?.initializeInbox(callback: ({ (success) in
                    //let messageCount = CleverTap.sharedInstance()?.getInboxMessageCount()
                    //let unreadCount = CleverTap.sharedInstance()?.getInboxMessageUnreadCount()
                    //print("Inbox Message:\(String(describing: messageCount))/\(String(describing: unreadCount)) unread")
                    print("INBOX")
             }))*/
            

            
            //AlertWith3Buttons.defineAction()
            
            // Optional: Tracks in-app purchases automatically as the "Purchase" event.
            // To require valid receipts upon purchase or change your reported
            // currency code from USD, update your app settings.
            // Leanplum.trackInAppPurchases()
            
            // Sets the app version, which otherwise defaults to
            // the build number (CFBundleVersion).
            //Leanplum.setAppVersion("1.0.0")
            
            //Set variables
            let lpGameBgImg = Var(name: "gameBgImg", file: "gamebgimg") //Background image var
            let lpGameTitle = Var(name: "gameTitle", string: "Fun Game") // Label of the "Start" button String
            let lpPowerUp = Var(name: "powerUp", dictionary: [ //Dictionary
                "lpName": "Turbo Boost",
                "lpPrice": 150,
                "lpSpeed": 1.5,
                "lpTimeout": 15])
            
            Leanplum.onVariablesChanged {
                print(lpGameBgImg.imageValue() ?? "defaultImageValueAppDelegate")
                print(lpGameTitle.stringValue ?? "defaultGameTitleAppDelegate")
            }
            
            
            
            
            ///////////////////////////////////////////////
            //PUSH NOTIFICATION FUNCTION!!!!!!!!!!!!!!!!!!!
            //iOS-10
            if #available(iOS 10.0, *){
                let userNotifCenter = UNUserNotificationCenter.current()
                
                userNotifCenter.requestAuthorization(options: [.badge,.alert,.sound]){ (granted,error) in
                    //Handle individual parts of the granting here.
                    
                    if granted {
                        DispatchQueue.main.async {
                            UIApplication.shared.registerForRemoteNotifications()
                        }
                    }
                }
            }
            //iOS 8-9
            else if #available(iOS 8.0, *){
                let settings = UIUserNotificationSettings.init(types: [UIUserNotificationType.alert,UIUserNotificationType.badge,UIUserNotificationType.sound],
                                                               categories: nil)
                UIApplication.shared.registerUserNotificationSettings(settings)
                UIApplication.shared.registerForRemoteNotifications()
            }
            //iOS 7
            else{
                UIApplication.shared.registerForRemoteNotifications(matching:
                                                                        [UIRemoteNotificationType.alert,
                                                                         UIRemoteNotificationType.badge,
                                                                         UIRemoteNotificationType.sound])
            }
            
            ///////////////////////////////////////////////
            
            Leanplum.setAppVersion("2.26.0")
            
            // Starts a new session and updates the app content from Leanplum.
            //Leanplum.start() //Added age attribute for audience
            
            try Leanplum.start(){ success in
                print("Leanplum started \(success ? "successfully" : "unsuccessfully").")
                Leanplum.setHandleCleverTapNotification { (userInfo, isNotificationOpen, block) in
                    print("CleverTap handle push block: \(userInfo), isNotificationOpen: \(isNotificationOpen)")
                    
                    if(isNotificationOpen) {
                        block(isNotificationOpen)
                    }
                    //block(isNotificationOpen)
                }
            }
            
            return true
        }
        
        // MARK: UISceneSession Lifecycle
        
        func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
            // Called when a new scene session is being created.
            // Use this method to select a configuration to create the new scene with.
            return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
        }
        
        func application(_ application: UIApplication, didDiscardSceneSessions sceneSessions: Set<UISceneSession>) {
            // Called when the user discards a scene session.
            // If any sessions were discarded while the application was not running, this will be called shortly after application:didFinishLaunchingWithOptions.
            // Use this method to release any resources that were specific to the discarded scenes, as they will not return.
        }
    
   /* func initializeInbox(callback: CleverTapInboxSuccessBlock) {
        guard let cleverTap = cleverTapInstance else {
            print("CleverTapInstance is not initialized yet.")
            return
        }
        
        cleverTap.initializeInbox(callback: { (success) in
            print("INBOX initialized: \(success)")

            
            // If needed, get the inbox message count
            let unreadCount = cleverTap.getInboxMessageUnreadCount()
            let unreadMessageArray = cleverTap.getUnreadInboxMessages()
            
            for i in 0..<unreadMessageArray.count {
                let message = unreadMessageArray[i]
                let messageId = message.messageId
                let data = message.customData
                
                if data != nil {
                        NotificationCenter.default.post(
                            name: Notification.Name("onLeanplumInboxMessageArrived"),
                            object: ["messageID": messageId,
                                     "inbox": "CleverTap",
                                     "data": data!])
                    } else {
                        cleverTap.deleteInboxMessage(forID: messageId ?? "") // delete bad message that has no data
                    }
            }
        })
    }*/
    
    
    func initializeInbox(callback: @escaping CleverTapInboxSuccessBlock) {
        guard let cleverTap = cleverTapInstance else {
            print("❌ CleverTapInstance is not initialized yet.")
            callback(false)
            return
        }

        cleverTap.initializeInbox { success in
            print("📩 INBOX initialized: \(success)")

            if success {
                // Manually register an update listener to refresh messages on every update
                cleverTap.registerInboxUpdatedBlock {
                    print("📩 CleverTap Inbox Updated! Refreshing messages now...")
                    self.processInboxMessages()
                }

                // Process messages immediately after initialization
                self.processInboxMessages()
            }

            callback(success)
        }
    }


    func processInboxMessages() {
        guard let cleverTap = cleverTapInstance else {
            print("❌ CleverTapInstance is not initialized yet.")
            return
        }

        print("🔄 Fetching latest messages from CleverTap...")

        // Force a cache refresh by initializing inbox again
        cleverTap.initializeInbox { success in
            print("📩 CleverTap Inbox Refresh: \(success)")

            let allMessages = cleverTap.getAllInboxMessages()
            let unreadMessages = cleverTap.getUnreadInboxMessages()

            print("📩 Unread Messages Count: \(unreadMessages.count)")
            print("📩 All Messages Count: \(allMessages.count)")

            for message in allMessages {
                let messageId = message.messageId
                let data = message.customData

                print("📩 Message ID: \(messageId), Raw JSON: \(message.json?.description ?? "No Content")")

                if let data = data, !data.isEmpty {
                    print("✅ Found custom data: \(data)")

                    NotificationCenter.default.post(
                        name: Notification.Name("onLeanplumInboxMessageArrived"),
                        object: nil,
                        userInfo: ["messageID": messageId,
                                   "inbox": "CleverTap",
                                   "data": data])

                    // 🔹 Delay before marking as read and deleting to prevent race conditions
                    DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
                        cleverTap.markReadInboxMessage(forID: messageId ?? "")

                        DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
                            if let existingMessage = cleverTap.getInboxMessage(forId: messageId ?? "") {
                                cleverTap.deleteInboxMessage(forID: messageId ?? "")
                                print("🗑 Deleted message: \(messageId)")
                            } else {
                                print("⚠️ Message not found, possibly already removed: \(messageId)")
                            }
                        }
                    }
                } else {
                    print("⚠️ Missing custom data for message ID: \(messageId)")
                }
            }
        }
    }


    
    
    
    
    
    func initializeInbox() {
        guard let cleverTap = cleverTapInstance else {
            print("CleverTapInstance is not initialized yet.")
            return
        }

        cleverTap.initializeInbox(callback: { (success) in
            print("INBOX initialized: \(success)")
            
            // If needed, get the inbox message count
            let messageCount = cleverTap.getInboxMessageCount()
            let unreadCount = cleverTap.getInboxMessageUnreadCount()
            print("Inbox Messages: \(messageCount)/\(unreadCount) unread")
        })
    }
    
    func getAllInboxMessages() -> [CleverTapInboxMessage] {
        guard let cleverTap = cleverTapInstance else {
            print("CleverTapInstance is not initialized yet.")
            return []
        }
        return cleverTap.getAllInboxMessages() ?? [] // Get all messages, return empty if nil
    }

    func getUnreadInboxMessages() -> [CleverTapInboxMessage] {
        guard let cleverTap = cleverTapInstance else {
            print("CleverTapInstance is not initialized yet.")
            return []
        }
        return cleverTap.getUnreadInboxMessages() ?? [] // Get only unread messages, return empty if nil
    }
    
    //Get Inbox Unread Count
    // Get Inbox Unread Count
    func getInboxMessageUnreadCount() -> Int {
        guard let cleverTap = cleverTapInstance else {
            print("CleverTapInstance is not initialized yet.")
            return 0 // Return 0 instead of an empty array
        }
        return cleverTap.getInboxMessageUnreadCount() // This method returns an Int
    }

    
    func printInboxMessages() {
        let allMessages = getAllInboxMessages()
        let unreadMessages = getUnreadInboxMessages()
        let unreadCount = getInboxMessageUnreadCount() // Get unread message count

        print("📩 Total Inbox Messages: \(allMessages.count)")
        print("📩 Unread Inbox Messages (from count method): \(unreadCount)") // Added this line
        print("📩 Unread Inbox Messages (from message list): \(unreadMessages.count)")

        // Print message details
        for message in allMessages {
            print("📩 Message ID: \(message.messageId), Content: \(message.json?.description ?? "No Content")")
        }

        for message in unreadMessages {
            print("📩 Unread Message ID: \(message.messageId), Content: \(message.json?.description ?? "No Content")")
        }
    }
    


    
        
    // This method allows foreground push notifications
     /*  func userNotificationCenter(_ center: UNUserNotificationCenter,
                                   willPresent notification: UNNotification,
                                   withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
           completionHandler([.banner, .sound, .badge]) // Show notification while app is open
       }*/
    
   /* func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        
        Leanplum.willPresent(notification)

        Leanplum.setHandleCleverTapNotification { (userInfo, isNotificationOpen, block) in
           print("CleverTap handle push block: \(userInfo), isNotificationOpen: \(isNotificationOpen)")
            block(isNotificationOpen)
        }
        
        Leanplum.setHandleCleverTapNotification(nil)
        
        CleverTap.sharedInstance()?.recordNotificationViewedEvent(withData: notification.request.content.userInfo)
    }*/
    
    
    
    
        
    }
    
