import 'package:flutter/material.dart';
import 'package:zego_uikit_prebuilt_call/zego_uikit_prebuilt_call.dart';
import 'package:patienttracking/User/screens/LiveStream/util.dart';

class LiveCall extends StatefulWidget {
  // declare the roomId and userId variables
  //  will need to pass these variables from the SOS screen
  //  to the LiveCall screen
  final String roomId, userId;

  const LiveCall(
      //  will need to call this constructor from the SOS screen
      //  and pass the roomId and userId
      {super.key,
      required this.roomId,
      required this.userId});

  @override
  State<LiveCall> createState() => _LiveCallState();
}

class _LiveCallState extends State<LiveCall> {
  ZegoUIKitPrebuiltCallController? callController;

  late String roomID;
  late String userID;

  @override
  void initState() {
    super.initState();
    callController = ZegoUIKitPrebuiltCallController();
    roomID = widget.roomId;
    userID = widget.userId;
  }

  @override
  void dispose() {
    super.dispose();
    callController = null;
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: ZegoUIKitPrebuiltCall(
        appID: Utils.AppIDVideoConference,
        appSign: Utils.AppSignVideoConference,
        callID: roomID,
        userID: userID,
        userName: "User{$userID}",
        config: ZegoUIKitPrebuiltCallConfig.groupVideoCall(),
      ),
    );
  }
}












// class LiveGroupCall extends StatelessWidget {
//   final String roomId, userId;
//   final bool isHost;

//   LiveGroupCall({
//     super.key,
//     required this.roomId,
//     required this.userId,
//     required this.isHost,
//   });
//   @override
//   Widget build(BuildContext context) {
//     return SafeArea(
//         child: ZegoUIKitPrebuiltLiveStreaming(
//       appID: Utils.AppID,
//       appSign: Utils.AppSign,
//       userName: "User{$userId}",
//       userID: userId,
//       liveID: roomId,
//       config: isHost
//           ? ZegoUIKitPrebuiltLiveStreamingConfig.host()
//           // : ZegoUIKitPrebuiltLiveStreamingConfig.audience(),
//           : ZegoUIKitPrebuiltLiveStreamingConfig.audience()
//         ..audioVideoViewConfig.showAvatarInAudioMode = true
//         ..audioVideoViewConfig.showSoundWavesInAudioMode = true,
//     ));
//   }
// }
