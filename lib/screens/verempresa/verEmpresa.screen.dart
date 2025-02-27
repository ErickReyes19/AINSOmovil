import 'package:ainso/globals/widgets/widgets.dart';
import 'package:ainso/models/models.dart';
import 'package:ainso/screens/crearEmpresa/crearempresa.screen.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/empresa.provider.dart'; // Asegúrate de tener tu provider de empresa

class EmpresaVisorScreen extends StatelessWidget {
  const EmpresaVisorScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final empresaProvider = Provider.of<EmpresaProvider>(context);
    final empresa = empresaProvider.empresa; // Obtienes la empresa del provider
      final tema = Theme.of(context).colorScheme;
    return Scaffold(
      backgroundColor: Colors.white, // Fondo blanco para la pantalla
      appBar: AppBar(
        title: const Text("Información de la Empresa", style: TextStyle(fontWeight: FontWeight.bold)),
        elevation: 1,
        actions: empresa != null
            ? [
                IconButton(
                  icon: Icon(Icons.edit),
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => CrearEmpresaScreen(titulo: 'Editar empresa', empresa: empresa,),
                      ),
                    );
                  },
                ),
              ]
            : null,
      ),
      body: empresa == null
          ? _noEmpresaView(context)
          : Padding(
              padding: const EdgeInsets.all(16.0),
              child: ListView(
                children: [
                  _buildHeader(empresa),
                  const SizedBox(height: 20),

                  // Dirección
                  _buildInfoRow(
                    icon: Icons.location_on,
                    label: 'Dirección:',
                    value: empresa.direccion,
                    color: tema.primary,
                  ),
                  const SizedBox(height: 16),

                  // Email
                  _buildInfoRow(
                    icon: Icons.email,
                    label: 'Email:',
                    value: empresa.email,
                    color: tema.primary,
                  ),
                  const SizedBox(height: 16),

                  // RTN
                  _buildInfoRow(
                    icon: Icons.business,
                    label: 'RTN:',
                    value: empresa.rtn,
                    color: tema.primary,
                  ),
                  const SizedBox(height: 20),

                  // Mostrar Bancos
                  if (empresa.bancos.isNotEmpty)
                    _buildSectionWithIcon(
                      color: tema.primary,
                      context: context,
                      sectionTitle: 'Bancos',
                      icon: Icons.account_balance,
                      contentList: empresa.bancos.map((banco) {
                        return Padding(
                          padding: const EdgeInsets.only(bottom: 8.0),
                          child: Text(
                            '${banco.banco} - ${banco.nombre} - ${banco.cuenta}',
                            style: TextStyle(
                              fontSize: 16,
                              color: Colors.black54,
                            ),
                          ),
                        );
                      }).toList(),
                    ),
                  const SizedBox(height: 20),

                  // Mostrar Teléfonos
                  if (empresa.telefonos.isNotEmpty)
                    _buildSectionWithIcon(
                      context: context,
                      color: tema.primary,
                      sectionTitle: 'Teléfonos',
                      icon: Icons.phone,
                      contentList: empresa.telefonos.map((telefono) {
                        return Padding(
                          padding: const EdgeInsets.only(bottom: 8.0),
                          child: Text(
                            telefono.telefono,
                            style: TextStyle(
                              fontSize: 16,
                              color: Colors.black54,
                            ),
                          ),
                        );
                      }).toList(),
                    ),
                ],
              ),
            ),
    );
  }

  // Vista cuando no hay empresa cargada
  Widget _noEmpresaView(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            "No hay información de la empresa",
            style: TextStyle(fontSize: 18, color: Colors.black54),
          ),
          const SizedBox(height: 20),
          ButtonXXL(
            funcion: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => CrearEmpresaScreen(titulo: 'Crear empresa'),
                ),
              );
            },
            texto: 'Crear Empresa',
          ),
        ],
      ),
    );
  }

  // Widget para el encabezado con el nombre de la empresa
  Widget _buildHeader(Empresa empresa) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          empresa.nombre,
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
            color: Colors.black,
          ),
        ),
        const SizedBox(height: 8),
        Text(
          'Empresa registrada',
          style: TextStyle(
            fontSize: 16,
            color: Colors.black45,
          ),
        ),
      ],
    );
  }

  // Widget para cada fila de información con un ícono
  Widget _buildInfoRow({
    required IconData icon,
    required String label,
    required String value,
    required Color color,

  }) {
    
    return Row(
      children: [
        Icon(icon, color: color), // Color azul para el icono
        const SizedBox(width: 8),
        Expanded(
          child: Text(
            '$label $value',
            style: TextStyle(fontSize: 16, color: Colors.black),
            overflow: TextOverflow.ellipsis,
          ),
        ),
      ],
    );
  }

  // Widget para mostrar una sección con un título, un ícono y una lista de contenidos
  Widget _buildSectionWithIcon({
    required BuildContext context,
    required String sectionTitle,
    required IconData icon,
    required Color color,
    required List<Widget> contentList,

  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Icon(icon, color: color), // Color azul para el ícono
            const SizedBox(width: 8),
            Text(
              sectionTitle,
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.black,
              ),
            ),
          ],
        ),
        const SizedBox(height: 8),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: contentList,
        ),
      ],
    );
  }
}
