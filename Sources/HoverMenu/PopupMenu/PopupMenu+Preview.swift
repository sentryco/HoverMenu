import SwiftUI
/**
 * Preview
 * - Important: ⚠️️ Only for macOS
 * - Fixme: ⚠️️ Make this work for AddButton, moreButton, and optionRow for macOS, I think it does now? confirm?
 * - Fixme: ⚠️️ ...then make it hybrid so it works for iOS, investigate this closer
 * - Fixme: ⚠️️ Replace the old popover menues, but don't delete the code, the arrow popover could come in handy, investigate this
 */
#Preview(traits: .fixedLayout(width: 200, height: 200)) {
   struct DebugView: View {
      @State private var showMenu: Bool = false
      var body: some View {
            Button("Show More") {
               // Your popUp code here
               Swift.print("press: - showMenu \(showMenu)")
               showMenu = true
            }
            .popupMenu(isPresented: $showMenu,
               // - Fixme: ⚠️️ move to own var
               menuItems: [  // insert menu items here
               .init(title: "Menu item one") { Swift.print("action 1") },
               .init(title: "Menu item two") { Swift.print("action 2") }
               ], menuPostition: nil/*center*/)
               }
      }
   return DebugView()
      #if os(macOS)
      .frame(width: 200, height: 200) // needed or else button shrinks view
      #endif
}
