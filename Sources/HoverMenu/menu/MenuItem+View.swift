import SwiftUI
#if os(iOS)
import UIKit
#endif
/**
 * Universal context-menu for iOS and macOS
 */
extension View {
   /**
    * Displays a context menu for both iOS and macOS platforms.
    * - Description: This modifier adds a context menu to the view which adapts to the platform it's running on. On iOS, a tap press will trigger the menu, while on macOS, a click will show a popover with the menu items.
    * - Note: On iOS, it uses the `editMenu` modifier to display a menu on long press.
    * - Note: On macOS, it uses a `popover` to display the menu on tap.
    * - Fixme: ⚠️️ And then we can make one universal call for iOS and macOS
    * - Parameters:
    *   - menuItems: The collection of menu items to be displayed in the context menu.
    *   - showMenu: A binding to a boolean value that indicates whether the menu should be shown.
    * - Returns: A view that displays a context menu based on the platform.
    */
   @ViewBuilder
   public func contextMenu(menuItems: MenuItems, showMenu: Binding<Bool>) -> some View {
      self
         #if os(iOS) // This line checks if the operating system is iOS.
         .editMenu { // Attaches an edit menu to the view for iOS.
            // This line displays the menu actions defined in the menuItems
            menuItems.menuActions
         }
         #elseif os(macOS) // This line checks if the operating system is macOS.
         .onTapGesture { // ⚠️️ We could also use button, but this seems to do just fine
            // This line sets the showMenu binding to true, indicating the menu should be shown
            showMenu.wrappedValue = true
         }
         .popover( // Attaches a popover view to the current view, which is used to display contextual options on macOS.
            isPresented: showMenu, // This line sets the presentation state of the popover based on the showMenu binding.
            attachmentAnchor: .point(.center) // Makes the popover appear centered relative to the button.
         ) { // Note: The popover shows full screen on iOS
            // This line displays the menu stack with the given showMenu binding.
            menuItems.menuStack(showMenu: showMenu)
         }
         #endif
   }
}
