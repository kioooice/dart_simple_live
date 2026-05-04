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
          {
            'cell_room': {
              'rawdata': json.encode({
                'owner': {
                  'web_rid': '987654321',
                  'nickname': '主播B',
                  'avatar_thumb': {
                    'url_list': ['https://example.com/avatar.jpg'],
                  },
                },
                'title': '另一场直播',
                'cover': {
                  'url_list': ['https://example.com/cover2.jpg'],
                },
                'user_count': 654,
              }),
            },
          },
        ],
      });

      expect(result.hasMore, isFalse);
      expect(result.items, hasLength(2));
      expect(result.items.first.roomId, '123456789');
      expect(result.items.first.title, '测试直播间');
      expect(result.items.first.cover, 'https://example.com/cover.jpg');
      expect(result.items.first.userName, '主播A');
      expect(result.items.first.online, 321);
      expect(result.items.last.roomId, '987654321');
      expect(result.items.last.title, '另一场直播');
      expect(result.items.last.cover, 'https://example.com/cover2.jpg');
      expect(result.items.last.userName, '主播B');
      expect(result.items.last.online, 654);
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

    test('parses anchor items from live search data', () {
      final result = DouyinSite.parseSearchAnchorsResult({
        'data': [
          {
            'cell_room': {
              'rawdata': json.encode({
                'owner': {
                  'web_rid': '987654321',
                  'nickname': '主播B',
                  'avatar_thumb': {
                    'url_list': ['https://example.com/avatar.jpg'],
                  },
                },
                'title': '另一场直播',
                'cover': {
                  'url_list': ['https://example.com/cover2.jpg'],
                },
              }),
            },
          },
        ],
      });

      expect(result.hasMore, isFalse);
      expect(result.items, hasLength(1));
      expect(result.items.single.roomId, '987654321');
      expect(result.items.single.avatar, 'https://example.com/avatar.jpg');
      expect(result.items.single.userName, '主播B');
      expect(result.items.single.liveStatus, isTrue);
    });
  });
}
