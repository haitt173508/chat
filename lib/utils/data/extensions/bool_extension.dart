extension BoolExtension on bool {
  int compareTo(bool b) => this && !b
      ? 2
      : (!this && b)
          ? -2
          : 0;
}
