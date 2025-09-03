class Paginated<T> {
  final List<T> data;
  final int timestamp;

  const Paginated({required this.data, required this.timestamp});
}
