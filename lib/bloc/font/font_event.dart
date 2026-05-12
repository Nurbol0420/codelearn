import 'package:equatable/equatable.dart';

abstract class FontEvent extends Equatable {
  const FontEvent();

  @override
  List<Object> get props => [];
}

class UpdateFontScale extends FontEvent {
  final double scale;
  const UpdateFontScale(this.scale);

  @override
  List<Object> get props => [scale];
}

class UpdateFontFamily extends FontEvent {
  final String family;
  const UpdateFontFamily(this.family);

  @override
  List<Object> get props => [family];
}
