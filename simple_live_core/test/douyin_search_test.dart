import 'dart:convert';

import 'package:simple_live_core/simple_live_core.dart';
import 'package:test/test.dart';

void main() {
  group('Douyin search result parsing', () {
    test('parses room items from raw live search data', () {
      final result = DouyinSite.parseSearchRoomsResult({
        'data': [
          {
            'lives': {
              'rawdata': json.encode({
                'owner': {'web_rid': '123456789', 'nickname': '主播A'},
                'title': '测试直播间',
                'cover': {
                  'url_list': ['https://example.com/cover.jpg'],
                },
                'stats': {'total_user': '321'},
              }),
            },
          },
        ],
      });

      expect(result.hasMore, isFalse);
      expect(result.items, hasLength(1));
      expect(result.items.single.roomId, '123456789');
      expect(result.items.single.title, '测试直播间');
      expect(result.items.single.cover, 'https://example.com/cover.jpg');
      expect(result.items.single.userName, '主播A');
      expect(result.items.single.online, 321);
    });

    test('throws a clear error when Douyin requires login', () {
      expect(
        () => DouyinSite.parseSearchRoomsResult({
          'status_code': 2483,
          'status_msg': '请先登录，再继续搜索吧',
        }),
        throwsA(
          isA<Exception>().having(
            (e) => e.toString(),
            'message',
            contains('请先登录'),
          ),
        ),
      );
    });
  });
}
