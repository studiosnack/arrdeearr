//
//  button-textfield.swift
//  arrdeearr
//
//  Created by Marcos Ojeda on 8/26/24.
//

import SwiftUI

struct ButtonTextfield: View {
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
            .onSubmit {
              onSubmit(value)
            }
            .onAppear {
              focused = true
            }
            .onExitCommand {
              onEscape()
            }
            .focused($focused)
            .padding([.horizontal], 5)
            .padding([.top], 10)
            .font(.caption)
        )
        :
          AnyView(
            HStack {
            Button(
              action: {
                onToggle()
              },
              label: {
                Label(
                  "Root Category",
                  systemImage: "plus.circle"
                )
                .font(.caption)
                .alignmentGuide(HorizontalAlignment.leading, computeValue: { $0[.leading] })
              }
            )
            .padding([.leading],10)
            Spacer()
          }
        ))
        .padding([.bottom])
        .buttonStyle(.borderless)
      
    }
}

// A wrapped version of the above that adds to 'root'
// it only accepts the store,
struct RootTextFieldButton: View {
  @Binding var store: RDRWStore

  @State var shouldSeeRootButtonTextfield: Bool = false;
  @State var newCategoryName: String = ""
  
  func handleAddCategory(name: String) {
    store.categories.add(categoryName: name)
    newCategoryName = ""
  }
  
  func handleToggle() {
    shouldSeeRootButtonTextfield = !shouldSeeRootButtonTextfield
  }
  func handleEscape() {
    shouldSeeRootButtonTextfield = false
    newCategoryName = ""
  }
  
  var body: some View {
    return ButtonTextfield(
      shouldShowTextfield: $shouldSeeRootButtonTextfield,
      value: $newCategoryName,
      onSubmit: handleAddCategory,
      onEscape: handleEscape,
      onToggle: handleToggle
    )
  }
}


#Preview {
  @Previewable @State var showsField: Bool = false;
  @Previewable @State var textValue: String = "";
  
  return ButtonTextfield(
    shouldShowTextfield: $showsField,
    value: $textValue,
    onSubmit: {val in print(val);
      print(textValue);
      showsField = false;
    },
    onEscape: {print("escapde!"); showsField = false;},
    onToggle: {showsField = !showsField})
}
