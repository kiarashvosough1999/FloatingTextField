//
//  FloatingTextField.swift
//  Shared
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

struct FloatingTextField: View {
    
    @available(iOS 15.0, macOS 12.0, tvOS 15.0, watchOS 8.0, *)
    private enum Field: Int, Hashable {
        case focused, unFocused
    }
    
    let title: String
    
    @Binding var text: String
    
    @State var isFocused: Bool = false
    
    @available(iOS 15.0, macOS 12.0, tvOS 15.0, watchOS 8.0, *)
    @FocusState private var focusField: Field?
    
    var body: some View {
        ZStack(alignment: .leading) {
            if #available(iOS 15.0, macOS 12.0, tvOS 15.0, watchOS 8.0, *) {
                TextField("", text: $text)
                    .focused($focusField, equals: .focused)
                    .frame(height: 50, alignment: .leading)
                    .padding(.horizontal, 16)
                    .textFieldStyle(PlainTextFieldStyle())
                    .background(
                        RoundedRectangle(cornerRadius: 16)
                            .strokeBorder(Color.blue, lineWidth: 2)
                    )
            } else {
                LegacyTextField(isFirstResponderSender: $isFocused, text: $text)
                    .frame(height: 50, alignment: .leading)
                    .padding(.horizontal, 16)
                    .textFieldStyle(PlainTextFieldStyle())
                    .background(
                        RoundedRectangle(cornerRadius: 16)
                            .strokeBorder(Color.blue, lineWidth: 2)
                    )
            }
            
            Text(text.isEmpty ? title : title.withSingleLeadingSpace.withSingleTrailingSpace)
                .font(.title.bold().weight(.medium))
                .foregroundColor(Color(.placeholderText))
            /// Do not replace `Color.white.opacity(0)` with `Color.clear`, it will result in unexpected behavior on changing animation state
                .background(text.isEmpty ? Color.white.opacity(0) : Color.white)
                .offset(y: text.isEmpty ? 0 : -33)
                .scaleEffect(text.isEmpty ? 1 : 0.75, anchor: .leading)
                .animation(.spring(response: 0.5, dampingFraction: 0.6))
                .padding(.horizontal, 16)
                .onTapGesture {
                    if #available(iOS 15.0, macOS 12.0, tvOS 15.0, watchOS 8.0, *) {
                        focusField = .focused
                    } else {
                        isFocused = true
                    }
                }
            
        }
        .padding(15)
    }
}

#if DEBUG
struct FloatingTextField_Previews: PreviewProvider {
    static var previews: some View {
        FloatingTextField(title: "Your Email Address", text: .constant(""))
            .frame(width: 350, height: 60, alignment: .center)
    }
}
#endif
