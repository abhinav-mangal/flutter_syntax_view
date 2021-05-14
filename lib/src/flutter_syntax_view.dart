import 'package:flutter/material.dart';
import 'dart:math' as math; // math.max & max

import 'syntax/index.dart';
import 'package:rich_text_controller/rich_text_controller.dart';

class SyntaxView extends StatefulWidget {
  SyntaxView(
      {required this.code,
      required this.syntax,
      this.syntaxTheme,
      this.withZoom = true,
      this.withLinesCount = true,
      this.fontSize = 12.0,
      this.expanded = false});

  /// Code text
  final String code;

  /// Syntax/Langauge (Dart, C, C++...)
  final Syntax syntax;

  /// Enable/Disable zooming controlls (default: true)
  final bool withZoom;

  /// Enable/Disable line number in left (default: true)
  final bool withLinesCount;

  /// Theme of syntax view example SyntaxTheme.dracula() (default: SyntaxTheme.dracula())
  final SyntaxTheme? syntaxTheme;

  /// Font Size with a default value of 12.0
  final double fontSize;

  /// Expansion which allows the SyntaxView to be used inside a Column or a ListView... (default: false)
  final bool expanded;













  @override
  State<StatefulWidget> createState() => SyntaxViewState();
}

class SyntaxViewState extends State<SyntaxView> {
  /// For Zooming Controls
  static const double MAX_FONT_SCALE_FACTOR = 3.0;
  static const double MIN_FONT_SCALE_FACTOR = 0.5;
  double _fontScaleFactor = 1.0;

  RichTextController  _controller = RichTextController(patternMap: {}, stringMap: null);
  
  TextStyle baseStyle = const TextStyle(color: const Color(0xFF000000));
  TextStyle numberStyle = const TextStyle(color: const Color(0xFF1565C0));
  TextStyle commentStyle = const TextStyle(color: const Color(0xFF9E9E9E));
  TextStyle keywordStyle = const TextStyle(color: const Color(0xFF9C27B0));
  TextStyle stringStyle = const TextStyle(color: const Color(0xFF43A047));
  TextStyle punctuationStyle = const TextStyle(color: const Color(0xFF000000));
  TextStyle classStyle = const TextStyle(color: const Color(0xFF512DA8));
  TextStyle constantStyle = const TextStyle(color: const Color(0xFF795548));




  @override
  void initState(){
    // initialize with your custom regex patterns or Strings and styles
      //* Starting V1.2.0 You also have "String" parameter in default constructor and also added the //"fromValue" Constructor!
      _controller = RichTextController(
          patternMap: {
           
          RegExp(r'"""(?:[^"\\]|\\(.|\n))*"""'): commentStyle,

          RegExp('/\\*+[^*]*\\*+(?:[^/*][^*]*\\*+)*/'): commentStyle,

          RegExp(r'r".*"'):stringStyle,

          RegExp(r"r'.*'"):stringStyle,
          RegExp(r'"""(?:[^"\\]|\\(.|\n))*"""'):stringStyle,
          RegExp(r"'''(?:[^'\\]|\\(.|\n))*'''"):stringStyle,
          RegExp(r'"(?:[^"\\]|\\.)*"'):stringStyle,
          RegExp(r"'(?:[^'\\]|\\.)*'"):stringStyle,

          RegExp(r'\d+\.\d+'):numberStyle,
          RegExp(r'\d+'):numberStyle,

          RegExp(r'[\[\]{}().!=<>&\|\?\+\-\*/%\^~;:,]'):punctuationStyle,

          RegExp(r'@\w+'):keywordStyle,

          RegExp(r'\babstract|\bvoid|\bimport|\bas|\bclass|\blate|\bint|\bfinal|\bbool|\bif|\belse|\bget'):keywordStyle,


          },

          stringMap: null,
       

      );


    





    super.initState();

  }

  @override
  Widget build(BuildContext context) {
    return Stack(alignment: AlignmentDirectional.bottomEnd, children: <Widget>[
      Container(
          padding: widget.withLinesCount
              ? const EdgeInsets.only(left: 5, top: 10, right: 10, bottom: 10)
              : const EdgeInsets.all(10),
          color: widget.syntaxTheme!.backgroundColor,
          constraints: widget.expanded ? BoxConstraints.expand() : null,
          child: Scrollbar(
              child: SingleChildScrollView(
                  child: SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: widget.withLinesCount
                          ? buildCodeWithLinesCount() // Syntax view with line number to the left
                          : buildCode() // Syntax view
                      )))),
      if (widget.withZoom) zoomControls() // Zoom controll icons
    ]);
  }

  Widget buildCodeWithLinesCount() {
    final int numLines = '\n'.allMatches(widget.code).length + 1;
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.max,
      children: [
        Column(
            // mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              for (int i = 1; i <= numLines; i++)
                RichText(
                    textScaleFactor: _fontScaleFactor,
                    text: TextSpan(
                      style: TextStyle(
                          fontFamily: 'monospace',
                          fontSize: widget.fontSize,
                          color: widget.syntaxTheme!.linesCountColor),
                      text: "$i",
                    )),
            ]),
        VerticalDivider(width: 5),
        buildCode(),
        //Expanded(child: buildCode()),
      ],
    );
  }

  // // Code text
  // Widget buildCode() {
  //   return RichText(
  //       textScaleFactor: _fontScaleFactor,
  //       text: /* formatted text */ TextSpan(
  //         style: TextStyle(fontFamily: 'monospace', fontSize: widget.fontSize),
  //         children: <TextSpan>[
  //           getSyntax(widget.syntax, widget.syntaxTheme).format(widget.code)
  //         ],
  //       ));
  // }

  // Code text

  Widget buildCode(){
    return EditableText(
      controller: _controller, 
      focusNode: FocusNode(), 
      style: TextStyle(), 
      cursorColor: Colors.blue, 
      backgroundCursorColor: Colors.cyan,
      keyboardType: TextInputType.multiline,
      readOnly: false,
      onChanged: (value){
        
      },





      );
  }

  Widget zoomControls() {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        IconButton(
            icon:
                Icon(Icons.zoom_out, color: widget.syntaxTheme!.zoomIconColor),
            onPressed: () => setState(() {
                  _fontScaleFactor =
                      math.max(MIN_FONT_SCALE_FACTOR, _fontScaleFactor - 0.1);
                })),
        IconButton(
            icon: Icon(Icons.zoom_in, color: widget.syntaxTheme!.zoomIconColor),
            onPressed: () => setState(() {
                  _fontScaleFactor =
                      math.min(MAX_FONT_SCALE_FACTOR, _fontScaleFactor + 0.1);
                })),
      ],
    );
  }
}
