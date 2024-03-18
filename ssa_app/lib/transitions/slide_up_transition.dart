import 'package:flutter/material.dart';

class SlideUpTransition<T> extends PageRouteBuilder<T> {
  SlideUpTransition({required WidgetBuilder builder, RouteSettings? settings})
      : super(
          pageBuilder: (BuildContext context, Animation<double> animation,
              Animation<double> secondaryAnimation) {
            return builder(context);
          },
          transitionDuration:
              const Duration(milliseconds: 300), // Quick and snappy transition
          reverseTransitionDuration: const Duration(milliseconds: 300),
          transitionsBuilder: (BuildContext context,
              Animation<double> animation,
              Animation<double> secondaryAnimation,
              Widget child) {
            // Adjust slide animation to start from 75% mark from the bottom
            var beginSlide = const Offset(0.0, 0.75);
            var endSlide = Offset.zero;
            var curveSlide = Curves.easeInOut;
            var slideTween = Tween(begin: beginSlide, end: endSlide)
                .chain(CurveTween(curve: curveSlide));
            var slideAnimation = animation.drive(slideTween);

            // Adjust fade animation to start becoming visible at the 75% mark
            var beginFade = 0.0;
            var endFade = 1.0;
            // This tween adjusts the opacity to start changing from 0.0 to 1.0, starting at 25% of the animation duration
            var fadeTween = Tween(begin: beginFade, end: endFade);
            // Use Interval to delay the start of the fade animation so it begins at the 75% mark
            var fadeAnimation = animation
                .drive(CurveTween(
                    curve: const Interval(0.25, 1.0, curve: Curves.easeInOut)))
                .drive(fadeTween);

            return FadeTransition(
              opacity: fadeAnimation,
              child: SlideTransition(
                position: slideAnimation,
                child: child,
              ),
            );
          },
        );
}
