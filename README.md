[![Tests](https://github.com/sentryco/HoverMenu/actions/workflows/Tests.yml/badge.svg)](https://github.com/sentryco/HoverMenu/actions/workflows/Tests.yml)

# HoverMenu

HoverMenu is a Swift package that provides a classic hover menu implementation for both iOS and macOS platforms. It offers a unified API to create context menus that adapt to the specific UI patterns of each operating system. 

> :memo: **Note:** For iOS, the menu is horizontally arranged (the classic look from UIKit that currently is not available in SwiftUI), and for macOS, the menu is vertically arranged.

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
- Clean up the code 
