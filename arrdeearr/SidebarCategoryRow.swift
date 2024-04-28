//
//  SidebarCategoryRow.swift
//  arrdeearr
//
//  Created by Marcos Ojeda on 3/30/24.
//

import SwiftUI

struct SidebarCategoryRow: View {
  var treeEntry: CategoryTree;
  let contextClick: (_ item: CategoryTree) -> Any? = {item in nil}

  @Environment(\.isFocused) private var isFocused: Bool;
  @State private var buttonOpacity: Double = 0

  func focusAnimation(hovering: Bool) {
    withAnimation(.easeInOut(duration: 0.14)) {
      buttonOpacity = (hovering) ? 1 : 0
    }
  }

  var body: some View {

    HStack {
      NavigationLink(treeEntry.value.name, value: treeEntry.id)
      Spacer()
      Button {
        if contextClick != nil {
          contextClick(treeEntry)
        }
      } label: {
        Label("Context Menu", 
              systemImage: "ellipsis.circle")
        .labelStyle(.iconOnly)
      }
      .opacity(buttonOpacity)
      .buttonStyle(.borderless)
    }.onHover(perform: focusAnimation)
      .focusable()
      .focusedValue(\.selectedCategory, treeEntry.value)
      .onKeyPress(.return, action: {
        print()
        return .handled
      })
      /*
       // not sure why this doesn't work
      .onChange(of: isFocused) { focusAnimation(hovering: isFocused)
        print("oh wow \(isFocused ? "focused":"notfocused")")
      }
       */

  }
}

/*struct DemoSidebarCategoryRow: View {
  let entry = CategoryTree(value: Category(id: "foo", parentId: "root", name: "Root Category"), children: [])
  let entry2 = CategoryTree(value: Category(id: "bar", parentId: "root", name: "Other Category"), children: [])

  private var items: Binding<[CategoryTree]> {
    Binding.constant([entry, entry2]) // (base:[entry, entry2];
  }

  var body: some View {

    NavigationSplitView{
      List(items, id: \.id) { item in
        if item.children?.count ?? 0 > 0 {
          DisclosureGroup(
            isExpanded: .constant(false),
            content: {},
            label: {
              SidebarCategoryRow(treeEntry: item, contextClick: {_ in print("ha")})
            }
          ).focusable(interactions: .automatic)
        } else {
          SidebarCategoryRow(treeEntry: item, contextClick: {_ in print("heh")})
        }
      }
    } content: {
    }
    detail: {

    }

  }
}
#Preview {
  DemoSidebarCategoryRow()
}
 */
