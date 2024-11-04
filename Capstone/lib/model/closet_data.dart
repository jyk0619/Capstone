class ClosetData {
  final String patternCategory;  // 패턴 카테고리
  final String className;        // 클래스 이름
  final int classId;            // 클래스 ID
  final String category;         // 카테고리
  final String colorPalette;     // 색상 팔레트
  final String colorName;        // 색상 이름
  final int patternId;           // 패턴 ID

  ClosetData({
    required this.patternCategory,
    required this.className,
    required this.classId,
    required this.category,
    required this.colorPalette,
    required this.colorName,
    required this.patternId,
  });

  factory ClosetData.fromJson(Map<String, dynamic> json) {
    return ClosetData(
      patternCategory: json['classification'][0]['pattern_category'],
      className: json['classification'][1]['class'],
      classId: json['classification'][1]['class_id'],
      category: json['classification'][1]['category'],
      colorPalette: json['classification'][1]['color_palette'],
      colorName: json['classification'][1]['color_name'],
      patternId: json['classification'][0]['pattern_id'],
    );
  }
}
