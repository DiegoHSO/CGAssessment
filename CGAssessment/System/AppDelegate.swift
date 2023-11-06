//
//  AppDelegate.swift
//  CGAssessment
//
//  Created by Diego Henrique Silva Oliveira on 05/09/23.
//

import CoreData
import IQKeyboardManagerSwift
import OSLog
import UIKit

@main
class AppDelegate: UIResponder, UIApplicationDelegate {

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        setupDependencies()
        setupExampleCGA()
        return true
    }

    // MARK: UISceneSession Lifecycle

    func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession,
                     options: UIScene.ConnectionOptions) -> UISceneConfiguration {
        // Called when a new scene session is being created.
        // Use this method to select a configuration to create the new scene with.
        return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
    }

    func application(_ application: UIApplication, didDiscardSceneSessions sceneSessions: Set<UISceneSession>) {
        // Called when the user discards a scene session.
        // If any sessions were discarded while the application was not running,
        // this will be called shortly after application:didFinishLaunchingWithOptions.
        // Use this method to release any resources that were specific to the discarded scenes, as they will not return.
    }

    // MARK: - Core Data stack

    lazy var persistentContainer: NSPersistentCloudKitContainer = {
        /*
         The persistent container for the application. This implementation
         creates and returns a container, having loaded the store for the
         application to it. This property is optional since there are legitimate
         error conditions that could cause the creation of the store to fail.
         */
        let container = NSPersistentCloudKitContainer(name: "CGAssessment")

        if let description = container.persistentStoreDescriptions.first {
            // Generate Notifications on remote changes
            description.setOption(true as NSNumber, forKey: NSPersistentStoreRemoteChangeNotificationPostOptionKey)
        } else {
            os_log("Error: %@", log: .default, type: .error, "\(#function): Failed to retrieve a persistent store description.")
        }

        container.loadPersistentStores(completionHandler: { (_, error) in
            os_log("Error: %@", log: .default, type: .error, String(describing: error))
        })

        return container
    }()

    // MARK: - Core Data Saving support

    func saveContext() {
        let context = persistentContainer.viewContext
        if context.hasChanges {
            do {
                try context.save()
            } catch {
                os_log("Error: %@", log: .default, type: .error, String(describing: error))
            }
        }
    }

    // MARK: - Private Methods

    private func setupDependencies() {
        IQKeyboardManager.shared.enable = true
        IQKeyboardManager.shared.shouldResignOnTouchOutside = true
        IQKeyboardManager.shared.enableAutoToolbar = false
        IQKeyboardManager.shared.shouldShowToolbarPlaceholder = false
        IQKeyboardManager.shared.previousNextDisplayMode = .alwaysHide
    }

    private func setupExampleCGA() {
        if DAOFactory.coreDataDAO is CoreDataDAOMock {
            let dao = DAOFactory.coreDataDAO

            do {
                try dao.addStandaloneCGA()
            } catch {
                fatalError("Unable to create example CGA")
            }
        } else {
            if !UserDefaults.standard.bool(forKey: LocalStorageKeys.firstTime.rawValue) {
                UserDefaults.standard.set(true, forKey: LocalStorageKeys.firstTime.rawValue)

                let dao = DAOFactory.coreDataDAO

                do {
                    try dao.addStandaloneCGA()
                } catch {
                    fatalError("Unable to create example CGA")
                }
            }
        }
    }

}
