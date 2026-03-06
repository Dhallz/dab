import 'dart:io';

import 'package:dab_api/src/infrastructure/connectors/phorge/phorge_client.dart';

void main() async {
  final client = PhorgeClient();

  try {
    final whoami = await client.call('user.whoami', {});
    final phid = whoami['phid'];

    print('Testing global transaction search sorting for author $phid...');

    final txRes = await client.call('transaction.search', {
      'objectType': 'TASK',
      'constraints': {
        'authorPHIDs': [phid],
      },
      'limit': 5,
    });

    final data = txRes['data'] as List;
    for (var tx in data) {
      print('ID: ${tx['id']}, Date: ${tx['dateCreated']}');
    }
  } catch (e) {
    print('Failed or unsupported: $e');
  }
  exit(0);
}
