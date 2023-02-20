// Autogenerated from Pigeon (v9.0.0), do not edit directly.
// See also: https://pub.dev/packages/pigeon
// ignore_for_file: public_member_api_docs, non_constant_identifier_names, avoid_as, unused_import, unnecessary_parenthesis, prefer_null_aware_operators, omit_local_variable_types, unused_shown_name, unnecessary_import

import 'dart:async';
import 'dart:typed_data' show Float64List, Int32List, Int64List, Uint8List;

import 'package:flutter/foundation.dart' show ReadBuffer, WriteBuffer;
import 'package:flutter/services.dart';

enum QuestionType {
  singleChoice,
}

class QuizModel {
  QuizModel({
    required this.questions,
    this.startImageUrl,
    this.endImageUrl,
    this.startTitle,
    this.startDescription,
    this.endTitle,
    this.endDescription,
    required this.nextButtonTitle,
    this.seedColor,
  });

  List<QuestionModel?> questions;

  String? startImageUrl;

  String? endImageUrl;

  String? startTitle;

  String? startDescription;

  String? endTitle;

  String? endDescription;

  String nextButtonTitle;

  String? seedColor;

  Object encode() {
    return <Object?>[
      questions,
      startImageUrl,
      endImageUrl,
      startTitle,
      startDescription,
      endTitle,
      endDescription,
      nextButtonTitle,
      seedColor,
    ];
  }

  static QuizModel decode(Object result) {
    result as List<Object?>;
    return QuizModel(
      questions: (result[0] as List<Object?>?)!.cast<QuestionModel?>(),
      startImageUrl: result[1] as String?,
      endImageUrl: result[2] as String?,
      startTitle: result[3] as String?,
      startDescription: result[4] as String?,
      endTitle: result[5] as String?,
      endDescription: result[6] as String?,
      nextButtonTitle: result[7]! as String,
      seedColor: result[8] as String?,
    );
  }
}

class QuestionModel {
  QuestionModel({
    required this.id,
    required this.type,
    this.image,
    required this.title,
    this.description,
    required this.options,
  });

  String id;

  QuestionType type;

  String? image;

  String title;

  String? description;

  List<Option?> options;

  Object encode() {
    return <Object?>[
      id,
      type.index,
      image,
      title,
      description,
      options,
    ];
  }

  static QuestionModel decode(Object result) {
    result as List<Object?>;
    return QuestionModel(
      id: result[0]! as String,
      type: QuestionType.values[result[1]! as int],
      image: result[2] as String?,
      title: result[3]! as String,
      description: result[4] as String?,
      options: (result[5] as List<Object?>?)!.cast<Option?>(),
    );
  }
}

class Option {
  Option({
    required this.id,
    required this.text,
  });

  String id;

  String text;

  Object encode() {
    return <Object?>[
      id,
      text,
    ];
  }

  static Option decode(Object result) {
    result as List<Object?>;
    return Option(
      id: result[0]! as String,
      text: result[1]! as String,
    );
  }
}

class AnswerModel {
  AnswerModel({
    required this.questionId,
    this.optionId,
    this.text,
  });

  String questionId;

  String? optionId;

  String? text;

  Object encode() {
    return <Object?>[
      questionId,
      optionId,
      text,
    ];
  }

  static AnswerModel decode(Object result) {
    result as List<Object?>;
    return AnswerModel(
      questionId: result[0]! as String,
      optionId: result[1] as String?,
      text: result[2] as String?,
    );
  }
}

class _QuizApiCodec extends StandardMessageCodec {
  const _QuizApiCodec();
  @override
  void writeValue(WriteBuffer buffer, Object? value) {
    if (value is AnswerModel) {
      buffer.putUint8(128);
      writeValue(buffer, value.encode());
    } else if (value is Option) {
      buffer.putUint8(129);
      writeValue(buffer, value.encode());
    } else if (value is QuestionModel) {
      buffer.putUint8(130);
      writeValue(buffer, value.encode());
    } else if (value is QuizModel) {
      buffer.putUint8(131);
      writeValue(buffer, value.encode());
    } else {
      super.writeValue(buffer, value);
    }
  }

  @override
  Object? readValueOfType(int type, ReadBuffer buffer) {
    switch (type) {
      case 128: 
        return AnswerModel.decode(readValue(buffer)!);
      case 129: 
        return Option.decode(readValue(buffer)!);
      case 130: 
        return QuestionModel.decode(readValue(buffer)!);
      case 131: 
        return QuizModel.decode(readValue(buffer)!);
      default:
        return super.readValueOfType(type, buffer);
    }
  }
}

class QuizApi {
  /// Constructor for [QuizApi].  The [binaryMessenger] named argument is
  /// available for dependency injection.  If it is left null, the default
  /// BinaryMessenger will be used which routes to the host platform.
  QuizApi({BinaryMessenger? binaryMessenger})
      : _binaryMessenger = binaryMessenger;
  final BinaryMessenger? _binaryMessenger;

  static const MessageCodec<Object?> codec = _QuizApiCodec();

  Future<QuizModel> getQuiz() async {
    final BasicMessageChannel<Object?> channel = BasicMessageChannel<Object?>(
        'dev.flutter.pigeon.QuizApi.getQuiz', codec,
        binaryMessenger: _binaryMessenger);
    final List<Object?>? replyList =
        await channel.send(null) as List<Object?>?;
    if (replyList == null) {
      throw PlatformException(
        code: 'channel-error',
        message: 'Unable to establish connection on channel.',
      );
    } else if (replyList.length > 1) {
      throw PlatformException(
        code: replyList[0]! as String,
        message: replyList[1] as String?,
        details: replyList[2],
      );
    } else if (replyList[0] == null) {
      throw PlatformException(
        code: 'null-error',
        message: 'Host platform returned null value for non-null return value.',
      );
    } else {
      return (replyList[0] as QuizModel?)!;
    }
  }

  Future<void> sendAnswers(List<AnswerModel?> arg_answers) async {
    final BasicMessageChannel<Object?> channel = BasicMessageChannel<Object?>(
        'dev.flutter.pigeon.QuizApi.sendAnswers', codec,
        binaryMessenger: _binaryMessenger);
    final List<Object?>? replyList =
        await channel.send(<Object?>[arg_answers]) as List<Object?>?;
    if (replyList == null) {
      throw PlatformException(
        code: 'channel-error',
        message: 'Unable to establish connection on channel.',
      );
    } else if (replyList.length > 1) {
      throw PlatformException(
        code: replyList[0]! as String,
        message: replyList[1] as String?,
        details: replyList[2],
      );
    } else {
      return;
    }
  }
}
