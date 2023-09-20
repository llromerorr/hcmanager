import 'package:flutter/material.dart';
import 'package:pedidos/main.dart';
import 'globals.dart' as globals;

class Usuarios extends StatefulWidget {
  const Usuarios({super.key});

  @override
  State<Usuarios> createState() => _UsuariosState();
}

class _UsuariosState extends State<Usuarios> {

  Widget output = const Center(child: CircularProgressIndicator());

  @override
  void initState() {
    globals.cargarUsuarios().then((value){
      setState(() {
        output = Scaffold(
          body: Padding(
            padding: const EdgeInsets.only(top: 8.0),
            child: Column(
              children: [
                const Padding(
                  padding: EdgeInsets.symmetric(vertical: 10),
                  child: Text("Administrativo H.C.\n¿Quien eres?", style: TextStyle(fontSize: 30), textAlign: TextAlign.center),
                ),
          
                Expanded(
                  child: ListView.builder(
                    itemCount: globals.usuarios.length,
                    itemBuilder: (context, index) => InkWell(
                      onTap: (){
                        globals.cargarProductos(index).then((value){
                          Navigator.push(context, MaterialPageRoute(builder: (context) => const MainApp())).then((value){setState(() {
                            globals.productos.clear();
                            globals.pedidos.clear();
                          });});
                        });
                      },
                      child: Padding(
                        padding: const EdgeInsets.symmetric(vertical: 15),
                        child: Column(
                          children: [
                            Container(
                              width: 80,
                              height: 80,
                              decoration: BoxDecoration(
                                borderRadius: const BorderRadius.all(Radius.circular(20)),
                                color: globals.usuarios[index]["cedula"]!.contains("usd") ? Colors.green : Colors.blue 
                              ),
                              child: Center(child: Text((globals.usuarios[index]["cedula"]!.contains("usd") ? "\$" : "Bs."), style: const TextStyle(fontSize: 30))),
                            ),
                      
                            const Divider(
                              color: Colors.transparent,
                              height: 10,
                            ),
                            
                            Text(globals.usuarios[index]["nombre"]!, style: const TextStyle(fontSize: 22)),
                          ],
                        ),
                      ),
                    )
                  ),
                ),
              ],
            ),
          )
        );
      });
    });

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return output;
  }
}