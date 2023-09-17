import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:heav/Ofertas.dart';

class OfertasItem extends StatelessWidget {
  final Ofertas ofertas;
  const OfertasItem({Key? key, required this.ofertas}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(left: 25,right: 25,top: 20) ,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        color: Colors.blueAccent,
        boxShadow: [
          BoxShadow(
            color: Colors.black12,
            blurRadius: 1.5,
            spreadRadius: 1.5,
            offset: Offset(0, 1),
          ),

        ],
      ),
      child: Row(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(ofertas.id,style: TextStyle(
                fontSize: 13.5,
                fontFamily: 'Ubuntu',
                fontWeight: FontWeight.bold,
                color: Colors.white),),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: CircleAvatar(
              radius: 30.0,
              backgroundImage:
              NetworkImage(ofertas.img_user.replaceAll(" ", "")),
              backgroundColor: Colors.transparent,
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: CircleAvatar(
              radius: 13.0,
              backgroundImage:
              NetworkImage(ofertas.img_moneda.replaceAll(" ", "")),
              backgroundColor: Colors.transparent,
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(ofertas.porciento,style: TextStyle(
                fontSize: 8,
                fontFamily: 'Ubuntu',
                fontWeight: FontWeight.bold,
                color: Colors.white),),
          ),
        ],
      ),
    );
  }
}
