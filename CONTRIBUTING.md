# Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/JamitLabs/SwiftPackageManager. This project is intended to be a safe, welcoming space for collaboration, and contributors are expected to adhere to the [Contributor Covenant](http://contributor-covenant.org) code of conduct.

## Getting Started

This section will tell you how you can get started contributing to SwiftPackageManager.

### Prerequisites

Before you start developing, please make sure you have the following tools installed on your machine:

- Xcode 9.4+
- [SwiftLint](https://github.com/realm/SwiftLint)

### Useful Commands

In order to generate the **Xcode project** to develop within, run this command:

```
swift package generate-xcodeproj
```

To check if all **tests** are passing correctly:

```
swift test
```

To check if the **linter** shows any warnings or errors:

```
swiftlint
```

Alternatively you can also add `swiftlint` as a build script to the target `SwiftPackageManagerKit` so warnings & errors show off right within Xcode when building. (Recommended)

### Development Tips

#### Debugging with Xcode
To run the SwiftPackageManager tool right from within Xcode for testing, remove the line

```swift
cli.goAndExit()
```

from the file at path `Sources/SwiftPackageManager/main.swift` and replace it with something like:

```swift
cli.debugGo(with: "spm install -v")
```

Now, when you choose the `SwiftPackageManager` scheme in Xcode and run the tool, you will see the command line output right within the Xcode console and can debug using breakpoints like you normally would.

Beware though that the tool will run within the product build directory, which might look something like this:

```
/Users/YOU/Library/Developer/Xcode/DerivedData/SwiftPackageManager-aayvtbwcxecganalwqrvbfznkjke/Build/Products/Debug
```

You can print the exact directory of your Xcode by running:

```swift
FileManager.default.currentDirectoryPath
```

To test a specific SwiftPackageManager configuration just create an example project with dependencies to check.

#### Debugging failing Tests

For some reason when running the tests of the `SwiftPackageManager-Package` scheme Xcode seems to always fail without running any tests. So the tests need to be run from the command line using `swift test`. To debug this way it might be useful to put `print` statements within the code area that is of your interest.

If the tests fail with a crash, you might want to locate the crashing code by placing many of the following line to the crashing rule to find the file and line that was last correctly executed:

```swift
print("Reached line \(#line) in file \(#file).")
```

### Commit Messages

Please also try to follow the same syntax and semantic in your **commit messages** (see rationale [here](http://chris.beams.io/posts/git-commit/)).
