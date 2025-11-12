import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:confetti/confetti.dart';
import 'package:intl/intl.dart';
import '../../blocs/contador/contador_bloc.dart';
import '../../blocs/contador/contador_event.dart';
import '../../blocs/contador/contador_state.dart';

class ContadorPage extends StatelessWidget {
  const ContadorPage({super.key});

  @override
  Widget build(BuildContext context) {
    context.read<ContadorBloc>().add(LoadContador());
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
        centerTitle: true,
        title: const Text('Bóveda de Johnny', style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold)),
        iconTheme: const IconThemeData(color: Colors.black),
      ),
      body: SafeArea(
        child: Stack(
          alignment: Alignment.topCenter,
          children: [
            BlocConsumer<ContadorBloc, ContadorState>(
              listener: (context, state) {
                if (state is ContadorLoaded) {}
              },
              builder: (context, state) {
                if (state is ContadorLoading || state is ContadorInitial) {
                  return const Center(child: CircularProgressIndicator());
                } else if (state is ContadorLoaded) {
                  return Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16.0),
                    child: Column(
                      children: [
                        const SizedBox(height: 20),
                        _buildTotalGanancias(state.gananciaTotalBruta),
                        const SizedBox(height: 24),
                        _buildManualControls(context, azul),
                        const SizedBox(height: 24), // Increased space
                        _buildHistorialContainer(state, azul), // New container for history
                      ],
                    ),
                  );
                } else if (state is ContadorError) {
                  return Center(child: Text(state.message, style: const TextStyle(color: Colors.red)));
                }
                return const Center(child: Text('Algo salió mal.', style: TextStyle(color: Colors.red)));
              },
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

  Widget _buildTotalGanancias(double total) {
    return Stack(
      alignment: Alignment.center,
      children: [
        Image.asset(
          'assets/images/vault.png', 
          width: 250, 
          height: 250,
          errorBuilder: (context, error, stackTrace) {
            return Container(
              width: 200,
              height: 200,
              decoration: const BoxDecoration(shape: BoxShape.circle, color: Colors.grey),
              child: const Center(child: Icon(Icons.error, color: Colors.red)),
            );
          },
        ),
        Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text('Ganancia Total', 
              style: TextStyle(fontSize: 22, color: Colors.yellow, fontWeight: FontWeight.bold, shadows: [Shadow(blurRadius: 3, color: Colors.black, offset: Offset(2, 2))])
            ),
            const SizedBox(height: 8),
            Text(
              '\$${total.toStringAsFixed(2)}',
              style: const TextStyle(fontSize: 40, color: Colors.yellow, fontWeight: FontWeight.bold, shadows: [Shadow(blurRadius: 4, color: Colors.black, offset: Offset(2, 2))]),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildManualControls(BuildContext context, Color borderColor) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        ElevatedButton(onPressed: () { context.read<ContadorBloc>().add(const AddManualMoney(100)); _confettiController.play(); }, style: ElevatedButton.styleFrom(backgroundColor: Colors.yellow, foregroundColor: Colors.black, side: BorderSide(color: borderColor, width: 2), shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10))), child: const Text('+100')),
        const SizedBox(width: 20),
        ElevatedButton(onPressed: () { context.read<ContadorBloc>().add(const SubtractManualMoney(100)); }, style: ElevatedButton.styleFrom(backgroundColor: Colors.yellow, foregroundColor: Colors.black, side: BorderSide(color: borderColor, width: 2), shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10))), child: const Text('-100')),
      ],
    );
  }

  Widget _buildHistorialContainer(ContadorLoaded state, Color azulColor) {
    return Expanded(
      child: Container(
        decoration: BoxDecoration(
          color: azulColor.withOpacity(0.2),
          borderRadius: BorderRadius.circular(15),
        ),
        padding: const EdgeInsets.all(12),
        child: Column(
          children: [
            const Text('Historial de Eventos', style: TextStyle(color: Colors.yellow, fontSize: 20, fontWeight: FontWeight.bold)),
            const SizedBox(height: 10),
            _buildHistorialList(state),
          ],
        ),
      ),
    );
  }

  Widget _buildHistorialList(ContadorLoaded state) {
    if (state.historialEventos.isEmpty) {
      return const Expanded(child: Center(child: Text('Aún no hay eventos finalizados.', textAlign: TextAlign.center, style: TextStyle(color: Colors.grey, fontSize: 16))));
    }
    return Expanded(
      child: ListView.builder(
        itemCount: state.historialEventos.length,
        itemBuilder: (context, index) {
          final event = state.historialEventos[index];
          return Card(
            color: const Color(0xFF1E3A5F),
            margin: const EdgeInsets.symmetric(vertical: 6),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
            child: ListTile(
              leading: const Icon(Icons.celebration, color: Colors.yellow, size: 30),
              title: Text(event.title, style: const TextStyle(color: Colors.yellow, fontWeight: FontWeight.bold)),
              subtitle: Text('Finalizó: ${DateFormat('dd/MM/yyyy').format(event.endTime)}', style: const TextStyle(color: Colors.white70)),
              trailing: Text('\$${event.totalEarned.toStringAsFixed(2)}', style: const TextStyle(color: Colors.greenAccent, fontSize: 18, fontWeight: FontWeight.bold)),
            ),
          );
        },
      ),
    );
  }
}
