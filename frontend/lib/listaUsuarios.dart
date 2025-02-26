import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import 'package:frontend/Models/1modelsUser.dart';
import 'package:frontend/formulario.dart';

class ListaUsuarios extends StatelessWidget {
  const ListaUsuarios({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Lista de Usuarios',
          style: TextStyle(
            fontSize: 22.0,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(
          Icons.plus_one,
          size: 30.0,
        ),
        onPressed: () {
          Navigator.of(context).pop();
          Navigator.of(context).push(MaterialPageRoute(
              builder: (BuildContext context) => Formulario()));
        },
      ),
      body: FutureBuilder<List<User>>(
        future: obtenerUser(),
        builder: (BuildContext context, AsyncSnapshot<List<User>> snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            List<User> usuarios = snapshot.data;

            return construirListaUsuarios(usuarios);
          }
          return Center(child: CircularProgressIndicator());
        },
      ),
    );
  }

  ListView construirListaUsuarios(List<User> usuarios) {
    return ListView.builder(
      itemCount: usuarios.length,
      itemBuilder: (BuildContext context, int index) {
        User user = usuarios[index];
        return Column(
          children: [
            ListTile(
              title: Text(
                user.name,
                style: TextStyle(
                  fontSize: 17.0,
                  fontWeight: FontWeight.bold,
                ),
              ),
              leading: Icon(Icons.email, color: Colors.black),
              subtitle: Text(user.email),
            ),
            Divider(),
          ],
        );
      },
    );
  }
}

Future<List<User>> obtenerUser() async {
  final url = Uri.parse('http://bf12d21f1e5f.ngrok.io/comments');
  final respuesta = await http.get(url);

  if (respuesta.statusCode == 200) {
    return userFromJson(respuesta.body);
  } else {
    return null;
  }
}
