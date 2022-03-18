//
//  LegacyTextField.swift
//  FloatingTextField
//
//  Created by Kiarash Vosough on 3/18/22.
//
//  Copyright 2020 KiarashVosough and other contributors
//
//  Permission is hereby granted, free of charge, to any person obtaining
//  a copy of this software and associated documentation files (the
//  Software"), to deal in the Software without restriction, including
//  without limitation the rights to use, copy, modify, merge, publish,
//  distribute, sublicense, and/or sell copies of the Software, and to
//  permit persons to whom the Software is furnished to do so, subject to
//  the following conditions:
//
//  The above copyright notice and this permission notice shall be
//  included in all copies or substantial portions of the Software.
//
//  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND,
//  EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF
//  MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND
//  NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE
//  LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION
//  OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION
//  WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.

import SwiftUI
import UIKit

public struct LegacyTextField: UIViewRepresentable {
    
    public enum FocusState: Int, Hashable {
        case focused, unFocused
    }
    
    public typealias ShouldReturnBlock = () -> Bool
    
    public typealias FocusChangedBlock = (Self.FocusState) -> Void
    
    public typealias TextFieldConfigurationBlock = (UITextField) -> Void
    
    @Binding public var isFirstResponderSender: Bool
    
    @Binding public var text: String
    
    public var shouldReturn: ShouldReturnBlock
    
    public var didFocused: FocusChangedBlock
    
    public var configuration: TextFieldConfigurationBlock
    
    public init(isFirstResponderSender: Binding<Bool>, text: Binding<String>, shouldReturn: @escaping LegacyTextField.ShouldReturnBlock = { true }, didFocused: @escaping LegacyTextField.FocusChangedBlock = { focused in }, configuration: @escaping LegacyTextField.TextFieldConfigurationBlock = { view in }) {
        self._isFirstResponderSender = isFirstResponderSender
        self._text = text
        self.shouldReturn = shouldReturn
        self.didFocused = didFocused
        self.configuration = configuration
    }
    
    
    public func makeUIView(context: Context) -> UITextField {
        let view = UITextField()
        view.addTarget(context.coordinator, action: #selector(Coordinator.textViewDidChange), for: .editingChanged)
        view.delegate = context.coordinator
        return view
    }
    
    public func updateUIView(_ uiView: UITextField, context: Context) {
        uiView.text = text
        if isFirstResponderSender {
            uiView.becomeFirstResponder()
        } else {
            uiView.resignFirstResponder()
        }
    }
    
    public func makeCoordinator() -> Coordinator {
        Coordinator($text, didFocused: didFocused, shouldReturn: shouldReturn)
    }
    
    public class Coordinator: NSObject, UITextFieldDelegate {
        
        @Binding var text: String
        
        public var didFocused: FocusChangedBlock
        
        public var shouldReturn: ShouldReturnBlock
        
        public init(_ text: Binding<String>, didFocused: @escaping FocusChangedBlock, shouldReturn: @escaping ShouldReturnBlock) {
            self._text = text
            self.didFocused = didFocused
            self.shouldReturn = shouldReturn
        }
        
        @objc public func textViewDidChange(_ textField: UITextField) {
            self.text = textField.text ?? ""
        }
        
        public func textFieldDidBeginEditing(_ textField: UITextField) {
            // should not use binding here as it changes view state during update
            didFocused(.focused)
        }
        
        public func textFieldDidEndEditing(_ textField: UITextField) {
            // should not use binding here as it changes view state during update
            didFocused(.unFocused)
        }
        
        public func textFieldShouldReturn(_ textField: UITextField) -> Bool {
            shouldReturn()
        }
    }
}
