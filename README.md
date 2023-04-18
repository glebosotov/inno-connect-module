# connect

## Getting started

### iOS (UIKit / SwiftUI)

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

### Android (Kotlin / Java)

1. Add this repository as a submodule to your project.
2. Add this to your `settings.gradle`

    ```groovy
    setBinding(new Binding([gradle: this]))
    evaluate(new File(
        settingsDir.parentFile,
        'connect/.android/include_flutter.groovy'
    ))
    ```

3. Add this to your `build.gradle` In the `dependencies` section

    ```groovy
    implementation project(':flutter')
    ```

4. Use compileOptions in your `build.gradle` to set the Java version to 11

    ```groovy
    compileOptions {
        sourceCompatibility JavaVersion.VERSION_11
        targetCompatibility JavaVersion.VERSION_11
    }
    ```

5. Sync gradle and add `Pigeon.kt` to your project
6. Anywhere in your Kotlin code use the following lines:

    ```kotlin
    // Setting up the flutter engine somewhere in onCreate
    flutterEngine = FlutterEngine(this)
    QuizApi.setUp(flutterEngine.dartExecutor.binaryMessenger, FlutterApi())
    ```

    ```kotlin
    // Starting the activity
    // Start executing Dart code to pre-warm the FlutterEngine.
    flutterEngine.dartExecutor.executeDartEntrypoint(
        DartExecutor.DartEntrypoint.createDefault()
    )

    // Cache the FlutterEngine to be used by FlutterActivity.
    FlutterEngineCache.getInstance().put("flutter_engine", flutterEngine)
    val flutterActivity = FlutterActivity.withCachedEngine("flutter_engine")
    startActivity(flutterActivity.build(this))
    ```

    ```kotlin
    // Set up the data
    private class FlutterApi : QuizApi {

        override fun getQuizConfig(): QuizConfiguration {
            return QuizConfiguration(
                    startImageUrl = "https://.../content/learning-bro.png",
                    endImageUrl = "https://.../content/grades-bro.png",
                    startTitle = "Hello",
                    startDescription = "Hello",
                    endTitle = "Hello",
                    endDescription = "Hello",
                    nextButtonTitle = "Next",
                    seedColor = "0379FB"
            )
        }

        override fun getQuestions(): List<QuestionModel> {
            return listOf<QuestionModel>(
                    QuestionModel(
                            id = "q1",
                            type = QuestionType.SINGLECHOICEOPEN,
                            image = null,
                            title = "Hello",
                            description = "Hello",
                            options =
                                    listOf<Option>(
                                            Option(id = "o1", text = "Hello", isOpen = true),
                                            Option(id = "o2", text = "Hello", isOpen = false),
                                            Option(id = "o3", text = "Hello", isOpen = false),
                                            Option(id = "o4", text = "Hello", isOpen = false),
                                    )
                    ),
            )
        }

        override fun getHubScreenConfig(): HubScreenConfiguration {
            return HubScreenConfiguration(news = listOf<NewsItem>(
                NewsItem(
                    id = "news1",
                    title = "This is a sample news item"
                )
            ), buttons = listOf<HubButton>(
                HubButton(
                    id = "hub1",
                    startsQuiz = true,
                    title = "start the quiz"
                )
            ))
        }

        override fun sendAnswers(answers: List<AnswerModel>) {}

        override fun quizStarted() {}

        override fun hubButtonPressed(id: String) {}

        override fun newsItemPressed(id: String) {}
    }
    ```

### Flutter

1. Add this repository as a submodule to your project
2. Add this to your `pubspec.yaml`

    ```yaml
    dependencies:
      connect:
        path: connect
    ```

3. Use the `ConnectPage` widget like so:

    ```dart
    ConnectPage(
        quizConfiguration: QuizConfiguration(nextButtonTitle: "Test"),
        hubScreenConfiguration: HubScreenConfiguration(news: [], buttons: []),
        questions: [],
        onQuizDone: (_) => print("quizDone"),
      )
    ```

## Development

Command to run Pigeon generation

```bash
flutter pub run pigeon --input platform_api.dart --dart_out lib/pigeon.dart --experimental_swift_out Pigeon.swift --kotlin_out Pigeon.kt
```
