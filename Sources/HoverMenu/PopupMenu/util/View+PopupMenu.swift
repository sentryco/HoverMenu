import SwiftUI
/**
 * macOS Exclusive: Convenient Popup Menu Attachment
 * - Descrption: This extension provides a convenient way to attach a popup menu to a view on macOS. 
 *               It is particularly useful in scenarios where a context menu or a dropdown menu is needed. The `popupMenu` function simplifies the process of creating and managing popup menus by handling the overlay and positioning of the menu items.
 * - Note: This extension is used in `PopupMenuWrapper` to provide a platform-agnostic way of displaying popup menus.
 */
extension View { // ⚠️️ was Button extension
   /**
    * Attaches a popup menu to the view.
    * - Description: This function overlays a popup menu on the view when `isPresented` is true. The menu is populated with `menuItems` and positioned at `menuPosition` if specified.
    * - Parameters:
    *   - isPresented: A binding to a boolean that controls the visibility of the popup menu.
    *   - menuItems: An array of items to be displayed in the popup menu.
    *   - menuPosition: The position at which the popup menu should be displayed. Defaults to .zero.
    * - Returns: The view with the popup menu overlay.
    */
   @ViewBuilder // - Fixme: ⚠️️ might not be needed
   public func popupMenu(isPresented: Binding<Bool>, menuItems: PopupMenuItems, menuPostition: CGPoint? = .zero) -> some View {
      #if os(macOS) // - Fixme: ⚠️️ Move above func
      self
         .overlay( // We add the view to the overlay, it's hidden
            PopupMenu( // Creates a new PopupMenu instance
               showMenu: isPresented, // Binding to control the visibility of the popup menu
               menuItems: menuItems, // Array of items to be displayed in the popup menu
               menuPosition: menuPostition // Position at which the popup menu should be displayed
            )
         )
      #endif
   }
}
/**
 * MenuItems
 */
extension View { // ⚠️️ Was Button extension etc
   /**
    * Attaches a popup menu to the view.
    * - Description: This function overlays a popup menu on the view when `isPresented` is true. The menu is populated with `items` and positioned at the default position.
    * - Parameters:
    *   - isPresented: A binding to a boolean that controls the visibility of the popup menu.
    *   - items: An array of items to be displayed in the popup menu.
    * - Returns: The view with the popup menu overlay.
    */
   @ViewBuilder // - Fixme: ⚠️️ might not be needed
   public func popupMenu(isPresented: Binding<Bool>, items: MenuItems) -> some View {
      #if os(macOS) // - Fixme: ⚠️️ Move above func
      // Converts the MenuItems array to PopupMenuItems by mapping each item to a new PopupMenuItem with its title and action
      let popupMenuItems: PopupMenuItems = items.compactMap {
         .init(
            title: $0.title, // Sets the title of the PopupMenuItem to the title of the MenuItem
            callback: $0.action // Sets the callback of the PopupMenuItem to the action of the MenuItem
         )
      }
      // Calls the popupMenu function to attach a popup menu to the view
      self.popupMenu(
         isPresented: isPresented, // Passes the binding to control the visibility of the popup menu
         menuItems: popupMenuItems // Passes the converted PopupMenuItems to populate the menu
      )
      #endif
   }
}
