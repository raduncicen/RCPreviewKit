//
//  MVVMSwiftUIView.swift
//  RCPreviewKit
//
//  Created by Radun Çiçen on 17.02.2025.
//

import SwiftUI

@available(iOS 15.0, *)
class MVVMSwiftUIViewController: UIHostingController<MVVMSwiftUIView> { }

@available(iOS 15.0, *)
struct MVVMSwiftUIView: View {
    @ObservedObject var viewModel: MVVMSwiftUIViewModel

    var body: some View {
        Color.gray
            .overlay {
                Text("MVVMSwiftUIView")
            }
            .navigationTitle("Some Nav Title")
    }
}

class MVVMSwiftUIViewModel: ObservableObject {
    @Published var luckyNumber: Int

    init(luckyNumber: Int) {
        self.luckyNumber = luckyNumber
    }
}

/// A mock lucky number service which acts as an example for an async and async throws request
class LuckyNumberService {
    func getLuckyNumber() async -> Int {
        (0...10).randomElement()!
    }

    func tryGetLuckyNumber() async throws -> Int {
        let number = await getLuckyNumber()
        if number % 3 == 0 {
            throw NSError(
                domain: "com.example.luckyNumberService",
                code: 404,
                userInfo: [NSLocalizedDescriptionKey : "Failed to fetch lucky number"]
            )
        }
        return number
    }

    func tryGetLuckyNumber(shouldFail: Bool) async throws -> Int {
        let number = await getLuckyNumber()
        if shouldFail {
            throw NSError(
                domain: "com.example.luckyNumberService",
                code: 404,
                userInfo: [NSLocalizedDescriptionKey : "Failed to fetch lucky number"]
            )
        }
        return number
    }
}

@available(iOS 15.0, *)
class ViewControllerFactory {
    func makeMVVMSwiftUIViewController(luckyNumber: Int) -> UIViewController {
        let viewModel = MVVMSwiftUIViewModel(luckyNumber: luckyNumber)
        let view = MVVMSwiftUIView(viewModel: viewModel)

        return MainActor.assumeIsolated {
            MVVMSwiftUIViewController(rootView: view)
        }
    }
}

// MARK: - SAMPLE ASYNC PREVIEWS
/// - EXAMPLE: Async request
@available(iOS 15.0, *)
#Preview {
    RCPreviewer({ navigationController, asyncExecutor in
        let luckyNumber = asyncExecutor.execute(.detached(operation: {
            let numberService = LuckyNumberService()
            let luckyNumber = await numberService.getLuckyNumber()
            return luckyNumber
        }))
        let viewModel = MVVMSwiftUIViewModel(luckyNumber: luckyNumber)
        let view = MVVMSwiftUIView(viewModel: viewModel)
        let viewController = MVVMSwiftUIViewController(rootView: view)
        return viewController
    })
}

/// - EXAMPLE: Async request_1
@available(iOS 15.0, *)
#Preview("Async_1") {
    RCPreviewer({ navigationController, asyncExecutor in
        let luckyNumber = asyncExecutor.execute(.detached(operation: {
            let numberService = LuckyNumberService()
            let luckyNumber = await numberService.getLuckyNumber()
            return luckyNumber
        }))
        let viewModel = MVVMSwiftUIViewModel(luckyNumber: luckyNumber)
        let view = MVVMSwiftUIView(viewModel: viewModel)
        let viewController = MVVMSwiftUIViewController(rootView: view)
        return viewController
    })
}

/// - EXAMPLE: Async request_2
@available(iOS 15.0, *)
#Preview("Async_2") {
    RCPreviewer({ navigationController, asyncExecutor in
        let luckyNumber = asyncExecutor.execute(.detached(operation: {
            let numberService = LuckyNumberService()
            let luckyNumber = await numberService.getLuckyNumber()
            return luckyNumber
        }))
        return ViewControllerFactory().makeMVVMSwiftUIViewController(luckyNumber: luckyNumber)
    })
}

// MARK: - SAMPLE ASYNC/THROWS PREVIEWS

@available(iOS 15.0, *)
#Preview("Async/Throws with failure view") {
    RCPreviewer { navigationController, asyncExecutor, viewFactory in
        asyncExecutor.execute(.detached(operation: {
            let shouldFail = true
            return try await LuckyNumberService().tryGetLuckyNumber(shouldFail: shouldFail)
        }), successVC: { response in
            ViewControllerFactory().makeMVVMSwiftUIViewController(luckyNumber: response)
        }, errorVC: { error in
            viewFactory.makeErrorVC(error: error)
        })
    }
}
