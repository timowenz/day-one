//
//  EmojiTextFieldView.swift
//  DayOne
//
//  Created by Timo Wenz on 17.11.25.
//

import SwiftUI
import SwiftData
import UIKit

struct EmojiTextFieldView: UIViewRepresentable {
    @Binding var text: String
    @Binding var isPresented: Bool

    func makeUIView(context: Context) -> UITextField {
        let textField = UITextField()
        textField.delegate = context.coordinator
        textField.keyboardType = UIKeyboardType(rawValue: 124) ?? .default // Hidden emoji keyboard type
        textField.textAlignment = .center
        textField.font = UIFont.systemFont(ofSize: 40)
        return textField
    }

    func updateUIView(_ uiView: UITextField, context: Context) {
        uiView.text = text

        if isPresented, !uiView.isFirstResponder {
            DispatchQueue.main.async {
                uiView.becomeFirstResponder()
            }
        } else if !isPresented, uiView.isFirstResponder {
            DispatchQueue.main.async {
                uiView.resignFirstResponder()
            }
        }
    }

    func makeCoordinator() -> Coordinator {
        Coordinator(text: $text, isPresented: $isPresented)
    }

    class Coordinator: NSObject, UITextFieldDelegate {
        @Binding var text: String
        @Binding var isPresented: Bool

        init(text: Binding<String>, isPresented: Binding<Bool>) {
            _text = text
            _isPresented = isPresented
        }

        func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
            if let currentText = textField.text,
               let textRange = Range(range, in: currentText)
            {
                let updatedText = currentText.replacingCharacters(in: textRange, with: string)
                text = String(updatedText.suffix(1))
                textField.text = text

                DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                    self.isPresented = false
                }
            }
            return false
        }
    }
}
