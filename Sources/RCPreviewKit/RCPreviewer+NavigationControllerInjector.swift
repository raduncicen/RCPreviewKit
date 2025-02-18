//
//  RCPreviewerNavigationControllerInjector.swift
//  RCPreviewKit
//
//  Created by Radun Çiçen on 15.02.2025.
//


import UIKit

extension RCPreviewer {
    public final class NavigationControllerInjector {

        nonisolated(unsafe) public static let shared = NavigationControllerInjector()

        private var navigationControllerProvider: (() -> UINavigationController)?
        
        private init() {}
        
        /// Allows developers to inject a navigation controller factory.
        public func setNavigationController(provider: @escaping () -> UINavigationController) {
            self.navigationControllerProvider = provider
        }
        
        /// Retrieves the injected navigation controller if it exists.
        public nonisolated func getNavigationController() -> UINavigationController {
            navigationControllerProvider?() ?? MainActor.assumeIsolated { UINavigationController() }
        }
    }
}
