import 'dart:async';
import 'package:bloc/bloc.dart';
import '../../data/model/gallery_person.dart';
import '../../data/repositories/gallery_repository.dart';
import 'gallery_event.dart';
import 'gallery_state.dart';

class GalleryBloc extends Bloc<GalleryEvent, GalleryState> {
  final GalleryRepository _galleryRepository;
  StreamSubscription? _gallerySubscription;

  GalleryBloc(this._galleryRepository) : super(GalleryInitial()) {
    on<LoadGallery>(_onLoadGallery);
    on<GalleryUpdated>(_onGalleryUpdated);
    on<AddPerson>(_onAddPerson);
    on<UpdatePerson>(_onUpdatePerson);
    on<DeletePerson>(_onDeletePerson);
    on<UpdateRanking>(_onUpdateRanking); // Register the new event handler
  }

  void _onLoadGallery(LoadGallery event, Emitter<GalleryState> emit) {
    emit(GalleryLoading());
    _gallerySubscription?.cancel();
    _gallerySubscription = _galleryRepository.getPeopleStream().listen(
          (people) => add(GalleryUpdated(people)),
        );
  }

  void _onGalleryUpdated(GalleryUpdated event, Emitter<GalleryState> emit) {
    // Sort the list by ranking before emitting the state
    final sortedPeople = List<GalleryPerson>.from(event.people)
      ..sort((a, b) => b.ranking.compareTo(a.ranking));
    emit(GalleryLoaded(sortedPeople));
  }

  void _onAddPerson(AddPerson event, Emitter<GalleryState> emit) {
    _galleryRepository.addPerson(event.person);
  }

  void _onUpdatePerson(UpdatePerson event, Emitter<GalleryState> emit) {
    _galleryRepository.updatePerson(event.person);
  }

  void _onDeletePerson(DeletePerson event, Emitter<GalleryState> emit) {
    _galleryRepository.deletePerson(event.personId);
  }

  void _onUpdateRanking(UpdateRanking event, Emitter<GalleryState> emit) {
    final updatedPerson = event.person.copyWith(ranking: event.person.ranking + 1);
    _galleryRepository.updatePerson(updatedPerson);
  }

  @override
  Future<void> close() {
    _gallerySubscription?.cancel();
    return super.close();
  }
}
