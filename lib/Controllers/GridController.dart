import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../Constants/Constants.dart';
import '../Entities/Sesion.dart';
import '../Models/EventObject.dart';
import '../Models/ImagenesProductoModel.dart';
import '../Models/UpdateDFAModel.dart';
import '../Utils/HexColor.dart';
import '../services/ApiService.dart';
import 'BaseController.dart';
import 'dart:convert' show json;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:photo_view/photo_view.dart';
import 'package:photo_view/photo_view_gallery.dart';

  class GridController extends BaseController {
    final List<ImagenesProductoModel> imageUrls;

    GridController({required this.imageUrls}) : super();



    @override
  _GridController createState() => _GridController();

}

class _GridController extends BaseControllerState<GridController> with AutomaticKeepAliveClientMixin , WidgetsBindingObserver {

  @override
  bool get wantKeepAlive => true;
  bool isChecked = false;


  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance!.addObserver(this);
    WidgetsBinding.instance!.addPostFrameCallback((_) => getUser()
    );

  }
  @override
  void dispose() {
    WidgetsBinding.instance!.removeObserver(this);
    super.dispose();
  }

  getUser(){


  }


  Future<void> _logOut() async {
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
      appBar: AppBar(
        iconTheme: IconThemeData(
          color: HexColor(ColorTheme.buttoncolor), //change your color here
        ),
        backgroundColor: HexColor(ColorTheme.primaryColor),
        bottomOpacity: 0.0,
        elevation: 0.0,
        title:  Container(   // <--- Change here
            padding: EdgeInsets.symmetric(vertical: MediaQuery.of(context).size.height * 0.1),
            child: Image.asset("assets/logo_white.png", fit: BoxFit.fitHeight, height: 50,)
        ),
        centerTitle: true, systemOverlayStyle: SystemUiOverlayStyle.light,
      ),
      body: GestureDetector(
        onTap: () {FocusScope.of(context).requestFocus(new FocusNode());},
        child: Container(
          padding: EdgeInsets.only(top: 10,left: 10,right: 10,bottom: 10),
          child: lista()
        )
      ),
    );
  }

  Widget lista(){
    return GridView.builder(
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2, // 2 columnas
        childAspectRatio: 1.0, // Para que las imágenes sean cuadradas
      ),
      itemCount: widget.imageUrls.length,
      itemBuilder: (BuildContext context, int index) {
        return GestureDetector(
          onTap: () {
            // Aquí puedes agregar un manejo para cuando se haga clic en una imagen.
          },
          child: GestureDetector(
            onTap: () {
              Navigator.push(context, MaterialPageRoute(builder: (context) {
                return ImageViewer(
                  imageUrls: widget.imageUrls,
                  initialIndex: index,
                );
              }));
            },
            child: Card(
              elevation: 1,
              child: Image.network(
                  widget.imageUrls[index].urlImagen!!,
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) {
                    // Muestra la imagen de error 404 si la carga de la imagen falla.
                    return Image.network(
                      "https://static.vecteezy.com/system/resources/previews/005/337/799/non_2x/icon-image-not-found-free-vector.jpg",
                      fit: BoxFit.cover,
                    );
                  }// Para ajustar la imagen al cuadro
              ),
            ),
          ),
        );
      },
    );
  }

}

class ImageViewer extends StatelessWidget {
  final List<ImagenesProductoModel> imageUrls;
  final int initialIndex;

  ImageViewer({required this.imageUrls, required this.initialIndex});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Productos'),
      ),
      body: PhotoViewGallery.builder(
        itemCount: imageUrls.length,
        builder: (context, index) {
          return PhotoViewGalleryPageOptions(
            imageProvider: NetworkImage(imageUrls[index].urlImagen!!),
            minScale: PhotoViewComputedScale.contained,
            maxScale: PhotoViewComputedScale.covered * 2,
          );
        },
        backgroundDecoration: BoxDecoration(
          color: Colors.black,
        ),
        pageController: PageController(initialPage: initialIndex),
      ),
    );
  }
}
