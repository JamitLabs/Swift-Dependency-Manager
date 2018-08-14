


<p align="center">
    <img src="https://raw.githubusercontent.com/JamitLabs/SwiftDependencyManager/stable/Logo.png"
      width=600>
</p>

<p align="center">
    <a href="https://app.bitrise.io/app/TODO">
        <img src="https://app.bitrise.io/app/TODO/status.svg?token=TODO&branch=stable"
             alt="Build Status">
    </a>
    <a href="https://codebeat.co/projects/github-com-jamitlabs-swiftdependencymanager-stable">
        <img src="https://codebeat.co/badges/TODO"
             alt="Codebeat Badge">
    </a>
    <a href="https://github.com/JamitLabs/SwiftDependencyManager/releases">
        <img src="https://img.shields.io/badge/Version-0.0.0-blue.svg"
             alt="Version: 0.0.0">
    </a>
    <img src="https://img.shields.io/badge/Swift-4.1-FFAC45.svg"
         alt="Swift: 4.1">
    <img src="https://img.shields.io/badge/Platforms-macOS-FF69B4.svg"
        alt="Platforms: macOS">
    <a href="https://github.com/JamitLabs/SwiftDependencyManager/blob/stable/LICENSE">
        <img src="https://img.shields.io/badge/License-MIT-lightgrey.svg"
              alt="License: MIT">
    </a>
</p>

<p align="center">
    <a href="#installation">Installation</a>
  • <a href="#usage">Usage</a>
  • <a href="#contributing">Contributing</a>
  • <a href="#license">License</a>
</p>

# Swift Dependency Manager (SDM)

A dependency manager based on Swift Package Manager (SPM) for iOS/macOS/tvOS/watchOS.


## Requirements

- Xcode 9.3+ and Swift 4.1+
- Xcode Command Line Tools (see [here](http://stackoverflow.com/a/9329325/3451975) for installation instructions)

## Installation

### Using [Mint](https://github.com/yonaskolb/Mint):

To **install** SwiftDependencyManager simply run this command:

```shell
$ mint install JamitLabs/SwiftDependencyManager
```

To **update** to the newest version of SwiftDependencyManager when you have an old version already installed run:

```shell
$ mint update JamitLabs/SwiftDependencyManager
```

## Usage

SwiftDependencyManager provides the following sub commands:
- **`init`**: Creates a new Package.swift file with basic structure.
- **`build`**: Builds all dependencies.
- **`clean`**: Cleans all dependencies.
- **`install`**: Installs the already resolved dependencies.
- **`update`**: Updates the dependencies.

**Shared Flags:**
- `--verbose`, `-v`: Prints out more detailed information about steps taken.

## Contributing

See the file [CONTRIBUTING.md](https://github.com/JamitLabs/SwiftDependencyManager/blob/stable/CONTRIBUTING.md).

## License
This library is released under the [MIT License](http://opensource.org/licenses/MIT). See LICENSE for details.
