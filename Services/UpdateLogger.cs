using System;
using System.IO;

namespace Contract2512.Services
{
    /// <summary>
    /// Логгер для диагностики автообновления
    /// </summary>
    public static class UpdateLogger
    {
        private static string? _logFilePath;

        static UpdateLogger()
        {
            try
            {
                // Создаем файл лога в папке приложения
                var appDir = AppDomain.CurrentDomain.BaseDirectory;
                _logFilePath = Path.Combine(appDir, "update_check.log");
                
                // Очищаем старый лог при запуске
                File.WriteAllText(_logFilePath, $"=== Лог проверки обновлений ===\n");
                File.AppendAllText(_logFilePath, $"Время запуска: {DateTime.Now:yyyy-MM-dd HH:mm:ss}\n");
                File.AppendAllText(_logFilePath, $"Папка приложения: {appDir}\n\n");
            }
            catch (Exception ex)
            {
                System.Diagnostics.Debug.WriteLine($"❌ Ошибка создания лог-файла: {ex.Message}");
            }
        }

        public static void Log(string message)
        {
            try
            {
                if (_logFilePath != null)
                {
                    var timestamp = DateTime.Now.ToString("HH:mm:ss.fff");
                    File.AppendAllText(_logFilePath, $"[{timestamp}] {message}\n");
                }
                System.Diagnostics.Debug.WriteLine(message);
            }
            catch (Exception ex)
            {
                System.Diagnostics.Debug.WriteLine($"❌ Ошибка записи в лог: {ex.Message}");
            }
        }

        public static void LogSection(string title)
        {
            Log($"\n{'=',50}");
            Log(title);
            Log($"{'=',50}");
        }

        public static string? GetLogFilePath()
        {
            return _logFilePath;
        }
    }
}
