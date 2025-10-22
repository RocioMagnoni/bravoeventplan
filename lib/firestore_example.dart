import 'package:cloud_firestore/cloud_firestore.dart';

class FirestoreExample {
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  // CREATE - Agregar un documento
  Future<String> agregarProducto(String nombre, double precio, int stock) async {
    try {
      DocumentReference docRef = await _db.collection('productos').add({
        'nombre': nombre,
        'precio': precio,
        'stock': stock,
        'fechaCreacion': FieldValue.serverTimestamp(),
      });
      print('✅ Producto agregado con ID: ${docRef.id}');
      return docRef.id;
    } catch (e) {
      print('❌ Error al agregar producto: $e');
      return '';
    }
  }

  // READ - Leer todos los documentos
  Future<void> obtenerTodosLosProductos() async {
    try {
      QuerySnapshot snapshot = await _db.collection('productos').get();
      print('📦 Total de productos: ${snapshot.docs.length}');
      for (var doc in snapshot.docs) {
        Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
        print('${doc.id}: ${data['nombre']} - \$${data['precio']}');
      }
    } catch (e) {
      print('❌ Error al obtener productos: $e');
    }
  }

  // READ - Leer un documento específico
  Future<Map<String, dynamic>?> obtenerProducto(String productoId) async {
    try {
      DocumentSnapshot doc =
      await _db.collection('productos').doc(productoId).get();

      if (doc.exists) {
        return doc.data() as Map<String, dynamic>;
      } else {
        print('⚠️ El producto no existe');
        return null;
      }
    } catch (e) {
      print('❌ Error al obtener producto: $e');
      return null;
    }
  }

  // UPDATE - Actualizar un documento
  Future<void> actualizarStock(String productoId, int nuevoStock) async {
    try {
      await _db.collection('productos').doc(productoId).update({
        'stock': nuevoStock,
        'fechaActualizacion': FieldValue.serverTimestamp(),
      });
      print('✅ Stock actualizado exitosamente');
    } catch (e) {
      print('❌ Error al actualizar stock: $e');
    }
  }

  // DELETE - Eliminar un documento
  Future<void> eliminarProducto(String productoId) async {
    try {
      await _db.collection('productos').doc(productoId).delete();
      print('🗑️ Producto eliminado exitosamente');
    } catch (e) {
      print('❌ Error al eliminar producto: $e');
    }
  }

  // REALTIME - Escuchar cambios en tiempo real
  Stream<QuerySnapshot> escucharProductos() {
    return _db
        .collection('productos')
        .orderBy('fechaCreacion', descending: true)
        .snapshots();
  }

  // QUERY - Consulta con filtros
  Future<void> buscarProductosBaratos() async {
    try {
      QuerySnapshot snapshot = await _db
          .collection('productos')
          .where('precio', isLessThan: 100)
          .where('stock', isGreaterThan: 0)
          .get();

      print('💰 Productos baratos en stock: ${snapshot.docs.length}');
      for (var doc in snapshot.docs) {
        Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
        print(
            '${data['nombre']}: \$${data['precio']} (Stock: ${data['stock']})');
      }
    } catch (e) {
      print('❌ Error en búsqueda: $e');
    }
  }
}
