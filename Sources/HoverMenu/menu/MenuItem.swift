import SwiftUI
#if os(iOS)
import UIKit
#endif
/**
 * Model for Menu (for MoreMenu, HeaderMenu, AddTypeMenu etc)
 * - Abstract: Represents a single item in a menu, including its title, action, icon name, and optional keyboard shortcut.
 * - Description: A `MenuItem` represents an actionable item in a menu with an associated icon and optional keyboard shortcut. It encapsulates the title of the item, the action to be executed when the item is selected, the system name of the icon to be displayed alongside the title, and an optional keyboard shortcut for quick access.
 * - Note: Used by `MenuIconButton`, `MenuIconContainer`, `PopupMenuWrapper` and `AddFieldButton`
 * - Fixme: ⚠️️ Action should be optional, yes probably, fix it later
 * - Fixme: ⚠️️ Add a preview? 👈 use copilot?
 * - Fixme: ⚠️️ Rename to MenuItemModel?
 */
public struct MenuItem {
   public let title: String
   public let action: () -> Void
   public let iconName: String
   public let keyboardShortCut: String?
   /**
    * Initializes a `MenuItem` with the given properties.
    * - Description: This initializer creates a new `MenuItem` instance with the specified title, action to be executed upon selection, icon representation, and an optional keyboard shortcut for quick access.
    * - Fixme: ⚠️️ make Callback action optional?
    * - Parameters:
    *   - title: The title of the menu item.
    *   - action: The callback action to perform when the menu item is selected.
    *   - iconName: The name of the icon to display for the menu item.
    *   - keyboardShortCut: An optional keyboard shortcut associated with the menu item.
    */
   public init(title: String, action: @escaping () -> Void, iconName: String, keyboardShortCut: String? = nil) {
      self.title = title
      self.action = action
      self.iconName = iconName
      self.keyboardShortCut = keyboardShortCut
   }
}
