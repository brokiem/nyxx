part of nyxx;

/// Represents channel with another user.
class DMChannel extends MessageChannel {
  /// The recipient.
  User recipient;

  DMChannel._new(Nyxx client, Map<String, dynamic> data)
      : super._new(client, data, 4) {
    if (raw['recipients'] != null) {
      this.recipient =
          User._new(client, raw['recipients'][0] as Map<String, dynamic>);
    } else {
      this.recipient =
          User._new(client, raw['recipient'] as Map<String, dynamic>);
    }
  }
}
