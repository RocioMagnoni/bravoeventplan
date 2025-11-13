import 'dart:async';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../data/repositories/gallery_repository.dart';
import 'gallery_event.dart';
import 'gallery_state.dart';
import '../../data/model/gallery_person.dart';

class GalleryBloc extends Bloc<GalleryEvent, GalleryState> {
  final GalleryRepository _repository;
  
  GalleryBloc(this._repository) : super(GalleryInitial()) {
    on<LoadGallery>(_onLoadGallery);
    on<AddPerson>(_onAddPerson);
    on<UpdatePerson>(_onUpdatePerson);
    on<DeletePerson>(_onDeletePerson);
    on<UpdateRanking>(_onUpdateRanking, transformer: (events, mapper) => events.asyncExpand(mapper));
  }

  Future<void> _onLoadGallery(LoadGallery event, Emitter<GalleryState> emit) async {
    emit(GalleryLoading());
    await emit.forEach(
      _repository.getPeopleStream(), 
      onData: (people) => GalleryLoaded(people),
      onError: (error, _) => GalleryError(error.toString()),
    );
  }

  Future<void> _onAddPerson(AddPerson event, Emitter<GalleryState> emit) async {
    try {
      await _repository.addPerson(event.person);
    } catch (e) {
      emit(GalleryError("Failed to add person: ${e.toString()}"));
    }
  }

  Future<void> _onUpdatePerson(UpdatePerson event, Emitter<GalleryState> emit) async {
    try {
      await _repository.updatePerson(event.person);
    } catch (e) {
      emit(GalleryError("Failed to update person: ${e.toString()}"));
    }
  }

  Future<void> _onDeletePerson(DeletePerson event, Emitter<GalleryState> emit) async {
    try {
      await _repository.deletePerson(event.personId);
    } catch (e) {
      emit(GalleryError("Failed to delete person: ${e.toString()}"));
    }
  }

  Future<void> _onUpdateRanking(UpdateRanking event, Emitter<GalleryState> emit) async {
    if (state is! GalleryLoaded) return;

    final currentState = state as GalleryLoaded;
    final currentPeople = currentState.people;

    try {
      // First, update the person in the database
      final personToUpdate = event.person;
      final updatedPerson = personToUpdate.copyWith(ranking: personToUpdate.ranking + 1);
      await _repository.updatePerson(updatedPerson);
      
      // The stream will eventually update the list, but for immediate feedback and animation,
      // we manually create the new state.
      final List<GalleryPerson> updatedList = List.from(currentPeople);
      final index = updatedList.indexWhere((p) => p.id == personToUpdate.id);
      if (index != -1) {
        updatedList[index] = updatedPerson;
      }
      
      // Sort the list again to reflect the new order
      updatedList.sort((a, b) => b.ranking.compareTo(a.ranking));

      // Emit the special state to trigger the animation
      emit(GalleryUpdateSuccess(updatedList, personToUpdate.id!));

    } catch (e) {
      emit(GalleryError("Failed to update ranking: ${e.toString()}"));
    }
  }
  
  @override
  Future<void> close() {
    return super.close();
  }
}
