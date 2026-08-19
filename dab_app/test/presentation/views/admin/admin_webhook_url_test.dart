import 'package:dab_app/presentation/views/admin/models/admin_webhook_url.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  const public = 'https://discourse-huddle-bagful.ngrok-free.dev';
  const client = 'http://localhost:9080';
  const settings = {'public_api_url': public};

  test('derives Jira webhook from Security public_api_url', () {
    expect(
      derivedWebhookUrl(providerId: 'jira', systemSettings: settings),
      '$public/integrations/jira/webhook',
    );
  });

  test('Slack uses the events path', () {
    expect(
      derivedWebhookUrl(providerId: 'slack', systemSettings: settings),
      '$public/integrations/slack/events',
    );
  });

  test('upgrades public http public_api_url to https', () {
    expect(
      derivedWebhookUrl(
        providerId: 'figma',
        systemSettings: const {
          'public_api_url': 'http://discourse-huddle-bagful.ngrok-free.dev',
        },
      ),
      'https://discourse-huddle-bagful.ngrok-free.dev/integrations/figma/webhook',
    );
  });

  test('does not invent a localhost default when public_api_url is unset', () {
    expect(
      derivedWebhookUrl(providerId: 'jira', systemSettings: const {}),
      isEmpty,
    );
  });

  test('replaces a leftover localhost stored URL with the Security URL', () {
    expect(
      displayWebhookUrl(
        stored: '$client/integrations/jira/webhook',
        publicApiDerived: '$public/integrations/jira/webhook',
        clientDerived: '$client/integrations/jira/webhook',
      ),
      '$public/integrations/jira/webhook',
    );
  });

  test('keeps a genuine custom override', () {
    expect(
      displayWebhookUrl(
        stored: 'https://hooks.example/jira',
        publicApiDerived: '$public/integrations/jira/webhook',
        clientDerived: '$client/integrations/jira/webhook',
      ),
      'https://hooks.example/jira',
    );
  });

  test('does not persist localhost or the Security default', () {
    expect(
      shouldPersistWebhookUrl(
        value: '$client/integrations/jira/webhook',
        publicApiDerived: '$public/integrations/jira/webhook',
        clientDerived: '$client/integrations/jira/webhook',
      ),
      isFalse,
    );
    expect(
      shouldPersistWebhookUrl(
        value: '$public/integrations/jira/webhook',
        publicApiDerived: '$public/integrations/jira/webhook',
        clientDerived: '$client/integrations/jira/webhook',
      ),
      isFalse,
    );
    expect(
      shouldPersistWebhookUrl(
        value: 'https://hooks.example/jira',
        publicApiDerived: '$public/integrations/jira/webhook',
        clientDerived: '$client/integrations/jira/webhook',
      ),
      isTrue,
    );
  });
}
