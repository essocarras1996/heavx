//import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:cron/cron.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:heav/Ofertas.dart';
import 'package:html/parser.dart' show parse;
import 'package:html/dom.dart' as dom;

import 'OfertasItem.dart';

void main() {

  runApp(const MyApp());

}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        brightness: Brightness.light,
        primarySwatch: Colors.blue,
      ),
      home: const MyHomePage(title: 'HeavenEx'),
    );
  }
}

class MyHomePage extends StatefulWidget {


  const MyHomePage({Key? key, required this.title}) : super(key: key);


  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  late List<Ofertas> _list;
  int cantidad_cryptos=0;
  bool isLoading = false;
  final cron = Cron();
  FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
  FlutterLocalNotificationsPlugin();

  static const AndroidInitializationSettings initializationSettingsAndroid =
  AndroidInitializationSettings('@mipmap/ic_launcher');

  final InitializationSettings initializationSettings = InitializationSettings(
      android: initializationSettingsAndroid);

  @override
  Widget build(BuildContext context) {

    SystemUiOverlayStyle overlayStyle = SystemUiOverlayStyle(
      systemNavigationBarIconBrightness: Brightness.dark,
      systemNavigationBarColor: Colors.white,//color bottomBar
      systemNavigationBarDividerColor: Colors.white,// color de dividir bottomBar de screen es una linea
      /*systemNavigationBarColor: SelectColor.parseColor("#120c6e"),
      systemNavigationBarDividerColor: SelectColor.parseColor("#120c6e"),*/
      statusBarColor: Colors.transparent,
      statusBarIconBrightness: Brightness.dark,
      statusBarBrightness: Brightness.dark,

    );
    SystemChrome.setSystemUIOverlayStyle(overlayStyle);

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Center(child: Text('HeavenEx')),
        actions: [
          IconButton(
              icon: Icon(
                Icons.alarm,
                color: Colors.white,
                size: 19,
              ),
              onPressed: () async {
                getNotification();

              }),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.blueAccent,
        /*backgroundColor: SelectColor.parseColor("120c8e"),*/
        child: Icon(Icons.refresh,color: Colors.white,),
        onPressed: () {
          getBecados();
         //getBecados();
        },
      ),
      body: Container(
        child: isLoading?Center(
          child: ListView.builder(
            primary: true,
            padding: EdgeInsets.only(bottom: 100),
            itemCount: _list.length,
            itemBuilder: (context, index) => OfertasItem(
              ofertas:_list[index] ,
            ),
          ),
        ):Center(child: CircularProgressIndicator()),
      ),
    );
  }

  getNotification(){
    cron.schedule(Schedule.parse('*/3 * * * *'), () async {
      print('Corriendo Tarea');
      getBecados();
    });
  }

  Future<void> getBecados() async {

    await Future.delayed(Duration(milliseconds: 400));
    Dio dio;
    var customHeaders = {
      'Host' : 'heavenex.com',
      'Referer':'https://heavenex.com/accounts/login/?next=/crypto/offer/sell/0',
      'User-Agent':'Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:96.0) Gecko/20100101 Firefox/96.0',
      'Accept':'text/html,application/xhtml+xml,application/xml;q=0.9,image/avif,image/webp,*/*;q=0.8',
      'Accept-Language':'es-ES,es;q=0.8,en-US;q=0.5,en;q=0.3',
      'Accept-Encoding':'gzip, deflate',
      'Sec-Fetch-Dest':'empty',
      'Sec-Fetch-Mode':'cors',
      'Sec-Fetch-Site':'same-site',
      'Connection':'keep-alive',
      'Cache-Control':'max-age=0',
      'TE':'trailers'
    };
    dio =Dio()
      ..options.connectTimeout = 100000
      ..options.receiveTimeout = 100000
      ..options.sendTimeout = 100000
      ..options.receiveDataWhenStatusError = true
      ..options.followRedirects = true
      ..options.method = 'GET'
      ..options.responseType = ResponseType.json
      ..options.receiveDataWhenStatusError = true
      ..options.headers = customHeaders
      ..interceptors.add(LogInterceptor());

    try {
      var response = await dio.get('https://heavenex.com/offers');
      var document = parse(response.data);

      var rows = document.getElementsByClassName('table_responsive')[0].getElementsByTagName('table')[0].getElementsByTagName('tbody')[0].getElementsByTagName('tr');
      _list= [];
      Ofertas ofertas;
      for (int i = 0; i < rows.length; i++) {
        ofertas = new Ofertas(
            rows[i].getElementsByTagName('td')[0].text,
            rows[i].getElementsByTagName('td')[1].text.replaceAll(" ", "?").replaceAll(new RegExp(r"\?\?+"), "").replaceAll(new RegExp(r"\s+"), "").replaceAll("?", " "),
            rows[i].getElementsByTagName('td')[3].getElementsByTagName('img').where((e) => e.attributes.containsKey('src'))
            .map((e) => e.attributes['src'])
            .toString().replaceAll("(", "").replaceAll(")", ""),
            rows[i].getElementsByTagName('td')[1].getElementsByTagName('a').first.getElementsByTagName('img').where((e) => e.attributes.containsKey('src')).map((e) => e.attributes['src']).toString().replaceAll("(", "").replaceAll(")", ""),
            rows[i].getElementsByTagName('td')[3].text.replaceAll(" ", "?").replaceAll(new RegExp(r"\?\?+"), "").replaceAll(new RegExp(r"\s+"), "").replaceAll("?", " "),
            rows[i].getElementsByTagName('td')[4].text.replaceAll(" ", "?").replaceAll(new RegExp(r"\?\?+"), "").replaceAll(new RegExp(r"\s+"), "").replaceAll("?", " "),
            rows[i].getElementsByTagName('td')[5].text.replaceAll(" ", "?").replaceAll(new RegExp(r"\?\?+"), "").replaceAll(new RegExp(r"\s+"), "").replaceAll("?", " ").replaceAll("%", "% "),
            rows[i].getElementsByTagName('td')[5].text.replaceAll(" ", "?").replaceAll(new RegExp(r"\?\?+"), "").replaceAll(new RegExp(r"\s+"), "").replaceAll("?", " ").replaceAll("%", "% "),
            rows[i].getElementsByTagName('td')[6].text.replaceAll(" ", "?").replaceAll(new RegExp(r"\?\?+"), "").replaceAll(new RegExp(r"\s+"), "").replaceAll("?", " "));
        var a =rows[i].getElementsByTagName('td')[5].text.replaceAll(" ", "?").replaceAll(new RegExp(r"\?\?+"), "").replaceAll(new RegExp(r"\s+"), "").replaceAll("?", " ").split("%");
        int temp = int.parse(a[0]);
        if(temp>100) {
          _list.add(ofertas);

        }
      }
      if(cantidad_cryptos!=_list.length){
        showNotification();
        cantidad_cryptos=_list.length;
      }

      print(_list[0].img_user);
      isLoading = true;
      setState(() {

      });

    } catch (e) {
      print(e);
    }

  }
  Future<void> getCitas() async {

    await Future.delayed(Duration(milliseconds: 400));
    Dio dio;
    var customHeaders = {
      'User-Agent':'Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:96.0) Gecko/20100101 Firefox/96.0',
      'Accept':'text/html,application/xhtml+xml,application/xml;q=0.9,image/avif,image/webp,*/*;q=0.8',
      'Accept-Language':'es-ES,es;q=0.8,en-US;q=0.5,en;q=0.3',
      'Accept-Encoding':'gzip, deflate',
      'Sec-Fetch-Dest':'empty',
      'Sec-Fetch-Mode':'cors',
      'Sec-Fetch-Site':'same-site',
      'Connection':'keep-alive',
      'Cache-Control':'max-age=0',
      'TE':'trailers'
    };
    dio =Dio()
      ..options.connectTimeout = 100000
      ..options.receiveTimeout = 100000
      ..options.sendTimeout = 100000
      ..options.receiveDataWhenStatusError = true
      ..options.followRedirects = true
      ..options.method = 'GET'
      ..options.responseType = ResponseType.json
      ..options.receiveDataWhenStatusError = true
      ..options.headers = customHeaders
      ..interceptors.add(LogInterceptor());

    try {
      var response = await dio.get('https://docs.google.com/forms/d/e/1FAIpQLSenjWwID4tbDF_p3TpnHmkOMphksAra5dBxpaR6ogVBBAQv8w/closedform');
      var document = parse(response.data);

      print(document.outerHtml);
      setState(() {

      });

    } catch (e) {
      print(e);
    }

  }
  showNotification()async{
    await flutterLocalNotificationsPlugin.initialize(initializationSettings,
        onSelectNotification: null);
    const String groupKey = 'com.android.example.WORK_EMAIL';
    const String groupChannelId = 'grouped channel id';
    const String groupChannelName = 'grouped channel name';
    const String groupChannelDescription = 'grouped channel description';
    const AndroidNotificationDetails firstNotificationAndroidSpecifics =
    AndroidNotificationDetails(groupChannelId, groupChannelName,
        channelDescription: groupChannelDescription,
        importance: Importance.high,
        sound: RawResourceAndroidNotificationSound('notify'),
        enableVibration: true,
        priority: Priority.high,
        enableLights: true,
        groupKey: groupKey);
    const NotificationDetails firstNotificationPlatformSpecifics =
    NotificationDetails(android: firstNotificationAndroidSpecifics);
    await flutterLocalNotificationsPlugin.show(1, 'Nuevas Cryptos',
        'Apurate que se acaba...', firstNotificationPlatformSpecifics);
    const AndroidNotificationDetails secondNotificationAndroidSpecifics =
    AndroidNotificationDetails(groupChannelId, groupChannelName,
        channelDescription: groupChannelDescription,
        importance: Importance.high,
        enableVibration: true,
        sound: RawResourceAndroidNotificationSound('notify'),
        priority: Priority.high,
        groupKey: groupKey);
    const NotificationDetails secondNotificationPlatformSpecifics =
    NotificationDetails(android: secondNotificationAndroidSpecifics);
   /* await flutterLocalNotificationsPlugin.show(
        2,
        'Jeff Chang',
        'Please join us to celebrate the...',
        secondNotificationPlatformSpecifics);*/
   /* await AwesomeNotifications().createNotification(
        content: NotificationContent(
            id: 100000,
            channelKey: 'basic_test',
            title: 'Hay Nuevas Cryptos',
            bigPicture:'https://i0.wp.com/www.jornadageek.com.br/wp-content/uploads/2018/06/Looney-tunes.png?resize=696%2C398&ssl=1',
            notificationLayout: NotificationLayout.BigPicture,
            payload: {'uuid': 'uuid-test'}));*/
  }
  void selectNotification() async {

    await Navigator.push(
      context,
      MaterialPageRoute<void>(builder: (context) => MyApp()),
    );
  }
}
