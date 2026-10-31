import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../blocs/country_detail/country_detail_bloc.dart';
import '../entities/country.dart';
import '../screens/countries_screen.dart';
import '../screens/country_detail_screen.dart';
import '../services/countries_service.dart';

/// Rutas de la app:
///   /               → lista de países
///   /country/:code  → detalle (ej: /country/COL)
final appRouter = GoRouter(
  initialLocation: '/',
  routes: [
    GoRoute(
      path: '/',
      builder: (context, state) => const CountriesScreen(),
    ),
    GoRoute(
      path: '/country/:code',
      builder: (context, state) {
        final code = state.pathParameters['code']!.toUpperCase();
        final preview = state.extra is Country ? state.extra as Country : null;

        // Cada detalle tiene su propio BLoC, que se crea al abrir la
        // pantalla y se cierra solo al salir de ella.
        return BlocProvider(
          create: (context) =>
              CountryDetailBloc(context.read<CountriesService>())
                ..add(CountryDetailRequested(code)),
          child: CountryDetailScreen(code: code, preview: preview),
        );
      },
    ),
  ],
);
