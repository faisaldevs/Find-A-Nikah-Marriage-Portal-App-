import 'package:dio/dio.dart';
import 'package:find_a_nikah/features/face_verification/data/data.dart';
import 'package:find_a_nikah/features/face_verification/domain/domain.dart';
import 'package:flutter_test/flutter_test.dart';

Response<dynamic> _response({
  required int statusCode,
  Map<String, dynamic>? data,
}) => Response<dynamic>(
  requestOptions: RequestOptions(path: '/test'),
  statusCode: statusCode,
  data: data,
);

void main() {
  const mapper = FaceVerificationResponseMapper();

  group('mapSession', () {
    final now = DateTime(2026, 10, 15, 12);

    test('reads the /start envelope: sessionId, challenges, expiry', () {
      final session = mapper.mapSession(
        _response(
          statusCode: 201,
          data: {
            'statusCode': 201,
            'data': {
              'sessionId': '6ad0568775cdd6b1b4ec5ea0',
              'challenges': ['front', 'left', 'right'],
              'expiresInSeconds': 120,
            },
            'message': 'Face check started',
            'success': true,
          },
        ),
        now: now,
      );
      expect(session.sessionId, '6ad0568775cdd6b1b4ec5ea0');
      expect(session.plan.steps.map((s) => (s.fieldName, s.pose)), [
        ('front', LivenessPose.front),
        ('left', LivenessPose.left),
        ('right', LivenessPose.right),
      ]);
      expect(session.expiresAt, now.add(const Duration(seconds: 120)));
      expect(session.isExpiredAt(now), isFalse);
      expect(
        session.isExpiredAt(now.add(const Duration(seconds: 120))),
        isTrue,
      );
    });

    test("follows the server's challenge order and skips unknown ones", () {
      final session = mapper.mapSession(
        _response(
          statusCode: 201,
          data: {
            'data': {
              'sessionId': 's',
              'challenges': ['right', 'blink', 'front'],
            },
          },
        ),
      );
      expect(session.plan.steps.map((s) => s.pose), [
        LivenessPose.right,
        LivenessPose.front,
      ]);
      expect(session.expiresAt, isNull);
    });

    test('no recognised challenges → default plan', () {
      final session = mapper.mapSession(
        _response(
          statusCode: 201,
          data: {
            'data': {
              'sessionId': 's',
              'challenges': ['blink'],
            },
          },
        ),
      );
      expect(session.plan, LivenessStepPlan.defaultPlan);
    });

    test('tolerates a bare (un-enveloped) body', () {
      final session = mapper.mapSession(
        _response(statusCode: 200, data: {'session_id': 'xyz'}),
      );
      expect(session.sessionId, 'xyz');
      expect(session.plan, LivenessStepPlan.defaultPlan);
    });

    test('non-map body never throws', () {
      final session = mapper.mapSession(_response(statusCode: 200));
      expect(session.sessionId, isNull);
      expect(session.raw, isEmpty);
    });
  });

  group('mapResult (confirmed contract)', () {
    test('200 isFaceVerified + approved → Verified', () {
      final result = mapper.mapResult(
        _response(
          statusCode: 200,
          data: {
            'statusCode': 200,
            'data': {
              'isFaceVerified': true,
              'distance': 0.356,
              'verification': {'status': 'approved', 'rejectionReason': null},
            },
            'message': 'Face verified successfully',
          },
        ),
      );
      expect(result, isA<Verified>());
    });

    test('422 → Rejected with the backend message, retryable', () {
      final result = mapper.mapResult(
        _response(
          statusCode: 422,
          data: {
            'statusCode': 422,
            'success': false,
            'message':
                'Step 1 (front): no face detected. Keep your face in the '
                'oval and in good light.',
          },
        ),
      );
      expect(result, isA<Rejected>());
      expect((result as Rejected).reason, startsWith('Step 1 (front)'));
      expect(result.canRetry, isTrue);
    });

    test('2xx with status rejected → Rejected with the rejection reason', () {
      final result = mapper.mapResult(
        _response(
          statusCode: 200,
          data: {
            'data': {
              'isFaceVerified': false,
              'verification': {
                'status': 'rejected',
                'rejectionReason': 'Face did not match',
              },
            },
          },
        ),
      );
      expect((result as Rejected).reason, 'Face did not match');
    });

    test('pending / unknown 2xx → UnderReview, never Verified', () {
      expect(
        mapper.mapResult(
          _response(
            statusCode: 202,
            data: {
              'data': {
                'verification': {'status': 'pending'},
              },
            },
          ),
        ),
        isA<UnderReview>(),
      );
      expect(
        mapper.mapResult(_response(statusCode: 200, data: {})),
        isA<UnderReview>(),
      );
    });
  });

  // Lenient verdict parsing — restore with the mapper's commented-out
  // `mapResult` once the contract is known.
  // group('mapResult', () {
  //   test('2xx with status "verified" maps to Verified', () {
  //     final result = mapper.mapResult(
  //       _response(statusCode: 200, data: {'status': 'verified'}),
  //     );
  //     expect(result, isA<Verified>());
  //   });
  //
  //   test('202 maps to UnderReview', () {
  //     final result = mapper.mapResult(_response(statusCode: 202, data: {}));
  //     expect(result, isA<UnderReview>());
  //   });
  //
  //   test('2xx with an unrecognized body defaults to UnderReview', () {
  //     final result = mapper.mapResult(
  //       _response(statusCode: 200, data: {'something': 'else'}),
  //     );
  //     expect(result, isA<UnderReview>());
  //   });
  //
  //   test('2xx with status "rejected" maps to Rejected', () {
  //     final result = mapper.mapResult(
  //       _response(
  //         statusCode: 200,
  //         data: {'status': 'rejected', 'reason': 'no match'},
  //       ),
  //     );
  //     expect(result, isA<Rejected>());
  //     expect((result as Rejected).reason, 'no match');
  //   });
  //
  //   test('4xx maps to Rejected with reason and canRetry from the body', () {
  //     final result = mapper.mapResult(
  //       _response(
  //         statusCode: 422,
  //         data: {'reason': 'poor quality', 'canRetry': false},
  //       ),
  //     );
  //     expect(result, isA<Rejected>());
  //     final rejected = result as Rejected;
  //     expect(rejected.reason, 'poor quality');
  //     expect(rejected.canRetry, isFalse);
  //   });
  //
  //   test('4xx with no canRetry in the body defaults to true', () {
  //     final result = mapper.mapResult(_response(statusCode: 400, data: {}));
  //     expect((result as Rejected).canRetry, isTrue);
  //   });
  // });
}
