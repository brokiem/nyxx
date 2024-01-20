import 'dart:convert';

import 'package:http/http.dart' hide MultipartRequest;
import 'package:http/http.dart' as http show MultipartRequest;
import 'package:nyxx/src/client.dart';
import 'package:nyxx/src/http/route.dart';

/// An HTTP request to be made against the API.
///
/// {@template http_request}
/// This class is a wrapper around the [BaseRequest] class from `package:http`, providing rate
/// limit, audit log and authentication support.
/// {@endtemplate}
abstract class HttpRequest {
  /// The name of the header containing the audit log reason for a request.
  static const xAuditLogReason = 'X-Audit-Log-Reason';

  /// The name of the header containing the authentication for a request.
  static const authorization = 'Authorization';

  /// The name of the header containing the user agent for a request.
  static const userAgent = 'User-Agent';

  /// The route for this request.
  final HttpRoute route;

  /// The method for this request.
  final String method;

  /// The query parameters for this request.
  final Map<String, String> queryParameters;

  /// The headers for this request.
  ///
  /// This map will not contain the [authorization] or the [xAuditLogReason] headers generated by
  /// nyxx, but it will override their values if they are present.
  final Map<String, String> headers;

  /// The audit log reason for this request.
  ///
  /// Only supported on certain endpoints.
  final String? auditLogReason;

  /// Whether to add authentication to this request when sending it.
  final bool authenticated;

  /// Whether to apply the global rate limit to this request.
  final bool applyGlobalRateLimit;

  /// The identifier for the rate limit bucket for this request.
  String get rateLimitId => '$method ${route.rateLimitId}';

  /// Create a new [HttpRequest].
  ///
  /// {@macro http_request}
  HttpRequest(
    this.route, {
    this.method = 'GET',
    this.queryParameters = const {},
    this.headers = const {},
    this.auditLogReason,
    this.authenticated = true,
    this.applyGlobalRateLimit = true,
  });

  /// Transform this [HttpRequest] into a [BaseRequest] to be sent.
  ///
  /// The [client] will be used for authentication if authentication is enabled for this request.
  BaseRequest prepare(Nyxx client);

  Uri _getUri(Nyxx client) => Uri.https(
        client.apiOptions.host,
        client.apiOptions.baseUri + route.path,
        queryParameters.isNotEmpty ? queryParameters : null,
      );

  Map<String, String> _getHeaders(Nyxx client) => {
        userAgent: client.apiOptions.userAgent,
        if (auditLogReason != null) xAuditLogReason: auditLogReason!,
        if (authenticated) authorization: client.apiOptions.authorizationHeader,
        'Accept-Language': 'en-US,en;q=0.9',
        'Origin': 'https://discord.com',
        'Referer': 'https://discord.com/channels/@me',
        'Sec-Ch-Ua': '"Not_A Brand";v="8", "Chromium";v="120", "Google Chrome";v="120"',
        'Sec-Ch-Ua-Mobile': '?0',
        'Sec-Ch-Ua-Platform': '"Windows"',
        'Sec-Fetch-Dest': 'empty',
        'Sec-Fetch-Mode': 'cors',
        'Sec-Fetch-Site': 'same-origin',
        'X-Debug-Options': 'bugReporterEnabled',
        'X-Discord-Locale': 'en-US',
        'X-Discord-Timezone': 'Universal',
        'X-Super-Properties': base64Encode(utf8.encode(jsonEncode(client.apiOptions.properties))),
        ...headers,
      };

  @override
  String toString() => 'HttpRequest($method $route)';
}

/// An [HttpRequest] with a JSON body.
class BasicRequest extends HttpRequest {
  /// The `Content-Type` header for JSON requests.
  static const jsonContentTypeHeader = {'Content-Type': 'application/json'};

  /// The JSON-encoded body of this request.
  ///
  /// Set to `null` to send no body.
  final String? body;

  /// Create a new [BasicRequest].
  BasicRequest(
    super.route, {
    this.body,
    super.method,
    super.queryParameters,
    super.applyGlobalRateLimit,
    super.auditLogReason,
    super.authenticated,
    super.headers,
  });

  @override
  Request prepare(Nyxx client) {
    final request = Request(method, _getUri(client));
    request.headers.addAll(_getHeaders(client));

    if (body != null) {
      request.headers.addAll(jsonContentTypeHeader);
      request.body = body!;
    }

    return request;
  }
}

class FormDataRequest extends HttpRequest {
  /// A list of files to be sent in this request.
  final List<MultipartFile> files;

  /// Form params to send with http request
  final Map<String, String> formParams;

  /// Create a new [FormDataRequest].
  FormDataRequest(
    super.route, {
    this.formParams = const {},
    this.files = const [],
    super.applyGlobalRateLimit,
    super.auditLogReason,
    super.authenticated,
    super.headers,
    super.method,
    super.queryParameters,
  });

  @override
  http.MultipartRequest prepare(Nyxx client) {
    final request = http.MultipartRequest(method, _getUri(client));
    request
      ..headers.addAll(_getHeaders(client))
      ..fields.addAll(formParams)
      ..files.addAll(files);

    return request;
  }
}

/// An [HttpRequest] with files & a JSON payload.
class MultipartRequest extends FormDataRequest {
  /// Create a new [MultipartRequest].
  MultipartRequest(
    super.route, {
    String? jsonPayload,
    super.files,
    super.applyGlobalRateLimit,
    super.auditLogReason,
    super.authenticated,
    super.headers,
    super.method,
    super.queryParameters,
  }) : super(formParams: jsonPayload != null ? {'payload_json': jsonPayload} : {});
}
