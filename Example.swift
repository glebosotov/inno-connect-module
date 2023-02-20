//
//  ViewController.swift
//  FeedbackDemo
//
//  Created by Gleb Osotov on 2/15/23.
//

import UIKit
import Flutter

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        // Make a button to call the showFlutter function when pressed.
        let button = UIButton(type:UIButton.ButtonType.custom)
        button.addTarget(self, action: #selector(showFlutter), for: .touchUpInside)
        button.setTitle("Show Flutter!", for: UIControl.State.normal)
        button.frame = CGRect(x: 80.0, y: 210.0, width: 160.0, height: 40.0)
        button.backgroundColor = UIColor.blue
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
        
        let api = FlutterAPI(onAnswered: {
            flutterViewController.dismiss(animated: true)
        })
        QuizApiSetup.setUp(binaryMessenger: messenger, api: api)
        
        present(flutterViewController, animated: true, completion: nil)
     }
}

class FlutterAPI: NSObject, QuizApi {
    let onAnswered: () -> Void
    
    init(onAnswered: @escaping () -> Void) {
        self.onAnswered = onAnswered
        super.init()
    }
    
    func getQuiz() throws -> QuizModel {
        let questions = [
            QuestionModel(id: "q1", type: .singleChoice, title: "What do frogs eat?", options: [
                Option(id: "q1a1", text: "Grass"),
                Option(id: "q1a2", text: "Each other (🫢)")
            ]),
            QuestionModel(id: "q2", type: .singleChoice, title: "Isn't this UI nice?", options: [Option(id: "q2a1", text: "YES"),]),
            QuestionModel(id: "q3", type: .singleChoice, image: "https://www.apple.com/v/homepod-2nd-generation/a/images/overview/handoff__1iir0nzgjkia_medium_2x.jpg", title: "What are your feelings towards HomePod?", description: "With HomePod or HomePod mini, amplify all the listening experiences you love. And enjoy an effortlessly connected smart home — with Siri built in — that’s private and secure.", options: [Option(id: "q3a1", text: "yes?")])
        ]
        return QuizModel(questions: questions, startImageUrl: "https://www.apple.com/v/homepod-2nd-generation/a/images/overview/handoff__1iir0nzgjkia_medium_2x.jpg", endImageUrl: "https://www.apple.com/v/homepod-2nd-generation/a/images/overview/handoff__1iir0nzgjkia_medium_2x.jpg", startTitle: "Hello and welcome", startDescription: "Longer text", endTitle: "Thanks for participating", endDescription: "This was great", nextButtonTitle: "Continue", seedColor: "FF0000")
    }
    
    func sendAnswers(answers: [AnswerModel]) throws {
        self.onAnswered()
        print(answers)
        // TODO: log answers to analytics for metrics
    }
}
