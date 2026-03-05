import 'package:go_router/go_router.dart';
import 'package:cosmatic_app/features/splash/presentation/splash_screen.dart';
import 'package:cosmatic_app/features/onboarding/presentation/onboarding_screen.dart';
import 'package:cosmatic_app/features/home/presentation/home_screen.dart';
import 'package:cosmatic_app/features/products/presentation/product_list_screen.dart';
import 'package:cosmatic_app/features/products/presentation/product_detail_screen.dart';
import 'package:cosmatic_app/features/cart/presentation/cart_screen.dart';
import 'package:cosmatic_app/features/checkout/presentation/checkout_screen.dart';
import 'package:cosmatic_app/features/checkout/presentation/order_success_screen.dart';
import 'package:cosmatic_app/features/wishlist/presentation/wishlist_screen.dart';
import 'package:cosmatic_app/features/orders/presentation/order_tracking_screen.dart';
import 'package:cosmatic_app/features/orders/presentation/order_detail_screen.dart';
import 'package:cosmatic_app/features/settings/presentation/settings_screen.dart';
import 'package:cosmatic_app/features/search/presentation/search_screen.dart';
import 'package:cosmatic_app/features/auth/presentation/login_screen.dart';
import 'package:cosmatic_app/features/auth/presentation/register_screen.dart';
import 'package:cosmatic_app/features/orders/presentation/my_orders_screen.dart';

class AppRouter {
  static const String splash = '/';
  static const String onboarding = '/onboarding';
  static const String home = '/home';
  static const String products = '/products';
  static const String productDetail = '/products/:slug';
  static const String cart = '/cart';
  static const String checkout = '/checkout';
  static const String orderSuccess = '/order-success';
  static const String wishlist = '/wishlist';
  static const String orderTracking = '/order-tracking';
  static const String orderDetail = '/order-detail';
  static const String settings = '/settings';
  static const String search = '/search';
  static const String login = '/login';
  static const String register = '/register';
  static const String myOrders = '/my-orders';

  static final GoRouter router = GoRouter(
    initialLocation: splash,
    routes: [
      GoRoute(path: splash, builder: (_, __) => const SplashScreen()),
      GoRoute(path: onboarding, builder: (_, __) => const OnboardingScreen()),
      GoRoute(path: home, builder: (_, __) => const HomeScreen()),
      GoRoute(
        path: products,
        builder: (_, state) {
          final catId = state.uri.queryParameters['category_id'];
          final brandId = state.uri.queryParameters['brand_id'];
          final catName = state.uri.queryParameters['name'] ?? 'المنتجات';
          return ProductListScreen(
            categoryId: catId != null ? int.tryParse(catId) : null,
            brandId: brandId != null ? int.tryParse(brandId) : null,
            categoryName: catName,
          );
        },
      ),
      GoRoute(
        path: productDetail,
        builder: (_, state) {
          final slug = state.pathParameters['slug']!;
          return ProductDetailScreen(slug: slug);
        },
      ),
      GoRoute(path: cart, builder: (_, __) => const CartScreen()),
      GoRoute(path: checkout, builder: (_, __) => const CheckoutScreen()),
      GoRoute(
        path: orderSuccess,
        builder: (_, state) {
          final orderNumber = state.uri.queryParameters['order'] ?? '';
          return OrderSuccessScreen(orderNumber: orderNumber);
        },
      ),
      GoRoute(path: wishlist, builder: (_, __) => const WishlistScreen()),
      GoRoute(path: orderTracking, builder: (_, __) => const OrderTrackingScreen()),
      GoRoute(
        path: orderDetail,
        builder: (_, state) {
          final number = state.uri.queryParameters['number'] ?? '';
          return OrderDetailScreen(orderNumber: number);
        },
      ),
      GoRoute(path: settings, builder: (_, __) => const SettingsScreen()),
      GoRoute(path: search, builder: (_, __) => const SearchScreen()),
      GoRoute(path: login, builder: (_, __) => const LoginScreen()),
      GoRoute(path: register, builder: (_, __) => const RegisterScreen()),
      GoRoute(path: myOrders, builder: (_, __) => const MyOrdersScreen()),
    ],
  );
}
