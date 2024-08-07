//
//  SidebarContent.swift
//  arrdeearr
//
//  Created by Marcos Ojeda on 7/21/24.
//

import SwiftUI

struct NavigationSidebarContent: View {

  @Binding var document: ArrdeearrDocument;

  var body: some View {

    let selectedCategoryRow = Binding(get: {
      document.store.application.selectedCategoryRow
    }, set: {
      rowId in document.store.application.selectedCategoryRow = rowId
    })

    let outlineData: [CategoryTree] = CategoryTree.forCategoryStore(
      store: document.store.categories, atPath: "root"
    ) ?? []

    func sidebarOpenBinding(path: String) -> Binding<Bool> {
      return Binding(
        get: {document.store.application.sideBarOpenedState[path] ?? false},
        set: {val in document.store.application.sideBarOpenedState[path] = val ? val : nil})
    }

    return List(outlineData, id: \.id, selection: selectedCategoryRow) { category in

      ConfigurableDisclosureGroup(
        data: category,
        path: \.children,
        isOpen: {tree in sidebarOpenBinding(path: tree.id)} ) 
        {
          categoryEntry in
          SidebarEntry(
            needsTextField: document.store.application.wantsChildInput[categoryEntry.id] == true,
            categoryEntry: categoryEntry,
            document: $document
          )

        }
    }
  }
}

struct SidebarEntry: View {
  @State var newCategoryName: String = "";
  var needsTextField: Bool
  var categoryEntry: CategoryTree
  @Binding var document: ArrdeearrDocument;

  enum Field: Hashable {
    case CategoryName
  }
  @FocusState private var hasFocus: Field?
  
  func handleSubmit(name: String) -> Void {
    /**
    this is really wonky, should just use a popup here
     */
    document.store.categories.add(parentId: categoryEntry.id, name: name)
    // hide the input after adding the new category
    document.store.application.toggleWantsChildInput(for: categoryEntry.id)
    newCategoryName = ""
  }

  var body: some View {
    VStack{
      SidebarCategoryRow(
        treeEntry: categoryEntry,
        contextClick: {
          entry in
            document.store.application.toggleWantsChildInput(for: entry.id)
        }
      )
      needsTextField ? Form() {
        TextField("Name", text: $newCategoryName, prompt: Text("Name"))
          .focused($hasFocus, equals: .CategoryName)
          .disableAutocorrection(true)
          .textFieldStyle(.roundedBorder)
          .onSubmit {
            handleSubmit(name: newCategoryName)

          }
      }.defaultFocus($hasFocus, .CategoryName)
        .labelsHidden() : nil
    }
  }
}

//#Preview {
//    SidebarContent()
//}
