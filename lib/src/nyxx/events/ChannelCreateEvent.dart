part of nyxx;

/// Sent when a channel is created.
class ChannelCreateEvent {
  /// The channel that was created, either a [GuildChannel], [DMChannel], or [GroupDMChannel].
  Channel channel;

  ChannelCreateEvent._new(Nyxx client, Map<String, dynamic> json) {
    if (client.ready) {
      if (json['d']['type'] == 1) {
        this.channel =
            DMChannel._new(client, json['d'] as Map<String, dynamic>);
        client._events.onChannelCreate.add(this);
      } else if (json['d']['type'] == 3) {
        this.channel =
            GroupDMChannel._new(client, json['d'] as Map<String, dynamic>);
        client._events.onChannelCreate.add(this);
      } else {
        final Guild guild =
            client.guilds[Snowflake(json['d']['guild_id'] as String)];
        if (json['d']['type'] == 0) {
          this.channel = TextChannel._new(
              client, json['d'] as Map<String, dynamic>, guild);
        } else {
          this.channel = VoiceChannel._new(
              client, json['d'] as Map<String, dynamic>, guild);
        }
        client._events.onChannelCreate.add(this);
      }
    }
  }
}
