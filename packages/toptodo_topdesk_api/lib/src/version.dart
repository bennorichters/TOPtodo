import 'package:equatable/equatable.dart';

/// Version in the form of MAJOR.MINOR.REVISION
class Version extends Equatable {
  /// Creates a Version
  const Version(this.major, this.minor, this.revision);
  /// The major part of this [Version]
  final int major;
  /// The minor part of this [Version]
  final int minor;
  /// The revision part of this [Version]
  final int revision;

  /// Converts a String into a [Version]
  /// 
  /// The string should have the form `'MAJOR.MINOR.REVISION'`
  factory Version.fromString(String version) {
    try {
      final numbers = version.split('.');

      if (numbers.length > 3) {
        throw ArgumentError(
          'unexpect format of version "$version"',
        );
      }

      return Version(
        int.parse(numbers[0]),
        int.parse(numbers[1]),
        int.parse(numbers[2]),
      );
    } catch (e) {
      throw ArgumentError(
        'could not parse version "$version" error: $e',
      );
    }
  }

  /// Returns `true` if `this` represents a smaller version than `other`,
  /// `false` otherwise
  bool operator <(Version other) =>
      major < other.major ||
      (major == other.major &&
          (minor < other.minor ||
              (minor == other.minor && revision < other.revision)));

  /// Returns `true` if `this` represents a greater version than `other`,
  /// `false` otherwise
  bool operator >(Version other) => this != other && !(this < other);

  @override
  List<Object> get props => [major, minor, revision];

  @override
  String toString() => '$major.$minor.$revision';
}
