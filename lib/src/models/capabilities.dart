import 'package:nyxx/src/utils/flags.dart';

/// A set of client capabilities
///
/// Capabilities is a field (capabilities) within the IDENTIFY payload
/// that communicates what the client is "capable" of. Unfortunately this
/// means Discord's API does weird things that don't match what the documentation says.
///
/// External references:
/// * https://discord.neko.wtf/capabilities/
class Capabilities extends Flags<Capabilities> {
  /// Don't send user notes in READY
  static const lazyUserNotes = Flag<Capabilities>.fromOffset(0);

  static const noAffineUserIds = Flag<Capabilities>.fromOffset(1);

  static const versionedReadStates = Flag<Capabilities>.fromOffset(2);

  static const versionedUserGuildSettings = Flag<Capabilities>.fromOffset(3);

  static const deduplicateUserObjects = Flag<Capabilities>.fromOffset(4);

  /// Responsible for sending READY_SUPPLEMENTAL
  static const prioritizedReadyPayload = Flag<Capabilities>.fromOffset(5);

  static const multipleGuildExperimentPopulations = Flag<Capabilities>.fromOffset(6);

  static const nonChannelReadStates = Flag<Capabilities>.fromOffset(7);

  static const authTokenRefresh = Flag<Capabilities>.fromOffset(8);

  /// user_settings field in the READY message will be omitted
  static const userSettingsProto = Flag<Capabilities>.fromOffset(9);

  /// Heavily alters the guild object
  static const clientStateV2 = Flag<Capabilities>.fromOffset(10);

  /// Causes the gateway to send PASSIVE_UPDATE_V1 events
  static const passiveGuildUpdate = Flag<Capabilities>.fromOffset(11);

  /// Behavior unknown. Only changed observed so far is CALL_CREATE events being fired for calls that are active at time of connection
  static const unnamedBit12 = Flag<Capabilities>.fromOffset(12);

  /// Causes gateway to send MESSAGE_REACTION_ADD_MANY
  static const unnamedBit13 = Flag<Capabilities>.fromOffset(13);

  static const all = Capabilities(16383);

  static const none = Capabilities(0);

  /// Create a new [Capabilities] from a capabilities value.
  const Capabilities(super.value);
}