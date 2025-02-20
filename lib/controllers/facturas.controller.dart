// ignore_for_file: avoid_print

import 'package:accesorios_industriales_sosa/models/factura.model.dart';
import 'package:accesorios_industriales_sosa/services/services.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../globals/widgets/widgets.dart';
import '../providers/providers.dart';

class FacturasLocalesController {
  final service = FacturasLocalesService();

  Future<bool> insertarFactura(Factura factura, context) async {
    final provider = Provider.of<FacturaProvider>(context, listen: false);
    try {
      provider.loading = true;
      service.insertarFacturaLocal(factura);
      provider.loading = false;
      sncackbarGlobal('Factura agregada con éxito.', color: Colors.green);

      return true;
    } catch (e) {
      return false;
    }
  }

  Future<bool> actualizarFactura(Factura factura, context) async {
    final provider = Provider.of<FacturaProvider>(context, listen: false);
    try {
      provider.loading = true;
      service.actualizarFacturaLocal(factura);
      provider.loading = false;
      sncackbarGlobal('Factura actualizada con éxito.', color: Colors.green);
      return true;
    } catch (e) {
      return false;
    }
  }

  Future<bool> traerFacturasLocalesCliente(
      context, DateTime fechaDesde, DateTime fechaHasta) async {
    final facturaProvider =
        Provider.of<FacturaProvider>(context, listen: false);
    final clienteProvider =
        Provider.of<ClientesProvider>(context, listen: false);
    try {
      facturaProvider.loading = true;
      facturaProvider.listFactura = await service.traerFacturasLocalesCliente(
          fechaDesde, fechaHasta, clienteProvider.idClienteSelected);
      facturaProvider.ordenarFacturasPorFecha(facturaProvider.listFactura);
      facturaProvider.loading = false;
      return true;
    } catch (e) {
      print(e);
      facturaProvider.listFactura = [];
      return false;
    }
  }
  Future<bool> traerFacturasLocalesProveedor(
      context, DateTime fechaDesde, DateTime fechaHasta) async {
    final facturaProvider =
        Provider.of<FacturaProvider>(context, listen: false);
    final clienteProvider =
        Provider.of<ClientesProvider>(context, listen: false);
    try {
      facturaProvider.loading = true;
      facturaProvider.listFactura = await service.traerFacturasLocalesProveedor(
          fechaDesde, fechaHasta, clienteProvider.idClienteSelected);
      facturaProvider.ordenarFacturasPorFecha(facturaProvider.listFactura);
      facturaProvider.loading = false;
      return true;
    } catch (e) {
      print(e);
      facturaProvider.listFactura = [];
      return false;
    }
  }

  Future<bool> traerFacturasLocalesPorIdCliente(context, int idCliente) async {
    final facturaProvider =
        Provider.of<FacturaProvider>(context, listen: false);
    try {
      facturaProvider.loading = true;
      facturaProvider.listFactura =
          await service.traerFacturasLocalesPorId(idCliente);
      facturaProvider.ordenarFacturasPorFecha(facturaProvider.listFactura);
      facturaProvider.loading = false;
      return true;
    } catch (e) {
      print(e);
      facturaProvider.listFactura = [];
      return false;
    }
  }

  Future<bool> cambiarEstado(context, int idFactura) async {
    final facturaProvider =
        Provider.of<FacturaProvider>(context, listen: false);
    try {
      facturaProvider.loading = true;
      await service.cambiarEstadoFactura(idFactura);
      facturaProvider.loading = false;
      return true;
    } catch (e) {
      print(e);
      facturaProvider.listFactura = [];
      return false;
    }
  }
}
