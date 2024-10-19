import SwiftUI
/**
 * Buttons
 * - Fixme: ⚠️️ Move to +Buttons file
 * - Fixme: ⚠️️ Clean up and refactor this file
 */
extension MenuItems {
   /**
    * - Abstract: Generates a view with buttons for each `MenuItem` in the
    *             collection, suitable for macOS platforms.
    * - Description: This method generates a view with buttons for each
    *                `MenuItem` in the collection. It is designed for use within
    *                a macOS-specific context and provides a way to display a list
    *                of buttons corresponding to each `MenuItem`.
    * - Note: This method is only available on macOS platforms and is designed
    *         to be used within a macOS-specific context.
    * - Fixme: ⚠️️ Add icons to the list
    * - Fixme: ⚠️️ Also set accesibility-id maybe?
    * - Fixme: ⚠️️ Mark it as macOS only, is it only for macOS? confirm?
    * - Parameters:
    *   - showMenu: An optional binding to a boolean value that controls the visibility of the menu.
    * - Returns: A view containing buttons for each `MenuItem` in the collection.
    */
   @ViewBuilder // - Fixme: ⚠️️ this might not be needed?
   public func buttons(showMenu: Binding<Bool>? = nil) -> some View {
      ForEachElementAndIndex(self) { (_ index: Int, _ menuItem: MenuItem) in
         self.item( // Call the item function with the menuItem, index, and showMenu
            menuItem: menuItem, // The menuItem to be displayed
            index: index, // The index of the menuItem in the collection
            showMenu: showMenu // The binding to control the visibility of the menu
         )
      }
   }
   /**
    * - Abstract: Generates a stacked view with buttons for each `MenuItem`,
    *             suitable for macOS platforms.
    * - Description: This method creates a view with a vertical stack of buttons.
    *                Each button corresponds to a `MenuItem` and triggers the
    *                associated action when clicked. Designed for macOS platforms,
    *                where a vertical stack of buttons is a common UI pattern.
    * - Note: This method is for macOS-specific context, intended to display a
    *         vertical stack of buttons, each linked to a `MenuItem`.
    * - Fixme: ⚠️️ Try to make popOver call work on center of view
    * - Parameters:
    *   - showMenu: An optional binding to a boolean value that controls the visibility of the menu.
    * - Returns: A view containing a vertical stack of buttons for each `MenuItem` in the collection.
    */
   #if os(macOS)
   public func menuStack(showMenu: Binding<Bool>? = nil) -> some View {
      VStack {
         self.buttons(showMenu: showMenu) // Creates the menu items
            .buttonStyle(.plain) // Remove default macOS styling
      }
      // - Fixme: ⚠️️ use measure const?
      .padding() // Applies padding to the view
   }
   #endif
   /**
    * Needed or else return is opaque in foreach-element-and-index etc
    * - Description: This function generates a button for a given `MenuItem`.
    *                The button, when clicked, triggers the action associated
    *                with the `MenuItem`. If a `showMenu` binding is provided,
    *                the visibility of the menu is controlled based on the state
    *                of this binding. The function also supports the addition of
    *                a keyboard shortcut for the button if specified in the
    *                `MenuItem`.
    * - Fixme: ⚠️️ Strange that icon isn't left aligned when rendered, try to research it, doesn't seem to be any info on this easily available
    * - Fixme: ⚠️️ We could add `accessevbilityIdentifier` to the button based on some id in menuItem model?
    * - Fixme: ⚠️️ Maybe only add keyboard shortcut for debug mode for UITesting etc? 👈
    * - Fixme: ⚠️️ Add a condition clasue inside keyboardShortcut, as an extension etc 👈
    * - Fixme: ⚠️️ Rename to menuItemView 👈
    * - Parameters:
    *   - menuItem: The `MenuItem` to be displayed as a button.
    *   - index: The index of the `menuItem` in the collection.
    * - Returns: A view representing the button for the specified `menuItem`.
    */
   @ViewBuilder
   public func item(menuItem: MenuItem, index: Int, showMenu: Binding<Bool>? = nil) -> some View {
      let btn = Button { // Menu Button with icon and name etc
         // Sets the showMenu binding to false, indicating the menu should be hidden
         showMenu?.wrappedValue = false
         // Executes the action associated with the current menuItem
         menuItem.action()
      } label: {
         HStack {
            Image(systemName: menuItem.iconName) // left icon
            Text(menuItem.title) // left aligned text
            #if os(macOS)
            Spacer() // left align (needed for macOS)
            #endif
         }
      }
         // .accessibilityElement(children: .contain)
         // .accessibilityLabel(menuItem.title)
         .accessibilityIdentifier(menuItem.title)
      if let keyBoardShortcut: String = menuItem.keyboardShortCut {
         btn.keyboardShortcut( // Applies a keyboard shortcut to the button
            .init(Character(keyBoardShortcut)), // Initialize the keyboard shortcut with the first character of the keyBoardShortcut string
            modifiers: [] // No modifiers are used
         )
      } else {
         btn
      }
      #if os(macOS)
      if index < self.count - 1 { // Avoids adding divider to the last item
         Divider()
      }
      #endif
   }
}
