// swift-tools-version:5.2

import PackageDescription

let package = Package(
    name: "GenericID",
    products: [
        .library(
            name: "GenericID",
            targets: ["GenericID"]),
    ],
    dependencies: [
        .package(url: "https://github.com/MxIris-LyricsX-Project/CXShim", .branchItem("master"))
    ],
    targets: [
        .target(name: "GenericID", dependencies: ["CXShim"]),
        .testTarget(name: "GenericIDTests", dependencies: ["GenericID"]),
    ]
)

enum CombineImplementation {
    
    case combine
    case combineX
    case openCombine
    
    static var `default`: CombineImplementation {
        return .combineX
    }
    
    init?(_ description: String) {
        let desc = description.lowercased().filter { $0.isLetter }
        switch desc {
        case "combine":     self = .combine
        case "combinex":    self = .combineX
        case "opencombine": self = .openCombine
        default:            return nil
        }
    }
}

extension ProcessInfo {

    var combineImplementation: CombineImplementation {
        return environment["CX_COMBINE_IMPLEMENTATION"].flatMap(CombineImplementation.init) ?? .default
    }
}

import Foundation

let combineImpl = ProcessInfo.processInfo.combineImplementation

if combineImpl == .combine {
    package.platforms = [.macOS(.v10_15), .iOS(.v13), .tvOS(.v13), .watchOS(.v6)]
}
