import 'package:ainso/services/services.dart';
import '../models/models.dart';

class CotizacionService {
  final database = LocalDataBaseService.db.database;

  /// Método para insertar una nueva cotización con sus ítems
  Future<int> insertarCotizacion(Cotizacion cotizacion) async {
    final db = await database;

    try {
      // Insertar la cotización
      final idCotizacion = await db.insert('Cotizacion', {
        'idCliente': cotizacion.cotizacion.idCliente,
        'fecha': cotizacion.cotizacion.fecha.toIso8601String(),
        'total': cotizacion.cotizacion.total,
        'subtotal': cotizacion.cotizacion.subtotal,
        'isv': cotizacion.cotizacion.isv,
        'numeroCotizacion': cotizacion.cotizacion.numeroCotizacion,
        'tipoPago': cotizacion.cotizacion.tipoPago,
        'tipoCotizacion': cotizacion.cotizacion.tipoCotizacion,
      });

      // Insertar los ítems de la cotización
      for (var item in cotizacion.items) {
        await db.insert('ItemCotizacion', {
          'idCotizacion': idCotizacion,
          'nombre': item.nombre,
          'precio': item.precio,
          'descripcion': item.descripcion,
          'cantidad': item.cantidad,
          'unidad': item.unidad,
          'total': item.total,
        });
      }

      return idCotizacion; // Retorna el ID de la cotización insertada
    } catch (e) {
      // ignore: avoid_print
      print('Error al insertar la cotización: $e');
      return -1; // En caso de error, retorna -1
    }
  }

  /// Método para obtener una cotización por su ID
  Future<Cotizacion?> obtenerCotizacionPorId(int idCotizacion) async {
    final db = await database;

    try {
      // Obtener la cotización
      final cotizacionRes = await db.query('Cotizacion', where: 'idCotizacion = ?', whereArgs: [idCotizacion]);

      if (cotizacionRes.isNotEmpty) {
        var cotizacion = cotizacionRes.first;

        // Obtener los ítems de la cotización
        final itemsRes = await db.query(
          'ItemCotizacion',
          where: 'idCotizacion = ?',
          whereArgs: [idCotizacion],
        );
        List<Item> items = itemsRes.map((i) => Item.fromJson(i)).toList();

        return Cotizacion(
          cotizacion: CotizacionClass.fromJson(cotizacion),
          items: items,
        );
      }
    // ignore: empty_catches
    } catch (e) {
    }

    return null; // Retorna null si no se encuentra la cotización
  }

  /// Método para obtener todas las cotizaciones
  Future<List<Cotizacion>> obtenerTodasLasCotizaciones() async {
    final db = await database;

    try {
      // Obtener todas las cotizaciones
      final cotizacionesRes = await db.query('Cotizacion');

      List<Cotizacion> cotizaciones = [];

      for (var cotizacion in cotizacionesRes) {
        // Para cada cotización, obtenemos sus ítems
        int idCotizacion = cotizacion['idCotizacion'] as int;

        final itemsRes = await db.query(
          'ItemCotizacion',
          where: 'idCotizacion = ?',
          whereArgs: [idCotizacion],
        );
        List<Item> items = itemsRes.map((i) => Item.fromJson(i)).toList();

        cotizaciones.add(Cotizacion(
          cotizacion: CotizacionClass.fromJson(cotizacion),
          items: items,
        ));
      }

      return cotizaciones;
    } catch (e) {
      return []; // Retorna una lista vacía en caso de error
    }
  }

  /// Método para editar una cotización
  Future<int> editarCotizacion(Cotizacion cotizacion) async {
    final db = await database;

    try {
      // Actualizar la cotización
      int count = await db.update(
        'Cotizacion',
        {
          'idCliente': cotizacion.cotizacion.idCliente,
          'fecha': cotizacion.cotizacion.fecha.toIso8601String(),
          'total': cotizacion.cotizacion.total,
          'subtotal': cotizacion.cotizacion.subtotal,
          'isv': cotizacion.cotizacion.isv,
          'numeroCotizacion': cotizacion.cotizacion.numeroCotizacion,
          'tipoPago': cotizacion.cotizacion.tipoPago,
          'tipoCotizacion': cotizacion.cotizacion.tipoCotizacion,
        },
        where: 'idCotizacion = ?',
        whereArgs: [cotizacion.cotizacion.idCotizacion],
      );

      // Eliminar los ítems anteriores y reinserta los nuevos
      await db.delete('ItemCotizacion', where: 'idCotizacion = ?', whereArgs: [cotizacion.cotizacion.idCotizacion]);
      for (var item in cotizacion.items) {
        await db.insert('ItemCotizacion', {
          'idCotizacion': cotizacion.cotizacion.idCotizacion,
          'nombre': item.nombre,
          'precio': item.precio,
          'descripcion': item.descripcion,
          'cantidad': item.cantidad,
          'unidad': item.unidad,
          'total': item.total,
        });
      }

      return count; // Retorna la cantidad de filas afectadas
    } catch (e) {
      return -1; // Retorna -1 en caso de error
    }
  }

  /// Método para eliminar una cotización por su ID
  Future<int> eliminarCotizacion(int idCotizacion) async {
    final db = await database;

    try {
      // Eliminar los ítems de la cotización
      await db.delete('ItemCotizacion', where: 'idCotizacion = ?', whereArgs: [idCotizacion]);

      // Eliminar la cotización
      int count = await db.delete('Cotizacion', where: 'idCotizacion = ?', whereArgs: [idCotizacion]);

      return count; // Retorna la cantidad de filas afectadas
    } catch (e) {
      return -1; // Retorna -1 en caso de error
    }
  }
}
