

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
class MyIntegrator: Integrator<MyRoute> {
    
    // This function needs to be `overriden`, otherwhise, it's gonna throw a `fatalError`
    override func start() {
        // Implement everithing that is related to the start of the flow...
        // We we suggest to set the first / starting route here.
    }
    
    override func executeBeforeTransition(to route: RouteType) throws -> UIViewController {
       // Here goes the logic you need before each transition... 
       // Stuff like ViewController configurations and such.
    }
    
}
```

## Advanced Usage

### URL Support
---
You only need to do one thing to add URL support to your routes: 
- register the mapping functions for the required path patterns.
```swift
class MyIntegrator: Integrator<MyRoute> {

    /* ... */

    func registerURLs() {
        router.map("login") { _ in return .login }
        router.map("home-tabbar/{tab}") { try MyRoute.homeTabBar(HomeTab($0.param("tab"))) }
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

### Integrator to Integrator communication
---

In order to send messages from the `Parent` flow to it's `Child`, you need to do this:
```swift

class MyParentIntegrator: Integrator {

     /* ... */
     
     func someThingThatNeedsToPassAMessageToTheChilds {
     
        // Define the message, normally and enum, which needs to conform with `IntegratorInput`
        let message = .something(with: someData)
        
        // Then send it
        
        sendInputToChild("MyChildIdentifier", input: message)
        // OR
        broadcastInputToAllChilds(input: message)
        
     }

}

```

On the `Child`, you need to override the function below in order to intercept the messages.
```swift
class MyChildIntegrator: Integrator {

     /* ... */
     
    override func receiveInput(_ input: IntegratorInput) {
        switch (input) {
        case .someInput(let data):
            // Do something with the data
        }
    }
    
}
```

---

In order to send messages from the `Child` flow to it's `Parent`, you need to do this:
```swift

class MyChildIntegrator: Integrator {

     /* ... */
     
     func someThingThatNeedsToPassAMessageToTheParent {
     
        // Define the message, normally and enum, which needs to conform with `Integrator`
        let message = .something(with: someData)
        
        // Then send it
        sendOutputToParent(output: message)
        
     }

}

```

On the `Parent`, you need to override the function below in order to intercept the messages.
```swift
class MyParentIntegrator: Integrator {

    /* ... */

    func receiveOutput(from child: Integrator, output: IntegratorOutput) {
        switch (child, output) {
        case let (integrator as SomeIntegrator, output as SomeIntegrator.Output):
            switch output {
            case .someOutput:
                // Do something with the message received
                sendOutputToParent(output) // Then pass it on if needed, or not...
            }
        default: return
        }
    }

}
```

## Thank you note
Thanks to the guys from XRouter, URLNavigator, RouteComposer, CoreNavigation and Compass for the resources provided that helped me to create this tool. 
