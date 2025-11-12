import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flip_card/flip_card.dart';
import 'package:lottie/lottie.dart';
import '../../blocs/gallery/gallery_bloc.dart';
import '../../blocs/gallery/gallery_event.dart';
import '../../blocs/gallery/gallery_state.dart';
import '../../data/model/gallery_person.dart';
import 'new_person_page.dart';
import 'edit_person_page.dart';

class GalleryPage extends StatelessWidget {
  const GalleryPage({super.key});

  void _navigateAndAddPerson(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => const NewPersonPage()),
    );
  }

  @override
  Widget build(BuildContext context) {
    final azul = const Color(0xFF1E3A5F);

    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.yellow,
        centerTitle: true,
        title: const Text(
          'Galería de Chicas Hermosas',
          style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
        ),
        iconTheme: const IconThemeData(color: Colors.black),
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: azul,
        child: const Icon(Icons.add, color: Colors.black),
        onPressed: () => _navigateAndAddPerson(context),
      ),
      body: BlocBuilder<GalleryBloc, GalleryState>(
        builder: (context, state) {
          if (state is GalleryLoading || state is GalleryInitial) {
            return const Center(child: CircularProgressIndicator());
          } else if (state is GalleryLoaded) {
            if (state.people.isEmpty) {
              return const Center(
                child: Text(
                  'No hay nadie en la galería.\n¡Añade a alguien!',
                  textAlign: TextAlign.center,
                  style: TextStyle(color: Colors.yellow, fontSize: 18),
                ),
              );
            }
            return GridView.builder(
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                childAspectRatio: 3 / 4.5,
              ),
              itemCount: state.people.length,
              itemBuilder: (context, index) {
                return FlippablePersonCard(person: state.people[index]);
              },
            );
          } else if (state is GalleryError) {
            return Center(
              child: Text(
                state.message,
                style: const TextStyle(color: Colors.red, fontSize: 18),
              ),
            );
          }
          return const SizedBox.shrink();
        },
      ),
    );
  }
}

class FlippablePersonCard extends StatefulWidget {
  final GalleryPerson person;
  const FlippablePersonCard({super.key, required this.person});

  @override
  State<FlippablePersonCard> createState() => _FlippablePersonCardState();
}

class _FlippablePersonCardState extends State<FlippablePersonCard>
    with SingleTickerProviderStateMixin {
  late final AnimationController _animationController;
  static const double _fireStartFramePercentage = 0.1;
  double _scale = 1.0;

  final _deletePhrases = [
    "¡Adiós, muñeca… el deber llama!",
    "Johnny no llora… solo mira al espejo y sigue adelante.",
  ];

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(vsync: this)
      ..addStatusListener((status) {
        if (status == AnimationStatus.completed) {
          _animationController.value = _fireStartFramePercentage;
        }
      });
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  void _navigateToEditPage(BuildContext context, GalleryPerson person) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => EditPersonPage(person: person)),
    );
  }

  void _showDeleteConfirmation(BuildContext context, GalleryPerson person) {
    showDialog(
      context: context,
      builder: (BuildContext ctx) {
        return AlertDialog(
          title: const Text('Confirmar Borrado'),
          content: Text(
            '¿Estás seguro de que quieres eliminar a ${person.name} de la galería?',
          ),
          actions: <Widget>[
            TextButton(
              onPressed: () => Navigator.of(ctx).pop(),
              child: const Text('Cancelar'),
            ),
            TextButton(
              onPressed: () {
                context.read<GalleryBloc>().add(DeletePerson(person.id!));
                final randomPhrase =
                    _deletePhrases[Random().nextInt(_deletePhrases.length)];
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(
                      randomPhrase,
                      style: const TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    backgroundColor: Colors.red,
                  ),
                );
                Navigator.of(ctx).pop();
              },
              child: const Text('Borrar', style: TextStyle(color: Colors.red)),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final azulJean = const Color(0xFF1E3A5F);

    return AnimatedScale(
      scale: _scale,
      duration: const Duration(milliseconds: 200),
      child: FlipCard(
        onFlip: () {
          setState(() => _scale = 1.05);
        },
        onFlipDone: (isFront) {
          setState(() => _scale = 1.0);
        },
        front: Container(
          margin: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(4.0),
            boxShadow: [
              BoxShadow(
                color: Colors.yellow.withOpacity(0.4),
                blurRadius: 8,
                spreadRadius: 2,
              ),
            ],
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(4.0),
            child: Stack(
              fit: StackFit.expand,
              children: [
                _buildImage(widget.person.imageUrl),
                Positioned(
                  bottom: 8,
                  left: 8,
                  child: GestureDetector(
                    onTap: () {
                      if (_animationController.isAnimating) return;
                      context.read<GalleryBloc>().add(UpdateRanking(widget.person));
                      _animationController.forward(from: _fireStartFramePercentage);
                    },
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                      decoration: BoxDecoration(
                        color: Colors.black.withOpacity(0.6),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Lottie.asset(
                            'assets/animations/fire_animation.json',
                            controller: _animationController,
                            width: 40,
                            height: 40,
                            onLoaded: (composition) {
                              _animationController.duration = composition.duration;
                              _animationController.value = _fireStartFramePercentage;
                            },
                          ),
                          const SizedBox(width: 4),
                          Text(
                            widget.person.ranking.toString(),
                            style: const TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
        back: Card(
          margin: const EdgeInsets.all(8),
          color: Colors.yellow,
          child: Padding(
            padding: const EdgeInsets.all(12.0),
            child: SingleChildScrollView(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        widget.person.name,
                        style: const TextStyle(
                          color: Colors.black,
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const Divider(color: Colors.black, thickness: 1.5),
                      const SizedBox(height: 8),
                      _InfoRow(icon: Icons.cake, text: '${widget.person.age} años'),
                      const SizedBox(height: 8),
                      _InfoRow(icon: Icons.location_on, text: widget.person.location),
                      const SizedBox(height: 8),
                      _InfoRow(icon: Icons.alternate_email, text: widget.person.socialMedia),
                      const SizedBox(height: 8),
                      _InfoRow(icon: Icons.favorite, text: widget.person.interests),
                      const SizedBox(height: 8),
                      _InfoRow(icon: Icons.note, text: widget.person.personalNote),
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      IconButton(
                        icon: Icon(Icons.edit, color: azulJean),
                        onPressed: () => _navigateToEditPage(context, widget.person),
                      ),
                      IconButton(
                        icon: const Icon(Icons.delete, color: Colors.red),
                        onPressed: () => _showDeleteConfirmation(context, widget.person),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildImage(String imageUrl) {
    if (imageUrl.startsWith('http')) {
      return Image.network(
        imageUrl,
        fit: BoxFit.cover,
        errorBuilder: (context, error, stackTrace) =>
            const Icon(Icons.error, color: Colors.red, size: 48),
      );
    } else {
      return Image.asset(imageUrl, fit: BoxFit.cover);
    }
  }
}

class _InfoRow extends StatelessWidget {
  final IconData icon;
  final String text;

  const _InfoRow({required this.icon, required this.text});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(icon, color: Colors.black, size: 20),
        const SizedBox(width: 10),
        Expanded(
          child: Text(
            text,
            style: const TextStyle(color: Colors.black, fontSize: 16),
          ),
        ),
      ],
    );
  }
}
