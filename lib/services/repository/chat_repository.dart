import 'dart:io';
import 'package:dio/dio.dart';
import 'package:mime/mime.dart';
import 'package:http_parser/http_parser.dart';
import 'package:olabisiolai_flutter_app/constant/app_api_url.dart';
import 'package:olabisiolai_flutter_app/services/api/api_services.dart';
import 'package:olabisiolai_flutter_app/utils/app_log.dart';

class ChatRepository {
  ChatRepository._privateConstructor();
  static final ChatRepository _instance = ChatRepository._privateConstructor();
  static ChatRepository get instance => _instance;

  final ApiServices _apiServices = ApiServices.instance;
  final AppApiUrl _api = AppApiUrl.instance;

  /// Fetch all conversations
  Future<dynamic> getConversations() async {
    try {
      var response = await _apiServices.getServices(_api.conversations);
      return response;
    } catch (e) {
      errorLog("getConversations repo", e);
      return null;
    }
  }

  /// Create a conversation with a participant (vendor user uuid)
  Future<dynamic> createConversation(String participantUuid, {String? name}) async {
    try {
      var response = await _apiServices.postServices(
        url: _api.conversations,
        body: {
          "type": "direct",
          if (name != null) "name": name,
          "participants": [participantUuid]
        },
      );
      return response;
    } catch (e) {
      errorLog("createConversation repo", e);
      return null;
    }
  }

  /// Delete/leave conversation
  Future<dynamic> deleteConversation(String conversationUuid) async {
    try {
      var response = await _apiServices.deleteServices(
        url: "${_api.conversations}/$conversationUuid",
      );
      return response;
    } catch (e) {
      errorLog("deleteConversation repo", e);
      return null;
    }
  }

  /// Search conversations
  Future<dynamic> searchConversations(String query) async {
    try {
      var response = await _apiServices.getServices(
        "${_api.conversations}/search",
        queryParameters: {"q": query},
      );
      return response;
    } catch (e) {
      errorLog("searchConversations repo", e);
      return null;
    }
  }

  /// Fetch messages for a specific conversation
  Future<dynamic> getMessages(String conversationUuid) async {
    try {
      var response = await _apiServices.getServices(
        "${_api.conversations}/$conversationUuid/messages",
      );
      return response;
    } catch (e) {
      errorLog("getMessages repo", e);
      return null;
    }
  }

  /// Send message
  Future<dynamic> sendMessage(String conversationUuid, String body, {List<String>? attachmentIds}) async {
    try {
      Map<String, dynamic> requestBody = {
        "body": body,
      };
      if (attachmentIds != null && attachmentIds.isNotEmpty) {
        requestBody["attachments"] = attachmentIds;
      }
      var response = await _apiServices.postServices(
        url: "${_api.conversations}/$conversationUuid/messages",
        body: requestBody,
      );
      return response;
    } catch (e) {
      errorLog("sendMessage repo", e);
      return null;
    }
  }

  /// Upload file attachment
  Future<dynamic> uploadAttachment(File file) async {
    try {
      String fileName = file.path.split('/').last;
      var mimeType = lookupMimeType(file.path);
      
      FormData formData = FormData.fromMap({
        "file": await MultipartFile.fromFile(
          file.path,
          filename: fileName,
          contentType: MediaType.parse(mimeType ?? "image/jpeg"),
        ),
      });

      var response = await _apiServices.postServices(
        url: "/attachments",
        body: formData,
      );
      return response;
    } catch (e) {
      errorLog("uploadAttachment repo", e);
      return null;
    }
  }

  /// Update message content
  Future<dynamic> updateMessage(String messageUuid, String body) async {
    try {
      var response = await _apiServices.putServices(
        url: "/messages/$messageUuid",
        body: {
          "body": body,
        },
      );
      return response;
    } catch (e) {
      errorLog("updateMessage repo", e);
      return null;
    }
  }

  /// Delete message
  Future<dynamic> deleteMessage(String messageUuid) async {
    try {
      var response = await _apiServices.deleteServices(
        url: "/messages/$messageUuid",
      );
      return response;
    } catch (e) {
      errorLog("deleteMessage repo", e);
      return null;
    }
  }

  /// Mark message as read
  Future<dynamic> readMessage(String messageUuid) async {
    try {
      var response = await _apiServices.postServices(
        url: "/messages/$messageUuid/read",
      );
      return response;
    } catch (e) {
      errorLog("readMessage repo", e);
      return null;
    }
  }

  /// Send typing status indication
  Future<dynamic> setTypingStatus(String conversationUuid, bool isTyping) async {
    try {
      var response = await _apiServices.postServices(
        url: "${_api.conversations}/$conversationUuid/typing",
        body: {
          "is_typing": isTyping,
        },
      );
      return response;
    } catch (e) {
      errorLog("setTypingStatus repo", e);
      return null;
    }
  }
}
