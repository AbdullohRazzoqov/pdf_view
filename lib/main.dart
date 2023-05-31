import 'dart:async';
import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:path_provider/path_provider.dart';
import 'package:flutter_pdfview/flutter_pdfview.dart';

List<String> mavzu1 = [
  '1.1. Kriptografiya tarixi',
  '1.2. Kriptografiya tasnifi',
  '2.1. Sanoq tizimlari va bitlar arifmetikasi',
];

List<String> mavzu2 = [
  '2.2. Butun sonlarning bo‘linish belgisi',
  '2.3. Tub sonlar',
  '2.4. Sonlarni ko‘paytuvchilarga yoyish',
  '2.5. Eng katta umumiy bo‘luvchi',
  '2.6. Taqqoslama arifmetikasi',
  '2.7. Orin almashtirishlar',
  '2.8. Matritsalar',
];
List<String> mavzu3 = [
  '3.1. O‘rnigа qo‘yish usuli',
  '3.2. Monoalifboli o‘rniga qo‘yish usuli',
  '3.2.1. Sezarusuli',
  '3.2.2. Affin tizimidagi Sezar usuli',
  '3.2.3. Tayanchso‘zliSezarusuli',
  '3.2.4. Polibiykvadrati',
  '3.2.5. Atbashusuli',
  '3.2.6. Pleyferusuli',
  '3.2.7. Omofonusuli',
  '3.2.8. Vernamusuli',
  '3.3. Polialifboli o‘rniga qo‘yish usuli',
  '3.3.1. Gronsfeld usuli',
  '3.3.2. Vijiner jadvali',
  '3.3.3. ADFGX usuli',
  '3.4. O‘rin almashtirish usuli',
  '3.4.1. Shifrlovchi jadval',
  '3.4.2. Tayanch so‘zli shifrlovchi jadval',
  '3.4.3.Matritsa usul',
  '3.4.4. Sehrli kvadrat',
  '3.4.5.Gamilton usuli',
  '3.5. Shifrlashning analitik usullari',
  '3.5.1. Matritsalarni ko‘paytirish usuli',
  '3.5.2. Xaltaga buyumlarni joylashtirish masalasi',
  '3.6. Shifrlashning additiv usullari',
  '3.6.1.Gammalashtirish usuli',
  '3.6.2.Uitstonning“ikkikvadrat” usuli',
  '3.6.3. To‘rt kvadrat usuli',
  '3.6.4.Xill usuli',
];
List<String> mavzu4 = [
  '4.1. Kodlashga doir usullar',
  '4.2. Xaffman usuli',
];
List<String> mavzu5 = [
  '5.1. N bitli skremblerni qurish va takrorlanish davrini hisoblash',
  '5.2. Blokli shifrlar yordamida ma’lumotlarni shifrlash',
  '5.3. Psevdotasodifiy sonlar generatorini va uning dasturiy ta’minotini yaratish',
  '5.4. RC4 shifrlash algoritmi asosida ma’lumotni shifrlash va deshifrlash dasturini yaratish',
  '5.5. OpenSSL kutubxonasidan foydalangan holda ma’lumotlarni xesh qiymatini hisoblash'
];
List<String> xulosa = [
  'Tayanch so‘zlar ko‘rsatkichi',
  'Foydalanilgan adabiyotlar ro‘yxati',
  'Amaliy dasturlar',
  'Masalalar javoblari',
];

PDFViewController? pdfController;
int targetPage = 2; 
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
        body: Builder(
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
                            builder: (context) => PDFScreen(path: pathPDF),
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
  int pages = 10;
  int currentPage = 0;
  bool isReady = false;
  String errorMessage = '';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: Home(),
      appBar: AppBar(
        title: const Text("Document"),
        actions: <Widget>[
          IconButton(
            icon: const Icon(Icons.share),
            onPressed: () {},
          ),
        ],
      ),
      body: Stack(
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
      ),
      floatingActionButton: FloatingActionButton(
          onPressed: () {
            if (pdfController != null) {
              pdfController.setPage(targetPage);
            }
          },
          child: Icon(Icons.open_in_new),
        ),
      
    );
  }
}






















class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  List<bool> expanded = [
    false,
    false,
    false,
    false,
    false,
    false,
  ];

  int uzunlik = 40;

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        children: [
          ExpansionPanelList(
            expansionCallback: (panelIndex, isExpanded) {
              setState(() {
                expanded[panelIndex] = !isExpanded;
              });
            },
            children: [
              ExpansionPanel(
                headerBuilder: (context, isOpen) {
                  return const Padding(
                    padding: EdgeInsets.all(15),
                    child: Text("1-bob. KRIPTOGRAFIYANING UMUMIY ASOSLARI"),
                  );
                },
                body: Container(
                  padding: const EdgeInsets.all(20),
                  width: double.infinity,
                  child: SizedBox(
                      height: (uzunlik * mavzu1.length).toDouble(),
                      child: ListView.builder(
                        itemBuilder: (context, index) => Padding(
                          padding: const EdgeInsets.symmetric(vertical: 12),
                          child: Text(mavzu1[index]),
                        ),
                        itemCount: mavzu1.length,
                      )),
                ),
                isExpanded: expanded[0],
              ),
              ExpansionPanel(
                  headerBuilder: (context, isOpen) {
                    return const Padding(
                      padding: EdgeInsets.all(15),
                      child:
                          Text("2-bob. KRIPTOGRAFIYANING MATEMATIK ASOSLARI"),
                    );
                  },
                  body: Container(
                    padding: const EdgeInsets.all(20),
                    width: double.infinity,
                    child: SizedBox(
                        height: (uzunlik * mavzu2.length).toDouble(),
                        child: ListView.builder(
                          itemBuilder: (context, index) => Padding(
                            padding: const EdgeInsets.symmetric(vertical: 12),
                            child: Text(mavzu2[index]),
                          ),
                          itemCount: mavzu2.length,
                        )),
                  ),
                  isExpanded: expanded[1]),
              ExpansionPanel(
                  headerBuilder: (context, isOpen) {
                    return const Padding(
                      padding: EdgeInsets.all(15),
                      child: Text("3-bob.SIMMETRIK KALITLISHIFRLASHTIZIMLARI"),
                    );
                  },
                  body: Container(
                    padding: const EdgeInsets.all(20),
                    width: double.infinity,
                    child: SizedBox(
                        height: (uzunlik * mavzu3.length).toDouble(),
                        child: ListView.builder(
                          itemBuilder: (context, index) => Padding(
                            padding: const EdgeInsets.symmetric(vertical: 12),
                            child: Text(mavzu3[index]),
                          ),
                          itemCount: mavzu3.length,
                        )),
                  ),
                  isExpanded: expanded[2]),
              ExpansionPanel(
                  headerBuilder: (context, isOpen) {
                    return const Padding(
                      padding: EdgeInsets.all(15),
                      child: Text("4-bob. KODLASHGA DOIR ODDIY MISOLLAR"),
                    );
                  },
                  body: Container(
                    padding: const EdgeInsets.all(20),
                    width: double.infinity,
                    child: SizedBox(
                        height: (uzunlik * mavzu4.length).toDouble(),
                        child: ListView.builder(
                          itemBuilder: (context, index) => Padding(
                            padding: const EdgeInsets.symmetric(vertical: 12),
                            child: Text(mavzu4[index]),
                          ),
                          itemCount: mavzu4.length,
                        )),
                  ),
                  isExpanded: expanded[3]),
              ExpansionPanel(
                  headerBuilder: (context, isOpen) {
                    return const Padding(
                      padding: EdgeInsets.all(15),
                      child: Text(
                          "5-bob. AMALIY MASHG‘ULOTLAR UCHUN KO‘RSATMALAR"),
                    );
                  },
                  body: Container(
                    padding: const EdgeInsets.all(20),
                    width: double.infinity,
                    child: SizedBox(
                        height: (uzunlik * mavzu4.length).toDouble(),
                        child: ListView.builder(
                          itemBuilder: (context, index) => Padding(
                            padding: const EdgeInsets.symmetric(vertical: 12),
                            child: Text(mavzu4[index]),
                          ),
                          itemCount: mavzu4.length,
                        )),
                  ),
                  isExpanded: expanded[4]),
              ExpansionPanel(
                headerBuilder: (context, isOpen) {
                  return const Padding(
                    padding: EdgeInsets.all(15),
                    child: Text("XULOSA"),
                  );
                },
                body: Container(
                  padding: const EdgeInsets.all(20),
                  width: double.infinity,
                  child: SizedBox(
                      height: (uzunlik * mavzu5.length).toDouble(),
                      child: ListView.builder(
                        itemBuilder: (context, index) => Padding(
                          padding: const EdgeInsets.symmetric(vertical: 12),
                          child: Text(mavzu5[index]),
                        ),
                        itemCount: mavzu5.length,
                      )),
                ),
                isExpanded: expanded[5],
              ),
            ],
          ),
        ],
      ),
    );
  }
}
