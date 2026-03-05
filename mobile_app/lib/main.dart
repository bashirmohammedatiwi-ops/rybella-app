import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:provider/provider.dart';
import 'package:cosmatic_app/core/theme/app_theme.dart';
import 'package:cosmatic_app/core/theme/app_colors.dart';
import 'package:cosmatic_app/core/router/app_router.dart';
import 'package:cosmatic_app/features/auth/presentation/user_provider.dart';
import 'package:cosmatic_app/features/cart/presentation/cart_provider.dart';
import 'package:cosmatic_app/features/wishlist/presentation/wishlist_provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final userProvider = UserProvider();
  await userProvider.init();
  SystemChrome.setSystemUIOverlayStyle(
    const SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      statusBarIconBrightness: Brightness.dark,
      systemNavigationBarColor: AppColors.surface,
      systemNavigationBarIconBrightness: Brightness.dark,
    ),
  );
  final cartProvider = CartProvider();
  await cartProvider.loadFromStorage();
  runApp(CosmaticApp(cartProvider: cartProvider, userProvider: userProvider));
}

class CosmaticApp extends StatelessWidget {
  final CartProvider? cartProvider;
  final UserProvider? userProvider;

  const CosmaticApp({super.key, this.cartProvider, this.userProvider});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        if (userProvider != null)
          ChangeNotifierProvider.value(value: userProvider!)
        else
          ChangeNotifierProvider(create: (_) => UserProvider()..init()),
        if (cartProvider != null)
          ChangeNotifierProvider.value(value: cartProvider!)
        else
          ChangeNotifierProvider(create: (_) => CartProvider()),
        ChangeNotifierProvider(create: (_) => WishlistProvider()),
      ],
      child: MaterialApp.router(
        title: 'Rybella Iraq',
        debugShowCheckedModeBanner: false,
        locale: const Locale('ar', 'IQ'),
        supportedLocales: const [Locale('ar', 'IQ')],
        localizationsDelegates: const [
          GlobalMaterialLocalizations.delegate,
          GlobalWidgetsLocalizations.delegate,
          GlobalCupertinoLocalizations.delegate,
        ],
        theme: AppTheme.luxuryTheme,
        routerConfig: AppRouter.router,
        builder: (context, child) => Directionality(
          textDirection: TextDirection.rtl,
          child: child ?? const SizedBox.shrink(),
        ),
      ),
    );
  }
}
