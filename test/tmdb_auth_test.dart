import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get/get.dart';
import 'package:hive/hive.dart';
import 'package:http/http.dart' as http;
import 'package:http/testing.dart';
import 'package:screenly/app/data/models/tmdb_account_model.dart';
import 'package:screenly/app/data/services/tmdb_auth_service.dart';
import 'package:screenly/app/modules/profile/controllers/profile_controller.dart';
import 'package:screenly/app/modules/profile/views/profile_view.dart';
import 'package:screenly/utils/preferences_utils.dart';

void main() {
  setUpAll(() {
    final tempDir = Directory.systemTemp.createTempSync('screenly_auth_test_');
    Hive.init(tempDir.path);
  });

  setUp(() {
    Get.deleteAll(force: true);
    Get.reset();
  });

  group('TmdbAccountModel', () {
    test('parses account details with TMDB avatar and computes getters', () {
      final json = {
        'id': 548,
        'name': 'Travis Bell',
        'username': 'travisbell',
        'include_adult': false,
        'iso_639_1': 'en',
        'iso_3166_1': 'CA',
        'avatar': {
          'tmdb': {'avatar_path': '/rkBwhsn8h6j7k0k3.png'},
          'gravatar': {'hash': 'c9e9fc152ee756a935964dab850fb301'},
        },
      };

      final account = TmdbAccountModel.fromJson(json);

      expect(account.id, 548);
      expect(account.name, 'Travis Bell');
      expect(account.username, 'travisbell');
      expect(account.displayName, 'Travis Bell');
      expect(
        account.avatarUrl,
        'https://image.tmdb.org/t/p/w200/rkBwhsn8h6j7k0k3.png',
      );
      expect(account.includeAdult, isFalse);
      expect(account.iso6391, 'en');
      expect(account.iso31661, 'CA');
    });

    test('falls back to username when name is empty', () {
      final json = {
        'id': 100,
        'name': '',
        'username': 'moviefan99',
        'avatar': {
          'gravatar': {'hash': 'abc123hash'},
        },
      };

      final account = TmdbAccountModel.fromJson(json);

      expect(account.displayName, 'moviefan99');
      expect(
        account.avatarUrl,
        'https://www.gravatar.com/avatar/abc123hash?s=200&d=mp',
      );
    });

    test('toJson produces expected structure', () {
      final account = TmdbAccountModel(
        id: 777,
        name: 'Screenly User',
        username: 'screenly_user',
        avatarPath: '/avatar.jpg',
      );

      final json = account.toJson();

      expect(json['id'], 777);
      expect(json['name'], 'Screenly User');
      expect(json['username'], 'screenly_user');
      expect(json['avatar_path'], '/avatar.jpg');
    });
  });

  group('PreferencesUtils TMDB Session', () {
    test('saves, retrieves, and clears TMDB session info', () async {
      await PreferencesUtils.clearTmdbSession();
      expect(await PreferencesUtils.isTmdbLoggedIn(), isFalse);
      expect(await PreferencesUtils.getTmdbSessionId(), null);
      expect(await PreferencesUtils.getTmdbAccountId(), null);

      const sessionId = 'test_session_12345';
      const accountId = 999;
      final userData = {
        'id': accountId,
        'name': 'Test User',
        'username': 'testuser',
      };

      await PreferencesUtils.saveTmdbSession(
        sessionId: sessionId,
        accountId: accountId,
        user: userData,
      );

      expect(await PreferencesUtils.isTmdbLoggedIn(), isTrue);
      expect(await PreferencesUtils.getTmdbSessionId(), sessionId);
      expect(await PreferencesUtils.getTmdbAccountId(), accountId);

      final user = await PreferencesUtils.getTmdbUser();
      expect(user, isNotNull);
      expect(user!['username'], 'testuser');

      await PreferencesUtils.clearTmdbSession();
      expect(await PreferencesUtils.isTmdbLoggedIn(), isFalse);
      expect(await PreferencesUtils.getTmdbSessionId(), null);
    });
  });

  group('TmdbAuthService', () {
    test('createRequestToken returns token on 200 success', () async {
      final mockClient = MockClient((request) async {
        if (request.url.path.contains('/authentication/token/new')) {
          return http.Response(
            json.encode({
              'success': true,
              'request_token': 'mock_request_token_abc',
            }),
            200,
          );
        }
        return http.Response('Not Found', 404);
      });

      final authService = TmdbAuthService(client: mockClient);
      final token = await authService.createRequestToken();
      expect(token, 'mock_request_token_abc');
    });

    test('buildAuthUrl includes default deep link redirect_to parameter', () {
      final authService = TmdbAuthService();
      final uri = authService.buildAuthUrl('token_test_123');
      expect(
        uri.toString(),
        'https://www.themoviedb.org/authenticate/token_test_123?redirect_to=screenly%3A%2F%2Fapproved',
      );

      final uriCustom = authService.buildAuthUrl(
        'token_test_123',
        redirectTo: 'https://screenly.app/callback',
      );
      expect(
        uriCustom.toString(),
        'https://www.themoviedb.org/authenticate/token_test_123?redirect_to=https%3A%2F%2Fscreenly.app%2Fcallback',
      );
    });

    test('createSession returns session_id on success', () async {
      final mockClient = MockClient((request) async {
        if (request.url.path.contains('/authentication/session/new')) {
          return http.Response(
            json.encode({
              'success': true,
              'session_id': 'mock_session_id_456',
            }),
            200,
          );
        }
        return http.Response('Not Found', 404);
      });

      final authService = TmdbAuthService(client: mockClient);
      final sessionId = await authService.createSession(
        requestToken: 'validated_token',
      );
      expect(sessionId, 'mock_session_id_456');
    });

    test('getAccountDetails returns TmdbAccountModel on success', () async {
      final mockClient = MockClient((request) async {
        if (request.url.path.contains('/account')) {
          return http.Response(
            json.encode({
              'id': 1234,
              'name': 'John Doe',
              'username': 'johndoe',
              'include_adult': false,
            }),
            200,
          );
        }
        return http.Response('Not Found', 404);
      });

      final authService = TmdbAuthService(client: mockClient);
      final account = await authService.getAccountDetails(
        sessionId: 'test_session',
      );
      expect(account.id, 1234);
      expect(account.displayName, 'John Doe');
    });

    test('deleteSession returns true on success', () async {
      final mockClient = MockClient((request) async {
        if (request.url.path.contains('/authentication/session')) {
          return http.Response(json.encode({'success': true}), 200);
        }
        return http.Response('Not Found', 404);
      });

      final authService = TmdbAuthService(client: mockClient);
      final success =
          await authService.deleteSession(sessionId: 'test_session');
      expect(success, isTrue);
    });
  });

  group('ProfileController Web Auth & Deep Link', () {
    test('startWebAuth requests token and launches browser URL with deep link',
        () async {
      Uri? launchedUri;
      final mockClient = MockClient((request) async {
        if (request.url.path.contains('/authentication/token/new')) {
          return http.Response(
            json.encode({
              'success': true,
              'request_token': 'test_req_token',
            }),
            200,
          );
        }
        return http.Response('Not Found', 404);
      });

      final authService = TmdbAuthService(client: mockClient);
      final controller = ProfileController(
        authService: authService,
        urlLauncher: (uri) async {
          launchedUri = uri;
          return true;
        },
        autoCheck: false,
      );

      final result = await controller.startWebAuth();

      expect(result, isTrue);
      expect(controller.isAwaitingApproval.value, isTrue);
      expect(controller.activeRequestToken.value, 'test_req_token');
      expect(
        launchedUri.toString(),
        'https://www.themoviedb.org/authenticate/test_req_token?redirect_to=screenly%3A%2F%2Fapproved',
      );
    });

    test('incoming deep link screenly://approved automatically completes login',
        () async {
      final mockClient = MockClient((request) async {
        if (request.url.path.contains('/authentication/session/new')) {
          return http.Response(
            json.encode({
              'success': true,
              'session_id': 'auto_deep_link_session',
            }),
            200,
          );
        }
        if (request.url.path.contains('/account')) {
          return http.Response(
            json.encode({
              'id': 555,
              'name': 'Deep Link User',
              'username': 'deeplinker',
              'include_adult': false,
            }),
            200,
          );
        }
        return http.Response('Not Found', 404);
      });

      final linkController = StreamController<Uri>.broadcast();
      final authService = TmdbAuthService(client: mockClient);

      final controller = ProfileController(
        authService: authService,
        linkStream: linkController.stream,
        autoCheck: false,
      );
      controller.onInit();

      controller.activeRequestToken.value = 'token_prior';
      controller.isAwaitingApproval.value = true;

      // Simulate browser redirecting to screenly://approved?request_token=token_prior&approved=true
      linkController.add(
        Uri.parse(
          'screenly://approved?request_token=token_prior&approved=true',
        ),
      );

      // Allow event stream and async API calls to complete
      await Future<void>.delayed(const Duration(milliseconds: 100));

      expect(controller.isLoggedIn.value, isTrue);
      expect(controller.isAwaitingApproval.value, isFalse);
      expect(controller.currentUser.value?.displayName, 'Deep Link User');
      expect(await PreferencesUtils.isTmdbLoggedIn(), isTrue);
      expect(
        await PreferencesUtils.getTmdbSessionId(),
        'auto_deep_link_session',
      );

      await linkController.close();
      await PreferencesUtils.clearTmdbSession();
    });

    test('incoming deep link with denied=true cancels auth state', () async {
      final linkController = StreamController<Uri>.broadcast();
      final controller = ProfileController(
        linkStream: linkController.stream,
        autoCheck: false,
      );
      controller.onInit();

      controller.activeRequestToken.value = 'token_to_deny';
      controller.isAwaitingApproval.value = true;

      linkController.add(Uri.parse('screenly://approved?denied=true'));
      await Future<void>.delayed(const Duration(milliseconds: 100));

      expect(controller.isLoggedIn.value, isFalse);
      expect(controller.isAwaitingApproval.value, isFalse);
      expect(controller.activeRequestToken.value, isNull);

      await linkController.close();
    });

    test('cancelWebAuth resets approval state', () {
      final controller = ProfileController(autoCheck: false);
      controller.isAwaitingApproval.value = true;
      controller.activeRequestToken.value = 'temporary_token';

      controller.cancelWebAuth();

      expect(controller.isAwaitingApproval.value, isFalse);
      expect(controller.activeRequestToken.value, isNull);
    });
  });

  group('ProfileView', () {
    testWidgets('renders initial web auth card when not logged in',
        (tester) async {
      await PreferencesUtils.clearTmdbSession();

      final controller = Get.put(
        ProfileController(autoCheck: false),
      );
      controller.isCheckingAuth.value = false;
      controller.isLoggedIn.value = false;
      controller.isAwaitingApproval.value = false;

      await tester.pumpWidget(
        ScreenUtilInit(
          designSize: const Size(375, 812),
          builder: (context, child) => const GetMaterialApp(
            home: ProfileView(),
          ),
        ),
      );
      await tester.pump();

      expect(find.text('Profile'), findsOneWidget);
      expect(find.text('Connect TMDB Account'), findsOneWidget);
      expect(find.text('How it works'), findsOneWidget);
      expect(find.text('Authorize via TMDB Website'), findsOneWidget);
    });

    testWidgets('renders awaiting approval card when auth in progress',
        (tester) async {
      final controller = Get.put(
        ProfileController(autoCheck: false),
      );
      controller.isCheckingAuth.value = false;
      controller.isLoggedIn.value = false;
      controller.isAwaitingApproval.value = true;

      await tester.pumpWidget(
        ScreenUtilInit(
          designSize: const Size(375, 812),
          builder: (context, child) => const GetMaterialApp(
            home: ProfileView(),
          ),
        ),
      );
      await tester.pump();

      expect(find.text('Waiting for Approval'), findsOneWidget);
      expect(
        find.text('I Have Approved (Complete Login)'),
        findsOneWidget,
      );
      expect(find.text('Reopen Browser'), findsOneWidget);
      expect(find.text('Cancel'), findsOneWidget);
    });

    testWidgets('renders account details when user is logged in',
        (tester) async {
      final controller = Get.put(
        ProfileController(autoCheck: false),
      );
      controller.isCheckingAuth.value = false;
      controller.isLoggedIn.value = true;
      controller.isAwaitingApproval.value = false;
      controller.currentUser.value = TmdbAccountModel(
        id: 999,
        name: 'Sarah Connor',
        username: 'sconnor',
        iso31661: 'US',
        iso6391: 'en',
      );

      await tester.pumpWidget(
        ScreenUtilInit(
          designSize: const Size(375, 812),
          builder: (context, child) => const GetMaterialApp(
            home: ProfileView(),
          ),
        ),
      );
      await tester.pump();

      expect(find.text('Sarah Connor'), findsOneWidget);
      expect(find.text('@sconnor'), findsOneWidget);
      expect(find.text('TMDB Session Active'), findsOneWidget);
      expect(find.text('Account Information'), findsOneWidget);
      expect(find.text('Disconnect TMDB Account'), findsOneWidget);
    });
  });
}
