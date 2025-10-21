import 'dart:io' show Platform;

class Policy {
  // Determina si se permite abrir enlaces externos (ej: compras)
  bool shouldAllowExternalLinks() {
    // No se permite en iOS según las reglas de la App Store
    return !Platform.isIOS;
  }
}
