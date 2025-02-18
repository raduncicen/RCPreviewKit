//
//  BasicSwiftUIView.swift
//  RCPreviewKit
//
//  Created by Radun Çiçen on 17.02.2025.
//

import SwiftUI

@available(iOS 15.0, *)
struct BasicSwiftUIView: View {
    var body: some View {
        Color.gray
            .overlay {
                Text("BasicSwiftUIView")
            }
            .navigationTitle("Some Nav Title")
    }
}

@available(iOS 15.0, *)
class BasicViewController: UIHostingController<BasicSwiftUIView> { }


// MARK: - SAMPLE PREVIEWS

@available(iOS 15.0, *)
#Preview("Basic_1") {
    RCPreviewer { navigationController in
        let viewController = UIHostingController(rootView: BasicSwiftUIView())
        return viewController
    }
}

@available(iOS 15.0, *)
#Preview("Basic_2") {
    RCPreviewer { navigationController in
        let viewController = BasicViewController(rootView: .init())
        return viewController
    }
}

@available(iOS 15.0, *)
#Preview("PageSheet_Preview") {
    RCPreviewer { navigationController in
        let rootView = UIHostingController(rootView: Color.red)

        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
            let modalViewController = BasicViewController(rootView: .init())
            navigationController.present(modalViewController, animated: true)
        }

        return rootView
    }
}

@available(iOS 15.0, *)
#Preview("Push_Preview") {
    RCPreviewer { navigationController in
        let rootView = UIHostingController(rootView: Color.red)

        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
            let viewController = BasicViewController(rootView: .init())
            navigationController.pushViewController(viewController, animated: true)
        }

        return rootView
    }
}
