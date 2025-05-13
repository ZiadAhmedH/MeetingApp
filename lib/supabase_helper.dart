import 'package:supabase_flutter/supabase_flutter.dart';

class SupabaseHelper {

 static Future<void> init ()async {
      Supabase.initialize(url:"https://savwcqlrhixilqbryyff.supabase.co" , anonKey: "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6InNhdndjcWxyaGl4aWxxYnJ5eWZmIiwicm9sZSI6ImFub24iLCJpYXQiOjE3NDcxMTA4NDQsImV4cCI6MjA2MjY4Njg0NH0.R_AeeGUFazOsTRT7eR-3SHWCSCxecSM1Os66Gj9i0ag");
  }
}
