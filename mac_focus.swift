#!/usr/bin/env swift
//
// mac-focus - macOS focused element inspector
//
// This script returns information about the currently focused UI element
// in JSON format using macOS Accessibility APIs.
//
// Compilation:
//   swiftc -o mac-focus mac_focus.swift -framework ApplicationServices -framework Cocoa
//
// Usage:
//   ./mac-focus
//   sleep 3 && ./mac-focus
//
// Output: JSON object with element information (appName, bundleId, role, position, size, etc.)
//

import Cocoa
import ApplicationServices

func getAttribute(_ element: AXUIElement, _ attribute: String) -> CFTypeRef? {
    var value: CFTypeRef?
    let result = AXUIElementCopyAttributeValue(element, attribute as CFString, &value)
    return result == .success ? value : nil
}

func getString(_ element: AXUIElement, _ attribute: String) -> String? {
    return getAttribute(element, attribute) as? String
}

func getCGPoint(_ element: AXUIElement) -> CGPoint? {
    guard let ref = getAttribute(element, kAXPositionAttribute),
          CFGetTypeID(ref) == AXValueGetTypeID() else { return nil }
    
    let axValue = ref as! AXValue
    guard AXValueGetType(axValue) == .cgPoint else { return nil }
    
    var point = CGPoint.zero
    AXValueGetValue(axValue, .cgPoint, &point)
    return point
}

func getCGSize(_ element: AXUIElement) -> CGSize? {
    guard let ref = getAttribute(element, kAXSizeAttribute),
          CFGetTypeID(ref) == AXValueGetTypeID() else { return nil }
    
    let axValue = ref as! AXValue
    guard AXValueGetType(axValue) == .cgSize else { return nil }
    
    var size = CGSize.zero
    AXValueGetValue(axValue, .cgSize, &size)
    return size
}

guard let app = NSWorkspace.shared.frontmostApplication else {
    print("{\"error\":\"no_frontmost_app\"}")
    exit(1)
}

let appRef = AXUIElementCreateApplication(app.processIdentifier)

var focusedRef: CFTypeRef?
let result = AXUIElementCopyAttributeValue(
    appRef,
    kAXFocusedUIElementAttribute as CFString,
    &focusedRef
)

guard result == .success,
      let focused = focusedRef else {
    print("{\"error\":\"no_focused_element\"}")
    exit(1)
}

let element = focused as! AXUIElement

var json: [String: Any] = [:]

json["appName"] = app.localizedName ?? ""
json["bundleId"] = app.bundleIdentifier ?? ""
json["pid"] = app.processIdentifier
json["role"] = getString(element, kAXRoleAttribute) ?? ""
json["subrole"] = getString(element, kAXSubroleAttribute) ?? ""
json["title"] = getString(element, kAXTitleAttribute) ?? ""
json["description"] = getString(element, kAXDescriptionAttribute) ?? ""
json["value"] = getAttribute(element, kAXValueAttribute) ?? ""

if let position = getCGPoint(element) {
    json["position"] = [
        "x": position.x,
        "y": position.y
    ]
}

if let size = getCGSize(element) {
    json["size"] = [
        "width": size.width,
        "height": size.height
    ]
}

// Serializa JSON
if let jsonData = try? JSONSerialization.data(withJSONObject: json, options: [.prettyPrinted]),
   let jsonString = String(data: jsonData, encoding: .utf8) {
    print(jsonString)
} else {
    print("{\"error\":\"json_serialization_failed\"}")
}
