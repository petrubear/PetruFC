import 'package:flutter/material.dart';

import 'router.dart';
import 'theme.dart';

class PetruApp extends StatelessWidget {
  const PetruApp({super.key});

  @override
  Widget build(BuildContext context) => MaterialApp.router(
        title: 'Petru FC',
        theme: buildTheme(),
        routerConfig: router,
        debugShowCheckedModeBanner: false,
      );
}
