import 'package:chat_365/common/images.dart';
import 'package:chat_365/data/services/hive_service/hive_type_id.dart';
import 'package:equatable/equatable.dart';
import 'package:hive_flutter/hive_flutter.dart';
part 'emoji.g.dart';

@HiveType(typeId: HiveTypeId.emojiHiveTypeId)
class Emoji extends Equatable {
  const Emoji({
    required this.id,
    required this.assetPath,
    this.linkEmotion,
  });

  @HiveField(0)
  final int id;
  @HiveField(1)
  final String assetPath;
  @HiveField(2)
  final String? linkEmotion;

  static const kMinId = 1;

  static const like = Emoji(
    id: kMinId,
    assetPath: Images.img_like,
    linkEmotion: "https://mess.timviec365.vn/Emotion/Emotion1.png",
  );
  static const tearOffJoy = Emoji(
      id: kMinId + 1,
      assetPath: Images.img_tearOffJoy,
      linkEmotion: "https://mess.timviec365.vn/Emotion/Emotion2.png");
  static const heartEye = Emoji(
      id: kMinId + 2,
      assetPath: Images.img_heartEye,
      linkEmotion: "https://mess.timviec365.vn/Emotion/Emotion3.png");
  static const heart = Emoji(
      id: kMinId + 3,
      assetPath: Images.img_heart,
      linkEmotion: "https://mess.timviec365.vn/Emotion/Emotion4.png");
  static const thinkingFace = Emoji(
      id: kMinId + 4,
      assetPath: Images.img_thinkingFace,
      linkEmotion: "https://mess.timviec365.vn/Emotion/Emotion5.png");
  static const tearOffSad = Emoji(
      id: kMinId + 5,
      assetPath: Images.img_tearOffSad,
      linkEmotion: "https://mess.timviec365.vn/Emotion/Emotion6.png");
  static const angry = Emoji(
      id: kMinId + 6,
      assetPath: Images.img_angry,
      linkEmotion: "https://mess.timviec365.vn/Emotion/Emotion7.png");
  static const wow = Emoji(
      id: kMinId + 7,
      assetPath: Images.img_wow,
      linkEmotion: "https://mess.timviec365.vn/Emotion/Emotion8.png");

  static const values = [
    like,
    tearOffJoy,
    heartEye,
    heart,
    thinkingFace,
    tearOffSad,
    angry,
    wow,
  ];

  static fromId(int id) => values[id - 1];

  @override
  String toString() => assetPath.split('/').last;

  @override
  List<Object?> get props => [id];
}

// extension ReactionExt on Reaction {
//   static const kMinId = 1;

//   static Reaction fromId(int id) => Reaction.values[id - 1];

//   int get id {
//     switch (this) {
//       case Reaction.like:
//         return kMinId;
//       case Reaction.tearOffJoy:
//         return kMinId + 1;
//       case Reaction.heartEye:
//         return kMinId + 2;
//       case Reaction.heart:
//         return kMinId + 3;
//       case Reaction.thinkingFace:
//         return kMinId + 4;
//       case Reaction.tearOffSad:
//         return kMinId + 5;
//       case Reaction.angry:
//         return kMinId + 6;
//       case Reaction.wow:
//         return kMinId + 7;
//     }
//   }
// }
