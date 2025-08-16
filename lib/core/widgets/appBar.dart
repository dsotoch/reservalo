import 'package:flutter/material.dart';

class AppBarWidget extends StatelessWidget implements PreferredSizeWidget {
  final Widget titulo;
  final Widget? button;

  AppBarWidget({super.key, required this.titulo, this.button});

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: Colors.blueAccent,
      centerTitle: true,
      title: titulo,
      iconTheme: const IconThemeData(color: Colors.white),
      actions: button != null ? [button!] : null, // se agrega solo si no es null
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}
