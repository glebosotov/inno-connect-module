//
//  ViewController.swift
//  ConnectSDKDemo
//
//  Created by Gleb Osotov on 4/12/23.
//

import UIKit
import Flutter

class ViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let breatheView = BreatheView(frame: view.bounds)
        view.addSubview(breatheView)
        view.sendSubviewToBack(breatheView)
        
        // Make a button to call the showFlutter function when pressed.
        let button = CustomButton(
            frame: CGRect(
                x: view.frame.width * 0.1,
                y: view.frame.height / 2 - 20.0,
                width: view.frame.width * 0.8,
                height: 40.0
            )
        )
        button.addTarget(self, action: #selector(showFlutter), for: .touchUpInside)
        button.setTitle("Show Flutter!", for: UIControl.State.normal)
        button.setImage(UIImage(systemName: "shippingbox.circle.fill"), for: .normal)
        self.view.addSubview(button)
    }
    
    func getFlutterVC() -> FlutterViewController? {
        // Get the RootViewController.
        guard
            let windowScene = UIApplication.shared.connectedScenes
                .first(where: { $0.activationState == .foregroundActive && $0 is UIWindowScene }) as? UIWindowScene,
            let window = windowScene.windows.first(where: \.isKeyWindow),
            let _ = window.rootViewController
        else { return nil }
        
        // Create the FlutterViewController without an existing FlutterEngine.
        let flutterViewController = FlutterViewController(
            project: nil,
            nibName: nil,
            bundle: nil)
        flutterViewController.modalPresentationStyle = .overCurrentContext
        flutterViewController.isViewOpaque = false
        return flutterViewController
    }
    
    
    @objc func showFlutter() {
        //       let flutterEngine = (UIApplication.shared.delegate as! AppDelegate).flutterEngine
        guard let flutterViewController =
                getFlutterVC() else { return }
        
        
        let messenger = flutterViewController.binaryMessenger
        
        let api = FlutterAPI(
            onAnswered: {
//                flutterViewController.dismiss(animated: true)
            },
            onStarted: {
                
            },
            onSkipQuiz: {
                let alert = UIAlertController(title: "Skip quiz?", message: nil, preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "Skip", style: .default) {_ in
                    flutterViewController.dismiss(animated: true)
                })
                alert.addAction(UIAlertAction(title: "Cancel", style: .cancel))
                flutterViewController.present(alert, animated: true, completion: nil)
            }
        )
        QuizApiSetup.setUp(binaryMessenger: messenger, api: api)
        
        present(flutterViewController, animated: true, completion: nil)
    }
}


class FlutterAPI: NSObject, QuizApi {
    func deleteDataPressed() throws {
        
    }
    
    func getHubScreenConfig() throws -> HubScreenConfiguration {
        HubScreenConfiguration(
            news: [
                NewsItem(
                    id: "n1",
                    title: "The news system is active!",
                    description: "This is a very cool idea, we will see how it goes 🗿",
                    imageUrl: "https://www.apple.com/v/homepod-2nd-generation/a/images/overview/handoff__1iir0nzgjkia_medium_2x.jpg",
                    dateSecondsFromEpoch: Int64(Date().timeIntervalSince1970)
                ),
                NewsItem(
                    id: "n2",
                    title: "2The news system is active!",
                    description: "2This is a very cool idea, we will see how it goes 👨🏼‍🏫",
                    imageUrl: nil,
                    dateSecondsFromEpoch: Int64(Date().addingTimeInterval(1).timeIntervalSince1970)
                ),
            ],
            buttons: [
                HubButton(
                    title: "Reach me via telegram 😀",
                    id: "h1",
                    startsQuiz: false
                ),
                HubButton(
                    title: "Open quiz",
                    id: "h2",
                    startsQuiz: true
                )
            ],
            deleteButtonConfig: DeleteDataConfiguration(
                title: "Delete my data",
                confirmationTitle: "Are you sure?",
                confirmationMessage: "We will permanently delete your data from our servers",
                confirmationButtonTitle: "OK",
                cancelButtonTitle: "Cancel"
            ), disableHub: false
        )
    }
    
    func hubButtonPressed(id: String) throws {
        debugPrint("hub button \(id) pressed")
    }
    
    func newsItemPressed(id: String) throws {
        debugPrint("news button \(id) pressed")
    }
    
    func quizStarted() throws {
        self.onStarted()
    }
    
    func getQuestions() throws -> [QuestionModel] {
        let questions = [
            QuestionModel(
                id: "q1",
                type: .singleChoice,
                title: "What do frogs eat?", options: [
                    Option(isOpen: false, id: "q1a1", text: "Grass"),
                    Option(isOpen: false, id: "q1a2", text: "Each other (🫢)")
                ]
            ),
            QuestionModel(
                id: "q2",
                type: .open,
                title: "Isn't this UI nice?", options: [
                Option(isOpen: true, id: "q2a1", text: "")]
            ),
            QuestionModel(
                id: "q3",
                type: .singleChoiceOpen,
                image: "https://www.apple.com/v/homepod-2nd-generation/a/images/overview/handoff__1iir0nzgjkia_medium_2x.jpg",
                title: "What are your feelings towards HomePod?", description: "With HomePod or HomePod mini, amplify all the listening experiences you love. And enjoy an effortlessly connected smart home — with Siri built in — that’s private and secure.",
                options: [
                    Option(isOpen: false, id: "q3a1", text: "yes?"),
                    Option(isOpen: true, id: "q3a2", text: "")
                ]
            )
        ]
        return questions
    }
    
    let onStarted: () -> Void
    
    let onAnswered: () -> Void
    
    let onSkipQuiz: () -> Void
    
    init(
        onAnswered: @escaping () -> Void,
        onStarted: @escaping () -> Void,
        onSkipQuiz: @escaping () -> Void
    ) {
        self.onAnswered = onAnswered
        self.onStarted = onStarted
        self.onSkipQuiz = onSkipQuiz
        super.init()
    }
    
    func getQuizConfig() throws -> QuizConfiguration {
        return QuizConfiguration(
            startImageUrl: "https://www.apple.com/v/homepod-2nd-generation/a/images/overview/handoff__1iir0nzgjkia_medium_2x.jpg",
            endImageUrl: "https://www.apple.com/v/homepod-2nd-generation/a/images/overview/handoff__1iir0nzgjkia_medium_2x.jpg",
            startTitle: "Hello and welcome",
            startDescription: "Longer text",
            endTitle: "Thanks for participating",
            endDescription: "This was great",
            nextButtonTitle: "Continue",
            seedColor: "FF0000",
            disableSkipButton: false
        )
    }
    
    func sendAnswers(answers: [AnswerModel]) throws {
        self.onAnswered()
        print(answers)
        // TODO: log answers to analytics for metrics
    }
    
    func skipQuiz() throws {
        self.onSkipQuiz()
    }
}
