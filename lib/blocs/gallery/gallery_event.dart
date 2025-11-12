import 'package:equatable/equatable.dart';
import '../../data/model/gallery_person.dart';

abstract class GalleryEvent extends Equatable {
  const GalleryEvent();

  @override
  List<Object> get props => [];
}

class LoadGallery extends GalleryEvent {}

class GalleryUpdated extends GalleryEvent {
  final List<GalleryPerson> people;

  const GalleryUpdated(this.people);

  @override
  List<Object> get props => [people];
}

class AddPerson extends GalleryEvent {
  final GalleryPerson person;

  const AddPerson(this.person);

  @override
  List<Object> get props => [person];
}

class UpdatePerson extends GalleryEvent {
  final GalleryPerson person;

  const UpdatePerson(this.person);

  @override
  List<Object> get props => [person];
}

class DeletePerson extends GalleryEvent {
  final String personId;

  const DeletePerson(this.personId);

  @override
  List<Object> get props => [personId];
}

// Event to update the ranking of a person
class UpdateRanking extends GalleryEvent {
  final GalleryPerson person;

  const UpdateRanking(this.person);

  @override
  List<Object> get props => [person];
}
