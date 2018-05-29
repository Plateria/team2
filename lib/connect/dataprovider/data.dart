import 'package:courses_in_english/connect/dataprovider/campus/campus_provider.dart';
import 'package:courses_in_english/connect/dataprovider/course/course_provider.dart';
import 'package:courses_in_english/connect/dataprovider/course/selection_provider.dart';
import 'package:courses_in_english/connect/dataprovider/department/department_provider.dart';
import 'package:courses_in_english/connect/dataprovider/favorites/favorites_provider.dart';
import 'package:courses_in_english/connect/dataprovider/lecturer/lecturer_provider.dart';
import 'package:courses_in_english/connect/dataprovider/mock_provider_factory.dart';
import 'package:courses_in_english/connect/dataprovider/provider_factory.dart';
import 'package:courses_in_english/connect/dataprovider/user/user_provider.dart';
import 'package:courses_in_english/connect/dataprovider/user/user_settings_provider.dart';

/// Where to get all data from!
class Data {
  /// Singleton instance
  static final Data _instance = new Data._internal(new MockProviderFactory());

  CourseProvider courseProvider;
  SelectionProvider selectionProvider;
  DepartmentProvider departmentProvider;
  LecturerProvider lecturerProvider;
  UserProvider userProvider;
  FavoritesProvider favoritesProvider;
  CampusProvider campusProvider;
  UserSettingsProvider settingsProvider;

  /// Singleton factory
  factory Data() {
    return _instance;
  }

  /// Private default constructor
  Data._internal(ProviderFactory providerFactory)
      : courseProvider = providerFactory.createCourseProvider(),
        selectionProvider = providerFactory.createSelectionProvider(),
        departmentProvider = providerFactory.createDepartmentProvider(),
        lecturerProvider = providerFactory.createLecturerProvider(),
        userProvider = providerFactory.createUserProvider(),
        favoritesProvider = providerFactory.createFavoritesProvider(),
        campusProvider = providerFactory.createCampusProvider(),
        settingsProvider = providerFactory.createSettingsProvider();
}
