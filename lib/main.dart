// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:async';
import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_pdfview/flutter_pdfview.dart';
import 'package:path_provider/path_provider.dart';
import 'package:pdf_view/bloc/bloc/current_page_bloc.dart';

import 'screen/widget/driwer.dart';

class Birnima {
  String name;
  int page;
  Birnima({
    required this.name,
    required this.page,
  });
}

List<Birnima> mavzu1 = [
  Birnima(name: '1.1. Kriptografiya tarixi', page: 7),
  Birnima(name: '1.2. Kriptografiya tasnifi', page: 8),
];

List<Birnima> mavzu2 = [
  Birnima(name: '2.1. Sanoq tizimlari va bitlar arifmetikasi', page: 14),
  Birnima(name: '2.2. Butun sonlarning bo‘linish belgisi', page: 28),
  Birnima(name: '2.3. Tub sonlar', page: 31),
  Birnima(name: '2.4. Sonlarni ko‘paytuvchilarga yoyish', page: 33),
  Birnima(name: '2.5. Eng katta umumiy bo‘luvchi', page: 34),
  Birnima(name: '2.6. Taqqoslama arifmetikasi', page: 39),
  Birnima(name: '2.7. Orin almashtirishlar', page: 47),
  Birnima(name: '2.8. Matritsalar', page: 55),
];
List<Birnima> mavzu3 = [
  Birnima(name: '3.1. O‘rnigа qo‘yish usuli', page: 65),
  Birnima(name: '3.2. Monoalifboli o‘rniga qo‘yish usuli', page: 68),
  Birnima(name: '3.2.1. Sezarusuli', page: 72),
  Birnima(name: '3.2.2. Affin tizimidagi Sezar usuli', page: 74),
  Birnima(name: '3.2.3. Tayanchso‘zliSezarusuli', page: 75),
  Birnima(name: '3.2.4. Polibiykvadrati', page: 77),
  Birnima(name: '3.2.5. Atbashusuli', page: 81),
  Birnima(name: '3.2.6. Pleyferusuli', page: 84),
  Birnima(name: '3.2.7. Omofonusuli', page: 90),
  Birnima(name: '3.2.8. Vernamusuli', page: 95),
  Birnima(name: '3.3. Polialifboli o‘rniga qo‘yish usuli', page: 98),
  Birnima(name: '3.3.1. Gronsfeld usuli', page: 99),
  Birnima(name: '3.3.2. Vijiner jadvali', page: 101),
  Birnima(name: '3.3.3. ADFGX usuli', page: 104),
  Birnima(name: '3.4. O‘rin almashtirish usuli', page: 106),
  Birnima(name: '3.4.1. Shifrlovchi jadval', page: 109),
  Birnima(name: '3.4.2. Tayanch so‘zli shifrlovchi jadval', page: 110),
  Birnima(name: '3.4.3.Matritsa usul', page: 112),
  Birnima(name: '3.4.4. Sehrli kvadrat', page: 114),
  Birnima(name: '3.4.5.Gamilton usuli', page: 115),
  Birnima(name: '3.5. Shifrlashning analitik usullari', page: 117),
  Birnima(name: '3.5.1. Matritsalarni ko‘paytirish usuli', page: 117),
  Birnima(name: '3.5.2. Xaltaga buyumlarni joylashtirish masalasi', page: 121),
  Birnima(name: '3.6. Shifrlashning additiv usullari', page: 127),
  Birnima(name: '3.6.1.Gammalashtirish usuli', page: 128),
  Birnima(name: '3.6.2.Uitstonning“ikkikvadrat” usuli', page: 130),
  Birnima(name: '3.6.3. To‘rt kvadrat usuli', page: 133),
  Birnima(name: '3.6.4.Xill usuli', page: 135),
];
List<Birnima> mavzu4 = [
  Birnima(name: "4.1. Kodlashga doir usullar", page: 140),
  Birnima(name: '4.2. Xaffman usuli', page: 141),
];
List<Birnima> mavzu5 = [
  Birnima(
      name: '5.1. N bitli skremblerni qurish va takrorlanish davrini hisoblash',
      page: 148),
  Birnima(
      name: '5.2. Blokli shifrlar yordamida ma’lumotlarni shifrlash',
      page: 156),
  Birnima(
      name:
          '5.3. Psevdotasodifiy sonlar generatorini va uning dasturiy ta’minotini yaratish',
      page: 171),
  Birnima(
      name:
          '5.4. RC4 shifrlash algoritmi asosida ma’lumotni shifrlash va deshifrlash dasturini yaratish',
      page: 187),
  Birnima(
      name:
          '5.5. OpenSSL kutubxonasidan foydalangan holda ma’lumotlarni xesh qiymatini hisoblash',
      page: 201),
];
List<Birnima> xulosa = [
  Birnima(name: 'Tayanch so‘zlar ko‘rsatkichi', page: 221),
  Birnima(name: 'Foydalanilgan adabiyotlar ro‘yxati', page: 223),
  Birnima(name: 'Amaliy dasturlar', page: 226),
  Birnima(name: 'Masalalar javoblari', page: 238),
];

PDFViewController? pdfController;
int targetPage = 0;
void main() => runApp(MyApp());

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  String pathPDF = "";

  @override
  void initState() {
    super.initState();
    fromAsset('assets/pdf/kitob.pdf', 'kitob.pdf').then((f) {
      setState(() {
        pathPDF = f.path;
      });
    });
  }

  Future<File> fromAsset(String asset, String filename) async {
    Completer<File> completer = Completer();
    try {
      var dir = await getApplicationDocumentsDirectory();
      File file = File("${dir.path}/$filename");
      var data = await rootBundle.load(asset);
      var bytes = data.buffer.asUint8List();
      await file.writeAsBytes(bytes, flush: true);
      completer.complete(file);
    } catch (e) {
      throw Exception('Error parsing asset file!');
    }

    return completer.future;
  }

  @override
  Widget build(BuildContext context) {
    final themeData = Theme.of(context);
    return MaterialApp(
      home: Scaffold(
        body: BlocProvider(
          create: (context) => CurrentPageBloc(),
          child: Builder(
            builder: (BuildContext context) {
              return Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    ElevatedButton(
                      child: Text('Tap to Open Document',
                          style: themeData.textTheme.headlineMedium
                              ?.copyWith(fontSize: 21.0)),
                      onPressed: () {
                        if (pathPDF.isNotEmpty) {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => BlocProvider(
                                create: (context) => CurrentPageBloc(),
                                child: PDFScreen(path: pathPDF),
                              ),
                            ),
                          );
                        }
                      },
                    )
                  ],
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}

class PDFScreen extends StatefulWidget {
  final String? path;

  const PDFScreen({Key? key, this.path}) : super(key: key);

  @override
  _PDFScreenState createState() => _PDFScreenState();
}

class _PDFScreenState extends State<PDFScreen> with WidgetsBindingObserver {
  late PDFViewController pdfController;
  final Completer<PDFViewController> _controller =
      Completer<PDFViewController>();
  bool isReady = false;
  String errorMessage = '';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: Home(),
      appBar: AppBar(
        elevation: 0.0,
        title: const Text(
          "KRIPTOGRAFIYADAN MISOL VA MASALALAR TO‘PLAMI",
        ),
      ),
      body: BlocBuilder<CurrentPageBloc, CurrentPageState>(
        builder: (context, state) {
          print(state.selectPage);
          if (state.selectPage != 0) {
            if (pdfController != null) {
              pdfController.setPage(state.selectPage - 1);
            }
          }
          return Stack(
            children: <Widget>[
              PDFView(
                defaultPage: 0,
                onPageChanged: (page, total) {
                  if (kDebugMode) {
                    print("$page,  Totoal: $total");
                  }
                },
                filePath: widget.path,
                onRender: (pages) {
                  setState(() {
                    pages = pages;
                    isReady = true;
                  });
                },
                onError: (error) {
                  setState(() {
                    errorMessage = error.toString();
                  });
                  if (kDebugMode) {
                    print(error.toString());
                  }
                },
                onPageError: (page, error) {
                  setState(() {
                    errorMessage = '$page: ${error.toString()}';
                  });
                  if (kDebugMode) {
                    print('$page: ${error.toString()}');
                  }
                },
                onViewCreated: (PDFViewController pdfViewController) {
                  pdfController = pdfViewController;
                  _controller.complete(pdfViewController);
                },
              ),
              errorMessage.isEmpty
                  ? !isReady
                      ? const Center(
                          child: CircularProgressIndicator(),
                        )
                      : Container()
                  : Center(
                      child: Text(errorMessage),
                    )
            ],
          );
        },
      ),
    );
  }
}
