//
//  RCPreviewer+ViewFactory.swift
//  RCPreviewKit
//
//  Created by Radun Çiçen on 15.02.2025.
//

import SwiftUI

extension RCPreviewer {
    /// `ViewFactory` provides helper functions to create error view controllers.
    public struct ViewFactory {

        /// Creates a basic error `UIViewController`.
        ///
        /// - Parameter error: The error to be displayed.
        /// - Returns: A `UIViewController` displaying the raw error object.
        public func makeErrorVC(error: Error) -> UIViewController {
            MainActor.assumeIsolated {
                UIHostingController(rootView: Text("Error: \(error)"))
            }
        }

        /// Creates a basic error `UIViewController` using a string message.
        ///
        /// - Parameter message: The error message.
        /// - Returns: A `UIViewController` displaying the error message.
        public func makeErrorVC(message: String) -> UIViewController {
            MainActor.assumeIsolated {
                UIHostingController(rootView: Text(message))
            }
        }
    }
}
