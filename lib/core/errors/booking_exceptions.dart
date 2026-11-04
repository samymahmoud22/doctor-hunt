class AlreadyBookedException implements Exception {
  final String message;

  const AlreadyBookedException([
    this.message = 'This time slot has already been booked. Please choose another time.',
  ]);

  @override
  String toString() => message;
}

