import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:camera/camera.dart';
import '../../viewmodel/mirror_viewmodel.dart';

class MirrorPage extends StatelessWidget {
  const MirrorPage({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => MirrorViewModel(),
      child: const _MirrorPageView(),
    );
  }
}

class _MirrorPageView extends StatelessWidget {
  const _MirrorPageView();

  @override
  Widget build(BuildContext context) {
    final viewModel = context.watch<MirrorViewModel>();

    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.yellow,
        title: const Text("Espejo", style: TextStyle(color: Colors.black)),
        leading: Navigator.canPop(context)
            ? IconButton(
                icon: const Icon(Icons.arrow_back, color: Colors.black),
                onPressed: () => Navigator.pop(context),
              )
            : null,
      ),
      body: Builder(
        builder: (context) {
          if (viewModel.isUnsupported) {
            return const Center(
              child: Text(
                "Cámara no disponible en esta plataforma.",
                style: TextStyle(color: Colors.yellow, fontSize: 20),
              ),
            );
          }

          if (viewModel.initializeControllerFuture == null) {
            return const Center(child: CircularProgressIndicator());
          }

          return FutureBuilder<void>(
            future: viewModel.initializeControllerFuture,
            builder: (context, snapshot) {
              if (snapshot.connectionState != ConnectionState.done) {
                return const Center(child: CircularProgressIndicator());
              }

              final controller = viewModel.controller;

              if (controller == null || !controller.value.isInitialized) {
                return const Center(
                  child: Text(
                    "Error al inicializar la cámara.",
                    style: TextStyle(color: Colors.red, fontSize: 20),
                  ),
                );
              }

              return CameraPreview(controller);
            },
          );
        },
      ),
    );
  }
}
