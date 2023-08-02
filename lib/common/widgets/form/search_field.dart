import 'package:chat_365/core/constants/string_constants.dart';
import 'package:chat_365/modules/debouncer/text_editing_controller_debouncer.dart';
import 'package:chat_365/utils/data/extensions/context_extension.dart';
import 'package:flutter/material.dart';

class SearchField extends StatefulWidget {
  const SearchField({
    Key? key,
    this.callBack,
    this.inputDecoration,
  }) : super(key: key);

  final ValueChanged<String>? callBack;
  final InputDecoration? inputDecoration;

  @override
  State<SearchField> createState() => _SearchFieldState();
}

class _SearchFieldState extends State<SearchField> {
  late final TextEditingControllerDebouncer _debouncer;
  final TextEditingController _controller = TextEditingController();

  @override
  void initState() {
    super.initState();
    _debouncer = TextEditingControllerDebouncer(_call, controller: _controller);
  }

  @override
  void dispose() {
    _debouncer.dispose();
    super.dispose();
  }

  _call() {
    widget.callBack!(_controller.text);
  }

  @override
  Widget build(BuildContext context) {
    var outlineInputBorder = OutlineInputBorder(
      borderRadius: BorderRadius.circular(15),
      borderSide: BorderSide(
        color: context.theme.textColor,
      ),
    );
    return TextField(
      controller: _controller,
      onSubmitted: (_) => _call(),
      decoration: widget.inputDecoration ??
          InputDecoration(
            hintText: StringConst.search,
            suffixIconConstraints: BoxConstraints(
              maxHeight: 30,
              maxWidth: 30,
            ),
            enabledBorder: outlineInputBorder,
            border: outlineInputBorder,
            suffixIcon: Padding(
              padding: const EdgeInsets.only(right: 8.0),
              child: InkWell(
                onTap: _call,
                child: const CustomPaint(
                  size: Size.square(24),
                  painter: SearchIconPainter(),
                ),
              ),
            ),
          ),
    );
  }
}

class SearchIconPainter extends CustomPainter {
  const SearchIconPainter();

  @override
  void paint(Canvas canvas, Size size) {
    Path path_0 = Path();
    path_0.moveTo(size.width * 0.7823042, size.height * 0.7350000);
    path_0.lineTo(size.width * 0.6587125, size.height * 0.6124083);
    path_0.cubicTo(
        size.width * 0.7066875,
        size.height * 0.5525875,
        size.width * 0.7299208,
        size.height * 0.4766625,
        size.width * 0.7236333,
        size.height * 0.4002429);
    path_0.cubicTo(
        size.width * 0.7173500,
        size.height * 0.3238217,
        size.width * 0.6820208,
        size.height * 0.2527133,
        size.width * 0.6249167,
        size.height * 0.2015392);
    path_0.cubicTo(
        size.width * 0.5678125,
        size.height * 0.1503650,
        size.width * 0.4932708,
        size.height * 0.1230150,
        size.width * 0.4166208,
        size.height * 0.1251125);
    path_0.cubicTo(
        size.width * 0.3399700,
        size.height * 0.1272096,
        size.width * 0.2670363,
        size.height * 0.1585954,
        size.width * 0.2128158,
        size.height * 0.2128158);
    path_0.cubicTo(
        size.width * 0.1585954,
        size.height * 0.2670363,
        size.width * 0.1272096,
        size.height * 0.3399700,
        size.width * 0.1251125,
        size.height * 0.4166208);
    path_0.cubicTo(
        size.width * 0.1230150,
        size.height * 0.4932708,
        size.width * 0.1503650,
        size.height * 0.5678125,
        size.width * 0.2015392,
        size.height * 0.6249167);
    path_0.cubicTo(
        size.width * 0.2527133,
        size.height * 0.6820208,
        size.width * 0.3238217,
        size.height * 0.7173500,
        size.width * 0.4002429,
        size.height * 0.7236333);
    path_0.cubicTo(
        size.width * 0.4766625,
        size.height * 0.7299208,
        size.width * 0.5525875,
        size.height * 0.7066875,
        size.width * 0.6124083,
        size.height * 0.6587125);
    path_0.lineTo(size.width * 0.7350000, size.height * 0.7813083);
    path_0.cubicTo(
        size.width * 0.7380958,
        size.height * 0.7844292,
        size.width * 0.7417833,
        size.height * 0.7869083,
        size.width * 0.7458417,
        size.height * 0.7886000);
    path_0.cubicTo(
        size.width * 0.7499000,
        size.height * 0.7902917,
        size.width * 0.7542542,
        size.height * 0.7911625,
        size.width * 0.7586542,
        size.height * 0.7911625);
    path_0.cubicTo(
        size.width * 0.7630500,
        size.height * 0.7911625,
        size.width * 0.7674042,
        size.height * 0.7902917,
        size.width * 0.7714667,
        size.height * 0.7886000);
    path_0.cubicTo(
        size.width * 0.7755250,
        size.height * 0.7869083,
        size.width * 0.7792083,
        size.height * 0.7844292,
        size.width * 0.7823042,
        size.height * 0.7813083);
    path_0.cubicTo(
        size.width * 0.7883083,
        size.height * 0.7750958,
        size.width * 0.7916667,
        size.height * 0.7667917,
        size.width * 0.7916667,
        size.height * 0.7581542);
    path_0.cubicTo(
        size.width * 0.7916667,
        size.height * 0.7495125,
        size.width * 0.7883083,
        size.height * 0.7412125,
        size.width * 0.7823042,
        size.height * 0.7350000);
    path_0.close();
    path_0.moveTo(size.width * 0.4255167, size.height * 0.6587125);
    path_0.cubicTo(
        size.width * 0.3793967,
        size.height * 0.6587125,
        size.width * 0.3343108,
        size.height * 0.6450375,
        size.width * 0.2959621,
        size.height * 0.6194125);
    path_0.cubicTo(
        size.width * 0.2576133,
        size.height * 0.5937875,
        size.width * 0.2277242,
        size.height * 0.5573667,
        size.width * 0.2100742,
        size.height * 0.5147583);
    path_0.cubicTo(
        size.width * 0.1924242,
        size.height * 0.4721458,
        size.width * 0.1878062,
        size.height * 0.4252583,
        size.width * 0.1968042,
        size.height * 0.3800242);
    path_0.cubicTo(
        size.width * 0.2058021,
        size.height * 0.3347887,
        size.width * 0.2280117,
        size.height * 0.2932375,
        size.width * 0.2606246,
        size.height * 0.2606246);
    path_0.cubicTo(
        size.width * 0.2932375,
        size.height * 0.2280117,
        size.width * 0.3347887,
        size.height * 0.2058021,
        size.width * 0.3800242,
        size.height * 0.1968042);
    path_0.cubicTo(
        size.width * 0.4252583,
        size.height * 0.1878062,
        size.width * 0.4721458,
        size.height * 0.1924242,
        size.width * 0.5147583,
        size.height * 0.2100742);
    path_0.cubicTo(
        size.width * 0.5573667,
        size.height * 0.2277242,
        size.width * 0.5937875,
        size.height * 0.2576133,
        size.width * 0.6194125,
        size.height * 0.2959621);
    path_0.cubicTo(
        size.width * 0.6450375,
        size.height * 0.3343108,
        size.width * 0.6587125,
        size.height * 0.3793967,
        size.width * 0.6587125,
        size.height * 0.4255167);
    path_0.cubicTo(
        size.width * 0.6587125,
        size.height * 0.4873667,
        size.width * 0.6341458,
        size.height * 0.5466792,
        size.width * 0.5904125,
        size.height * 0.5904125);
    path_0.cubicTo(
        size.width * 0.5466792,
        size.height * 0.6341458,
        size.width * 0.4873667,
        size.height * 0.6587125,
        size.width * 0.4255167,
        size.height * 0.6587125);
    path_0.close();

    Paint paint_0_fill = Paint()..style = PaintingStyle.fill;
    paint_0_fill.color = Color(0xff757575).withOpacity(1.0);
    canvas.drawPath(path_0, paint_0_fill);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
