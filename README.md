

# STILL IN DEVELOPMENT...



# Integrator
Flow integration, based on the concepts of FlowControllers, Coordinators and ResponderChain.

---

## Basic Usage

### Create and configure the Routes

```swift
enum MyRoute: RouteType {

    // MARK: - Routes
    
    /// Root view controller
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

##### URL Support
[TODO]

---
### Creating and using a Router
```swift
// Create a router
let rootNavigationController = UINavigationController()
let router = Router<AppRoutes>(navigationController: rootNavigationController)

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
    }
    
}
extension AppIntegrator: RouteResolver {
    
    func executeBeforeTransition(to route: RouteType) throws -> UIViewController {
       // Here goes the logic you need before each transition... 
       // Stuff like ViewController configurations and such.
    }
    
}
```


























