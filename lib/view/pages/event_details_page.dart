import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:responsive_magnoni/data/model/event.dart';
import 'package:responsive_magnoni/data/model/guest.dart';
import '../../blocs/events/event_bloc.dart';
import '../../blocs/events/event_event.dart';

class EventDetailsPage extends StatefulWidget {
  final Event event;

  const EventDetailsPage({super.key, required this.event});

  @override
  State<EventDetailsPage> createState() => _EventDetailsPageState();
}

class _EventDetailsPageState extends State<EventDetailsPage> with SingleTickerProviderStateMixin {
  late List<Guest> _guests;
  late AnimationController _animationController;
  double _montoGanadoActual = 0.0;
  int _asistentes = 0;

  @override
  void initState() {
    super.initState();
    _guests = List<Guest>.from(widget.event.guests);
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 700),
    );

    if (widget.event.status == EventStatus.inProgress) {
      _animationController.repeat(reverse: true);
    }

    _recalculateMontoGanado();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  void _recalculateMontoGanado() {
    setState(() {
      _asistentes = _guests.where((g) => g.status == GuestStatus.present).length;
      _montoGanadoActual = _asistentes * widget.event.pricePerGuest;
    });
  }

  void _updateGuestStatus(int index, GuestStatus status) {
    if (widget.event.status != EventStatus.inProgress) return;
    setState(() {
      _guests[index] = _guests[index].copyWith(status: status);
    });
    _recalculateMontoGanado();
  }

  void _saveAttendance() {
    final updatedEvent = widget.event.copyWith(
      guests: _guests,
      totalEarned: _montoGanadoActual,
    );
    
    context.read<EventBloc>().add(UpdateEvent(updatedEvent));
    
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('¡Lista de asistencia actualizada, baby!', style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold)),
        backgroundColor: Colors.yellow,
      ),
    );

    if (DateTime.now().isAfter(widget.event.endTime)) {
        Navigator.of(context).pop();
    }
  }

  @override
  Widget build(BuildContext context) {
    final eventStatus = widget.event.status;
    final azul = const Color(0xFF1E3A5F);

    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.yellow,
        centerTitle: true,
        iconTheme: const IconThemeData(color: Colors.black),
        title: const Text('Detalle del Evento', style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold)),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (widget.event.imageUrl != null && widget.event.imageUrl!.isNotEmpty)
                Padding(
                  padding: const EdgeInsets.only(bottom: 20.0),
                  child: ClipRRect(
                     borderRadius: BorderRadius.circular(15.0),
                     child: Image.network(
                        widget.event.imageUrl!,
                        width: double.infinity,
                        height: 250,
                        fit: BoxFit.cover,
                        errorBuilder: (context, error, stackTrace) =>
                            const Center(child: Icon(Icons.error, color: Colors.red, size: 50)),
                     ),
                  ),
                ),

              // VIP Box for event details
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: azul.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(15),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Text(widget.event.title, textAlign: TextAlign.center, style: const TextStyle(color: Colors.yellow, fontSize: 24, fontWeight: FontWeight.bold)),
                    const SizedBox(height: 15),
                    Text(widget.event.description, textAlign: TextAlign.center, style: const TextStyle(color: Colors.white, fontSize: 16)),
                    const SizedBox(height: 15),
                    Row(children: [ const Icon(Icons.location_on, color: Colors.yellow, size: 18), const SizedBox(width: 8), Expanded(child: Text(widget.event.location, style: const TextStyle(color: Colors.white, fontSize: 16)))]),
                    const SizedBox(height: 15),
                     _buildRichDate('Inicio: ', widget.event.startTime),
                    const SizedBox(height: 5),
                    _buildRichDate('Fin:      ', widget.event.endTime),
                  ],
                ),
              ),

              const Divider(color: Colors.yellow, height: 40, thickness: 1),

              // Financial Info moved up
              _buildFinancialInfo(),

              const SizedBox(height: 20),
              Text(_getTitleForStatus(eventStatus), style: const TextStyle(color: Colors.yellow, fontSize: 18, fontWeight: FontWeight.bold)),
              const SizedBox(height: 10),
              if (_guests.isEmpty)
                const Text('No hay invitados en la lista.', style: TextStyle(color: Colors.grey, fontStyle: FontStyle.italic))
              else
                _buildGuestList(eventStatus),
              const SizedBox(height: 20),
              
              if (eventStatus == EventStatus.inProgress)
                Padding(
                  padding: const EdgeInsets.only(top: 20.0),
                  child: Center(
                    child: ScaleTransition(
                      scale: Tween<double>(begin: 0.95, end: 1.05).animate(_animationController),
                      child: ElevatedButton(
                        onPressed: _saveAttendance,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.yellow,
                          foregroundColor: Colors.black,
                          padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 12),
                          side: BorderSide(color: azul, width: 3),
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18.0)),
                        ),
                        child: const Text('Guardar Asistencia'),
                      ),
                    ),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildRichDate(String label, DateTime date) {
    return RichText(
      text: TextSpan(
        style: const TextStyle(fontSize: 16, fontFamily: 'WurmicsBravo'),
        children: <TextSpan>[
          TextSpan(text: label, style: const TextStyle(color: Colors.yellow, fontWeight: FontWeight.bold)),
          TextSpan(text: DateFormat('dd/MM/yyyy HH:mm').format(date), style: const TextStyle(color: Colors.white)),
        ],
      ),
    );
  }

  Widget _buildFinancialInfo() {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.grey[900],
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        children: [
          _InfoRowFinancial(label: '💵 Valor por invitado:', value: '\$${widget.event.pricePerGuest.toStringAsFixed(2)}'),
          const Divider(color: Colors.yellow),
          _InfoRowFinancial(label: '✅ Asistieron:', value: '$_asistentes / ${_guests.length}'),
          const Divider(color: Colors.yellow),
          _InfoRowFinancial(label: '💰 Monto ganado:', value: '\$${_montoGanadoActual.toStringAsFixed(2)}', isTotal: true),
        ],
      ),
    );
  }

  String _getTitleForStatus(EventStatus status) {
    switch (status) {
      case EventStatus.upcoming: return 'Invitados';
      case EventStatus.inProgress: return 'Control de Asistencia';
      case EventStatus.finished: return 'Veredicto Final';
    }
  }

  Widget _buildGuestList(EventStatus status) {
    return ListView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: _guests.length,
      itemBuilder: (context, index) {
        final guest = _guests[index];
        return Card(
          color: Colors.yellow,
          child: ListTile(
            title: Text(guest.name, style: const TextStyle(color: Colors.black, fontWeight: FontWeight.bold)),
            trailing: AnimatedSwitcher(
              duration: const Duration(milliseconds: 300),
              transitionBuilder: (child, animation) => ScaleTransition(scale: animation, child: child),
              child: _buildGuestTrailing(status, guest, index),
            ),
          ),
        );
      },
    );
  }

  Widget? _buildGuestTrailing(EventStatus status, Guest guest, int index) {
    switch (status) {
      case EventStatus.upcoming:
        return SizedBox(key: ValueKey('upcoming_${guest.name}'));
      case EventStatus.inProgress:
        if (guest.status == GuestStatus.pending) {
          return Row(
            key: ValueKey('pending_${guest.name}'),
            mainAxisSize: MainAxisSize.min,
            children: [
              IconButton(icon: const Icon(Icons.check_circle, color: Colors.green), onPressed: () => _updateGuestStatus(index, GuestStatus.present), tooltip: 'Presente'),
              IconButton(icon: const Icon(Icons.cancel, color: Colors.red), onPressed: () => _updateGuestStatus(index, GuestStatus.absent), tooltip: 'Ausente'),
            ],
          );
        } else {
          return _buildStatusSeal(guest.status, key: ValueKey('sealed_${guest.name}'));
        }
      case EventStatus.finished:
        return _buildStatusSeal(guest.status, key: ValueKey('finished_${guest.name}'));
    }
  }

  Widget _buildStatusSeal(GuestStatus status, {Key? key}) {
    Color backgroundColor; IconData iconData;
    switch (status) {
      case GuestStatus.present: backgroundColor = Colors.green; iconData = Icons.check; break;
      case GuestStatus.absent: backgroundColor = Colors.red; iconData = Icons.close; break;
      case GuestStatus.pending: return SizedBox(key: key);
    }
    return Container(
      key: key,
      padding: const EdgeInsets.all(4.0),
      decoration: BoxDecoration(color: backgroundColor, borderRadius: BorderRadius.circular(5)),
      child: Icon(iconData, color: Colors.white, size: 20),
    );
  }
}

class _InfoRowFinancial extends StatelessWidget {
  final String label;
  final String value;
  final bool isTotal;

  const _InfoRowFinancial({required this.label, required this.value, this.isTotal = false});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: const TextStyle(color: Colors.yellow, fontSize: 16, fontWeight: FontWeight.bold)),
          Text(
            value,
            style: TextStyle(
              color: isTotal ? Colors.green : Colors.white,
              fontSize: isTotal ? 20 : 16,
              fontWeight: FontWeight.bold
            ),
          ),
        ],
      ),
    );
  }
}
