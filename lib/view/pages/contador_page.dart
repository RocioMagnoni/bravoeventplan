import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:confetti/confetti.dart';
import '../../viewmodel/contador_viewmodel.dart';

class ContadorPage extends StatelessWidget {
  const ContadorPage({super.key});

  @override
  Widget build(BuildContext context) {
    return const _ContadorPageView();
  }
}

class _ContadorPageView extends StatefulWidget {
  const _ContadorPageView();

  @override
  State<_ContadorPageView> createState() => _ContadorPageViewState();
}

class _ContadorPageViewState extends State<_ContadorPageView> {
  late ConfettiController _confettiController;

  @override
  void initState() {
    super.initState();
    _confettiController = ConfettiController(duration: const Duration(seconds: 1));
  }

  @override
  void dispose() {
    _confettiController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final azul = const Color(0xFF1E3A5F);

    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.yellow,
        title: const Text(
          'Dinero',
          style: TextStyle(color: Colors.black),
        ),
        leading: Navigator.canPop(context)
            ? IconButton(
                icon: const Icon(Icons.arrow_back, color: Colors.black),
                onPressed: () => Navigator.pop(context),
              )
            : null,
      ),
      body: SafeArea(
        child: Stack(
          alignment: Alignment.topCenter,
          children: [
            Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text('Dinero total 💰', 
                      style: TextStyle(fontSize: 24, color: Colors.yellow)),
                  const SizedBox(height: 20),
                  Consumer<ContadorViewModel>(
                    builder: (context, viewModel, child) {
                      if (viewModel.shouldShowConfetti) {
                        _confettiController.play();
                        viewModel.onConfettiCompleted();
                      }
                      return Text(
                        '\$ ${viewModel.money}',
                        style: const TextStyle(
                          fontSize: 48,
                          color: Colors.yellow,
                          fontWeight: FontWeight.bold,
                        ),
                      );
                    },
                  ),
                  const SizedBox(height: 20),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      ElevatedButton(
                        onPressed: () =>
                            context.read<ContadorViewModel>().addMoney(),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: azul,
                        ),
                        child: const Text('+100'),
                      ),
                      const SizedBox(width: 20),
                      ElevatedButton(
                        onPressed: () =>
                            context.read<ContadorViewModel>().removeMoney(),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: azul,
                        ),
                        child: const Text('-100'),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            ConfettiWidget(
              confettiController: _confettiController,
              blastDirectionality: BlastDirectionality.explosive,
              shouldLoop: false,
              colors: const [Colors.yellow, Colors.blue, Colors.pink, Colors.orange, Colors.purple],
            ),
          ],
        ),
      ),
    );
  }
}
