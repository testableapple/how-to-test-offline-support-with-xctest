# How To Test Offline Support With XCTest

Offline support is one of the most complex features not only to implement but also to test. In this sample project, I'll show you how to disable the network on iOS Simulator from XCTest. Strap in, it can open up a whole new world for your automated test cases.

## Usage

1. Install dependencies

    ```bash
    npm install
    ```

2. Run the server

    ```bash
    node server.js &
    ```

3. Run the sample test

    ```bash
    xcodebuild test \
      -destination 'platform=iOS Simulator,name=iPhone 14' \
      -scheme Sample | xcpretty
    ```
