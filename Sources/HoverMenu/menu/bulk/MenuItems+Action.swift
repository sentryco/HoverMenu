#if os(iOS)
import SwiftUI
import UIKit
/**
 * Getter - UIAction
 * - Fixme: ⚠️️ Move to +MenuAction
 */
extension MenuItems {
   /**
    * Converts each `MenuItem` in the collection to a `UIAction` for use in iOS.
    * - Description: This property converts each `MenuItem` in the collection
    *                to a `UIAction` for use in iOS. It maps the title and action
    *                of each `MenuItem` to a corresponding `UIAction`.
    * - Note: This property is only available on iOS platforms
    * - Returns: An array of `UIAction` instances, each corresponding to a `MenuItem` in the collection.
    */
   public var menuActions: [UIAction] {
      // Maps each MenuItem to a UIAction, using the title and action of the MenuItem
      self.map { (menuDataItem: MenuItem) in
         .init( // Initializes a UIAction with the title of the MenuItem and a handler that calls the action of the MenuItem
            title: menuDataItem.title
         ) { // This line closes the initialization of UIAction with the title provided by the MenuItem. _ in // This closure is triggered when the UIAction is selected, executing the associated MenuItem's action.
               menuDataItem.action()
         }
      }
   }
}
#endif
