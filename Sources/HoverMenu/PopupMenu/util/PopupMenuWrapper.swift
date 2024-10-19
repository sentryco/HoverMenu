import SwiftUI
/**
 * For macOS and iOS
 * - Note: This struct is used in `IconMenuButton` and `OptionMenuView` to
 *         implement popup menus for various actions such as `editoptions`,
 *         `morebutton`, `addbutton`, and `options-row`.
 * - Description: This struct wraps a SwiftUI View with a popup menu, allowing
 *                for easy integration of menus into SwiftUI applications.
 * - Fixme: ⚠️️ Add preview? or do we have that in the implementations? investigate etc
 * - Fixme: ⚠️️ Ask copilot how we can make an extension for this
 */
public struct PopupMenuWrapper<Content: View>: View {
   /**
    * The items to be displayed in the popup menu
    * - Description: An array of menu items that define the actions available
    *                in the popup menu. Each item is represented by a `MenuItem` instance
    *                which includes a title, an action to be performed when the item is
    *                selected, and an optional icon.
    */   
   public let menuItems: MenuItems
   /**
    * The content to be displayed as the button or label for the popup menu.
    * - Description: A view that serves as the interactive element triggering
    *                the popup menu. This content is typically a button or a label
    *                that, when interacted with, will present the popup menu to the
    *                user.
    */
   public let content: Content
   /**
    * A state variable to control the visibility of the popup menu.
    * - Description: A boolean state variable that determines whether the popup
    *                menu should be visible. When `true`, the popup menu is shown;
    *                when `false`, it is hidden.
    */
   @State private var showMenu: Bool = false
   /**
    * Initializes a PopupMenuWrapper with the given menu items and content.
    * - Description: This initializer sets up the PopupMenuWrapper with a given
    *                set of menu items and a content view. The menu items are
    *                displayed in the popup menu when it is presented, and the
    *                content view is used as the button or label for the popup
    *                menu.
    * - Parameters:
    *   - menuItems: The items to be displayed in the popup menu.
    *   - content: The content to be displayed as the button or label for the popup menu.
    */
   public init(menuItems: MenuItems, @ViewBuilder content: () -> Content) {
      self.menuItems = menuItems
      self.content = content() // - Fixme: ⚠️️ should we rather execute in the implementation?
   }
   /**
    * Body
    * - Description: This is the main body of the PopupMenuWrapper. Depending
    *                on the operating system, it either creates a Menu for iOS
    *                or a Button with an attached popup menu for macOS. The
    *                content passed into the PopupMenuWrapper is used as the
    *                label for the Menu or Button.
    */
   @ViewBuilder // ⚠️️ Might not be needed? because OS clauses etc?
   public var body: some View {
      #if os(iOS)  // - Fixme: ⚠️️ Move to iOS var? maybe
      Menu { // Represents the menu
         menuItems.buttons() // Creates the menu items
      } label: { // Represents the button
         content // The content to be displayed as the button or label for the popup menu.
      } // Menu-button
      #elseif os(macOS) // - Fixme: ⚠️️ Move to macOS var? maybe
      Button(action: { self.showMenu = true }) { // Represents the button
         content // The content to be displayed as the button or label for the popup menu.
      }
      .popupMenu( // Attaches a popup menu to the button
         isPresented: $showMenu, // Binds the popup menu's visibility to the showMenu state variable
         items: menuItems // Passes the menu items to the popup menu
      )
      .buttonStyle(.plain) // Styles the button to be plain
      #endif
   }
}
// Preview
#Preview(traits: .fixedLayout(width: 240, height: 200)) {
   let menuItems = [
      MenuItem( title: "First Option", action: {}, iconName: "option1Icon"),
      MenuItem( title: "Second Option", action: {}, iconName: "option2Icon"),
      MenuItem( title: "Third Option", action: {}, iconName: "option3Icon")
   ]
   return PopupMenuWrapper(menuItems: menuItems) {
      Text("Preview Content")
   }
   .padding(48)
}
