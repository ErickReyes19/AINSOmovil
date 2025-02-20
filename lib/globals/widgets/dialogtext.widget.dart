
import 'package:accesorios_industriales_sosa/controllers/controller.dart';
import 'package:accesorios_industriales_sosa/globals/widgets/textparrafo.widget.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

void dialogText(BuildContext context,
    {String mensaje = 'Ingrese el pin de seguridad'}) {
  late TextEditingController txtPin = TextEditingController();
  showDialog(
    context: context,
    builder: (BuildContext context) {
      final tema = Theme.of(context).colorScheme;
      Size size = MediaQuery.of(context).size;
      return AlertDialog(
        contentPadding: const EdgeInsets.symmetric(horizontal: 0),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Row(
              children: [
                Expanded(
                  child: Container(
                      padding:
                          EdgeInsets.symmetric(vertical: size.height * 0.005),
                      decoration: BoxDecoration(
                          color: tema.primary,
                          borderRadius: const BorderRadius.only(
                              topLeft: Radius.circular(4),
                              topRight: Radius.circular(4))),
                      child: Icon(Icons.password,
                          size: size.height * 0.1, color: tema.onPrimary)),
                ),
              ],
            ),
            Padding(
              padding: EdgeInsets.symmetric(
                  horizontal: size.width * 0.03, vertical: 13),
              child: TextParrafo(
                texto: mensaje,
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10),
              child: TextField(
                keyboardType: TextInputType.number,
                controller: txtPin,
                onChanged: (String value) {},
                style: TextStyle(color: tema.secondary),
                decoration: InputDecoration(
                    labelStyle:
                        GoogleFonts.poppins(color: tema.onSurface),
                    hintStyle: GoogleFonts.poppins(color: tema.primary),
                    border: const OutlineInputBorder(),
                    hintText: "PIN"),
              ),
            ),
          ],
        ),
        actions: <Widget>[
          ElevatedButton(
            onPressed: () {
              AuthController()
                  .resetUsuario(txtPin.text, context)
                  // ignore: use_build_context_synchronously
                  .then((value) => Navigator.pop(context));
            },
            style: ButtonStyle(
              padding: WidgetStateProperty.all(const EdgeInsets.all(10)),
            ),
            child: const Text('Aceptar', style: TextStyle(color: Colors.white)),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
            },
            style: ButtonStyle(
              padding: WidgetStateProperty.all(const EdgeInsets.all(10)),
            ),
            child:
                const Text('Cancelar', style: TextStyle(color: Colors.white)),
          ),
        ],
      );
    },
  );
}
