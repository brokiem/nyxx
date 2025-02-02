import 'package:nyxx/src/models/gateway/event.dart';
import 'package:nyxx/src/models/guild/guild.dart';
import 'package:nyxx/src/models/user/user.dart';

/// {@template ready_event}
/// Emitted when the client's Gateway session is established.
/// {@endtemplate}
class ReadyEvent extends DispatchEvent {
  /// The version of the API being used.
  final int version;

  /// The current client's user.
  final User user;

  /// A list of guilds the user is in.
  final List<Guild> guilds;

  /// The ID of the Gateway session.
  final String sessionId;

  /// The URL to use when resuming the Gateway session.
  final Uri gatewayResumeUrl;

  /// The ID of the shard.
  final int? shardId;

  /// The total number of shards.
  final int? totalShards;

  /// {@macro ready_event}
  /// @nodoc
  ReadyEvent({
    required super.gateway,
    required this.version,
    required this.user,
    required this.guilds,
    required this.sessionId,
    required this.gatewayResumeUrl,
    required this.shardId,
    required this.totalShards,
  });
}

/// {@template resumed_event}
/// Emitted when
/// {@endtemplate}
class ResumedEvent extends DispatchEvent {
  /// {@macro resumed_event}
  /// @nodoc
  ResumedEvent({required super.gateway});
}
