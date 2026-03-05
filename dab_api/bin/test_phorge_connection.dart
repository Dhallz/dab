import 'dart:io';

import 'package:dab_api/src/domain/entities/user.dart';
import 'package:dab_api/src/infrastructure/config/config.dart';
import 'package:dab_api/src/infrastructure/connectors/phorge/phorge_client.dart';
import 'package:dab_api/src/infrastructure/connectors/phorge/phorge_connector.dart';

void main() async {
  final config = Config();

  if (config.phorgeUrl.contains('example.com') ||
      config.phorgeApiToken.isEmpty) {
    print('====================================================');
    print('❌ MISSING CONFIGURATION!');
    print('Please create a .env file in the dab_api directory:');
    print('PHORGE_URL=https://your-company.phorge.com');
    print('PHORGE_API_TOKEN=api-your-long-conduit-token');
    print('====================================================');
    exit(1);
  }

  print('\n🔗 Connecting to Phorge at ${config.phorgeUrl}...\n');

  final client = PhorgeClient();
  final connector = PhorgeConnector(client: client);

  try {
    print('==========================================');
    print('1. Testing Authentication (user.whoami)');
    print('==========================================');
    final whoami = await client.call('user.whoami', {});
    final phid = whoami['phid'];
    final realName = whoami['realName'];
    print('✅ Authenticated successfully as $realName ($phid)\n');

    print('==========================================');
    print('2. Testing Metadata (Available Tags)');
    print('==========================================');
    final projects = await connector.fetchAllProjects(phid);
    print('✅ Successfully fetched ${projects.length} active tags.');

    final sampleSize = projects.length > 5 ? 5 : projects.length;
    print('   Showing first $sampleSize tags:');
    for (var i = 0; i < sampleSize; i++) {
      final color = projects[i].color != null
          ? '[Color: ${projects[i].color}]'
          : '';
      print('   - ${projects[i].name} $color');
    }
    print('');

    print('==========================================');
    print('3. Testing Dashboard Activity Feed');
    print('==========================================');
    final dummyUser = User(
      id: 'test-user',
      name: realName,
      email: 'test@example.com',
      passwordHash: '',
      role: 'Standard',
      createdAt: DateTime.now(),
      phorgePhid: phid, // Crucial: Injecting the discovered PHID
    );

    print('⏳ Querying tasks active in the current Sprint...');
    final activities = await connector.fetchUserActivities(user: dummyUser);
    print(
      '✅ Successfully fetched ${activities.length} activities generated today:',
    );

    for (var act in activities) {
      print(
        '\n   [ ${act.createdAt.toLocal().toString().split('.')[0]} ] ${act.title}',
      );
      print('   ↳ ${act.content}');
      print('   🔗 ${act.url}');
    }

    print('\n🎉 INTEGRATION TEST COMPLETE 🎉');
  } catch (e) {
    print('\n❌ PIPELINE ERROR: $e');
  } finally {
    exit(0);
  }
}
