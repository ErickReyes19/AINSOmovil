// ignore_for_file: avoid_print, unused_local_variable

import 'package:ainso/models/cotizacionCliente.model.dart';
import 'package:ainso/models/cotizacionClienteReporte.model.dart';
import 'package:ainso/services/services.dart';
import '../models/models.dart';

class CotizacionService {
  final database = LocalDataBaseService.db.database;

  /// Método para insertar una nueva cotización con sus ítems
  Future<int> insertarCotizacion(Cotizacion cotizacion) async {
    final db = await database;

    try {
      // Iniciar una transacción batch
      var batch = db.batch();

      // Insertar la cotización y obtener el ID
      int idCotizacion = await db.insert('Cotizacion', {
        'idCliente': cotizacion.cotizacion.idCliente,
        'fecha': cotizacion.cotizacion.fecha.toIso8601String(),
        'total': cotizacion.cotizacion.total,
        'subtotal': cotizacion.cotizacion.subtotal,
        'isv': cotizacion.cotizacion.isv,
        'numeroCotizacion': cotizacion.cotizacion.numeroCotizacion,
        'tipoPago': cotizacion.cotizacion.tipoPago,
        'tipoCotizacion': cotizacion.cotizacion.tipoCotizacion,
      });

      // Insertar los ítems de la cotización en el batch
      for (var item in cotizacion.items) {
        batch.insert('ItemCotizacion', {
          'idCotizacion': idCotizacion,
          'nombre': item.nombre,
          'precio': item.precio,
          'descripcion': item.descripcion,
          'cantidad': item.cantidad,
          'unidad': item.unidad,
          'total': item.total,
        });
      }

      // Ejecutar la transacción
      await batch.commit(noResult: true);

      return idCotizacion;
    } catch (e) {
      print('Error al insertar la cotización: $e');
      return -1;
    }
  }

  /// Método para obtener una cotización por su ID
  Future<CotizacionCliente?> obtenerCotizacionPorId(int idCotizacion) async {
    final db = await database;

    try {
      // Consultar la tabla Cotizacion por ID
      final cotizacionRes = await db.query(
        'Cotizacion',
        where: 'idCotizacion = ?',
        whereArgs: [idCotizacion],
      );

      if (cotizacionRes.isNotEmpty) {
        final cotizacionRow = cotizacionRes.first;

        // Consultar los ítems asociados a esta cotización
        final itemsRes = await db.query(
          'ItemCotizacion',
          where: 'idCotizacion = ?',
          whereArgs: [idCotizacion],
        );
        List<Item> items = itemsRes.map((i) => Item.fromJson(i)).toList();

        // Construir el objeto Cotizacion, que ya contiene la lista de ítems
        Cotizacion cotizacion = Cotizacion(
          cotizacion: CotizacionClass.fromJson(cotizacionRow),
          items: items,
        );

        // Consultar la información del cliente usando el idCliente de la cotización
        final clienteRes = await db.query(
          'Clientes',
          where: 'idCliente = ?',
          whereArgs: [cotizacionRow['idCliente']],
        );

        if (clienteRes.isNotEmpty) {
          Cliente cliente = Cliente.fromJson(clienteRes.first);
          // Retornar el wrapper CotizacionCliente con la cotización (que incluye sus ítems)
          // y el cliente obtenido.
          return CotizacionCliente(cotizacion: cotizacion, cliente: cliente);
        }
      }
    } catch (e) {
      print('Error al obtener cotización: $e');
    }
    return null;
  }

  Future<CotizacionClienteReporte?> getCotizacionesReporteByClienteId(int idCliente) async {
    final db = await database;

    try {
      // 1️⃣ Obtener la información del cliente
      final clienteRes = await db.query(
        'Cli entes',
        where: 'idCliente = ?',
        whereArgs: [idCliente],
      );

      if (clienteRes.isEmpty) return null;

      Cliente cliente = Cliente.fromJson(clienteRes.first);

      // 2️⃣ Obtener todas las cotizaciones del cliente
      final cotizacionesRes = await db.query(
        'Cotizacion',
        where: 'idCliente = ?',
        whereArgs: [idCliente],
      );

      if (cotizacionesRes.isEmpty) {
        return CotizacionClienteReporte(cliente: cliente, cotizaciones: []);
      }

      List<Cotizacion> cotizaciones = [];

      for (var cotizacionRow in cotizacionesRes) {
        int idCotizacion = cotizacionRow['idCotizacion'] as int;

        // 3️⃣ Obtener los ítems de esta cotización
        final itemsRes = await db.query(
          'ItemCotizacion',
          where: 'idCotizacion = ?',
          whereArgs: [idCotizacion],
        );

        List<Item> items = itemsRes.map((i) => Item.fromJson(i)).toList();

        // 4️⃣ Construir la cotización con sus ítems
        Cotizacion cotizacion = Cotizacion(
          cotizacion: CotizacionClass.fromJson(cotizacionRow),
          items: items,
        );

        cotizaciones.add(cotizacion);
      }

      return CotizacionClienteReporte(cliente: cliente, cotizaciones: cotizaciones);
    } catch (e) {
      print('Error al obtener cotizaciones del cliente: $e');
      return null;
    }
  }
  Future<List<CotizacionCliente>> obtenerTodasLasCotizaciones({
    required DateTime fechaDesde,
    required DateTime fechaHasta,
    int? idCliente, // Parámetro opcional; si es 0 se ignora
  }) async {
    final db = await database;
    print(fechaDesde);
    print(fechaHasta);
    print(idCliente);

    try {
      // Convertir las fechas a cadenas en formato 'YYYY-MM-DD'
      String fechaDesdeStr =
          "${fechaDesde.year.toString().padLeft(4, '0')}-${fechaDesde.month.toString().padLeft(2, '0')}-${fechaDesde.day.toString().padLeft(2, '0')}";
      String fechaHastaStr =
          "${fechaHasta.year.toString().padLeft(4, '0')}-${fechaHasta.month.toString().padLeft(2, '0')}-${fechaHasta.day.toString().padLeft(2, '0')}";

      // Construir la cláusula WHERE
      String whereClause = 'fecha BETWEEN ? AND ?';
      List<dynamic> whereArgs = [fechaDesdeStr, fechaHastaStr];

      // Si se proporciona idCliente y es distinto de 0, agregarlo al filtro
      if (idCliente != null && idCliente != 0) {
        whereClause += ' AND idCliente = ?';
        whereArgs.add(idCliente);
      }

      // Obtener las cotizaciones según la cláusula WHERE
      final cotizacionesRes = await db.query(
        'Cotizacion',
        where: whereClause,
        whereArgs: whereArgs,
      );

      List<CotizacionCliente> cotizaciones = [];

      for (var cotizacion in cotizacionesRes) {
        int idCotizacion =
            cotizacion['idCotizacion'] as int; // Forzamos el cast a int

        // Obtener los ítems de la cotización
        final itemsRes = await db.query(
          'ItemCotizacion',
          where: 'idCotizacion = ?',
          whereArgs: [idCotizacion],
        );
        List<Item> items = itemsRes.map((i) => Item.fromJson(i)).toList();

        // Obtener la información del cliente
        final clienteRes = await db.query(
          'Clientes',
          where: 'idCliente = ?',
          whereArgs: [cotizacion['idCliente']],
        );

        Cliente? cliente;
        if (clienteRes.isNotEmpty) {
          cliente = Cliente.fromJson(clienteRes.first);
        }

        // Construir la instancia de Cotizacion y agregarla junto con los ítems y el cliente
        cotizaciones.add(
          CotizacionCliente(
            cotizacion: Cotizacion(
              cotizacion: CotizacionClass.fromJson(cotizacion),
              items: items,
            ),
            cliente: cliente!, // Aseguramos que el cliente no sea nulo
          ),
        );
      }

      print(cotizaciones);
      return cotizaciones;
    } catch (e) {
      print('Error al obtener cotizaciones: $e');
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
      await db.delete(
        'ItemCotizacion',
        where: 'idCotizacion = ?',
        whereArgs: [cotizacion.cotizacion.idCotizacion],
      );
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
      await db.delete(
        'ItemCotizacion',
        where: 'idCotizacion = ?',
        whereArgs: [idCotizacion],
      );

      // Eliminar la cotización
      int count = await db.delete(
        'Cotizacion',
        where: 'idCotizacion = ?',
        whereArgs: [idCotizacion],
      );

      return count; // Retorna la cantidad de filas afectadas
    } catch (e) {
      return -1; // Retorna -1 en caso de error
    }
  }
}
