import 'package:liquid_progress_indicator/liquid_progress_indicator.dart';
import 'package:responsive_sizer/responsive_sizer.dart';
import 'package:flutter/material.dart';

class ProgressBar extends StatelessWidget {
  const ProgressBar({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
                      child: SizedBox(
                    width: Adaptive.w(20),
                    height: 5.h,
                    child: LiquidLinearProgressIndicator(
                      value: 0.25, // Defaults to 0.5.
                      valueColor: const AlwaysStoppedAnimation(Colors
                          .blue), // Defaults to the current Theme's accentColor.
                      backgroundColor: Colors
                          .white, // Defaults to the current Theme's backgroundColor.
                      borderRadius: 12.0,
                      direction: Axis
                          .horizontal, // The direction the liquid moves (Axis.vertical = bottom to top, Axis.horizontal = left to right). Defaults to Axis.horizontal.
                      center: const Text("Cargando..."),
                    ),
                  ));
  }
}
