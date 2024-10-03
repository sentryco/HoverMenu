#if os(iOS)
import SwiftUI
import UIKit
/**
 * This mimicks how Menu work in swift-ui. But has the look and feel of the old "edit-menu-context-button" of UIKit
 * - Abstract: Adds ability to add edit-context-menu to swiftui views
 * - Description: This extension provides SwiftUI views with the ability to present a context menu similar to UIKit's edit menu. It allows for the addition of custom actions and handles the presentation and dismissal of the menu, integrating UIKit's edit menu functionality within SwiftUI.
 * - Important: ⚠️️ Only for iOS
 * - Note: Used in: `IconRowView`, `ReadRowView`, `OTPRowView`, `PassRowView`, `HistoryDetailView`
 * - Note: Also works on button, but then button action is supressed if added directly. There might be a work aroun don thihs like adding a text to a button, and attaching the editmenu to the text, or adding a bindinf to the editmenu, or other workarounds
 * - Note: Ref: https://developer.apple.com/documentation/uikit/uieditmenuinteractiondelegate
 * - Note: Ref: https://stackoverflow.com/questions/73712955/using-uieditmenuinteraction-with-uitextview
 * - Note: Ref: menu-builder in ios16: https://stackoverflow.com/questions/73763156/customize-menu-using-uieditmenuinteraction-in-wkwebview-ios-16
 * - Note: Ref: edit menu for iOS: https://toyboy2.medium.com/how-to-make-custom-menu-for-your-ios-app-2b22ba2cea8f and https://github.com/ios-swift-examples/iOSUIMenuExample/blob/main/iOSUIMenuExample/ViewController.swift
 * - Note: Ref: https://developer.apple.com/documentation/swiftui/view/contextmenu(forselectiontype:menu:primaryaction:)?changes=_5
 * - Note: Alternative name: `popoverMenu`
 * - Fixme: ⚠️️ If the button is tapped a second time while menu is showing, the expected behaviour might be to not show the menu, not a big deal, look in to it later
 * - Example: To add an edit menu to a Text view with custom actions, use the following code:
 * ```
 * Text("Example Text")
 *   .editMenu {
 *     return [
 *       UIAction(title: "Action 1", handler: { _ in print("Action 1 selected") }),
 *       UIAction(title: "Action 2", handler: { _ in print("Action 2 selected") }),
 *       UIAction(title: "Action 3", handler: { _ in print("Action 3 selected") })
 *     ]
 *   }
 * ```
 */
extension View {
   /**
    * EditMenu - The old school horizontal popover menu with a directional arrow etc
    * - Description: Attaches an edit menu to the view with specified actions and callbacks for presentation and dismissal
    * - Parameters:
    *   - actions: The actions to be displayed in the edit menu
    *   - onPresent: Callback when the edit menu is presented
    *   - onDismiss: Callback when the edit menu is dismissed
    * - Returns: The view with the attached edit menu
    */
   public func editMenu( _ actions: @escaping ActionsAlias, onPresent: EditMenuCallBack? = nil, onDismiss: EditMenuCallBack? = nil) -> some View {
      self.overlay { // This line adds an overlay to the current view, which allows the edit menu to be displayed on top of the view's content.
         // - Fixme: ⚠️️ An idea could be to insert the frame with geomproxy
         // - Fixme: ⚠️️ We have some convenince extensions that might be useful to achive that
         EditMenu( // Creates an instance of EditMenu which provides a context menu overlay.
            content: self, // The content view to which the edit menu is attached
            actions: actions, // The actions to be displayed in the edit menu
            onPresent: onPresent, // Callback when the edit menu is presented
            onDismiss: onDismiss // Callback when the edit menu is dismissed
         )
         .frame( // Fills the overlay to the max of the view its attached to
            maxWidth: .infinity, // Sets the maximum width of the frame to infinity
            maxHeight: .infinity // Sets the maximum height of the frame to infinity
         )
         // .background(.yellow)
      }
   }
}
/**
 * Const
 * - Fixme: ⚠️️ Move to own file
 */
extension View {
   /**
    * Alias for a function that returns an array of UIActions.
    */
   public typealias ActionsAlias = () -> [UIAction]
   /**
    * Alias for a function that returns nothing.
    */
   public typealias EditMenuCallBack = () -> Void
}
#endif
