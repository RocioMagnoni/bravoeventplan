import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:camera/camera.dart';
import 'package:lottie/lottie.dart';
import '../../blocs/mirror/mirror_bloc.dart';
import '../../blocs/mirror/mirror_event.dart';
import '../../blocs/mirror/mirror_state.dart';
import '../widgets/main_drawer.dart';

class MirrorPage extends StatelessWidget {
  const MirrorPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => MirrorBloc()..add(InitializeCamera()),
      child: const _MirrorPageView(),
    );
  }
}

class _MirrorPageView extends StatelessWidget {
  const _MirrorPageView();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.yellow,
        centerTitle: true,
        title: const Text(
          "Espejo",
          style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold)
        ),
        iconTheme: const IconThemeData(color: Colors.black),
      ),
      drawer: const MainDrawer(currentPage: AppPage.mirror), // ⬅️ CORRECTED THIS
      body: BlocBuilder<MirrorBloc, MirrorState>(
        builder: (context, state) {
          if (state is MirrorLoading || state is MirrorInitial) {
            return const Center(child: CircularProgressIndicator());
          } else if (state is MirrorReady) {
            return Center(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Stack(
                  alignment: Alignment.center,
                  children: [
                    Container(
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.yellow, width: 15), // Increased from 10 to 15
                        borderRadius: BorderRadius.circular(20),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.yellow.withOpacity(0.5),
                            blurRadius: 20,
                            spreadRadius: 5,
                          )
                        ]
                      ),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(10),
                        child: CameraPreview(state.controller),
                      ),
                    ),
                    _buildSparkle(top: 20, right: 20),
                  ],
                ),
              ),
            );
          } else if (state is MirrorFailure) {
            return Center(
              child: Text(
                state.error,
                style: const TextStyle(color: Colors.red, fontSize: 18),
                textAlign: TextAlign.center,
              ),
            );
          }
          return const SizedBox.shrink();
        },
      ),
    );
  }

  Widget _buildSparkle({double? top, double? bottom, double? left, double? right}) {
    return Positioned(
      top: top,
      bottom: bottom,
      left: left,
      right: right,
      child: Lottie.asset(
        'assets/animations/sparkles.json',
        width: 80, 
        height: 80,
      ),
    );
  }
}
