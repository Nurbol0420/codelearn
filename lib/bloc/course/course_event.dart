
abstract class CourseEvent {}

class LoadCourses extends CourseEvent {
  final String? categoryID;

  LoadCourses({this.categoryID});
}

class LoadCourseDetail extends CourseEvent {
  final String courseId;

  LoadCourseDetail(this.courseId);
}

class RefreshCoursesDetail extends CourseEvent {
  final String courseId;

  RefreshCoursesDetail(this.courseId);
}

class EnrollCourse extends CourseEvent {
  final String courseId;

  EnrollCourse(this.courseId);
}

class LoadEnrolledCourses extends CourseEvent {}

class DownloadCourse extends CourseEvent {
  final String courseId;

  DownloadCourse(this.courseId);
}

class LoadOfflineCourses extends CourseEvent {}

class UpdateCourse extends CourseEvent {
  final String instructorID;

  UpdateCourse(this.instructorID);
}

class DeleteCourse extends CourseEvent {
  final String courseId;

  DeleteCourse(this.courseId);
}