import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    var rootViewController: RootViewViewController!
    var navigationController: UINavigationController!

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        
        window = UIWindow(frame: UIScreen.main.bounds)
        rootViewController = RootViewViewController()
        navigationController = UINavigationController(rootViewController: rootViewController)
        window?.rootViewController = navigationController
        
        window?.makeKeyAndVisible()
        return true
    }


}

