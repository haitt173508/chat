import 'package:chat_365/core/constants/api_path.dart';
import 'package:chat_365/utils/data/clients/api_client.dart';
import 'package:chat_365/utils/data/models/request_method.dart';
import 'package:chat_365/utils/data/models/request_response.dart';

class NotificationRepo {
  final int userId;

  NotificationRepo(this.userId);

  final ApiClient _apiClient = ApiClient();

  Future<RequestResponse> getListNotification() => _apiClient.fetch(
        ApiPath.getListNotification + '/userId=$userId',
        searchParams: {
          'userId': userId,
        },
        method: RequestMethod.get,
      );
}
