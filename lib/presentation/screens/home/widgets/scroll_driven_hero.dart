import 'package:flutter/material.dart';

class ScrollDrivenHero extends StatefulWidget {
  final ScrollController controller;
  const ScrollDrivenHero({super.key, required this.controller});

  @override
  State<ScrollDrivenHero> createState() => _ScrollDrivenHeroState();
}

class _ScrollDrivenHeroState extends State<ScrollDrivenHero> {
  double _scrollPercentage = 0;

  @override
  void initState() {
    super.initState();
    widget.controller.addListener(_onScroll);
  }

  void _onScroll() {
    if (!widget.controller.hasClients) return;
    double maxScroll = 500;
    setState(() {
      _scrollPercentage = (widget.controller.offset / maxScroll).clamp(
        0.0,
        1.0,
      );
    });
  }

  @override
  void dispose() {
    widget.controller.removeListener(_onScroll);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        return Container(
          height: constraints.maxHeight,
          width: double.infinity,
          clipBehavior: Clip.none,
          child: Stack(
            alignment: Alignment.center,
            children: [
              // Fondo espacial
              Positioned.fill(
                child: Opacity(
                  opacity: (1.0 - _scrollPercentage).clamp(0.2, 1.0),
                  child: Image.asset(
                    'assets/images/antigravity-PRTADA-FONDO.png',
                    fit: BoxFit.cover,
                  ),
                ),
              ),
              // El Astronauta (Personaje Principal)
              // Lo movemos un poco hacia arriba para que no lo tape el título del AppBar
              Positioned(
                bottom: 20 + (_scrollPercentage * 100),
                child: Transform(
                  transform: Matrix4.identity()
                    ..setEntry(3, 2, 0.001)
                    ..rotateY(_scrollPercentage * 0.8) // Más rotación
                    ..translate(0.0, _scrollPercentage * -30.0)
                    ..scale(
                      1.0 + (_scrollPercentage * 0.3),
                    ), // Crece un poco al scroll
                  alignment: Alignment.center,
                  child: Image.asset(
                    'assets/images/astronauta_personaje_con_casco_flotando.png',
                    height: 280, // Más grande
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
