

# STILL IN DEVELOPMENT...



# Integrator
Flow integration, based on the concepts of FlowControllers, Coordinators and ResponderChain.

---

## Basic Usage

### Create and configure the Routes

```swift
enum MyRoute: RouteType {

    // MARK: - Routes
    
    case login
    case homeTabBar(tab: HomeTab)
    
    // MARK: - RouteType
    
    var transition: RouteTransition {
        switch self {
        case .login: return .set
        case .homeTabBar: return .set
        }
    }
    
}
```

---
### Creating and using a Router
```swift
// Create a router
let rootNavigationController = UINavigationController()
let router = Router<MyRoute>(navigationController: rootNavigationController)

// Navigate to a route using enums
router.navigate(to: MyRoute.login)

// Navigate to a route using URL's
router.openURL(url)

```

---
### Create an Integrator

##### Note
```
This is the part where you implement the `integration` related stuff, such as:
    - Delegates / closures / etc, for the callbacks from your controllers or actors.
    - Configure the actions before each transition, i.e., register the route resolvers, 
      in order to have control over the flow.                                            
```

##### Implementation
```swift
class MyIntegrator: Integrator {
   
    let router: RouterProtocol
    weak var integratorDelegate: IntegratorDelegate?
    var parent: Integrator?
    var childs: [Integrator]? = []
    
    func start() {
    
    	// Here goes the logic for the flow to start... First route, etc   
        
        // We need to register a resolver in order to have control over DI, and such on them
        router.registerResolver(forRouteType: MyRoute.self, resolver: executeBeforeTransition)
        
    }
    
}
extension AppIntegrator: RouteResolver {
    
    func executeBeforeTransition(to route: RouteType) throws -> UIViewController {
       // Here goes the logic you need before each transition... 
       // Stuff like ViewController configurations and such.
    }
    
}
```

## Advanced Usage

### URL Support
---
You only need to do one thing to add URL support to your routes.
Implement the static method `registerURLs`:
```swift
extension MyRoute {

    /* ... */

    static func registerURLs() -> URLMatcherGroup<Route>? {
        return .group("integrator.example.com") {
            $0.map("login") { MyRoute.login }
            $0.map("home-tabbar/{tab}") { try MyRoute.homeTabBar(HomeTab($0.param("tab"))) }
        }
    }

}
```

Then, handle it on the AppDelegate:
```swift
extension AppDelegate {

    /// Open Universal Links
    func application(_ application: UIApplication,
                 continue userActivity: NSUserActivity,
                 restorationHandler: @escaping ([Any]?) -> Void) -> Bool
    {
        guard userActivity.activityType == NSUserActivityTypeBrowsingWeb,
            let url = userActivity.webpageURL,
            let handledURL = router.openURL(url) else {
            return false // Unrecognized URL
        }

        return handledURL
    }

}
```


### Custom Transitions
---
#### NOTE: This is done exactly like in XRouter, so I copied their documentation for this part.

Here is an example using the popular [Hero Transitions](https://github.com/HeroTransitions/Hero) library.

Set the `customTransitionDelegate` for the `Router`:
```swift
router.customTransitionDelegate = self
```

(Optional) Define your custom transitions in an extension so you can refer to them statically
```swift
extension RouteTransition {
    static var heroCrossFade: RouteTransition {
        return .custom(identifier: "HeroCrossFade")
    }
}
```

Implement the delegate method `performTransition(...)`:
```swift

extension Router: RouterCustomTransitionDelegate {

    /// Handle custom transitions
    func performTransition(to viewController: UIViewController,
                           from sourceViewController: UIViewController,
                           transition: RouteTransition,
                           animated: Bool,
                           completion: ((Error?) -> Void)?) {
        if transition == .heroCrossFade {
            sourceViewController.hero.isEnabled = true
            destViewController.hero.isEnabled = true
            destViewController.hero.modalAnimationType = .fade

            // Creates a container nav stack
            let containerNavController = UINavigationController()
            containerNavController.hero.isEnabled = true
            containerNavController.setViewControllers([newViewController], animated: false)

            // Present the hero animation
            sourceViewController.present(containerNavController, animated: animated) {
                completion?(nil)
            }
        } else {
            completion?(nil)
        }
    }

}
```

And override the transition to your custom in your Router:
```swift
    override func transition(for route: Route) -> RouteTransition {
        switch route {
            case .profile:
                return .heroCrossFade
            default:
                return super.transition(for: route)
        }
    }
```



## Thank you note
Thanks to the guys from XRouter, URLNavigator, RouteComposer, CoreNavigation and Compass for the resources provided that helped me to create this tool. 
