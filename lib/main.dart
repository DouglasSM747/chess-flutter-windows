import 'package:desktop_window/desktop_window.dart';
import 'package:flutter/material.dart';
import 'package:xadrez/tabuleiro.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: MyHomePage(title: 'XADREZINHO'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class TabuleiroPeca extends _MyHomePageState {
  TabuleiroPeca();

  BuildContext context;

  static Widget pieceAux;

  static bool enablePlay = false;
  static bool pieceSelected = false;

  int lIndex;
  int cIndex;
  Color color;
  Widget piece;
}

class _MyHomePageState extends State<MyHomePage> {
  @override
  initState() {
    super.initState();
    testWindowFunctions();
    initalizeboardBoard();
  }

  List<TabuleiroPeca> listTabuleiroPeca = new List<TabuleiroPeca>();

  initalizeboardBoard() {
    for (int i = 0; i < 8; i++) {
      for (int j = 0; j < 8; j++) {
        TabuleiroPeca tabuleiroPeca = new TabuleiroPeca();
        tabuleiroPeca.lIndex = i;
        tabuleiroPeca.cIndex = j;
        if (colorsTabuleiro[i][j]['piece'] != null) tabuleiroPeca.piece = Image.asset(colorsTabuleiro[i][j]['piece']);
        tabuleiroPeca.color = colorsTabuleiro[i][j]['color'];
        setState(() {
          listTabuleiroPeca.add(tabuleiroPeca);
        });
      }
    }
  }

  Future testWindowFunctions() async {
    double nWidth = 1280;
    double nHeigth = 720;

    await DesktopWindow.setWindowSize(Size(nWidth, nHeigth));

    await DesktopWindow.setMinWindowSize(Size(nWidth, nHeigth));
    await DesktopWindow.setMaxWindowSize(Size(nWidth, nHeigth));
  }

  @override
  Widget build(BuildContext context) {
    final orientation = MediaQuery.of(context).orientation;

    return Scaffold(
      appBar: AppBar(
        title: Center(child: Text(widget.title, style: TextStyle(fontSize: 30))),
      ),
      body: Center(
        child: Container(
          height: 600,
          width: 600,
          child: GridView.builder(
            itemCount: listTabuleiroPeca.length,
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: (orientation == Orientation.portrait) ? 2 : 8),
            itemBuilder: (BuildContext context, int index) {
              return tabuleiro(listTabuleiroPeca[index]);
            },
          ),
        ),
      ),
    );
  }

  Widget tabuleiro(TabuleiroPeca peca) {
    return Card(
      color: peca.color,
      child: GestureDetector(
        onTap: () {
          print(listTabuleiroPeca.length);

          if (peca.piece != null && !TabuleiroPeca.pieceSelected && TabuleiroPeca.pieceAux == null) {
            for (int i = 0; i < 64; i++) {
              if (listTabuleiroPeca[i].lIndex == peca.lIndex && listTabuleiroPeca[i].cIndex == peca.cIndex) {
                print("Pegou peça na posição: " + peca.lIndex.toString() + " " + peca.cIndex.toString());
                setState(() {
                  TabuleiroPeca.pieceAux = listTabuleiroPeca[i].piece;
                  TabuleiroPeca.pieceSelected = true;
                  peca.piece = null;
                });
                break;
              }
            }
          } else {
            print("Soltou peça na posição: " + peca.lIndex.toString() + " " + peca.cIndex.toString());
            setState(() {
              peca.piece = TabuleiroPeca.pieceAux;
              TabuleiroPeca.pieceAux = null;
              TabuleiroPeca.pieceSelected = false;
            });
          }
        },
        child: peca.piece,
      ),
    );
  }
}
