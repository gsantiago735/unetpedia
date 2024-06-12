class DataException implements Exception {
  final String? details;

  const DataException({
    this.details,
  });

  @override
  String toString() => '${details.toString()}: $details';
}
