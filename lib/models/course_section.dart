class CourseSection {
  final String id;
  final String title;
  final int order;

  CourseSection({
    required this.id,
    required this.title,
    required this.order,
  });

  factory CourseSection.fromJson(Map<String, dynamic> json) => CourseSection(
        id: json['id'] as String,
        title: json['title'] as String,
        order: (json['order'] as num?)?.toInt() ?? 0,
      );

  Map<String, dynamic> toJson() => {
        'id': id,
        'title': title,
        'order': order,
      };

  CourseSection copyWith({String? id, String? title, int? order}) => CourseSection(
        id: id ?? this.id,
        title: title ?? this.title,
        order: order ?? this.order,
      );
}