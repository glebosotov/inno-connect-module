// Autogenerated from Pigeon (v9.0.0), do not edit directly.
// See also: https://pub.dev/packages/pigeon

import Foundation
#if os(iOS)
import Flutter
#elseif os(macOS)
import FlutterMacOS
#else
#error("Unsupported platform.")
#endif



private func wrapResult(_ result: Any?) -> [Any?] {
  return [result]
}

private func wrapError(_ error: Any) -> [Any?] {
  if let flutterError = error as? FlutterError {
    return [
      flutterError.code,
      flutterError.message,
      flutterError.details
    ]
  }
  return [
    "\(error)",
    "\(type(of: error))",
    "Stacktrace: \(Thread.callStackSymbols)"
  ]
}

enum QuestionType: Int {
  case singleChoice = 0
}

/// Generated class from Pigeon that represents data sent in messages.
struct QuizConfiguration {
  var startImageUrl: String? = nil
  var endImageUrl: String? = nil
  var startTitle: String? = nil
  var startDescription: String? = nil
  var endTitle: String? = nil
  var endDescription: String? = nil
  var nextButtonTitle: String
  var seedColor: String? = nil

  static func fromList(_ list: [Any?]) -> QuizConfiguration? {
    let startImageUrl = list[0] as? String 
    let endImageUrl = list[1] as? String 
    let startTitle = list[2] as? String 
    let startDescription = list[3] as? String 
    let endTitle = list[4] as? String 
    let endDescription = list[5] as? String 
    let nextButtonTitle = list[6] as! String
    let seedColor = list[7] as? String 

    return QuizConfiguration(
      startImageUrl: startImageUrl,
      endImageUrl: endImageUrl,
      startTitle: startTitle,
      startDescription: startDescription,
      endTitle: endTitle,
      endDescription: endDescription,
      nextButtonTitle: nextButtonTitle,
      seedColor: seedColor
    )
  }
  func toList() -> [Any?] {
    return [
      startImageUrl,
      endImageUrl,
      startTitle,
      startDescription,
      endTitle,
      endDescription,
      nextButtonTitle,
      seedColor,
    ]
  }
}

/// Generated class from Pigeon that represents data sent in messages.
struct QuestionModel {
  var id: String
  var type: String
  var image: String? = nil
  var title: String
  var description: String? = nil
  var options: [Option?]

  static func fromList(_ list: [Any?]) -> QuestionModel? {
    let id = list[0] as! String
    let type = list[1] as! String
    let image = list[2] as? String 
    let title = list[3] as! String
    let description = list[4] as? String 
    let options = list[5] as! [Option?]

    return QuestionModel(
      id: id,
      type: type,
      image: image,
      title: title,
      description: description,
      options: options
    )
  }
  func toList() -> [Any?] {
    return [
      id,
      type,
      image,
      title,
      description,
      options,
    ]
  }
}

/// Generated class from Pigeon that represents data sent in messages.
struct Option {
  var id: String
  var text: String

  static func fromList(_ list: [Any?]) -> Option? {
    let id = list[0] as! String
    let text = list[1] as! String

    return Option(
      id: id,
      text: text
    )
  }
  func toList() -> [Any?] {
    return [
      id,
      text,
    ]
  }
}

/// Generated class from Pigeon that represents data sent in messages.
struct AnswerModel {
  var questionId: String
  var optionId: String? = nil
  var text: String? = nil

  static func fromList(_ list: [Any?]) -> AnswerModel? {
    let questionId = list[0] as! String
    let optionId = list[1] as? String 
    let text = list[2] as? String 

    return AnswerModel(
      questionId: questionId,
      optionId: optionId,
      text: text
    )
  }
  func toList() -> [Any?] {
    return [
      questionId,
      optionId,
      text,
    ]
  }
}
private class QuizApiCodecReader: FlutterStandardReader {
  override func readValue(ofType type: UInt8) -> Any? {
    switch type {
      case 128:
        return AnswerModel.fromList(self.readValue() as! [Any])
      case 129:
        return Option.fromList(self.readValue() as! [Any])
      case 130:
        return QuestionModel.fromList(self.readValue() as! [Any])
      case 131:
        return QuizConfiguration.fromList(self.readValue() as! [Any])
      default:
        return super.readValue(ofType: type)
    }
  }
}

private class QuizApiCodecWriter: FlutterStandardWriter {
  override func writeValue(_ value: Any) {
    if let value = value as? AnswerModel {
      super.writeByte(128)
      super.writeValue(value.toList())
    } else if let value = value as? Option {
      super.writeByte(129)
      super.writeValue(value.toList())
    } else if let value = value as? QuestionModel {
      super.writeByte(130)
      super.writeValue(value.toList())
    } else if let value = value as? QuizConfiguration {
      super.writeByte(131)
      super.writeValue(value.toList())
    } else {
      super.writeValue(value)
    }
  }
}

private class QuizApiCodecReaderWriter: FlutterStandardReaderWriter {
  override func reader(with data: Data) -> FlutterStandardReader {
    return QuizApiCodecReader(data: data)
  }

  override func writer(with data: NSMutableData) -> FlutterStandardWriter {
    return QuizApiCodecWriter(data: data)
  }
}

class QuizApiCodec: FlutterStandardMessageCodec {
  static let shared = QuizApiCodec(readerWriter: QuizApiCodecReaderWriter())
}

/// Generated protocol from Pigeon that represents a handler of messages from Flutter.
protocol QuizApi {
  func getQuizConfig() throws -> QuizConfiguration
  func getQuestions() throws -> [QuestionModel]
  func sendAnswers(answers: [AnswerModel]) throws
  func quizStarted() throws
}

/// Generated setup class from Pigeon to handle messages through the `binaryMessenger`.
class QuizApiSetup {
  /// The codec used by QuizApi.
  static var codec: FlutterStandardMessageCodec { QuizApiCodec.shared }
  /// Sets up an instance of `QuizApi` to handle messages through the `binaryMessenger`.
  static func setUp(binaryMessenger: FlutterBinaryMessenger, api: QuizApi?) {
    let getQuizConfigChannel = FlutterBasicMessageChannel(name: "dev.flutter.pigeon.QuizApi.getQuizConfig", binaryMessenger: binaryMessenger, codec: codec)
    if let api = api {
      getQuizConfigChannel.setMessageHandler { _, reply in
        do {
          let result = try api.getQuizConfig()
          reply(wrapResult(result))
        } catch {
          reply(wrapError(error))
        }
      }
    } else {
      getQuizConfigChannel.setMessageHandler(nil)
    }
    let getQuestionsChannel = FlutterBasicMessageChannel(name: "dev.flutter.pigeon.QuizApi.getQuestions", binaryMessenger: binaryMessenger, codec: codec)
    if let api = api {
      getQuestionsChannel.setMessageHandler { _, reply in
        do {
          let result = try api.getQuestions()
          reply(wrapResult(result))
        } catch {
          reply(wrapError(error))
        }
      }
    } else {
      getQuestionsChannel.setMessageHandler(nil)
    }
    let sendAnswersChannel = FlutterBasicMessageChannel(name: "dev.flutter.pigeon.QuizApi.sendAnswers", binaryMessenger: binaryMessenger, codec: codec)
    if let api = api {
      sendAnswersChannel.setMessageHandler { message, reply in
        let args = message as! [Any?]
        let answersArg = args[0] as! [AnswerModel]
        do {
          try api.sendAnswers(answers: answersArg)
          reply(wrapResult(nil))
        } catch {
          reply(wrapError(error))
        }
      }
    } else {
      sendAnswersChannel.setMessageHandler(nil)
    }
    let quizStartedChannel = FlutterBasicMessageChannel(name: "dev.flutter.pigeon.QuizApi.quizStarted", binaryMessenger: binaryMessenger, codec: codec)
    if let api = api {
      quizStartedChannel.setMessageHandler { _, reply in
        do {
          try api.quizStarted()
          reply(wrapResult(nil))
        } catch {
          reply(wrapError(error))
        }
      }
    } else {
      quizStartedChannel.setMessageHandler(nil)
    }
  }
}
