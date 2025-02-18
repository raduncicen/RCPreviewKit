//
//  AdvanceUsage.swift
//  RCPreviewKit
//
//  Created by Radun Çiçen on 18.02.2025.
//

/// I will not show you how to implement a MVVM-C pattern, however I will provide a Preview usage example for this pattern.
/// I generally create a flow with MVVM-C pattern with the following syntax
/// ```swift
///     let settingsCoordinator = SettingsDIContainer.shared.settingsCoordinator()
///```
/// And then I call the start function to initiate my flow which can be
/// `settingsCoordinator.start()` /// `settingsCoordinator.start(navigationController)` or  `settingsCoordinator.startWithResponse(response)`
///
/// As you may know the settingsCoordinator should know how to navigate between its views and all I should be doing is to initiate it.
///
/// For such cases you can still use the RCPreviewer to test out the whole flow (*o*) with Previews! Yeeeeeey!
///
/// If you initiate your flows with by passing a navigationController on the `start(navigationController)` function you can use the below example
///```
/// #Preview("Manual NavigationController injection") {
///    RCPreviewer { navigationController in
///        SettingsDIContainer.shared.settingsCoordinator().start(navigationController)
///        return nil
///    }
///}
///```
///
///If you are injecting your navigationController through a different mean like through DependencyContainer you can call the NavigationControllerInjector in AppDelegate on appStart to inject the navigationController you wish to use an all Previews will use that instance as their root navigationController.
//
///```
///class AppDelegate {
///    func application(_ application: UIApplication,didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {
///       RCPreviewer.NavigationControllerInjector.shared.setNavigationController {
///           return AppDependencyContainer.shared.appNavigationController()
///       }
///    }
/// }
/// ```
///
/// Now you can use the flow code to start your flow. This option has some additional benefits. If you have a `alertPresenter` class which presents on top of the `appNavigationController()` you can test out the whole flow seemlessly.
///```
///#Preview("Automatic NavigationController injection") {
///    RCPreviewer { navigationController in
///        SettingsDIContainer.shared.settingsCoordinator().start()
///        return nil
///    }
///}
///```

