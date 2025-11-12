import 'package:equatable/equatable.dart';
import '../../data/model/gallery_person.dart';

abstract class GalleryState extends Equatable {
  const GalleryState();

  @override
  List<Object> get props => [];
}

// Initial state, before anything is loaded
class GalleryInitial extends GalleryState {}

// State while loading data from the repository
class GalleryLoading extends GalleryState {}

// State when the list of people has been successfully loaded
class GalleryLoaded extends GalleryState {
  final List<GalleryPerson> people;

  const GalleryLoaded(this.people);

  @override
  List<Object> get props => [people];
}

// State when an error occurs
class GalleryError extends GalleryState {
  final String message;

  const GalleryError(this.message);

  @override
  List<Object> get props => [message];
}
