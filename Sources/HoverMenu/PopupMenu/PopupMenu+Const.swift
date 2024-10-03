import Foundation
/**
 * A structure that represents a single item in a popup menu
 * - Parameters:
 *   - title: The title of the menu item
 *   - callback: The callback function to be executed when the menu item is clicked
 */
public struct PopupMenuItem { let title: String, callback: (() -> Void)? }
/**
 * A type alias for an array of popup menu items.
 */
public typealias PopupMenuItems = [PopupMenuItem]
