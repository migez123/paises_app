import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'blocs/countries/countries_bloc.dart';
import 'config/app_router.dart';
import 'config/app_theme.dart';
import 'services/countries_service.dart';

void main() {
  runApp(const PaisesApp());
}

class PaisesApp extends StatelessWidget {
  const PaisesApp({super.key});

  @override
  Widget build(BuildContext context) {
    // RepositoryProvider: un solo CountriesService para toda la app.
    // BlocProvider: el BLoC de la lista vive arriba de las rutas, así
    // la lista no se vuelve a pedir al regresar del detalle.
    return RepositoryProvider(
      create: (_) => CountriesService(),
      child: BlocProvider(
        create: (context) => CountriesBloc(context.read<CountriesService>())
          ..add(const CountriesRequested()),
        child: MaterialApp.router(
          title: 'Países',
          debugShowCheckedModeBanner: false,
          theme: AppTheme.light(),
          darkTheme: AppTheme.dark(),
          routerConfig: appRouter,
        ),
      ),
    );
  }
}
