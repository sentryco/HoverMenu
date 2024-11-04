[![Tests](https://github.com/sentryco/HoverMenu/actions/workflows/Tests.yml/badge.svg)](https://github.com/sentryco/HoverMenu/actions/workflows/Tests.yml)
[![codebeat badge](https://codebeat.co/badges/ea7a5444-469e-4e95-91f2-9cb372fa5db3)](https://codebeat.co/projects/github-com-sentryco-hovermenu-main)

# HoverMenu

HoverMenu is a Swift package that provides a classic hover menu implementation for both iOS and macOS platforms. It offers a unified API to create context menus that adapt to the specific UI patterns of each operating system. 

> [!NOTE]
> For iOS, the menu is horizontally arranged (the classic look from UIKit that currently is not available in SwiftUI), and for macOS, the menu is vertically arranged.

## Features

- **Platform Support**: Fully supports both iOS and macOS, ensuring a consistent experience across devices.
- **Customizable Menus**: Offers extensive customization options for menu items including actions, icons, and optional keyboard shortcuts.
- **SwiftUI Integration**: Seamlessly integrates with SwiftUI, allowing for modern, declarative UI code.

### Usage Example

To use HoverMenu in your SwiftUI application, you can follow this simple example:

```swift
import SwiftUI
import HoverMenu

struct ContentView: View {
    var body: some View {
        Text("Right-click or hover to see the menu")
            .hoverMenu {
                Button("Refresh", action: refreshAction)
                Button("Settings", action: settingsAction)
                Divider()
                Button("Quit", action: quitAction)
            }
    }

    func refreshAction() {
        print("Refreshed")
    }

    func settingsAction() {
        print("Settings opened")
    }

    func quitAction() {
        print("Application quitting")
    }
}
```

## Installation

- Add HoverMenu to your project using Swift Package Manager. In Xcode, go to File > Swift Packages > Add Package Dependency and enter the repository URL: https://github.com/sentryco/HoverMenu.git

- For package.swift file add the following dependency:

```swift
dependencies: [
    .package(url: "https://github.com/sentryco/HoverMenu", branch: "main")
]
```

### Todo: 

- Add preview for macOS  
- Rename repo to PopupMenu or PopoverMenu ?
- Refactoring and Code Cleanup
- Testing and Documentation (Improving tests and documentation can help maintain high code quality and ease future development efforts.)
- Code Organization and Structure: Separation of Concerns: Some files contain multiple responsibilities, which could be separated into more focused components or extensions. For example, the PopupMenu.swift file handles UI interactions and also manages state and UI updates, which could be more cleanly separated.
- Refactoring and Code Cleanup: PopupMenu and EditMenu Classes: There are multiple Fixme comments indicating areas that need attention, such as refactoring and cleaning up the code. For instance, in PopupMenu.swift and EditMenu+Coordinator.swift, there are suggestions to investigate and possibly refactor the way menus are presented and how gestures are handled.
- Remove unit-tests, add uitests
- UI/UX Enhancements: User Interface Polish: Enhancing the user interface, such as adding icons to menu items or improving the layout and responsiveness of UI components.
