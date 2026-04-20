import 'package:flutter/material.dart';
import 'package:modelhandling/screen/chat_screen.dart';
import 'package:supabase_flutter/supabase_flutter.dart';


void main() async{
  WidgetsFlutterBinding.ensureInitialized();
  await Supabase.initialize(url: 'https://ydmpzmmampfuuvumafuu.supabase.co' , anonKey: 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6InlkbXB6bW1hbXBmdXV2dW1hZnV1Iiwicm9sZSI6ImFub24iLCJpYXQiOjE3NzExNTE3MjEsImV4cCI6MjA4NjcyNzcyMX0.OTVhCIXHqT8rxQnL2AW-mroEtVgXGFhSCN95aFjC264');
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(colorScheme: .fromSeed(seedColor: Colors.deepPurple),),
      debugShowCheckedModeBanner: false,
      home: ChatPage(username: 'User1',),
    );
  }
}
