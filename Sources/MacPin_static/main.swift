import Foundation
import PWAKit

#if os(macOS)
import AppKit
let app = PWAKit.MacPinApp.shared
print("initializing MacPinAppDelegateOSX()")
let appDel = PWAKit.MacPinAppDelegateOSX()
app.delegate = appDel
app.run()
#elseif os(iOS)
import UIKit
print("initializing MacPinAppDelegateIOS()")
UIApplicationMain(
    CommandLine.argc,
    CommandLine.unsafeArgv,
    NSStringFromClass(MacPinApp.self),
    NSStringFromClass(MacPinAppDelegateIOS.self)
)
#endif
