//
//  RCPreviewer.swift
//  RCPreviewKit
//
//  Created by Radun Çiçen on 15.02.2025.
//

import SwiftUI

/// `RCPreviewer` is a `UIViewControllerRepresentable` SwiftUI wrapper that previews a `UIViewController`
/// inside a `UINavigationController`. This enables previewing UIKit-based view controllers
/// directly within SwiftUI previews.
///
/// ## Navigation Controller Injection
/// `RCPreviewer` utilizes an **injectable navigation controller**, which is provided by `NavigationControllerInjector.shared`.
/// This allows developers to **inject a shared navigation controller at app startup**, ensuring a **single root navigation controller**
/// is used consistently throughout all previews. This is useful when coordinating multiple previews or integrating with custom alert services.
///
/// Developers can either:
/// - Use the **default** injected navigation controller.
/// or
/// - Override the `navigationController` parameter to provide a custom navigation controller.
///
/// - **Setting a Global Navigation Controller (App Startup)**
/// ```swift
/// NavigationControllerInjector.shared.setNavigationController {
///     UINavigationController()
/// }
/// ```
///
/// - **Example Usage**
/// ```swift
/// #Preview {
///     RCPreviewer { navigationController in
///         let viewController = MyViewController()
///         return viewController
///     }
/// }
/// ```
public struct RCPreviewer: UIViewControllerRepresentable {

    /// The primary navigation controller used for embedding the view controller.
    let navigationController: UINavigationController

    /// A helper for executing asynchronous tasks.
    let asyncExecutor = AsyncExecutor()

    // MARK: - Initializers

    /// Initializes the `RCPreviewer` with a closure that returns a `UIViewController` inside a `UINavigationController`.
    ///
    /// - Parameters:
    ///   - navigationController: The navigation controller to be used. Defaults to the globally injected
    ///     navigation controller from `NavigationControllerInjector.shared`, ensuring consistency across previews.
    ///   - builder: A closure that receives the **root navigation controller** and returns an optional `UIViewController`.
    ///     The returned view controller is set as the root of the provided navigation controller.
    ///
    /// - Example:
    /// ```swift
    /// RCPreviewer { navigationController in
    ///     let viewController = MyViewController()
    ///     return viewController
    /// }
    /// ```
    public init(
        navigationController: UINavigationController = NavigationControllerInjector.shared.getNavigationController(),
        _ builder: @escaping (_ navigationController: UINavigationController) -> UIViewController?
    ) {
        self.navigationController = navigationController
        if let vc = builder(navigationController) {
            navigationController.viewControllers = [vc]
        }
    }

    /// Initializes the `RCPreviewer` with a closure that also provides an `AsyncExecutor` for performing async operations.
    ///
    /// - Parameters:
    ///   - navigationController: The navigation controller to be used. Defaults to the globally injected
    ///     navigation controller from `NavigationControllerInjector.shared`, ensuring consistency across previews.
    ///   - builder: A closure that receives the **root navigation controller** and an `AsyncExecutor`, returning an optional `UIViewController`.
    ///
    /// - Example:
    /// ```swift
    /// RCPreviewer { navigationController, asyncExecutor in
    ///     asyncExecutor.execute {
    ///         let response = await mockNetworkService.fetchData()
    ///         let viewModel = MyViewModel(response: response)
    ///         let viewController = MyViewController(viewModel: viewModel)
    ///         return viewController
    ///     }
    /// }
    /// ```
    public init(
        navigationController: UINavigationController = NavigationControllerInjector.shared.getNavigationController(),
        _ builder: @escaping (
            _ navigationController: UINavigationController,
            _ asyncExecutor: AsyncExecutor
        ) -> UIViewController?
    ) {
        self.navigationController = navigationController
        if let vc = builder(navigationController, asyncExecutor) {
            navigationController.viewControllers = [vc]
        }
    }

    /// Initializes the `RCPreviewer` with a closure that provides an `AsyncExecutor` and a `ViewFactory` for UI generation.
    ///
    /// - Parameters:
    ///   - navigationController: The navigation controller to be used. Defaults to the globally injected
    ///     navigation controller from `NavigationControllerInjector.shared`, ensuring consistency across previews.
    ///   - builder: A closure that receives the **root navigation controller**, an `AsyncExecutor`, and a `ViewFactory`,
    ///     returning an optional `UIViewController`.
    ///
    /// - Example:
    /// ```swift
    /// #Preview {
    ///     RottaPreviewer { navigationController, asyncPerformer, viewFactory in
    ///         asyncPerformer.perform(.detached(operation: {
    ///             let someService = MyService()
    ///             let response = try await someService.fetchData()
    ///             return response
    ///         }), successVC: { response in
    ///         let viewController = MyViewController(data: response)
    ///         return viewController
    ///         }, errorVC: { error in
    ///             return viewFactory.makeErrorVC(error: error)
    ///         })
    ///     }
    /// }
    /// ```
    public init(
        navigationController: UINavigationController = NavigationControllerInjector.shared.getNavigationController(),
        _ builder: @escaping (
            _ navigationController: UINavigationController,
            _ asyncExecutor: AsyncExecutor,
            _ viewFactory: ViewFactory
        ) -> UIViewController?
    ) {
        self.navigationController = navigationController
        if let vc = builder(navigationController, asyncExecutor, .init()) {
            navigationController.viewControllers = [vc]
        }
    }

}

// MARK: - UIViewControllerRepresentable conformance

extension RCPreviewer {

    public func makeUIViewController(context: Context) -> UINavigationController {
        return navigationController
    }

    public func updateUIViewController(_ uiViewController: UINavigationController, context: Context) {}
}
