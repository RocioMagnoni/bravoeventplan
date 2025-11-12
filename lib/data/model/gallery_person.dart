import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';

class GalleryPerson extends Equatable {
  final String? id;
  final String name;
  final int age;
  final String location;
  final String socialMedia;
  final String imageUrl;
  final int ranking;
  final String interests;
  final String personalNote;

  const GalleryPerson({
    this.id,
    required this.name,
    required this.age,
    required this.location,
    required this.socialMedia,
    required this.imageUrl,
    this.ranking = 0,
    this.interests = '',
    this.personalNote = '',
  });

  factory GalleryPerson.fromSnapshot(DocumentSnapshot snap) {
    final data = snap.data() as Map<String, dynamic>;
    return GalleryPerson(
      id: snap.id,
      name: data['name'] ?? 'No Name',
      age: data['age'] ?? 0,
      location: data['location'] ?? 'No Location',
      socialMedia: data['socialMedia'] ?? 'No Social Media',
      imageUrl: data['imageUrl'] ?? '',
      ranking: data['ranking'] ?? 0,
      interests: data['interests'] ?? '',
      personalNote: data['personalNote'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'age': age,
      'location': location,
      'socialMedia': socialMedia,
      'imageUrl': imageUrl,
      'ranking': ranking,
      'interests': interests,
      'personalNote': personalNote,
    };
  }

  GalleryPerson copyWith({
    int? ranking,
    String? name,
    int? age,
    String? location,
    String? socialMedia,
    String? imageUrl,
    String? interests,
    String? personalNote,
  }) {
    return GalleryPerson(
      id: id,
      name: name ?? this.name,
      age: age ?? this.age,
      location: location ?? this.location,
      socialMedia: socialMedia ?? this.socialMedia,
      imageUrl: imageUrl ?? this.imageUrl,
      ranking: ranking ?? this.ranking,
      interests: interests ?? this.interests,
      personalNote: personalNote ?? this.personalNote,
    );
  }

  @override
  List<Object?> get props => [
        id, name, age, location, socialMedia, imageUrl, ranking, interests, personalNote
      ];
}
