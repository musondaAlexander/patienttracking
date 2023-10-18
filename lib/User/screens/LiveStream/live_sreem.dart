import 'package:flutter/material.dart';
import 'package:patienttracking/User/screens/LiveStream/util.dart';
import 'package:zego_uikit_prebuilt_live_streaming/zego_uikit_prebuilt_live_streaming.dart';

class LiveStreemVew extends StatelessWidget {
  final String roomId, userId;
  final bool isHost;

  LiveStreemVew({
    super.key,
    required this.roomId,
    required this.userId,
    required this.isHost,
  });

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: ZegoUIKitPrebuiltLiveStreaming(
      appID: Utils.AppID,
      appSign: Utils.AppSign,
      userName: "User{$userId}",
      userID: userId,
      liveID: roomId,
      config: isHost
          ? ZegoUIKitPrebuiltLiveStreamingConfig.host()
          : ZegoUIKitPrebuiltLiveStreamingConfig.audience()
        ..audioVideoViewConfig.showAvatarInAudioMode = true
        ..audioVideoViewConfig.showSoundWavesInAudioMode = true,
    ));
  }
}
