
import 'package:toptopdo/models/credentials.dart';
import 'package:toptopdo/models/topdesk_elements.dart';
import 'package:toptopdo/repository_providers_api/repository_providers_api.dart';

class FakeTopdeskProvider implements TopdeskProvider {
  @override
  void init(Credentials credentials) {
    print('init called with $credentials');
  }

  @override
  Future<Iterable<IncidentDuration>> fetchDurations() async {
    return Future<Iterable<IncidentDuration>>.delayed(
      Duration(seconds: 2),
      () => const <IncidentDuration>[
        IncidentDuration(
          id: 'a',
          name: '1 minute',
        ),
        IncidentDuration(
          id: 'b',
          name: '1 hour',
        ),
        IncidentDuration(
          id: 'c',
          name: '2 hours',
        ),
        IncidentDuration(
          id: 'd',
          name: '1 week',
        ),
        IncidentDuration(
          id: 'e',
          name: '1 month',
        ),
      ],
    );
  }

  @override
  Future<Iterable<Branch>> fetchBranches(String startsWith) {
    final String swLower = startsWith.toLowerCase();
    return Future<Iterable<Branch>>.delayed(
      Duration(seconds: 2),
      () => const <Branch>[
        Branch(
          id: 'a',
          name: 'Branch A',
        ),
        Branch(
          id: 'b',
          name: 'Branch B',
        ),
        Branch(
          id: 'c',
          name: 'C Branch',
        ),
        Branch(
          id: 'd',
          name: 'D Branch',
        ),
        Branch(
          id: 'e',
          name: 'DD Branch',
        ),
      ].where((Branch b) => b.name.toLowerCase().startsWith(swLower)),
    );
  }
}
