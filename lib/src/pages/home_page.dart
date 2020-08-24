import 'package:flutter/material.dart';

import 'package:qrreaderapp/src/bloc/scans_bloc.dart';
import 'package:qrreaderapp/src/models/scan_model.dart';
import 'package:qrreaderapp/src/pages/direcciones_page.dart';
import 'package:qrreaderapp/src/pages/mapas_page.dart';
import 'package:qrreaderapp/src/utils/utils.dart' as utils;
import 'package:barcode_scan/barcode_scan.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {

  final scansBloc = new ScansBloc();

  int currentIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text('QR Scanner'),
        actions: [
          IconButton(
            icon: Icon(Icons.delete_forever),
            //onPressed: (){},
             onPressed: () {
               scansBloc.borrarScanTodos();
               }
             ),
        ],
      ),
      body: _callPage(currentIndex),
      bottomNavigationBar: _crearBottomNavigationBar(),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.filter_center_focus),
        onPressed: () => _scanQR( context),
        backgroundColor: Theme.of(context).primaryColor,
        ),
    );
  }

 
  _scanQR(BuildContext context) async {

    //https://github.com/LuzCampos/
    //geo:40.70861981284952,-74.00044813593753
    
    String futureString;

    try {
     futureString = await BarcodeScanner.scan();
    } catch( e ){
      futureString = e.toString();
    }

    if(futureString != null ){

    final scan = ScanModel( valor: futureString); 
    scansBloc.agregarScan(scan);

    utils.abrirScan(context, scan);      

    }

  }

  Widget _callPage( int paginaActual) {

    switch ( paginaActual ) {

      case 0: return MapasPage();
      case 1: return DireccionesPage();

      default:
        return MapasPage();

    }

  }

  Widget _crearBottomNavigationBar() {
      return BottomNavigationBar(
        currentIndex: currentIndex, //que elemento esta activo
        onTap: (index){
          setState(() {
            currentIndex = index;
          });
        }, //necesita el index 
        items: [
           BottomNavigationBarItem(
             icon: Icon(Icons.map),
             title: Text('Mapas')
             ),
           BottomNavigationBarItem(
             icon: Icon(Icons.brightness_5),
             title: Text('Direcciones')
             ),  
        ],
        );
  }
}