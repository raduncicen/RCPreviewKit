//
//  RCPreviewer+AsyncExecutor.swift
//  RCPreviewKit
//
//  Created by Radun Çiçen on 15.02.2025.
//

import UIKit

extension RCPreviewer {

    /// `AsyncExecutor` provides synchronous execution for asynchronous tasks.
    /// This is useful when bridging Swift Concurrency with blocking operations.
    /// You probably need this if you are using `Async/Await` in your service classes to prepare some data to configure or present your views.
    ///  AsyncExecutor let's you use these async services and pass the fetched data to the Previewed view seemlessly.
    public final class AsyncExecutor {

        ///  - IMPORTANT: Make sure to use a `.detached(...)` initializer for the `task` parameter to avoid deadlocks inside your preview.
        public func execute<T>(
            _ task: Task<T,Error>,
            successVC: (T) -> UIViewController,
            errorVC: (Error) -> UIViewController
        ) -> UIViewController {
            let semaphore = DispatchSemaphore(value: 0)
            var result: Result<T, Error>?
            Task {
                do {
                    let response = try await task.value
                    result = .success(response)
                } catch {
                    result = .failure(error)
                }
                semaphore.signal()
            }
            semaphore.wait()
            guard let result else {
                fatalError("This case should never happen")
            }

            switch result {
            case .success(let response):
                return successVC(response)
            case .failure(let error):
                return errorVC(error)
            }
        }
        /// Executes an async `Task` and returns the result synchronously.
        ///
        /// - Parameter task: A `Task` that produces a result.
        /// - Returns: The computed result.
        ///  - IMPORTANT: Make sure to use a `.detached(...)` initializer for the `task` parameter to avoid deadlocks inside your preview.
        public func execute<T>(_ task: Task<T, Never>) -> T {
            let semaphore = DispatchSemaphore(value: 0)
            var response: T?
            Task {
                response = await task.value
                semaphore.signal()
            }
            semaphore.wait()
            guard let result = response else {
                fatalError("AsyncExecutor - No data available or failed to retrieve result.")
            }
            return result
        }

        /// Executes an async `Task` that may return `nil`.
        ///
        /// - Parameter task: A `Task` that might return an optional result.
        /// - Returns: The computed result or `nil`.
        ///  - IMPORTANT: Make sure to use a `.detached(...)` initializer for the `task` parameter to avoid deadlocks inside your preview.
        public func executeOptional<T>(_ task: Task<T?, Never>) -> T? {
            let semaphore = DispatchSemaphore(value: 0)
            var response: T?
            Task {
                response = await task.value
                semaphore.signal()
            }
            semaphore.wait()
            return response
        }

        /// Executes a throwing async `Task` and returns the result or throws an error.
        ///
        /// - Parameter task: A throwing `Task`.
        /// - Throws: The error if the task fails.
        /// - Returns: The computed result.
        ///  - IMPORTANT: Make sure to use a `.detached(...)` initializer for the `task` parameter to avoid deadlocks inside your preview.
        public func executeThrowing<T>(_ task: Task<T, Error>) throws -> T {
            let semaphore = DispatchSemaphore(value: 0)
            var result: Result<T, Error>?
            Task {
                do {
                    let response = try await task.value
                    result = .success(response)
                } catch {
                    result = .failure(error)
                }
                semaphore.signal()
            }
            semaphore.wait()
            guard let finalResult = result else {
                fatalError("This case should never happen.")
            }

            switch finalResult {
            case .success(let value):
                return value
            case .failure(let error):
                throw error
            }
        }
    }
}
