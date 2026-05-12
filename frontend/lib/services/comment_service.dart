import '../models/comment.dart';
import 'api_service.dart';

class CommentService {
  final ApiService _api = ApiService();

  Future<List<Comment>> getComments(int emotionRecordId) async {
    final response = await _api.get('/emotions/$emotionRecordId/comments');
    final data = response.data['data'] as List<dynamic>? ?? [];
    return data
        .map((e) => Comment.fromJson(e as Map<String, dynamic>))
        .toList();
  }

  Future<Comment> addComment(int emotionRecordId, String content) async {
    final response = await _api.post(
      '/emotions/$emotionRecordId/comments',
      data: {'content': content},
    );
    final data = response.data['data'] as Map<String, dynamic>;
    return Comment.fromJson(data);
  }
}
