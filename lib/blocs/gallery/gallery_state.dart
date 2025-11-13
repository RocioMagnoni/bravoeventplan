import 'package:equatable/equatable.dart';
import '../../data/model/gallery_person.dart';

abstract class GalleryState extends Equatable {
  const GalleryState();

  @override
  List<Object?> get props => [];
}

class GalleryInitial extends GalleryState {}

class GalleryLoading extends GalleryState {}

class GalleryLoaded extends GalleryState {
  final List<GalleryPerson> people;

  const GalleryLoaded(this.people);

  @override
  List<Object?> get props => [people, identityHashCode(this)]; // Add identity to distinguish instances
}

// This state is emitted specifically to trigger an animation.
class GalleryUpdateSuccess extends GalleryLoaded {
  final String updatedPersonId;

  const GalleryUpdateSuccess(List<GalleryPerson> people, this.updatedPersonId) 
      : super(people);

  @override
  List<Object?> get props => [people, updatedPersonId];
}

class GalleryError extends GalleryState {
  final String message;

  const GalleryError(this.message);

  @override
  List<Object> get props => [message];
}
