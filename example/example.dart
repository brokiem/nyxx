import 'dart:io';

import 'package:nyxx/nyxx.dart';

void main() async {
  final client = await Nyxx.connectGateway(
    Platform.environment['TOKEN']!,
    GatewayIntents.allUnprivileged,
    options: GatewayClientOptions(plugins: [logging, cliIntegration]),
  );

  await for (final MessageCreateEvent(:message) in client.onMessageCreate) {
    print('Message ${message.id} sent by ${message.author.username} in channel ${message.channelId}!');

    if (message.content.contains('nyxx')) {
      await message.react(ReactionBuilder(name: '❤️', id: null));
    }
  }
}
