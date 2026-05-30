// swift-tools-version: 6.2
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
  name: "Features",
  platforms: [.iOS(.v26), .macOS(.v13)],
  products: [
    // Products define the executables and libraries a package produces, making them visible to other packages.
    .library(name: "Features", targets: ["Features"]),
    .library(name: "Models", targets: ["Models"]),
    .library(name: "Services", targets: ["Services"]),
  ],
  dependencies: [
    .package(
      url: "https://github.com/pointfreeco/swift-composable-architecture.git", exact: "1.25.5"),
    .package(url: "https://github.com/pointfreeco/swift-dependencies", from: "1.12.0"),
    .package(url: "https://github.com/AdguardTeam/SafariConverterLib", exact: "4.2.2"),
  ],
  targets: [
    // Targets are the basic building blocks of a package, defining a module or a test suite.
    // Targets can depend on other targets in this package and products from dependencies.
    .target(
      name: "Features",
      dependencies: [.models, .tca, .services]
    ),
    .testTarget(
      name: "FeaturesTests",
      dependencies: ["Features", .tca]
    ),
    .target(
      name: "Services",
      dependencies: [.dependencies, .safariConverterLib]
    ),
    .target(name: "Models"),
  ]
)
// First-party
extension Target.Dependency {
  static let models: Self = "Models"
  static let services: Self = "Services"
}

// Third-Party
extension Target.Dependency {
  static let tca = Self.product(
    name: "ComposableArchitecture", package: "swift-composable-architecture")
  static let dependencies = Self.product(name: "Dependencies", package: "swift-dependencies")
  static let safariConverterLib = Self.product(
    name: "ContentBlockerConverter", package: "SafariConverterLib")

}
