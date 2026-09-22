import 'dart:async';
import 'package:app_links/app_links.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:screenly/app/data/models/tmdb_account_model.dart';
import 'package:screenly/app/data/services/tmdb_auth_service.dart';
import 'package:screenly/config/theme_config.dart';
import 'package:screenly/utils/preferences_utils.dart';
import 'package:url_launcher/url_launcher.dart';

typedef UrlLauncherFunction = Future<bool> Function(Uri uri);

class ProfileController extends GetxController {
  final TmdbAuthService _authService;
  final UrlLauncherFunction _urlLauncher;
  final AppLinks? _appLinks;
  final Stream<Uri>? _customLinkStream;
  final bool autoCheck;

  StreamSubscription<Uri>? _linkSubscription;

  ProfileController({
    TmdbAuthService? authService,
    UrlLauncherFunction? urlLauncher,
    AppLinks? appLinks,
    Stream<Uri>? linkStream,
    this.autoCheck = true,
  })  : _authService = authService ?? TmdbAuthService(),
        _urlLauncher = urlLauncher ??
            ((uri) => launchUrl(uri, mode: LaunchMode.externalApplication)),
        _appLinks = appLinks ?? AppLinks(),
        _customLinkStream = linkStream;

  final isLoggedIn = false.obs;
  final isLoading = false.obs;
  final isCheckingAuth = true.obs;
  final isAwaitingApproval = false.obs;
  final activeRequestToken = RxnString();
  final currentUser = Rxn<TmdbAccountModel>();
  final errorMessage = ''.obs;

  @override
  void onInit() {
    super.onInit();
    _initDeepLinkListener();
    if (autoCheck) {
      checkAuthStatus();
    }
  }

  @override
  void onClose() {
    _linkSubscription?.cancel();
    super.onClose();
  }

  void _initDeepLinkListener() {
    final stream = _customLinkStream ?? _appLinks?.uriLinkStream;
    if (stream != null) {
      _linkSubscription = stream.listen(
        (uri) {
          handleIncomingUri(uri);
        },
        onError: (_) {},
      );
    }

    if (_customLinkStream == null && _appLinks != null) {
      _appLinks.getInitialLink().then((uri) {
        if (uri != null) {
          handleIncomingUri(uri);
        }
      }).catchError((_) {});
    }
  }

  /// Handle incoming deep links (e.g. screenly://approved?request_token=...&approved=true)
  Future<void> handleIncomingUri(Uri uri) async {
    final matchesScheme = uri.scheme == TmdbAuthService.authCallbackScheme;
    final matchesHost = uri.host == TmdbAuthService.authCallbackHost ||
        uri.path.contains(TmdbAuthService.authCallbackHost);

    if (!matchesScheme || !matchesHost) return;

    // 1. Check if the user declined access on TMDB website
    final isDenied = uri.queryParameters['denied'] == 'true';
    if (isDenied) {
      cancelWebAuth();
      _showSnackbar(
        'Authorization Cancelled',
        'You declined the permission request on TMDB.',
        bgColor: Colors.amber.shade900,
        duration: const Duration(seconds: 4),
        icon: Icons.cancel_outlined,
      );
      return;
    }

    // 2. TMDB appends request_token in the redirect query params
    final tokenFromUri = uri.queryParameters['request_token'];
    if (tokenFromUri != null && tokenFromUri.isNotEmpty) {
      activeRequestToken.value = tokenFromUri;
    }

    // 3. Complete authentication automatically
    if (activeRequestToken.value != null && !isLoggedIn.value) {
      await completeWebAuth();
    }
  }

  Future<void> checkAuthStatus() async {
    try {
      isCheckingAuth.value = true;
      final loggedIn = await PreferencesUtils.isTmdbLoggedIn();
      if (loggedIn) {
        final userMap = await PreferencesUtils.getTmdbUser();
        if (userMap != null) {
          currentUser.value = TmdbAccountModel.fromJson(userMap);
          isLoggedIn.value = true;
        }

        // Refresh account details asynchronously
        final sessionId = await PreferencesUtils.getTmdbSessionId();
        if (sessionId != null) {
          try {
            final freshAccount =
                await _authService.getAccountDetails(sessionId: sessionId);
            currentUser.value = freshAccount;
            await PreferencesUtils.saveTmdbSession(
              sessionId: sessionId,
              accountId: freshAccount.id,
              user: freshAccount.toJson(),
            );
          } catch (_) {
            // Keep cached user on network failure
          }
        }
      } else {
        isLoggedIn.value = false;
        currentUser.value = null;
      }
    } catch (_) {
      isLoggedIn.value = false;
      currentUser.value = null;
    } finally {
      isCheckingAuth.value = false;
    }
  }

  /// Step 1 & 2: Start Web Browser Auth Flow with deep link redirect
  Future<bool> startWebAuth() async {
    try {
      isLoading.value = true;
      errorMessage.value = '';

      // 1. Generate new request token
      final token = await _authService.createRequestToken();
      activeRequestToken.value = token;

      // 2. Build auth URL with deep link redirect (screenly://approved)
      final authUrl = _authService.buildAuthUrl(
        token,
        redirectTo: TmdbAuthService.defaultRedirectUrl,
      );

      // 3. Launch URL in external browser
      final launched = await _urlLauncher(authUrl);
      if (!launched) {
        throw Exception('Could not launch browser for TMDB authorization');
      }

      // 4. Update state to awaiting approval
      isAwaitingApproval.value = true;
      return true;
    } catch (e) {
      final cleanMsg = e.toString().replaceFirst('Exception: ', '');
      errorMessage.value = cleanMsg;
      _showSnackbar(
        'Failed to open TMDB',
        cleanMsg,
        bgColor: Colors.red.shade900,
        duration: const Duration(seconds: 4),
        icon: Icons.error_outline_rounded,
      );
      return false;
    } finally {
      isLoading.value = false;
    }
  }

  /// Re-open the authorization URL if user closed the browser tab
  Future<void> reopenAuthUrl() async {
    final token = activeRequestToken.value;
    if (token == null) return;

    try {
      final authUrl = _authService.buildAuthUrl(
        token,
        redirectTo: TmdbAuthService.defaultRedirectUrl,
      );
      await _urlLauncher(authUrl);
    } catch (_) {
      // Ignore error on reopen
    }
  }

  /// Step 3: Complete Web Auth by exchanging approved request_token with session_id
  Future<bool> completeWebAuth() async {
    final token = activeRequestToken.value;
    if (token == null) {
      errorMessage.value = 'No active request token. Please try again.';
      return false;
    }

    if (isLoading.value) return false;

    try {
      isLoading.value = true;
      errorMessage.value = '';

      // 1. Create session from authorized token
      final sessionId = await _authService.createSession(requestToken: token);

      // 2. Fetch account details
      final account =
          await _authService.getAccountDetails(sessionId: sessionId);

      // 3. Save to local storage
      await PreferencesUtils.saveTmdbSession(
        sessionId: sessionId,
        accountId: account.id,
        user: account.toJson(),
      );

      currentUser.value = account;
      isLoggedIn.value = true;
      isAwaitingApproval.value = false;
      activeRequestToken.value = null;

      _showSnackbar(
        'Login Successful',
        'Welcome, ${account.displayName}!',
        icon: Icons.check_circle_rounded,
      );
      return true;
    } catch (e) {
      final cleanMsg = e.toString().replaceFirst('Exception: ', '');
      errorMessage.value = cleanMsg;

      final isNotApproved = cleanMsg.toLowerCase().contains('denied') ||
          cleanMsg.toLowerCase().contains('not been granted') ||
          cleanMsg.toLowerCase().contains('permission') ||
          cleanMsg.toLowerCase().contains('failed to create');

      final displayMsg = isNotApproved
          ? 'Authorization not detected yet. Please tap "Approve" on the TMDB website first, then try again.'
          : cleanMsg;

      _showSnackbar(
        'Authorization Incomplete',
        displayMsg,
        bgColor: Colors.amber.shade900,
        duration: const Duration(seconds: 5),
        icon: Icons.info_outline_rounded,
      );
      return false;
    } finally {
      isLoading.value = false;
    }
  }

  /// Cancel awaiting approval state
  void cancelWebAuth() {
    isAwaitingApproval.value = false;
    activeRequestToken.value = null;
    errorMessage.value = '';
  }

  Future<void> logout() async {
    try {
      final sessionId = await PreferencesUtils.getTmdbSessionId();
      if (sessionId != null) {
        await _authService.deleteSession(sessionId: sessionId);
      }
    } catch (_) {
      // Ignore network errors on logout
    } finally {
      await PreferencesUtils.clearTmdbSession();
      isLoggedIn.value = false;
      currentUser.value = null;
      isAwaitingApproval.value = false;
      activeRequestToken.value = null;

      _showSnackbar(
        'Logged Out',
        'You have been logged out of TMDB',
        duration: const Duration(seconds: 2),
      );
    }
  }

  void _showSnackbar(
    String title,
    String message, {
    Color? bgColor,
    Color? textColor,
    IconData? icon,
    Duration? duration,
  }) {
    if (Get.context != null) {
      Get.snackbar(
        title,
        message,
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: bgColor ?? const Color(0xFF1E1E1E),
        colorText: textColor ?? Colors.white,
        margin: const EdgeInsets.all(16),
        borderRadius: 12,
        duration: duration ?? const Duration(seconds: 3),
        icon:
            icon != null ? Icon(icon, color: textColor ?? primaryColor) : null,
      );
    }
  }
}
