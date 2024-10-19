#if os(iOS)
import SwiftUI
import UIKit
/**
 * EditMenu - UIViewRepresentable
 * - Description: This struct represents a `SwiftUI` view that can be used to
 *                display an edit-menu with customizable actions and callbacks
 *                for presentation and dismissal. It conforms to the
 *                `UIViewRepresentable` protocol to integrate with UIKit views.
 * - Note: This doesn't need to be public
 * - Fixme: ⚠️️ Add some sort of accessibility-id?
 */
internal struct EditMenu<Content: View>: UIViewRepresentable {
   /**
    * Content -  How the button should look like
    * - Description: This is the visual representation of the button that
    *                triggers the edit menu. It can be customized to fit the
    *                design requirements of the application.
    */
   internal let content: Content
   /**
    * Actions - Has the title, icon and callbacks for the menu
    * - Description: This is a closure that returns an array of UIAction
    *                objects. Each UIAction represents an action that can be
    *                performed from the edit menu. The UIAction includes a
    *                title, an optional image, and a handler that is called
    *                when the action is selected.
    */
   internal let actions: () -> [UIAction]
   /**
    * onPresent - Callback for swiftui
    * - Description: This callback is triggered when the edit menu is
    *                presented, allowing for additional actions or state
    *                updates in response to the menu's presentation.
    */
   internal let onPresent: EditMenuCallBack?
   /**
    * onDismiss - Callback for swiftui
    * - Description: This callback is triggered when the edit menu is
    *                dismissed, allowing for additional actions or state
    *                updates in response to the menu's dismissal.
    */
   internal let onDismiss: EditMenuCallBack?
   /**
    * UIViewType - The type of the UIView
    * - Description: Defines the type of UIView that will be used to
    *                represent the SwiftUI view in the UIKit environment.
    */
   internal typealias UIViewType = UIView
   /**
    * Creates and configures the UIView for the EditMenu.
    * - Description: This function is responsible for creating the UIView that
    *                will be used to present the edit menu. It sets up the
    *                necessary interactions and gesture recognizers to handle
    *                user input and display the menu accordingly.
    * - Parameters:
    *   - context: The context containing the coordinator and other necessary information for creating the UIView.
    * - Returns: The configured UIView for the EditMenu.
    */
   internal func makeUIView(context: Context) -> UIView {
      // Check if the interaction exists in the coordinator
      if let interaction = context.coordinator.interaction {
         // Adds the interaction to the UIView for handling user interactions.
         context.coordinator.uiView.addInteraction(interaction)
      }
      // Add touched gesture
      let recognizer: UILongPressGestureRecognizer = .init( // Initializes a UILongPressGestureRecognizer
         target: context.coordinator, // Sets the target object for the gesture recognizer
         action: #selector(Coordinator.touched) // Sets the action to be performed when the gesture is recognized
      )
      recognizer.minimumPressDuration = 0.0 // Sets the minimum press duration for the gesture recognizer to 0.0
      recognizer.delegate = context.coordinator /*as? UIGestureRecognizerDelegate*/ // Set the delegate to self
      context.coordinator.uiView.addGestureRecognizer(recognizer) // Adds the gesture recognizer to the UIView
      // Add pan gesture recognizer
      let panRecognizer: UIPanGestureRecognizer = .init(
         target: context.coordinator,
         action: #selector(Coordinator.panDetected)
      )
      panRecognizer.delegate = context.coordinator /*as? UIGestureRecognizerDelegate*/
      // panRecognizer.shouldBeRequiredToFail(by: recognizer)
      context.coordinator.uiView.addGestureRecognizer(panRecognizer)
      // - Fixme: ⚠️️ Not sure if needed
      context.coordinator.uiView.isUserInteractionEnabled = true // Enables user interaction for the UIView
      // Return the UIView
      return context.coordinator.uiView
   }
   /**
    * Updates the UIView with the latest state from the context
    * - Description: This method is called whenever the SwiftUI state has 
    *                changes that need to be reflected in the UIKit 
    *                representation of the view. It ensures that the UIView 
    *                remains in sync with SwiftUI's state and lifecycle events
    * - Parameters:
    *   - uiView: The UIView to be updated
    *   - context: The context containing the latest state
    */
   internal func updateUIView(_ uiView: UIView, context: Context) {
      // not needed for this
      // Swift.print("updateUIView - uiView.bounds:  \(uiView.bounds)")
   }
   /**
    * Creates and returns a Coordinator instance for managing the EditMenu's internal state.
    * - Description: The `makeCoordinator` method creates a Coordinator
    *                object that serves as the communication hub between
    *                the SwiftUI view and the UIKit-based edit menu
    *                interaction. The Coordinator is responsible for
    *                managing the lifecycle of the UIEditMenuInteraction,
    *                handling user gestures, and presenting the edit menu.
    */
   internal func makeCoordinator() -> Coordinator {
      let coordinator = Coordinator(self) // Initializes a Coordinator with the current instance of EditMenu
      coordinator.interaction = UIEditMenuInteraction(delegate: coordinator) // Initializes a UIEditMenuInteraction with the coordinator as the delegate and assigns it to the coordinator's interaction property
      // Returns the configured Coordinator instance
      return coordinator
   }
}
#endif
