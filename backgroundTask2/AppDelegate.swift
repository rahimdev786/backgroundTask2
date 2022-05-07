//
//  AppDelegate.swift
//  backgroundTask2
//
//  Created by arshad on 5/7/22.
//
///App downloads content from the network
//App processes data in the background

import UIKit
import BackgroundTasks

@main
class AppDelegate: UIResponder, UIApplicationDelegate {



    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        
        BGTaskScheduler.shared.register(forTaskWithIdentifier:"App processes data in the background" , using: nil) { bgtask in
            self.handlerTask(bgtask as! BGAppRefreshTask)
        }
        return true
    }

    
    func handlerTask(_ task:BGAppRefreshTask){
        task.expirationHandler = {
            print("worked finished")
        }
        
        let randanNumber = (1...80).randomElement() ?? 1
        callapi(inde: randanNumber)
    }
    
    func callapi(inde:Int){
        
        let urlData = "https://jsonplaceholder.typicode.com/posts/\(inde)"
        NetworkManagerService.shared.PaserAnyData(HttpUrlName: urlData, method:"GET",EncodeData: nil, models.self) { data in
            switch data{
            case .success(let responce):
                let finalData = ["userData":responce]
                NotificationCenter.default.post(name: .postData, object: nil, userInfo:finalData )
            case .failure(let fai):
                if fai is APIError{
                    print(fai)
                }
            }
        }
    }
    
    
    
    func handlerbackgrpundtaask(){

        let backgroundRequest = BGAppRefreshTaskRequest(identifier: "App processes data in the background")
        backgroundRequest.earliestBeginDate = Date(timeIntervalSinceNow: 10)
        do {
            try BGTaskScheduler.shared.submit(backgroundRequest)
        } catch  {
            print(error.localizedDescription)
        }
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


extension Notification.Name{
    static let postData =  Notification.Name("postData")
}
