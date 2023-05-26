import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../model/adaylarModel.dart';
import 'package:url_launcher/url_launcher.dart';


class AdayDetayPage extends StatelessWidget {

  final Aday aday;
  const AdayDetayPage({Key? key, required this.aday, }) : super(key: key);


  @override
  Widget build(BuildContext context) {

    final Uri url = Uri.parse('${aday.cvUrl}');

    Future<void> _launchPdfUrl() async {
      if (await canLaunch(Uri.parse(url.toString()).toString())) {
        await launch(Uri.parse(url.toString()).toString(),
            headers: <String, String>{'header_key': 'header_value'},
            universalLinksOnly: true);
      } else {
        throw 'Could not launch $url';
      }
    }


    return Scaffold(
      appBar: AppBar(
        title: Text(aday.ad! + " " + aday.soyad!),
        centerTitle: true,
        backgroundColor: Colors.brown,
      ),
      body: SingleChildScrollView( // Wrap the column widget with SingleChildScrollView to make it scrollable
        scrollDirection: Axis.vertical,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start, // Set the cross-axis alignment of the children in the column to start
          children: [
            Padding(
              padding: const EdgeInsets.only(top:10,bottom: 10),
              child: Center(child: Text("Aday Bilgileri ", style: TextStyle(fontSize: 21,fontWeight: FontWeight.w500,color: Colors.grey.shade600)),),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: RichText(
                text: TextSpan(
                  children: <TextSpan>[
                    TextSpan(text: 'Ad Soyad : ', style: TextStyle(fontWeight: FontWeight.w500,fontSize: 17,color: Colors.grey.shade800)),
                    TextSpan(text: '${aday.ad} ${aday.soyad}', style: TextStyle(color: Colors.grey.shade700,fontSize: 17)),
                  ],
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: RichText(
                text: TextSpan(
                  children: <TextSpan>[
                    TextSpan(text: 'Telefon: ', style: TextStyle(fontWeight: FontWeight.w500,fontSize: 17,color: Colors.grey.shade800)),
                    TextSpan(text: '${aday.gsm}', style: TextStyle(color: Colors.grey.shade700,fontSize: 17)),
                  ],
                ),
              ),
            ),            Padding(
              padding: const EdgeInsets.all(8.0),
              child: RichText(
                text: TextSpan(
                  children: <TextSpan>[
                    TextSpan(text: 'Email: ', style: TextStyle(fontWeight: FontWeight.w500,fontSize: 17,color: Colors.grey.shade800)),
                    TextSpan(text: '${aday.email}', style: TextStyle(color: Colors.grey.shade700,fontSize: 17)),
                  ],
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: RichText(
                text: TextSpan(
                  children: <TextSpan>[
                    TextSpan(text: 'Toplam Deneyim: ', style: TextStyle(fontWeight: FontWeight.w500,fontSize: 17,color: Colors.grey.shade800)),
                    TextSpan(text: '${aday.toplamDeneyim} yıl', style: TextStyle(color: Colors.grey.shade700,fontSize: 17)),
                  ],
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: RichText(
                text: TextSpan(
                  children: <TextSpan>[
                    TextSpan(text: 'Mezuniyet Derecesi: ', style: TextStyle(fontWeight: FontWeight.w500,fontSize: 17,color: Colors.grey.shade800)),
                    TextSpan(text: '${aday.mezuniyet} ', style: TextStyle(color: Colors.grey.shade700,fontSize: 17)),
                  ],
                ),
              ),
            ),


            Padding(
              padding: const EdgeInsets.all(8.0),
              child: GestureDetector(
                onTap: () async {
                  _launchPdfUrl();
                  try {
                    await launchUrl(Uri.parse(url.toString()));
                  } catch (e) {
                    throw 'Could not launch $url';
                  }
                },
                child: RichText(
                  text: TextSpan(
                    children: <TextSpan>[
                      TextSpan(
                        text: 'Cv URL : ',
                        style: TextStyle(
                          fontWeight: FontWeight.w500,
                          fontSize: 17,
                          color: Colors.grey.shade800,
                        ),
                      ),
                      TextSpan(
                        text: '${aday.cvUrl}',
                        style: TextStyle(
                          color: Colors.grey.shade700,
                          fontSize: 17,
                          decoration: TextDecoration.underline,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),



            Padding(
              padding: const EdgeInsets.all(8.0),
              child: RichText(
                text: TextSpan(
                  children: <TextSpan>[
                    TextSpan(text: 'Yaş: ', style: TextStyle(fontWeight: FontWeight.w500,fontSize: 17,color: Colors.grey.shade800)),
                    TextSpan(text: '${aday.yas} ', style: TextStyle(color: Colors.grey.shade700,fontSize: 17)),
                  ],
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: RichText(
                text: TextSpan(
                  children: <TextSpan>[
                    TextSpan(text: 'Doğum Tarihi: ', style: TextStyle(fontWeight: FontWeight.w500,fontSize: 17,color: Colors.grey.shade800)),
                    TextSpan( text: '${DateFormat('dd.MM.yyyy').format(DateTime.parse(aday.dogumTarihi.toString()))}', style: TextStyle(color: Colors.grey.shade700,fontSize: 17)),
                  ],
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: RichText(
                text: TextSpan(
                  children: <TextSpan>[
                    TextSpan(text: 'Yaşadığı Şehir: ', style: TextStyle(fontWeight: FontWeight.w500,fontSize: 17,color: Colors.grey.shade800)),
                    TextSpan(text: '${aday.yasadigiSehir} ', style: TextStyle(color: Colors.grey.shade700,fontSize: 17)),
                  ],
                ),
              ),
            ), Padding(
              padding: const EdgeInsets.all(8.0),
              child: RichText(
                text: TextSpan(
                  children: <TextSpan>[
                    TextSpan(text: 'Doğduğu Şehir: ', style: TextStyle(fontWeight: FontWeight.w500,fontSize: 17,color: Colors.grey.shade800)),
                    TextSpan(text: '${aday.dogduguSehir} ', style: TextStyle(color: Colors.grey.shade700,fontSize: 17)),
                  ],
                ),
              ),
            ), Padding(
              padding: const EdgeInsets.all(8.0),
              child: RichText(
                text: TextSpan(
                  children: <TextSpan>[
                    TextSpan(text: 'Cinsiyet: ', style: TextStyle(fontWeight: FontWeight.w500,fontSize: 17,color: Colors.grey.shade800)),
                    TextSpan(text: '${aday.cinsiyet} ', style: TextStyle(color: Colors.grey.shade700,fontSize: 17)),
                  ],
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: RichText(
                text: TextSpan(
                  children: <TextSpan>[
                    TextSpan(text: 'Askerlik: ', style: TextStyle(fontWeight: FontWeight.w500,fontSize: 17,color: Colors.grey.shade800)),
                    TextSpan(text: '${aday.askerlik! ? 'Yapıldı ': 'Yapılmadı' } ', style: TextStyle(color: Colors.grey.shade700,fontSize: 17)),
                  ],
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: RichText(
                text: TextSpan(
                  children: <TextSpan>[
                    TextSpan(text: 'Ehliyet : ', style: TextStyle(fontWeight: FontWeight.w500,fontSize: 17,color: Colors.grey.shade800)),
                    TextSpan(text: '${aday.ehliyet! ? 'Var ': 'Yok' } ', style: TextStyle(color: Colors.grey.shade700,fontSize: 17)),
                  ],
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: RichText(
                text: TextSpan(
                  children: <TextSpan>[
                    TextSpan(text: 'Sigara: ', style: TextStyle(fontWeight: FontWeight.w500,fontSize: 17,color: Colors.grey.shade800)),
                    TextSpan(text: '${aday.sigara! ? 'Var ': 'Yok' } ', style: TextStyle(color: Colors.grey.shade700,fontSize: 17)),
                  ],
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: RichText(
                text: TextSpan(
                  children: <TextSpan>[
                    TextSpan(text: 'Alkol: ', style: TextStyle(fontWeight: FontWeight.w500,fontSize: 17,color: Colors.grey.shade800)),
                    TextSpan(text: '${aday.alkol! ? 'Var ': 'Yok' } ', style: TextStyle(color: Colors.grey.shade700,fontSize: 17)),
                  ],
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: RichText(
                text: TextSpan(
                  children: <TextSpan>[
                    TextSpan(text: 'Evlilik: ', style: TextStyle(fontWeight: FontWeight.w500,fontSize: 17,color: Colors.grey.shade800)),
                    TextSpan(text: '${aday.evlilik! ? 'Evli ': 'Bekar' } ', style: TextStyle(color: Colors.grey.shade700,fontSize: 17)),
                  ],
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: RichText(
                text: TextSpan(
                  children: <TextSpan>[
                    TextSpan(text: 'Çocuk Sayısı: ', style: TextStyle(fontWeight: FontWeight.w500,fontSize: 17,color: Colors.grey.shade800)),
                    TextSpan(text: '${aday.cocukSayisi } ', style: TextStyle(color: Colors.grey.shade700,fontSize: 17)),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
