//
//  TaskTriggerButton+Init.swift
//  TaskTriggerUI
//
//  Created by Lukas Pistrol on 26.11.24.
//

import SwiftUI

extension TaskTriggerButton {
    /// Creates a new ``TaskTriggerButton`` with a title.
    /// - Parameters:
    ///   - text: The button's title.
    ///   - role: The button's role. Defaults to `nil`.
    ///   - behavior: The button's behavior. Defaults to `.blocking(showPlaceholder: true)`.
    ///   - action: The async action to perform when the button is tapped.
    ///   - placeholder: The placeholder to show while the task is running. Defaults to a `ProgressView`.
    ///   If `showPlaceholder` on the `role` is set to `false`, this is ignored.
    public init(
        _ text: LocalizedStringKey,
        role: ButtonRole? = nil,
        behavior: Behavior = .blocking(showPlaceholder: true),
        action: @escaping @Sendable @MainActor () async -> Void,
        @ViewBuilder placeholder: @escaping () -> P = { ProgressView() }
    ) where L == Text {
        self.action = action
        self.label = { Text(text) }
        self.placeholder = placeholder
        self.role = role
        self.behavior = behavior
    }

    /// Creates a new ``TaskTriggerButton`` with a title and an image.
    /// - Parameters:
    ///   - text: The button's title.
    ///   - image: The button's image.
    ///   - role: The button's role. Defaults to `nil`.
    ///   - behavior: The button's behavior. Defaults to `.blocking(showPlaceholder: true)`.
    ///   - action: The async action to perform when the button is tapped.
    ///   - placeholder: The placeholder to show while the task is running. Defaults to a `ProgressView`.
    ///   If `showPlaceholder` on the `role` is set to `false`, this is ignored.
    @available(iOS 17.0, *)
    public init(
        _ text: LocalizedStringKey,
        image: ImageResource,
        role: ButtonRole? = nil,
        behavior: Behavior = .blocking(showPlaceholder: true),
        action: @escaping @Sendable @MainActor () async -> Void,
        @ViewBuilder placeholder: @escaping () -> P = { ProgressView() }
    ) where L == Label<Text, Image> {
        self.action = action
        self.label = { Label(text, image: image) }
        self.placeholder = placeholder
        self.role = role
        self.behavior = behavior
    }

    /// Creates a new ``TaskTriggerButton`` with a title and a system image.
    /// - Parameters:
    ///   - text: The button's title.
    ///   - systemImage: The button's system image.
    ///   - role: The button's role. Defaults to `nil`.
    ///   - behavior: The button's behavior. Defaults to `.blocking(showPlaceholder: true)`.
    ///   - action: The async action to perform when the button is tapped.
    ///   - placeholder: The placeholder to show while the task is running. Defaults to a `ProgressView`.
    ///   If `showPlaceholder` on the `role` is set to `false`, this is ignored.
    public init(
        _ text: LocalizedStringKey,
        systemImage: String,
        role: ButtonRole? = nil,
        behavior: Behavior = .blocking(showPlaceholder: true),
        action: @escaping @Sendable @MainActor () async -> Void,
        @ViewBuilder placeholder: @escaping () -> P = { ProgressView() }
    ) where L == Label<Text, Image> {
        self.action = action
        self.label = { Label(text, systemImage: systemImage) }
        self.placeholder = placeholder
        self.role = role
        self.behavior = behavior
    }
}
