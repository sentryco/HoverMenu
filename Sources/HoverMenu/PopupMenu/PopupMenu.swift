import SwiftUI
#if os(macOS)
import AppKit
/**
 * - Note: If you need to use `NSMenu` from `AppKit` in a SwiftUI application, you can do so by using the `NSViewRepresentable` protocol to create a SwiftUI view that wraps an `NSView` that uses `NSMenu`
 * - Description: This structure provides a SwiftUI view that wraps an `NSView`
 *                capable of displaying an `NSMenu`. It is designed to be used
 *                within a SwiftUI application where native AppKit components are
 *                required. The `PopupMenu` struct conforms to the
 *                `NSViewRepresentable` protocol, allowing SwiftUI to interface
 *                with AppKit's menu system.
 * - Note: Great breakdown of #selector in swiftui: https://www.waldo.com/blog/swift-selector
 * - Note: `PopupMenuWrapper` uses this
 * - Fixme: ⚠️️ try to align the popup locaion better, more like it is in legacy etc 👈
 */
public struct PopupMenu: NSViewRepresentable {
   /**
    * A binding to a boolean that controls the visibility of the popup menu.
    * - Description: This binding controls the visibility of the popup menu.
    *                When set to true, the popup menu is displayed. When set to
    *                false, the popup menu is hidden.
    */
   @Binding public var showMenu: Bool
   /**
    * The items to be displayed in the popup menu.
    * - Description: A collection of menu item representations that define
    *                the actions available in the popup menu.
    */
   public var menuItems: PopupMenuItems
   /**
    * - Description: This optional parameter specifies the position where the
    *                popup menu will be displayed. If not provided, the menu
    *                will be displayed at the current mouse position.
    * - Note: We have to use GeomReader to get this working by maybe passing
    *         the frame and mid point etc, or else just use .zero
    * - Note: If nil we use mousePoint
    */
   public var menuPosition: NSPoint? = .zero
   /**
    * Make view - we have to have a "view" to prompt the menu from
    * - Description: This function creates an NSView that represents the
    *                popup menu. The view is initially hidden to prevent
    *                unnecessary clicks.
    * - Parameter context: The context in which the NSView is being created.
    * - Returns: The NSView that represents the popup menu.
    */
   public func makeNSView(context: Context) -> NSView {
      let view = NSView()
      view.isHidden = true // If this is not hidden, we have to press twice etc
      return view
   }
   /**
    * Updates the NSView when the @State or @Binding properties change.
    * - Description: This method is called whenever the SwiftUI state or binding
    *                variables change. It checks the value of `showMenu` and, if
    *                true, creates and displays the popup menu at the specified
    *                position. After displaying the menu, it resets `showMenu` to
    *                false to hide the menu.
    * - Note: We can also use instead of popup:
    *         `NSMenu.popUpContextMenu(menu, with: NSApp.currentEvent ?? NSEvent(),
    *         for: nsView)`
    * - Parameters:
    *   - nsView: The NSView that the popup menu is being displayed in.
    *   - context: The context in which the NSView is being updated.
    */
   public func updateNSView(_ nsView: NSView, context: Context) {
      if showMenu {
         let menu = makeMenu(context: context)
         menu.popUp(
            positioning: menu.item(at: 0), // The item to position the menu relative to
            // - Fixme: ⚠️️⚠️️ try nsView.frame.center 👈
            at: menuPosition ?? nsView.mousePoint /*NSPoint.zero*/, /*  */ // The point to display the menu at
            in: nsView // The view to display the menu in
         ) // Display the menu with the popUp function
         DispatchQueue.main.async { // In this code, DispatchQueue.main.async is used to schedule the update of showMenu on the main queue. This ensures that the update is performed after the current method has finished executing, which should allow the menu to be shown before showMenu is set to false.
            // Toggle off
            self.showMenu = false // The showMenu boolean should be set to false after the menu is shown. However, due to the asynchronous nature of SwiftUI's state updates, the change might not take effect immediately. To ensure that showMenu is set to false after the menu is shown, you can dispatch the update to the main queue:
         }
      }
   }
   /**
    * Creates a coordinator instance to manage the menu interactions.
    * - Description: The coordinator acts as a bridge between the NSMenu item
    *                selection and the SwiftUI view. It contains a callback closure
    *                that is invoked when a menu item is selected, passing the
    *                title of the selected item to the provided closure.
    * - Returns: The coordinator instance.
    */
   public func makeCoordinator() -> Coordinator {
      let coordinator = Coordinator() // - Fixme: ⚠️️ we could posibly pass callback in init, for what?
      // Sets the callback function for the coordinator to handle menu item selection
      coordinator.callback = { title in
         // Finds the first menu item that matches the selected title
         let menuItem = menuItems.first { $0.title == title }
         // Executes the callback function of the found menu item, if it exists
         menuItem?.callback?()
      }
      // Returns the coordinator instance with the callback function set
      return coordinator
   }
   /**
    * Needed for selector calls
    * - Description: The Coordinator class acts as a bridge between the NSMenu
    *                item selection and the SwiftUI view. It contains a callback
    *                closure that is invoked when a menu item is selected,
    *                passing the title of the selected item to the provided
    *                closure.
    * - Fixme: ⚠️️ we could also pass the sender to the callback, to compare obj for more accuracy etc
    */
   public class Coordinator: NSObject {
      /**
       * The callback function type alias for handling menu item selection.
       * - Description: This is a type alias for a callback function that is
       *                triggered when a menu item is selected. The function
       *                takes a string parameter which is the title of the
       *                selected menu item.
       * - Parameters:
       *   - title: The title of the selected menu item.
       */
      public typealias CallBack = (_ title: String) -> Void
      /**
       * A callback function that is called when a menu item is clicked.
       * - Description: This is a callback function that gets triggered when
       *                a menu item is selected. It takes the title of the
       *                selected menu item as a parameter.
       */
      public var callback: CallBack?
      /**
       * - Abstract: Handles the menu item click event by calling the
       *             callback function with the title of the clicked menu item.
       * - Description: This method is triggered when a menu item is clicked.
       *                It retrieves the title of the clicked menu item and passes
       *                it to the callback function, if the callback is set.
       * - Parameters:
       *   - sender: The NSMenuItem that was clicked.
       */
      @objc public func menuItemClicked(_ sender: NSMenuItem) {
         callback?(sender.title)
      }
   }
}
/**
 * Menu maker
 */
extension PopupMenu {
   /**
    * We remake this on each menu popup, we might change title etc or disable or add / remove etc
    * - Description: This function creates a new NSMenu instance and populates
    *                it with NSMenuItems. Each NSMenuItem is created using the
    *                title and callback function from the corresponding MenuItem
    *                in the menuItems array. The action for each NSMenuItem is
    *                set to call the menuItemClicked function in the coordinator
    *                when the menu item is clicked.
    * - Parameter context: The context in which the NSView is being created.
    * - Returns: The NSView that represents the popup menu.
    */
   public func makeMenu(context: Context) -> NSMenu {
      let menu = NSMenu() // Initializes a new NSMenu instance
      // Iterates over each item in the menuItems array
      menuItems.forEach {
         let menuitem = NSMenuItem( // Initializes a new NSMenuItem instance
            title: $0.title, // Sets the title of the menu item to the title of the current item in the menuItems array
            action: #selector(context.coordinator.menuItemClicked(_:)), // Sets the action to be performed when the menu item is clicked
            keyEquivalent: "" // Sets the key equivalent for the menu item, currently set to an empty string
         )
         // Sets the target of the menu item to the coordinator instance
         menuitem.target = context.coordinator
         // Adds the menu item to the menu
         menu.addItem(menuitem)
         // - Fixme: ⚠️️ remember to add accessibility id here, see legacy etc or?
      }
      return menu
   }
}
/**
 * - Fixme: ⚠️️ move this to NSView+Ext see legacy etc
 */
extension NSView {
   /**
    * Mouse point
    * - Description: This computed property returns the current mouse location
    *                relative to the view's coordinate system. It first converts
    *                the mouse location from screen coordinates to window
    *                coordinates, and then from window coordinates to the view's
    *                coordinate system.
    * - Note: `window.mouseLocationOutsideOfEventStream` can also work as "relativeToWin" point
    */
   fileprivate var mousePoint: CGPoint {
      let relativeToWin = self.window?.convertPoint( // Converts the mouse location from screen coordinates to window coordinates
         fromScreen: NSEvent.mouseLocation // Get the mouse location from the screen
      ) ?? .zero // Get the mouse location relative to the window, or zero if the window is nil
      return self.convert(relativeToWin, from: nil) // Convert the relative mouse location to the view's coordinate system
   }
}
#endif
