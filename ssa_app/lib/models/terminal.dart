// /lib/models/terminal.dart
import 'package:cloud_firestore/cloud_firestore.dart';

class Terminal {
  final String archiveDir;
  final String group;
  final Timestamp? last30DayUpdateTimestamp;
  final Timestamp? last72HourUpdateTimestamp;
  final Timestamp? lastCheckTimestamp;
  final Timestamp? lastRollcallUpdateTimestamp;
  final String link;
  final String location;
  final String name;
  final int pagePosition;
  final String? pdf30DayHash;
  final String? pdf72HourHash;
  final String? pdfRollcallHash;
  final String? terminalImageUrl;
  final String timezone;

  Terminal({
    required this.archiveDir,
    required this.group,
    this.last30DayUpdateTimestamp,
    this.last72HourUpdateTimestamp,
    this.lastCheckTimestamp,
    this.lastRollcallUpdateTimestamp,
    required this.link,
    required this.location,
    required this.name,
    required this.pagePosition,
    this.pdf30DayHash,
    this.pdf72HourHash,
    this.pdfRollcallHash,
    this.terminalImageUrl,
    required this.timezone,
  });

  factory Terminal.fromDocumentSnapshot(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>?;
    if (data == null) {
      throw Exception("Document data is null");
    }
    // We do not use default values for non-nullable fields because we want to
    // throw an exception if the field is missing. This will prevent displaying
    // terminals with incomplete data.
    return Terminal(
      archiveDir: data['archiveDir'],
      group: data['group'],
      last30DayUpdateTimestamp: data['last30DayUpdateTimestamp'] as Timestamp?,
      last72HourUpdateTimestamp:
          data['last72HourUpdateTimestamp'] as Timestamp?,
      lastCheckTimestamp: data['lastCheckTimestamp'] as Timestamp?,
      lastRollcallUpdateTimestamp:
          data['lastRollcallUpdateTimestamp'] as Timestamp?,
      link: data['link'],
      location: data['location'],
      name: data['name'],
      pagePosition: data['pagePosition'],
      pdf30DayHash: data['pdf30DayHash'] as String?,
      pdf72HourHash: data['pdf72HourHash'] as String?,
      pdfRollcallHash: data['pdfRollcallHash'] as String?,
      terminalImageUrl: data['terminalImageUrl'] as String?,
      timezone: data['timezone'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'archiveDir': archiveDir,
      'group': group,
      'last30DayUpdateTimestamp': last30DayUpdateTimestamp,
      'last72HourUpdateTimestamp': last72HourUpdateTimestamp,
      'lastCheckTimestamp': lastCheckTimestamp,
      'lastRollcallUpdateTimestamp': lastRollcallUpdateTimestamp,
      'link': link,
      'location': location,
      'name': name,
      'pagePosition': pagePosition,
      'pdf30DayHash': pdf30DayHash,
      'pdf72HourHash': pdf72HourHash,
      'pdfRollcallHash': pdfRollcallHash,
      'terminalImageUrl': terminalImageUrl,
      'timezone': timezone,
    };
  }

  factory Terminal.fromMap(Map<String, dynamic> map) {
    return Terminal(
      archiveDir: map['archiveDir'],
      group: map['group'],
      last30DayUpdateTimestamp: map['last30DayUpdateTimestamp'] as Timestamp?,
      last72HourUpdateTimestamp: map['last72HourUpdateTimestamp'] as Timestamp?,
      lastCheckTimestamp: map['lastCheckTimestamp'] as Timestamp?,
      lastRollcallUpdateTimestamp:
          map['lastRollcallUpdateTimestamp'] as Timestamp?,
      link: map['link'],
      location: map['location'],
      name: map['name'],
      pagePosition: map['pagePosition'],
      pdf30DayHash: map['pdf30DayHash'] as String?,
      pdf72HourHash: map['pdf72HourHash'] as String?,
      pdfRollcallHash: map['pdfRollcallHash'] as String?,
      terminalImageUrl: map['terminalImageUrl'] as String?,
      timezone: map['timezone'],
    );
  }

  String getName() {
    return name;
  }

  String getLocation() {
    return location;
  }

  String getLink() {
    return link;
  }

  String? getTerminalImageUrl() {
    return terminalImageUrl;
  }

  String getGroup() {
    return group;
  }
}
