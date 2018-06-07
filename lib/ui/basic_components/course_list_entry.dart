import 'package:courses_in_english/connect/dataprovider/favorites/favorites_observer.dart';
import 'package:courses_in_english/connect/dataprovider/data.dart';
import 'package:flutter/material.dart';
import 'package:courses_in_english/model/course/course.dart';
import '../scaffolds/course_details.dart';
import 'package:courses_in_english/ui/basic_components/availability_widget.dart';

class CourseListEntry extends StatefulWidget {
  final Course course;

  CourseListEntry(this.course);

  @override
  _CourseListEntryState createState() =>
      new _CourseListEntryState(course);
}

class _CourseListEntryState extends State implements FavoritesObserver {
  static const Color GREEN = const Color(0xFF83D183);
  static const Color YELLOW = const Color(0xFFFFCC66);
  static const Color RED = const Color(0xFFFF3366);
  static const Color HEART = const Color(0xFFFFA1A1);

  final Course course;
  Data data = new Data();

  bool _favorite = false;

  _CourseListEntryState(this.course);

  void _toggleFav() {
    data.favoritesProvider.toggleFavorite(course.id);
  }

  @override
  void initState() {
    super.initState();

    data.favoritesProvider.addObserver(this);
    _favorite = data.favoritesProvider.isFavored(course.id);
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    double vw = size.width / 100;

    return new Material(
      child: new InkWell(
          onTap: () {
            Navigator.push(
              context,
              new MaterialPageRoute(
                builder: (context) {
                  return new CourseDetailsScaffold(course);
                },
              ),
            );
          },
          child: new Container(
              child: new Column(children: <Widget>[
                new Row(children: <Widget>[
                  new Expanded(
                      child: new Text(course.name,
                          softWrap: true,
                          overflow: TextOverflow.fade,
                          style: new TextStyle(fontWeight: FontWeight.bold),
                          textScaleFactor: 1.2)),
                  new Container(
                    child: new IconButton(
                        padding: new EdgeInsets.all(0.0),
                        icon: new Icon(
                            _favorite ? Icons.favorite : Icons.favorite_border),
                        iconSize: 9 * vw,
                        color: _favorite ? HEART : Colors.black12,
                        onPressed: () {
                          _toggleFav();
                        }),
                  ),
                ]),
                new Row(children: <Widget>[
                  new Expanded(
                      child: new Container(
                          child: new Text(
                            // TODO adjust to list of time and days
                              course.timeAndDay != null &&
                                      course.timeAndDay[0].day != null &&
                                      course.timeAndDay[0].duration != null
                                  ? course.timeAndDay[0].toDate()
                                  : "Time and Day Unknown",
                              style: new TextStyle(
                                  color: const Color(0xFF707070),
                                  fontWeight: FontWeight.bold,
                                  fontSize: 13.0)),
                          padding: new EdgeInsets.only(bottom: vw * 2.2))),
                ]),
                new Row(children: <Widget>[
                  new Expanded(
                    child: new Align(
                      child: new Text(
                        "Department ${course.department.number.toString().padLeft(2, '0')}",
                        style: new TextStyle(
                          fontWeight: FontWeight.bold,
                          color: new Color(course.department.color)
                        ),
                        textScaleFactor: 1.2,
                      ),
                      alignment: Alignment.centerLeft,
                    ),
                  ),
                  new Container(
                      child: new Align(
                          child: new AvailabilityWidget(course.status)))
                ])
              ]),
              decoration: new BoxDecoration(
                  border: new Border(
                      bottom: new BorderSide(
                          color: new Color(0xFFDDDDDD), width: 1.0))),
              padding: new EdgeInsets.only(
                  left: 3 * vw, top: 0.1 * vw, right: 3 * vw, bottom: 1 * vw))),
    );
  }

  @override
  void onFavoriteToggled() =>
      setState(() => _favorite = data.favoritesProvider.isFavored(course.id));

  @override
  void dispose() {
    super.dispose();
    data.favoritesProvider.removeObserver(this);
  }
}
