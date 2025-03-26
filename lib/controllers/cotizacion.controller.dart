
import 'package:ainso/models/cotizacionCliente.model.dart';
import 'package:ainso/models/cotizacionClienteReporte.model.dart';
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
  
  provider.loading = true; // Activar el estado de carga
  
  try {
    int idCotizacion = await service.insertarCotizacion(cotizacion);

    if (idCotizacion != -1) {
      sncackbarGlobal('Cotización agregada con éxito.', color: Colors.green);
      return true;
    } 

    sncackbarGlobal('Error al agregar la cotización.', color: Colors.red);
    return false;

  } catch (e) {
    // Log para depuración
    sncackbarGlobal('Error al agregar la cotización.', color: Colors.red);
    return false;

  } finally {
    provider.loading = false; // Asegurar que loading se desactive siempre
  }
}


  // Método para obtener todas las cotizaciones
  Future<bool> obtenerCotizaciones(BuildContext context, DateTime fechaDesde,DateTime fechaHasta) async {
    final provider = Provider.of<CotizacionProvider>(context, listen: false);
        final clienteProvider =
        Provider.of<ClientesProvider>(context, listen: false);
    try {
      provider.loading = true;
      List<CotizacionCliente> cotizaciones = await service.obtenerTodasLasCotizaciones(fechaDesde: fechaDesde, fechaHasta: fechaHasta, idCliente: clienteProvider.idClienteSelected);
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
      CotizacionCliente? cotizacion = await service.obtenerCotizacionPorId(idCotizacion);
      if (cotizacion != null) {
        provider.cotizacionCliente = cotizacion;
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
  Future<bool> obtenerCotizacionReportePorClienteId(int idCotizacion, BuildContext context) async {
    final provider = Provider.of<CotizacionProvider>(context, listen: false);
    print( "idCotizacion");
    print( idCotizacion);
    try {
      provider.loading = true;
      CotizacionClienteReporte? cotizacion = await service.getCotizacionesReporteByClienteId(idCotizacion);
      if (cotizacion != null) {
        provider.cotizacionClienteReporte = cotizacion;
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

}
