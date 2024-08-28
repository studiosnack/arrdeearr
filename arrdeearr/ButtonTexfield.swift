//
//  button-textfield.swift
//  arrdeearr
//
//  Created by Marcos Ojeda on 8/26/24.
//

import SwiftUI

struct button_textfield: View {
  @Binding var shouldShowTextfield: Bool;
  @Binding var value: String;
  @FocusState var focused: Bool;
  let onSubmit: (_ value: String) -> Void;
  let onEscape: () -> Void;
  let onToggle: () -> Void;
  
    var body: some View {
      
      return AnyView(
        shouldShowTextfield ?
        AnyView(
          TextField("New Category Name", text: $value)
            .onKeyPress(.escape, action: {
              onEscape();
              return .handled
            })
            .onSubmit {
              onSubmit(value)
            }
            .focused($focused)
            .padding([.horizontal], 5)
            .font(.caption)
        )
        : AnyView(
          Button(
            action: onToggle,
            label: {
              Label(
                "Root Category",
                systemImage: "plus.circle"
              ).font(.caption)
            }).padding([.leading],10)
        )
      )
        .padding([.bottom])
        .buttonStyle(.borderless)
      
    }
}

#Preview {
  @Previewable @State var showsField: Bool = false;
  @Previewable @State var textValue: String = "";
  
  return button_textfield(
    shouldShowTextfield: $showsField,
    value: $textValue,
    onSubmit: {val in print(val);
      print(textValue);
      showsField = false;
    },
    onEscape: {print("escapde!"); showsField = false;},
    onToggle: {showsField = !showsField})
}
