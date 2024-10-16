#if os(iOS)
import SwiftUI
import UIKit
/**
 * Coordinator
 */
extension EditMenu {
   /**
    * swiftui - bridge
    * - Description: This class serves as a bridge between SwiftUI and UIKit, 
    *                enabling the use of UIKit's UIEditMenuInteraction within a SwiftUI view. 
    *                It handles the lifecycle of the UIEditMenuInteraction, responds to user gestures, 
    *                and manages the presentation of the edit menu.
    * - Note: UIGestureRecognizerDelegate is needed for the gestureRecognizer method
    * - Note: we can't make extension for gesture delegate. because @objc
    * - Fixme: ⚠️️ it might be possible to also use shouldBeRequiredToFailBy istead of the cancelLongPressGesture etc. try to refactor this in the future. might be cleaner
    */
   internal class Coordinator: NSObject, UIEditMenuInteractionDelegate, UIGestureRecognizerDelegate {
      internal let editMenu: EditMenu // The EditMenu instance
      internal let uiView = UIView() // The UIView instance
      internal var interaction: UIEditMenuInteraction? // The UIEditMenuInteraction instance
      private var isPresent = false // keeps track of wheter the menu is showing or hiding
      private var cancelLongPressGesture: Bool = false
      deinit {
         // print("EditMenu.Coordinator.deinit - \(#function)") // not sure if needed ?
      }
      internal init(_ editMenu: EditMenu) {
         self.editMenu = editMenu
      }
      /**
       * Present menu on interaction
       * - Description: This method is responsible for displaying the edit menu. 
       *                It first checks if the menu is already being presented. 
       *                If not, it calculates the point to present the menu, 
       *                creates a configuration for the menu, and then presents the menu with the calculated configuration.
       * - Fixme: ⚠️️ the presentEditMenu doesnt present from the exact: midY, i have no idea why
       */
      internal func showMenu() {
         guard isPresent == false else { Swift.print("already presenting"); return } // Check if the menu is already being presented, if so, return
         // Swift.print("uiView.bounds: \(uiView.bounds)")
         // Swift.print("uiView.frame:  \(uiView.frame)")
         let pointInView = CGPoint( // Calculate the point to present the menu
            x: uiView.bounds.midX,
            y: uiView.frame.midY
         )
         // Swift.print("pointInView:  \(pointInView)")
         // let pointInWindow = uiView.convert(pointInView, to: uiView.superview) // Convert the point to the window's coordinate system
         // Swift.print("pointInWindow:  \(pointInWindow)")
         // Swift.print("uiView.bounds.midY: \(uiView.bounds.midY)")
         // Swift.print("point: \(point)")
         let configuration = UIEditMenuConfiguration( // Create a configuration for the menu
            identifier: "EditMenuInteractionIdentifier", // Set the identifier for the menu
            sourcePoint: pointInView // Set the source point for the menu
         )
         interaction?.presentEditMenu(with: configuration) // Present the menu with the calculated configuration
      }
      /**
       * Builds and returns a custom UIMenu for the edit menu interaction.
       * - Description: This method constructs a custom UIMenu for the edit menu interaction, 
       *                incorporating the actions provided by the EditMenu instance. 
       *                It ignores the suggested actions and focuses solely on the custom actions defined for the edit menu, 
       *                ensuring a tailored menu experience.
       * - Parameters:
       *   - interaction: The UIEditMenuInteraction instance managing the interaction.
       *   - configuration: The UIEditMenuConfiguration for the menu.
       *   - suggestedActions: An array of UIMenuElement representing the suggested actions.
       * - Returns: A UIMenu instance or nil if the menu cannot be created.
       */
      internal func editMenuInteraction(_ interaction: UIEditMenuInteraction, menuFor configuration: UIEditMenuConfiguration, suggestedActions: [UIMenuElement]) -> UIMenu? {
         // var actions = suggestedActions
         // Creates a UIMenu instance with the actions provided by the EditMenu instance
         let customMenu = UIMenu(
            // identifier: .init(""), - Fixme: ⚠️️ maybe set this to: InterfaceID.menu ?
            options: .displayInline, // Set the options for the UIMenu to display inline
            children: editMenu.actions()
         )
         // actions.append(customMenu)
         // return UIMenu(children: actions) // For Custom and Suggested Menu
         return UIMenu(children: customMenu.children) // For Custom Menu Only
      }
      /**
       * This method is called when the edit menu is about to be presented.
       * - Description: This method is triggered just before the edit menu is presented. 
       *                It calls the onPresent callback function provided by the EditMenu instance, 
       *                allowing any custom actions to be performed at this point. 
       *                It also sets the isPresent flag to true, indicating that the menu is currently being presented.
       * - Parameters:
       *   - interaction: The UIEditMenuInteraction instance managing the interaction.
       *   - configuration: The UIEditMenuConfiguration for the menu.
       *   - animator: The UIEditMenuInteractionAnimating instance that manages the animation of the menu presentation.
       */
      internal func editMenuInteraction(_ interaction: UIEditMenuInteraction, willPresentMenuFor configuration: UIEditMenuConfiguration, animator: UIEditMenuInteractionAnimating) {
         editMenu.onPresent?() // callback for swiftui
         isPresent = true // Sets the isPresent flag to true
      }
      /**
       * This method is called when the edit menu is about to be dismissed.
       * - Description: This method is triggered just before the edit menu is dismissed. 
       *                It calls the onDismiss callback function provided by the EditMenu instance, 
       *                allowing any custom actions to be performed at this point. 
       *                It also sets the isPresent flag to false, indicating that the menu is no longer being presented.
       * - Parameters:
       *   - interaction: The UIEditMenuInteraction instance managing the interaction.
       *   - configuration: The UIEditMenuConfiguration for the menu.
       *   - animator: The UIEditMenuInteractionAnimating instance that manages the animation of the menu dismissal.
       */
      internal func editMenuInteraction(_ interaction: UIEditMenuInteraction, willDismissMenuFor configuration: UIEditMenuConfiguration, animator: UIEditMenuInteractionAnimating) {
         editMenu.onDismiss?() // callback for swiftui
         isPresent = false // Sets the isPresent flag to false
      }
      /**
       * Handles the touch event.
       * - Description: This method is triggered when a touch event is detected on the UIView. 
       *                It checks the state of the gesture recognizer to determine if the touch event has ended. 
       *                If it has, it calls the showMenu() method to present the edit menu.
       * - Parameter sender: The `UILongPressGestureRecognizer` that triggered the action.
       */
      @objc internal func touched(_ sender: UILongPressGestureRecognizer) {
         // Swift.print("touched")
         if sender.state == .began { // onTapDown
            // Nothing
         } else if sender.state == .ended && cancelLongPressGesture == false {  // onTapUp
            showMenu()
         }
      }
      /**
       * Boilerplate
       * - Note: needed to fix the scrolling / tap conflict that would occure in lists
       */
      @objc internal func panDetected(_ sender: UIPanGestureRecognizer) {
         // Swift.print("panDetected")
         // Handle pan gesture
         if sender.state == .began { // onTapDown
            // Nothing
            cancelLongPressGesture = true
         } else if sender.state == .ended || sender.state == .cancelled {  // onTapUp
            cancelLongPressGesture = false
         }
      }
      /**
       * - Description: To avoid the gesture recognizer from interfering with other gestures such as scrolling, 
       *                you can make use of the gestureRecognizer(_:shouldRecognizeSimultaneouslyWith:) delegate method.
       * - Note: This method allows multiple gesture recognizers to recognize gestures simultaneously.
       * - Note: To cancel the long press gesture when a scroll begins, you can modify the gestureRecognizer(_:shouldRecognizeSimultaneouslyWith:) method to check if the other gesture recognizer is a scroll gesture (typically a UIPanGestureRecognizer used by scroll views) and return false in that case. This will prevent the long press gesture from being recognized when a scroll gesture is detected.
       * - Parameters:
       *   - gestureRecognizer: The gesture recognizer that is attempting to recognize a gesture.
       *   - otherGestureRecognizer: Another gesture recognizer that is attempting to recognize a gesture simultaneously.
       * - Returns: A Boolean value indicating whether the gesture recognizer should recognize the gesture simultaneously with the other gesture recognizer. Returns true to allow simultaneous recognition; otherwise, false.
       */
      internal func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldRecognizeSimultaneouslyWith otherGestureRecognizer: UIGestureRecognizer) -> Bool {
          true // Allow simultaneous gesture recognition
      }
   }
}
#endif
