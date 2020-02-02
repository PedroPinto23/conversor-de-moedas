import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'dart:async';

const request =
    'https://api.hgbrasil.com/finance?format=json-cors&key=ba03a24a'; // link
void main() async {
  print(await getData()); // pegar os dados

  runApp(MaterialApp(
    title: 'Teste',
    home: Home(),
  ));
}

Future<Map> getData() async {
  http.Response response = await http.get(request);
  return json.decode(response.body); // dados
}

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  final realController = TextEditingController();
  final dolarController = TextEditingController();
  final euroController = TextEditingController();
  final pesoController = TextEditingController();
  final bitCoinController = TextEditingController();

  void _clearAll() {
    realController.text = "";
    dolarController.text = "";
    euroController.text = "";
    pesoController.text = "";
    bitCoinController.text = "";
  }

  void _realChanged(String text) {
    if (text.isEmpty) {
      _clearAll();
      return;
    }
    double real = double.parse(text);
    dolarController.text = (real / dolar).toStringAsFixed(3);
    euroController.text = (real / euro).toStringAsFixed(3);
    pesoController.text = (real / peso).toStringAsFixed(3);
    bitCoinController.text = (real / bitcoin).toStringAsFixed(0);
  }

  void _dolarChanged(String text) {
    if (text.isEmpty) {
      _clearAll();
      return;
    }
    double dolar = double.parse(text);
    realController.text = (dolar * this.dolar).toStringAsFixed(3);
    euroController.text = (dolar * this.dolar / euro).toStringAsFixed(3);
    pesoController.text = (dolar * this.dolar / peso).toStringAsFixed(3);
    bitCoinController.text = (dolar * this.dolar / bitcoin).toStringAsFixed(0);
  }

  void _euroChanged(String text) {
    if (text.isEmpty) {
      _clearAll();
      return;
    }
    double euro = double.parse(text);
    realController.text = (euro * this.euro).toStringAsFixed(3);
    dolarController.text = (euro * this.euro / dolar).toStringAsFixed(3);
    pesoController.text = (euro * this.euro / peso).toStringAsFixed(3);
    bitCoinController.text = (euro * this.euro / bitcoin).toStringAsFixed(0);
  }

  void _pesoChanged(String text) {
    if (text.isEmpty) {
      _clearAll();
      return;
    }
    double peso = double.parse(text);
    realController.text = (peso * this.peso).toStringAsFixed(3);
    dolarController.text = (peso * this.peso / dolar).toStringAsFixed(3);
    bitCoinController.text = (peso * this.peso / bitcoin).toStringAsFixed(0);
    euroController.text = (peso * this.peso / euro).toStringAsFixed(3);
  }

  void _bitcoinChanged(String text) {
    if (text.isEmpty) {
      _clearAll();
      return;
    }
    double bitcoin = double.parse(text);
    realController.text = (bitcoin * this.bitcoin).toStringAsFixed(3);
    dolarController.text = (bitcoin * this.bitcoin / dolar).toStringAsFixed(3);
    pesoController.text = (bitcoin * this.bitcoin / peso).toStringAsFixed(3);
    euroController.text = (bitcoin * this.bitcoin / euro).toStringAsFixed(3);
  }

  double dolar;
  double euro;
  double peso;
  double bitcoin;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('\$ Conversor \$'),
        centerTitle: true,
        backgroundColor: Colors.amber,
      ),
      backgroundColor: Colors.black,
      body: FutureBuilder<Map>(
        future: getData(),
        builder: (context, snapshot) {
          switch (snapshot.connectionState) {
            case ConnectionState.none:
            case ConnectionState.waiting:
              return Center(
                  child: CircularProgressIndicator(
                backgroundColor: Colors.amber,
              ));
            default:
              if (snapshot.hasError) {
                return Center(
                  child: Text(
                    'Erro ao carregar os dados...',
                    style: TextStyle(color: Colors.amber, fontSize: 25.0),
                  ),
                );
              } else {
                dolar = snapshot.data['results']['currencies']['USD']['buy'];
                euro = snapshot.data['results']['currencies']['EUR']['buy'];
                peso = snapshot.data['results']['currencies']['ARS']['buy'];
                bitcoin = snapshot.data['results']['bitcoin']['mercadobitcoin']
                    ['buy'];
                return SingleChildScrollView(
                  padding: EdgeInsets.all(10),
                  child: Column(
                    children: <Widget>[
                      Icon(
                        Icons.monetization_on,
                        size: 150,
                        color: Colors.amber,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        mainAxisSize: MainAxisSize.max,
                        children: <Widget>[
                          Expanded(
                            child: RaisedButton(
                              onPressed: _clearAll,
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(30.0)),
                              color: Colors.amber,
                              child: Text(
                                'Limpar Tudo',
                                style: TextStyle(fontSize: 20),
                              ),
                            ),
                          ),
                        ],
                      ),
                      buildTextField(
                          'Reais', 'R\$', realController, _realChanged),
                      Divider(),
                      buildTextField(
                          'Dólares', '\$', dolarController, _dolarChanged),
                      Divider(),
                      buildTextField(
                          'Euros', '€', euroController, _euroChanged),
                      Divider(),
                      buildTextField('Pesos Argentinos', '\$', pesoController,
                          _pesoChanged),
                      Divider(),
                      buildTextField(
                          'BitCoins', 'BTC', euroController, _bitcoinChanged),
                    ],
                  ),
                );
              }
          }
        },
      ),
    );
  }
}

Widget buildTextField(String label, String prefix, TextEditingController c,
    Function handleChange) {
  return TextField(
    controller: c,
    decoration: InputDecoration(
        enabledBorder:
            OutlineInputBorder(borderSide: BorderSide(color: Colors.amber)),
        border: OutlineInputBorder(borderSide: BorderSide(color: Colors.amber)),
        labelText: label,
        labelStyle: TextStyle(color: Colors.amber),
        prefixText: prefix,
        prefixStyle: TextStyle(color: Colors.amber, fontSize: 25)),
    style: TextStyle(color: Colors.amber, fontSize: 25),
    onChanged: handleChange,
    keyboardType: TextInputType.number,
  );
}
