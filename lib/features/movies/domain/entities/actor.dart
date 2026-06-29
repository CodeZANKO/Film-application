import 'package:equatable/equatable.dart';

class Actor extends Equatable {
  final int id;
  final String name;
  final String profilePath;
  final String biography;
  final String birthDate;
  final String placeOfBirth;
  final List<int> movieIds; // IDs of movies this actor is known for

  const Actor({
    required this.id,
    required this.name,
    required this.profilePath,
    required this.biography,
    required this.birthDate,
    required this.placeOfBirth,
    required this.movieIds,
  });

  @override
  List<Object?> get props => [id, name, profilePath, biography, birthDate, placeOfBirth, movieIds];
}

