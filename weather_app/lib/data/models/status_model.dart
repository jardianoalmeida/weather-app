import '../../domain/domain.dart';

class StatusModel {
  final String description;
  final String image;

  StatusModel({required this.description, required this.image});

  factory StatusModel.fromJson(Map<String, dynamic> map) {
    return StatusModel(
      description: map['text'] ?? '',
      image: map['icon'],
    );
  }

  Status toEntity() {
    return Status(
      description: description,
      image: 'https:$image',
    );
  }
}
