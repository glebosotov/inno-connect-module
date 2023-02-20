# connect

## Getting started

1. Add this repository as a submodule to your project
2. Update Podfile
    - Add this at the end

    ```ruby
    post_install do |installer|
        flutter_post_install(installer) if defined?(flutter_post_install)
    end
    ```

    - Add this to the pods list for yout target

    ```ruby
    install_all_flutter_pods(flutter_application_path)
    ```

    - Add this to the top (change path as needed)

    ```ruby
    flutter_application_path = 'connect'
    load File.join(flutter_application_path, '.ios', 'Flutter', 'podhelper.rb')
    ```

3. Run `pod install`

4. In your `AppDelegate.swift` Change `UIApplicationDelegate` to `FlutterAppDelegate`

    ```swift
    @UIApplicationMain
    class AppDelegate: FlutterAppDelegate {
    ```

5. Add `Pigeon.swift` file to your project

6. Use the framework. See `Example.swift` for details
