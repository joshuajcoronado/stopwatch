# Stopwatch Project Guidelines

## Build & Test Commands
- Build: `xcodebuild -project stopwatch.xcodeproj -scheme stopwatch build`
- Run: `xcodebuild -project stopwatch.xcodeproj -scheme stopwatch run`
- Test: `xcodebuild -project stopwatch.xcodeproj -scheme stopwatch test`
- Single Test: In Xcode, click diamond icon next to test or use Test Navigator

## Code Style
- **Imports**: SwiftUI, Foundation, Combine at top of file
- **Formatting**: 4-space indentation, Swift standard bracing style
- **Types**: Use strong typing, clear type annotations for properties
- **Naming**: camelCase for variables/functions, PascalCase for types
- **Structure**: Use MARK comments to organize sections of code
- **SwiftUI**: Use GeometryReader for responsive sizing
- **Error Handling**: Prefer optional unwrapping with if let
- **Architecture**: Follow MVVM pattern with ContentView and managers

## Documentation
- File headers with description
- Document complex functionality with comments
- README explains features, shortcuts, and technical details