import 'dart:io' show Platform;

class Capability {
  // Simula si se necesita pedir permisos antes de acceder a una función (ej: cámara o API)
  bool requirePermissionDialog() {
    if (Platform.isIOS) return true;
    if (Platform.isAndroid) {
      // Simulación: versiones nuevas de Android requieren permisos explícitos
      return true;
    }
    return false;
  }

  // Detecta si la cámara está disponible
  bool hasCamera() {
    return Platform.isAndroid || Platform.isIOS;
  }
}
