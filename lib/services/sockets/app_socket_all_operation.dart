import 'dart:async';
import 'dart:convert';
import 'package:web_socket_channel/web_socket_channel.dart';
import 'package:olabisiolai_flutter_app/constant/app_api_url.dart';
import 'package:olabisiolai_flutter_app/services/storage/storage_services.dart';
import 'package:olabisiolai_flutter_app/services/api/api_services.dart';
import 'package:olabisiolai_flutter_app/utils/app_log.dart';

class AppSocketAllOperation {
  AppSocketAllOperation._privateConstructor();
  static final AppSocketAllOperation _instance =
      AppSocketAllOperation._privateConstructor();
  static AppSocketAllOperation get instance => _instance;

  WebSocketChannel? _channel;
  bool _isConnected = false;
  bool _isConnecting = false;
  String? _socketId;
  Timer? _reconnectTimer;

  // Track active channel subscriptions
  // Structure: { channel: { event: [handlers] } }
  final Map<String, Map<String, List<void Function(dynamic)>>> _channelEventHandlers = {};

  // Keep track of which channels we have successfully subscribed to on the socket
  final Set<String> _subscribedChannels = {};

  bool get isConnected => _isConnected;

  // Configuration (read dynamically from AppApiUrl)
  String get _appKey => AppApiUrl.reverbKey;
  String get _host => AppApiUrl.reverbHost;
  int? get _port => AppApiUrl.reverbPort;
  String get _scheme => AppApiUrl.reverbScheme;

  void initializeSocket() {
    if (_isConnected || _isConnecting) return;
    _connect();
  }

  void _connect() async {
    if (_isConnecting) return;
    _isConnecting = true;
    _reconnectTimer?.cancel();

    final portStr = _port != null ? ':$_port' : '';
    final wsUrl = '$_scheme://$_host$portStr/app/$_appKey?protocol=7&client=js&version=7.0.6&flash=false';

    appLog("Reverb: Connecting to $wsUrl");

    try {
      _channel = WebSocketChannel.connect(Uri.parse(wsUrl));
      _isConnecting = false;

      _channel!.stream.listen(
        (message) {
          _handleMessage(message);
        },
        onError: (error) {
          errorLog("Reverb WebSocket stream error", error);
          _handleDisconnect();
        },
        onDone: () {
          appLog("Reverb WebSocket connection closed");
          _handleDisconnect();
        },
      );
    } catch (e) {
      _isConnecting = false;
      errorLog("Reverb connection failed to initiate", e);
      _handleDisconnect();
    }
  }

  void _handleMessage(dynamic rawMessage) {
    try {
      final data = json.decode(rawMessage);
      final event = data['event'];

      appLog("Reverb received: event=$event, channel=${data['channel']}, data=${data['data']}");

      if (event == 'pusher:connection_established') {
        _isConnected = true;
        final connectionData = json.decode(data['data']);
        _socketId = connectionData['socket_id'];
        appLog("Reverb: Connection established. Socket ID: $_socketId");

        // Resubscribe to all registered channels
        _resubscribeAll();
      } else if (event == 'pusher:ping') {
        _send(json.encode({'event': 'pusher:pong', 'data': {}}));
      } else if (event == 'pusher:error') {
        errorLog("Reverb server sent error", data['data']);
      } else if (event == 'pusher_internal:subscription_succeeded') {
        final channel = data['channel'];
        _subscribedChannels.add(channel);
        appLog("Reverb: Subscription succeeded for channel: $channel");
      } else {
        // Broadcasted event from a channel
        final channel = data['channel'];
        final eventName = data['event'];
        final eventData = data['data'];

        _triggerHandlers(channel, eventName, eventData);
      }
    } catch (e) {
      errorLog("Error parsing Reverb message: $rawMessage", e);
    }
  }

  void _handleDisconnect() {
    _isConnected = false;
    _isConnecting = false;
    _socketId = null;
    _subscribedChannels.clear();

    // Auto-reconnect after 5 seconds
    _reconnectTimer?.cancel();
    _reconnectTimer = Timer(const Duration(seconds: 5), () {
      appLog("Reverb: Attempting auto-reconnection...");
      initializeSocket();
    });
  }

  void _send(String message) {
    if (_channel != null) {
      _channel!.sink.add(message);
    }
  }

  /// Subscribe to a channel and listen to a specific event
  void subscribe({
    required String channel,
    required String event,
    required void Function(dynamic) handler,
  }) {
    try {
      // Save the event handler
      if (!_channelEventHandlers.containsKey(channel)) {
        _channelEventHandlers[channel] = {};
      }
      if (!_channelEventHandlers[channel]!.containsKey(event)) {
        _channelEventHandlers[channel]![event] = [];
      }
      _channelEventHandlers[channel]![event]!.add(handler);

      // If connected, subscribe on socket immediately
      if (_isConnected) {
        _subscribeToChannelOnSocket(channel);
      } else {
        initializeSocket();
      }
    } catch (e) {
      errorLog("Reverb: subscribe failed for $channel:$event", e);
    }
  }

  /// Unsubscribe from a channel, or a specific event within a channel
  void unsubscribe({
    required String channel,
    String? event,
  }) {
    try {
      if (event != null) {
        _channelEventHandlers[channel]?[event]?.clear();
        appLog("Reverb: Unsubscribed handler for event '$event' on channel: $channel");
      } else {
        _channelEventHandlers.remove(channel);
        if (_subscribedChannels.contains(channel)) {
          _send(json.encode({
            'event': 'pusher:unsubscribe',
            'data': {'channel': channel}
          }));
          _subscribedChannels.remove(channel);
        }
        appLog("Reverb: Unsubscribed completely from channel: $channel");
      }
    } catch (e) {
      errorLog("Reverb: unsubscribe failed for $channel", e);
    }
  }

  void _resubscribeAll() {
    for (final channel in _channelEventHandlers.keys) {
      _subscribeToChannelOnSocket(channel);
    }
  }

  void _subscribeToChannelOnSocket(String channel) async {
    if (_subscribedChannels.contains(channel)) return;

    if (channel.startsWith('private-') || channel.startsWith('presence-')) {
      // Authenticate private/presence channel
      await _subscribePrivateChannel(channel);
    } else {
      // Subscribe to public channel
      _send(json.encode({
        'event': 'pusher:subscribe',
        'data': {'channel': channel}
      }));
    }
  }

  Future<void> _subscribePrivateChannel(String channel) async {
    final token = await StorageServices.instance.getToken();
    if (token.isEmpty) {
      appLog("Reverb: Cannot subscribe to private channel $channel - no user authentication token found");
      _subscribePublicFallback(channel);
      return;
    }

    try {
      final authUrl = "/broadcasting/auth";
      appLog("Reverb: Authenticating private channel $channel at $authUrl");

      final response = await ApiServices.instance.postServices(
        url: authUrl,
        body: {
          'socket_id': _socketId,
          'channel_name': channel,
        },
      );

      if (response != null && response['auth'] != null) {
        _send(json.encode({
          'event': 'pusher:subscribe',
          'data': {
            'channel': channel,
            'auth': response['auth'],
            if (response['channel_data'] != null) 'channel_data': response['channel_data'],
          }
        }));
      } else {
        appLog("Reverb: Private channel auth failed response, subscribing as public fallback");
        _subscribePublicFallback(channel);
      }
    } catch (e) {
      errorLog("Reverb private channel auth request error", e);
      _subscribePublicFallback(channel);
    }
  }

  void _subscribePublicFallback(String channel) {
    _send(json.encode({
      'event': 'pusher:subscribe',
      'data': {'channel': channel}
    }));
  }

  void _triggerHandlers(String channel, String event, dynamic rawData) {
    dynamic parsedData = rawData;
    if (rawData is String) {
      try {
        parsedData = json.decode(rawData);
      } catch (_) {}
    }

    final channelHandlers = _channelEventHandlers[channel];
    if (channelHandlers != null) {
      final handlers = channelHandlers[event];
      if (handlers != null) {
        for (final handler in handlers) {
          try {
            handler(parsedData);
          } catch (e) {
            errorLog("Error executing handler for $channel:$event", e);
          }
        }
      }
    }
  }

  // Backward compatibility wrapper for old socket_io_client interface
  void readEvent({
    required String event,
    required void Function(dynamic) handler,
  }) {
    subscribe(channel: 'global', event: event, handler: handler);
  }

  // Backward compatibility wrapper for old socket_io_client interface
  void emitEvent(String event, dynamic data) {
    if (_isConnected) {
      _send(json.encode({
        'event': event,
        'data': data,
      }));
    }
  }

  void reconnect() {
    dispose();
    initializeSocket();
  }

  void dispose() {
    _reconnectTimer?.cancel();
    _channel?.sink.close();
    _isConnected = false;
    _isConnecting = false;
    _socketId = null;
    _subscribedChannels.clear();
  }
}
