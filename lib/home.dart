import 'package:avatar_glow/avatar_glow.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_svg/svg.dart';
import 'package:hooks_riverpod/all.dart';
import 'package:Muzico/song_screen.dart';
import 'package:Muzico/viewmodels/home_vm.dart';

class HomePage extends HookWidget {
  bool change = true;
  bool animate = false;

  @override
  Widget build(BuildContext context) {
    final playButton = PlayButton(
      onPressed: () {},
    );
    final playButtonState = _PlayButtonState();
    final vm = useProvider(homeViewModel);
    return ProviderListener<HomeViewModel>(
      provider: homeViewModel,
      onChange: (context, vm) {
        if (vm.success) {
          playButtonState.isPlaying = false;
          animate = false;
          Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(
                builder: (context) => SongScreen(
                      song: vm.currentSong,
                      title: vm.title,
                      artist: vm.artist,
                    )),
            (Route<dynamic> route) => false,
          );
        } else if (vm.noResult) {
          playButtonState.isPlaying = false;
          animate = false;
          Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(builder: (context) => NoResultPage()),
            (Route<dynamic> route) => false,
          );
        }
      },
      child: Scaffold(
          backgroundColor: Colors.black,
          appBar: AppBar(
            backgroundColor: Colors.black,
            elevation: 0,
          ),
          body: Column(
            children: [
              SizedBox(
                height: 100,
              ),
              change
                  ? Text(
                      "Tap to listen",
                      style: TextStyle(
                        fontFamily: "Gilroy",
                        fontSize: 24,
                        //fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    )
                  : Text(
                      "Listening...",
                      style: TextStyle(
                        fontFamily: "Gilroy",
                        fontSize: 24,
                        //fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
              SizedBox(
                height: 160,
              ),
              Center(
                child:
                    /*Container(
                  height: 100,
                  child: SvgPicture.asset(
                    "assets/white1.svg",
                  ),
                ),*/
                    SizedBox(
                  height: 200,
                  width: 200,
                  child: PlayButton(
                    pauseIcon: Icon(Icons.pause, color: Colors.black, size: 90),
                    playIcon:
                        Icon(Icons.play_arrow, color: Colors.black, size: 90),
                    onPressed: () {
                      change = !change;
                      animate = !animate;
                      vm.isRecognizing
                          ? vm.stopRecognizing()
                          : vm.startRecognizing();
                    },
                  ),
                ),
              ),
            ],
          )),
    );
  }
}

// ignore: must_be_immutable
class PlayButton extends StatefulWidget {
  final bool initialIsPlaying;
  final Icon playIcon;
  final Icon pauseIcon;
  final VoidCallback onPressed;
  final vm = useProvider(homeViewModel);

  PlayButton({
    @required this.onPressed,
    this.initialIsPlaying = false,
    this.playIcon = const Icon(Icons.play_arrow),
    this.pauseIcon = const Icon(Icons.pause),
  }) : assert(onPressed != null);

  @override
  _PlayButtonState createState() => _PlayButtonState();
}

class _PlayButtonState extends State<PlayButton> with TickerProviderStateMixin {
  static const _kToggleDuration = Duration(milliseconds: 300);
  static const _kRotationDuration = Duration(seconds: 5);

  // rotation and scale animations
  AnimationController _rotationController;
  AnimationController _scaleController;
  double _rotation = 0;
  double _scale = 0.85;

  bool isPlaying;

  bool get _showWaves => !_scaleController.isDismissed;

  void _updateRotation() => _rotation = _rotationController.value * 2 * 3.14;
  void _updateScale() => _scale = (_scaleController.value * 0.2) + 0.85;

  @override
  void initState() {
    isPlaying = widget.initialIsPlaying;
    _rotationController =
        AnimationController(vsync: this, duration: _kRotationDuration)
          ..addListener(() => setState(_updateRotation))
          ..repeat();

    _scaleController =
        AnimationController(vsync: this, duration: _kToggleDuration)
          ..addListener(() => setState(_updateScale));

    super.initState();
  }

  void _onToggle() {
    setState(() => isPlaying = !isPlaying);

    if (_scaleController.isCompleted) {
      _scaleController.reverse();
    } else {
      _scaleController.forward();
    }

    widget.onPressed();
  }

  Widget _buildIcon(bool isPlaying) {
    return SizedBox.expand(
        key: ValueKey<bool>(isPlaying),
        child: GestureDetector(
          onTap: _onToggle,
          child: Container(
            decoration: BoxDecoration(
              color: Colors.black,
              borderRadius: BorderRadius.circular(100),
            ),
            child: Padding(
              padding: const EdgeInsets.all(38.0),
              child: SvgPicture.asset(
                "assets/white1.svg",
                height: 50,
              ),
            ),
          ),
        ));
  }

  @override
  Widget build(BuildContext context) {
    return ConstrainedBox(
      constraints: BoxConstraints(minWidth: 48, minHeight: 48),
      child: Stack(
        alignment: Alignment.center,
        children: [
          if (_showWaves) ...[
            Blob(color: Colors.white54, scale: _scale, rotation: _rotation),
            Blob(
                color: Colors.white24,
                scale: _scale,
                rotation: _rotation * 2 - 30),
            Blob(
                color: Colors.white30,
                scale: _scale,
                rotation: _rotation * 3 - 45),
          ],
          Container(
            constraints: BoxConstraints.expand(),
            child: AnimatedSwitcher(
              child: _buildIcon(isPlaying),
              duration: _kToggleDuration,
            ),
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: Colors.white,
            ),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _scaleController.dispose();
    _rotationController.dispose();
    super.dispose();
  }
}

class Blob extends StatelessWidget {
  final double rotation;
  final double scale;
  final Color color;

  const Blob({this.color, this.rotation = 0, this.scale = 1});

  @override
  Widget build(BuildContext context) {
    return Transform.scale(
      scale: scale,
      child: Transform.rotate(
        angle: rotation,
        child: Container(
          decoration: BoxDecoration(
            color: color,
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(150),
              topRight: Radius.circular(240),
              bottomLeft: Radius.circular(220),
              bottomRight: Radius.circular(180),
            ),
          ),
        ),
      ),
    );
  }
}
