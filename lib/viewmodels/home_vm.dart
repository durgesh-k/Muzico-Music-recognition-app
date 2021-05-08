import 'package:acr_cloud_sdk/acr_cloud_sdk.dart';
import 'package:flutter/cupertino.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:Muzico/services/models/deezer_song_model.dart';
import 'package:Muzico/services/song_service.dart';

class HomeViewModel extends ChangeNotifier {
  HomeViewModel() {
    initAcr();
  }
  final AcrCloudSdk acr = AcrCloudSdk();
  final songService = SongService();
  DeezerSongModel currentSong;
  bool isRecognizing = false;
  bool success = false;
  bool noResult = false;
  String title;
  String artist;

  Future<void> initAcr() async {
    try {
      acr
        ..init(
          host: 'identify-eu-west-1.acrcloud.com', // https://www.acrcloud.com/
          accessKey: '7ac403f493b62e424cb3d0729e5fa9ad',
          accessSecret: 'n2GoNogSVb25Jhfp4yyhwfWH1ggaAwvld2tDgxTV',
          setLog: true,
        )
        ..songModelStream.listen(searchSong);
    } catch (e) {
      print(e.toString());
    }
  }

  void searchSong(SongModel song) async {
    print(song);
    final metaData = song?.metadata;
    final status = song?.status?.msg;

    if (metaData != null && metaData.music.length > 0) {
      final trackId = metaData?.music[0]?.externalMetadata?.deezer?.track?.id;
      title = metaData?.music[0]?.title;
      artist = metaData?.music[0]?.artists[0].name;
      success = true;
      try {
        final res = await songService.getTrack(trackId);
        currentSong = res;
        success = true;
        notifyListeners();
      } catch (e) {
        isRecognizing = false;
        success = false;
        noResult = true;
        notifyListeners();
      }
    } else {
      isRecognizing = false;
      noResult = true;
      print("there was no result--------");
      notifyListeners();
    }
  }

  Future<void> startRecognizing() async {
    isRecognizing = true;
    success = false;
    noResult = false;
    notifyListeners();
    try {
      await acr.start();
    } catch (e) {
      print("there was no result2");
      print(e.toString());
    }
  }

  Future<void> stopRecognizing() async {
    isRecognizing = false;
    success = false;
    notifyListeners();
    try {
      await acr.stop();
    } catch (e) {
      print(e.toString());
    }
  }
}

final homeViewModel = ChangeNotifierProvider<HomeViewModel>((ref) {
  print('>>> In homeViewModel');
  return HomeViewModel();
});
