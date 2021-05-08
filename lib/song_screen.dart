import 'package:Muzico/home.dart';
import 'package:flutter/material.dart';
import 'package:Muzico/services/models/deezer_song_model.dart';
import 'package:flutter_svg/svg.dart';

class SongScreen extends StatelessWidget {
  final DeezerSongModel song;
  final title;
  final artist;
  const SongScreen(
      {Key key,
      @required this.song,
      @required this.title,
      @required this.artist})
      : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.transparent,
      ),
      body: Stack(alignment: Alignment.center, children: [
        Container(
          height: MediaQuery.of(context).size.height,
          width: MediaQuery.of(context).size.width,
          child: Column(
            children: [
              Container(
                /*height: MediaQuery.of(context).size.height * 0.6,
                width: MediaQuery.of(context).size.width,*/
                /*decoration: BoxDecoration(
                    image: DecorationImage(
                        image: song != null
                            ? NetworkImage(song?.album?.coverMedium)
                            : AssetImage('assets/images/cd.png'),
                        fit: BoxFit.cover)),*/
                child: Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: Image.asset('assets/cd.png',
                      width: MediaQuery.of(context).size.width - 100),
                ),
              ),
              Expanded(
                child: Container(
                  padding: EdgeInsets.all(20),
                  width: MediaQuery.of(context).size.width,
                  color: Colors.black,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Container(
                        //height: 100,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Container(
                              child: Text(/*song?.title ?? '',*/ title ?? '',
                                  // overflow: TextOverflow.ellipsis,
                                  style: TextStyle(
                                      fontFamily: "Gilroy",
                                      color: Colors.white,
                                      fontSize: 36,
                                      fontWeight: FontWeight.bold)),
                            ),
                          ],
                        ),
                      ),
                      SizedBox(height: 30),
                      Text(/*song?.artist?.name ?? '',*/ artist ?? '',
                          style: TextStyle(
                              fontFamily: "Gilroy",
                              color: Colors.white,
                              fontSize: 16)),
                    ],
                  ),
                ),
              )
            ],
          ),
        ),
        Positioned(
          bottom: 10,
          child: Padding(
            padding: const EdgeInsets.all(30.0),
            child: InkWell(
              onTap: () => /*Navigator.pop(context),*/

                  Navigator.of(context).pushAndRemoveUntil(
                MaterialPageRoute(builder: (context) => HomePage()),
                (Route<dynamic> route) => false,
              ),
              child: Container(
                height: 60,
                width: MediaQuery.of(context).size.width - 100,
                decoration: BoxDecoration(
                    color: Colors.black,
                    border: Border.all(color: Colors.white, width: 2),
                    borderRadius: BorderRadius.circular(8)),
                child: Center(
                  child: Text(
                    "Great",
                    style: TextStyle(
                      fontFamily: "Gilroy",
                      fontSize: 24,
                      //fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
            ),
          ),
        )
      ]),
    );
  }
}

class NoResultPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.transparent,
      ),
      body: Stack(alignment: Alignment.center, children: [
        Center(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Container(
                child: Padding(
                  padding: const EdgeInsets.only(
                    left: 120.0,
                    right: 120,
                    top: 120,
                  ),
                  child: SvgPicture.asset(
                    "assets/no-result.svg",
                    height: 80,
                  ),
                ),
              ),
              SizedBox(
                height: 30,
              ),
              Text(
                "No Result",
                style: TextStyle(
                  fontFamily: "Gilroy",
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
              SizedBox(
                height: 60,
              ),
            ],
          ),
        ),
        Positioned(
          bottom: 10,
          child: Padding(
            padding: const EdgeInsets.all(30.0),
            child: InkWell(
              onTap: () => /*Navigator.pop(context)*/ Navigator.of(context)
                  .pushAndRemoveUntil(
                MaterialPageRoute(builder: (context) => HomePage()),
                (Route<dynamic> route) => false,
              ),
              child: Container(
                height: 60,
                width: MediaQuery.of(context).size.width - 100,
                decoration: BoxDecoration(
                    color: Colors.black,
                    border: Border.all(color: Colors.white, width: 2),
                    borderRadius: BorderRadius.circular(8)),
                child: Center(
                  child: Text(
                    "Try Again",
                    style: TextStyle(
                      fontFamily: "Gilroy",
                      fontSize: 24,
                      //fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
            ),
          ),
        )
      ]),
    );
  }
}
