extension ListUtil<E> on Iterable<E> {
  E? get firstOrNull => isNotEmpty ? first : null;

  E? firstWhereOrNull(bool Function(E element) test) {
    for (final element in this) {
      if (test(element)) return element;
    }
    return null;
  }

  List mapIndexed(Function(int index, E element) data) {
    return List.generate(length, (index) => data(index, elementAt(index)));
  }
}

Iterable<T> intersperse<T>(T element, Iterable<T> iterable) sync* {
  final iterator = iterable.iterator;
  if (iterator.moveNext()) {
    yield iterator.current;
    while (iterator.moveNext()) {
      yield element;
      yield iterator.current;
    }
  }
}
