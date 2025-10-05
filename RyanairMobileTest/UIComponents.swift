//
//  UIComponents.swift
//  RyanairMobileTest
//
//  Created by Marcus Presa Käld
//

import SwiftUI

struct PickerTriggerField: View {
    let placeholder: String
    let value: String?
    let badge: String
    @Binding var isPresented: Bool

    var body: some View {
        HStack(spacing: 8) {
            TextField(placeholder, text: .constant(value ?? ""))
                .disabled(true)
                .textFieldStyle(.roundedBorder)

            Text(badge)
                .font(.caption)
                .padding(.horizontal, 8).padding(.vertical, 4)
                .background(Color.gray.opacity(0.15))
                .clipShape(Capsule())
        }
        .onTapGesture { isPresented = true }
        .accessibilityLabel("\(badge) airport picker")
        .accessibilityValue(value ?? "None selected")
    }
}
