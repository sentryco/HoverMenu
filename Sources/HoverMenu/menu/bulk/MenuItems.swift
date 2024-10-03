import SwiftUI
#if os(iOS)
import UIKit
#endif
/**
 * Multiple MenuItem's
 * - Abstract: This typealias represents a collection of `MenuItem` objects.
 * - Description: It is used to define multiple menu items in a single structure, making it easier to manage and pass around menu configurations.
 * - Note: Used by `popover-context-menu` for iOS and macOS. A hybrid menu system that works for both OSes
 * - Fixme: ⚠️️ ask copilot to find where this is used etc. then make comment about it etc
 */
public typealias MenuItems = [MenuItem]
