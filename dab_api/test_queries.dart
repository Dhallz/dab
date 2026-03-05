import 'dart:io';

import 'package:dab_api/src/infrastructure/config/config.dart';
import 'package:dab_api/src/infrastructure/connectors/phorge/phorge_client.dart';

void main() async {
  final config = Config();
  final client = PhorgeClient();

  try {
    // 1. Get whoami
    final whoami = await client.call('user.whoami', {});
    final phid = whoami['phid'];

    print('Fetching tasks for $phid...');
    final res = await client.call('maniphest.search', {
      'constraints': {
        'assigned': [phid],
        'statuses': ['open'],
      },
      'limit': 1,
    });

    final tasks = res['data'] as List;
    if (tasks.isEmpty) {
      print('No tasks found');
      exit(0);
    }

    final taskPhid = tasks.first['phid'];
    print('Fetching transactions for $taskPhid...');

    final txRes = await client.call('transaction.search', {
      'objectIdentifier': taskPhid,
    });

    final txs = txRes['data'] as List;
    for (var tx in txs) {
      if (tx['type'] == 'comment') {
        print('\nFound comment transaction:');
        print(tx);
      }
    }
  } catch (e) {
    print('Error: $e');
  }
  exit(0);
}
