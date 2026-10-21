class SupabaseConstants {
  SupabaseConstants._();

  static const String supabaseUrl = String.fromEnvironment(
    'SUPABASE_URL',
    defaultValue: 'https://zvjxzvbbcdzwuiztxoes.supabase.co',
  );

  static const String supabaseAnonKey = String.fromEnvironment(
    'SUPABASE_ANON_KEY',
    defaultValue:
        'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6Inp2anh6dmJiY2R6d3VpenR4b2VzIiwicm9sZSI6ImFub24iLCJpYXQiOjE3OTA5NjMwODgsImV4cCI6MjEwNjUzOTA4OH0.Kv56F1xPCw2mPvefE9tH8xEsw7mwdD8n9UGZSFLMXd4',
  );

  static const String webClientId = String.fromEnvironment(
    'GOOGLE_WEB_CLIENT_ID',
    defaultValue:
        '304504714791-emaernnvj05ggjaqeq2a88ku6qntqfdl.apps.googleusercontent.com',
  );
}
