import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pdf_view/bloc/bloc/current_page_bloc.dart';
import 'package:pdf_view/main.dart';

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
              myPanel(
                bop: "1-bob. KRIPTOGRAFIYANING UMUMIY ASOSLARI",
                list: mavzu1,
                item: 0,
              ),
              myPanel(
                bop: "2-bob. KRIPTOGRAFIYANING MATEMATIK ASOSLARI",
                list: mavzu2,
                item: 1,
              ),
              myPanel(
                bop: "3-bob.SIMMETRIK KALITLISHIFRLASHTIZIMLARI",
                list: mavzu3,
                item: 2,
              ),
              myPanel(
                bop: "4-bob. KODLASHGA DOIR ODDIY MISOLLAR",
                list: mavzu4,
                item: 3,
              ),
              myPanel(
                bop: "5-bob. AMALIY MASHG‘ULOTLAR UCHUN KO‘RSATMALAR",
                list: mavzu5,
                item: 4,
              ),
              myPanel(
                bop: "XULOSA",
                list: xulosa,
                item: 5,
              ),
            ],
          ),
        ],
      ),
    );
  }

  ExpansionPanel myPanel({
    required String bop,
    required List<Birnima> list,
    required int item,
  }) {
    return ExpansionPanel(
        headerBuilder: (context, isOpen) {
          return Padding(
            padding: const EdgeInsets.all(15),
            child: Text(bop),
          );
        },
        body: Container(
          padding: const EdgeInsets.all(20),
          width: double.infinity,
          child: SizedBox(
              height: (uzunlik * list.length).toDouble(),
              child: ListView.builder(
                itemBuilder: (context, index) {
                  return GestureDetector(
                    onTap: () {
                      print('object');
                      context
                          .read<CurrentPageBloc>()
                          .add(CurrentPageEvent(currentPage: list[index].page));
                      Navigator.pop(context);
                    },
                    child: Padding(
                      padding: const EdgeInsets.symmetric(vertical: 12),
                      child: Text(list[index].name),
                    ),
                  );
                },
                itemCount: list.length,
              )),
        ),
        isExpanded: expanded[item]);
  }
}
