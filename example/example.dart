import 'dart:io';

import 'package:nyxx/nyxx.dart';

void main() async {
  final client = await Nyxx.connectGateway(
    Platform.environment['TOKEN']!,
    GatewayIntents.allUnprivileged,
    options: GatewayClientOptions(plugins: [Logging(logLevel: Level.ALL), cliIntegration]),
  );

  client.onReady.listen((final ReadyEvent event) {
    print('Ready!');

    // get guilds
    final guilds = client.guilds.cache.values.toList();
    // print all guild details
    for (final guild in guilds) {
      print('Guild ${guild.name} has ${guild.channelList.length} channels');
    }
  });

  await for (final MessageCreateEvent(:message) in client.onMessageCreate) {
    print('Message ${message.id} sent by ${message.author.username} in channel ${message.channelId}!');

    if (message.content.contains('nyxx')) {
      await message.react(ReactionBuilder(name: '❤️', id: null));
    }
  }
}
