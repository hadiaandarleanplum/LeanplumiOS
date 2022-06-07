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

@main
class AppDelegate: UIResponder, UIApplicationDelegate{
    
    // You may notice two different Leanplum apps on your App Settings page, one for development and one for production. To reduce the risk of using the wrong key in your development cycle, we have created two apps for you. We would recommend in while you are in your development phase, using the API keys from the development version of your Leanplum App. Once you are ready to go-live, switch over to the API and production key from the production LP app
    
    // When you're ready for final QA, you can switch to the live app, but use the app in Development mode. This is where you copy over your messages, sync new variables, or move other content from your test app to the live app.

    var debugAppId: String = "app_xvhLIDh3sIs71lx6yMYEW8LhhodWlFwvAUPeM4JoCSQ"
    var debugDevKey: String = "dev_nUVY7kDD4NFROS0HSBB8c1UDnRwb17tb5d1smWQI93o"
    var prodAppId: String = "app_IF2eLLGxH8jme6fyd4qe3AnJDPuyuV2W6mYLMORepkQ"
    var prodProdKey: String = "dev_08KT3uYYrZdwku6wgMOiZywlYETW6r8j9XetCriYdlM" //devKey, does the production app come with a dev key so you can test before pushing to live?
    
    // Development mode keeps your team's user activity out of Analytics. This allows you to try things out in Leanplum without worrying about polluting your actual user data in Analytics. You can view your team's testing activity in the "Developer Activity" section of analytics.


    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        
        //UNUserNotificationCenter.current().delegate = self
        //application.applicationIconBadgeNumber = 0
        
        #if DEBUG
            //Leanplum.setDeviceId(ASIdentifierManager.shared().advertisingIdentifier.uuidString)
        Leanplum.setAppId(debugAppId,
                          developmentKey:debugDevKey)
          #else
            Leanplum.setAppId(prodAppId,
              productionKey: prodProdKey)
          #endif
        
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

        
        // Starts a new session and updates the app content from Leanplum.
        Leanplum.start() //Added age attribute for audience
        
        
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
    

    
    
    


}

