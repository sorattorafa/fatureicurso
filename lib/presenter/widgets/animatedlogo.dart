import 'package:flutter/material.dart';

// Reponsabilidades: controle da animação

class AnimatedSplashLogo extends StatefulWidget {
  const AnimatedSplashLogo({
    super.key,
  });

  @override
  State<AnimatedSplashLogo> createState() => _AnimatedSplashLogoState();
}

class _AnimatedSplashLogoState extends State<AnimatedSplashLogo>
    with SingleTickerProviderStateMixin {
  Animation<double>? _animation;
  AnimationController? _animationController;
  bool hasBlur = false;

  @override
  void dispose() {
    _animationController!.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();

    _animationController = AnimationController(
      duration: const Duration(seconds: 4),
      vsync: this,
    )..repeat(reverse: true);

    _animationController!.addStatusListener((status) {
      if (status == AnimationStatus.forward) {
        setState(() {
          hasBlur = false;
        });
      } else if (status == AnimationStatus.reverse) {
        setState(() {
          hasBlur = true;
        });
      }
    });

    _animation = Tween<double>(begin: 50.0, end: 150.0).animate(
      CurvedAnimation(parent: _animationController!, curve: Curves.easeInOut),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: AnimatedBuilder(
          animation: _animation!,
          child: Image.asset('assets/icons/logo.png'),
          builder: (context, child) {
            // o que ficará pulsando na tela
            return Container(
              width: _animation!.value,
              height: _animation!.value,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    Colors.grey,
                    Colors.grey.withOpacity(0.5),
                  ],
                  begin: Alignment.centerLeft,
                  end: Alignment.centerRight,
                ),
                // Adiciona um efeito de blur ao gradiente
                shape: BoxShape.circle,
                border: Border.all(
                  color: Colors.transparent,
                  width: 4,
                ),
                boxShadow: [],
              ),
              child: child,
            );
          }),
    );
  }
}
