import 'package:courses_in_english/connect/dataprovider/data.dart';
import 'package:courses_in_english/model/campus/campus.dart';
import 'package:courses_in_english/model/course/course.dart';
import 'package:courses_in_english/model/department/department.dart';
import 'package:courses_in_english/model/lecturer/lecturer.dart';
import 'package:courses_in_english/model/user/user.dart';
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:firebase_analytics/observer.dart';
import 'package:firebase_messaging/firebase_messaging.dart';

typedef void OnSuccess(Session s);
typedef void OnDataChanged(Session s);
typedef void OnFailure(Session s, Error e);

class Session {
  // Singleton
  static final _instance = new Session._internal();

  factory Session() => _instance;

  Session._internal() {
    if (_firebaseMessaging == null) {
      _initializeFirebaseMessaging();
    }
    if (_firebaseAnalytics == null) {
      _initializeFirebaseAnalytics();
    }
  }

  FirebaseAnalytics _firebaseAnalytics;
  FirebaseMessaging _firebaseMessaging;
  FirebaseAnalyticsObserver _firebaseObserver;
  final Data data = new Data();
  final List<OnDataChanged> callbacks = [];

  User _user;
  Iterable<Campus> _campuses;
  Iterable<Department> _departments;
  Iterable<Lecturer> _lecturers;
  Iterable<Course> _courses;
  Iterable<Course> _favorites;
  Iterable<Course> _selected;

  void login(
    String email,
    String password, {
    OnSuccess success,
    OnFailure failure,
  }) async {
    await data.userProvider.login(email, password).then(
      (user) {
        _user = user;
        // TODO save user to cache
        success(this);
      },
      onError: (Error e) => failure(this, e),
    );
  }

  void download({OnFailure failure}) async {
    bool successful = true;
    _campuses = await data.campusProvider.getCampuses().catchError(
      (error) {
        successful = false;
        if (failure != null) failure(this, error);
      },
    );
    _departments = await data.departmentProvider.getDepartments().catchError(
      (error) {
        successful = false;
        if (failure != null) failure(this, error);
      },
    );
    _lecturers = await data.lecturerProvider.getLecturers().catchError(
      (error) {
        successful = false;
        if (failure != null) failure(this, error);
      },
    );
    _courses = await data.courseProvider.getCourses().catchError(
      (error) {
        successful = false;
        if (failure != null) failure(this, error);
      },
    );
    _favorites = await data.courseProvider.getFavorizedCourses().catchError(
      (error) {
        successful = false;
        if (failure != null) failure(this, error);
      },
    );
    _selected = await data.courseProvider.getSelectedCourses().catchError(
      (error) {
        successful = false;
        if (failure != null) failure(this, error);
      },
    );
    if (successful) {
      // TODO save downloaded data to cache
      callbacks.forEach((callback) => callback(this));
    }
  }

  void favorize(Course c, {OnSuccess success, OnFailure failure}) async {
    bool successful = true;
    _favorites = await data.courseProvider.favorizeCourse(c).then((_) {
      return data.courseProvider.getFavorizedCourses();
    }).catchError((error) {
      successful = false;
      if (failure != null) failure(this, error);
    }).whenComplete(() {
      if (success != null) success(this);
    });
    if (successful) callbacks.forEach((callback) => callback(this));
  }

  void unfavorize(Course c, {OnSuccess success, OnFailure failure}) async {
    bool successful = true;
    _favorites = await data.courseProvider.unFavorizeCourse(c).then((_) {
      return data.courseProvider.getFavorizedCourses();
    }).catchError((error) {
      successful = false;
      if (failure != null) failure(this, error);
    }).whenComplete(() {
      if (success != null) success(this);
    });
    if (successful) callbacks.forEach((callback) => callback(this));
  }

  void select(Course c, {OnSuccess success, OnFailure failure}) async {
    // TODO to be implemented
    throw new UnimplementedError();
  }

  void deselect(Course c, {OnSuccess success, OnFailure failure}) async {
    // TODO to be implemented
    throw new UnimplementedError();
  }

  void subscribeToTopic(String topic) {
    _firebaseMessaging.subscribeToTopic(topic);
  }

  void unsubscribeFromTopic(String topic) {
    _firebaseMessaging.unsubscribeFromTopic(topic);
  }

  /// Initializes our Firebase Instance (we don't really need it in the other classes, but I thought it would be nice to have it at a central place
  void _initializeFirebaseMessaging() {
    _firebaseMessaging = new FirebaseMessaging();
    _firebaseMessaging.configure(
      ///Fires on notification message if the app is active. Fires on data messages when app is in background (Android, iOS)
      onMessage: (Map<String, dynamic> message) {
        print("onMessage: $message");
      },

      ///Fires on notification message if the app is in the background (Android only)
      onLaunch: (Map<String, dynamic> message) {
        print("onLaunch: $message");
      },

      ///Fires if app is opened from notification (Android only)
      onResume: (Map<String, dynamic> message) {
        print("onResume: $message");
      },
    );
    _firebaseMessaging.requestNotificationPermissions(
        const IosNotificationSettings(sound: true, badge: true, alert: true));
    _firebaseMessaging.getToken().then((String token) {
      //Todo do we need the user-token?
    });
    _firebaseMessaging.getToken().then((token) {});
    _firebaseMessaging.subscribeToTopic("all");
  }

  /// Initialized our Firebase Analytics instance. As we need this more often, it's good to have it in the session.
  void _initializeFirebaseAnalytics() {
    _firebaseAnalytics = new FirebaseAnalytics();
    _firebaseObserver =
        new FirebaseAnalyticsObserver(analytics: _firebaseAnalytics);
    _firebaseAnalytics.logAppOpen();
  }

  get user => _user;

  get campuses => _campuses;

  get departments => _departments;

  get lecturers => _lecturers;

  get courses => _courses;

  get favorites => _favorites;

  get selected => _selected;

  get observer => _firebaseObserver;
}
