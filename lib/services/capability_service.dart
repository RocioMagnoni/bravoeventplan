import 'package:flutter/foundation.dart' show kIsWeb;

class CapabilityService {
  // Returns true if the app is running on the web.
  static bool get isWebApp => kIsWeb;
}
