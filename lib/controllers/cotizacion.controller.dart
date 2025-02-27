
import 'package:ainso/providers/providers.dart';
import 'package:ainso/services/services.dart';
import 'package:flutter/material.dart';
import 'package:ainso/models/models.dart';
import 'package:provider/provider.dart';
import '../globals/widgets/widgets.dart';

class CotizacionController {
  final service = CotizacionService();

  // Método para insertar una nueva cotización
  Future<bool> insertarCotizacion(Cotizacion cotizacion, BuildContext context) async {
    final provider = Provider.of<CotizacionProvider>(context, listen: false);
    try {
      provider.loading = true;
      int idCotizacion = await service.insertarCotizacion(cotizacion);

      if (idCotizacion != -1) {
        provider.cotizaciones.add(cotizacion); // Agregar la nueva cotización al provider
        provider.loading = false;
        sncackbarGlobal('Cotización agregada con éxito.', color: Colors.green);
        return true;
      } else {
        provider.loading = false;
        sncackbarGlobal('Error al agregar la cotización.', color: Colors.red);
        return false;
      }
    } catch (e) {
      provider.loading = false;
      sncackbarGlobal('Error al agregar la cotización.', color: Colors.red);
      return false;
    }
  }

  // Método para obtener todas las cotizaciones
  Future<bool> obtenerCotizaciones(BuildContext context) async {
    final provider = Provider.of<CotizacionProvider>(context, listen: false);
    try {
      provider.loading = true;
      List<Cotizacion> cotizaciones = await service.obtenerTodasLasCotizaciones();
      provider.cotizaciones = cotizaciones;
      provider.loading = false;
      return true;
    } catch (e) {
      provider.loading = false;
      provider.cotizaciones = [];
      return false;
    }
  }

  // Método para obtener una cotización por su ID
  Future<bool> obtenerCotizacionPorId(int idCotizacion, BuildContext context) async {
    final provider = Provider.of<CotizacionProvider>(context, listen: false);
    try {
      provider.loading = true;
      Cotizacion? cotizacion = await service.obtenerCotizacionPorId(idCotizacion);
      
      if (cotizacion != null) {
        provider.cotizacion = cotizacion;
        provider.loading = false;
        return true;
      } else {
        provider.loading = false;
        return false;
      }
    } catch (e) {
      provider.loading = false;
      provider.cotizacion = null;
      return false;
    }
  }

  // Método para editar una cotización
  Future<bool> editarCotizacion(Cotizacion cotizacion, BuildContext context) async {
    final provider = Provider.of<CotizacionProvider>(context, listen: false);
    try {
      provider.loading = true;
      int result = await service.editarCotizacion(cotizacion);

      if (result > 0) {
        // Actualiza la cotización en el provider
        provider.cotizacion = cotizacion;
        sncackbarGlobal('Cotización actualizada con éxito.', color: Colors.green);
        provider.loading = false;
        return true;
      } else {
        provider.loading = false;
        sncackbarGlobal('Error al actualizar la cotización.', color: Colors.red);
        return false;
      }
    } catch (e) {
      provider.loading = false;
      sncackbarGlobal('Error al editar la cotización.', color: Colors.red);
      return false;
    }
  }

  // Método para eliminar una cotización
  Future<bool> eliminarCotizacion(int idCotizacion, BuildContext context) async {
    final provider = Provider.of<CotizacionProvider>(context, listen: false);
    try {
      provider.loading = true;
      int result = await service.eliminarCotizacion(idCotizacion);

      if (result > 0) {
        // Elimina la cotización de la lista en el provider
        provider.cotizaciones.removeWhere((cot) => cot.cotizacion.idCotizacion == idCotizacion);
        sncackbarGlobal('Cotización eliminada con éxito.', color: Colors.green);
        provider.loading = false;
        return true;
      } else {
        provider.loading = false;
        sncackbarGlobal('Error al eliminar la cotización.', color: Colors.red);
        return false;
      }
    } catch (e) {
      provider.loading = false;
      sncackbarGlobal('Error al eliminar la cotización.', color: Colors.red);
      return false;
    }
  }
}
