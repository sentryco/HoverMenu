#if os(iOS)
import SwiftUI
/**
 * Preview (DarkMode)
 */
#Preview {
   Text("Hello, World!")
      // .frame(width: 100, height: 80)
      .editMenu({
         [
            UIAction(
               title: "Action 1",
               image: nil)               { _ in
                  print("Action 1 selected")
               },
            UIAction(
               title: "Action 2",
               image: nil)               { _ in
                  print("Action 2 selected")
               },
            UIAction(title: "Copy to clipboard") { _ in
               Swift.print("Copy to clipboard")
            }
         ]
      }, onPresent: {
         print("Menu presented")
      }, onDismiss: {
         print("Menu dismissed")
      })
      .padding()
      .frame(maxWidth: .infinity, maxHeight: .infinity)
      .background(Color.black)
      .environment(\.colorScheme, .dark)
      // .previewLayout(.sizeThatFits)
}
#endif
