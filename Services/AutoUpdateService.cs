using System;
using System.Diagnostics;
using System.IO;
using System.Reflection;
using System.Threading.Tasks;

namespace Contract2512.Services
{
    /// <summary>
    /// Сервис автоматического обновления приложения через Squirrel Update.exe
    /// </summary>
    public class AutoUpdateService
    {
        private readonly string _updateUrl;
        private readonly string _currentVersion;

        public AutoUpdateService(string updateUrl)
        {
            _updateUrl = updateUrl;
            _currentVersion = GetCurrentVersion();
        }

        /// <summary>
        /// Получает текущую версию приложения
        /// </summary>
        private string GetCurrentVersion()
        {
            var assembly = Assembly.GetExecutingAssembly();
            var version = assembly.GetName().Version;
            return $"{version?.Major}.{version?.Minor}.{version?.Build}";
        }

        /// <summary>
        /// Проверяет наличие обновлений через Update.exe
        /// </summary>
        public async Task<UpdateInfo> CheckForUpdatesAsync()
        {
            try
            {
                Debug.WriteLine($"🔍 Проверка обновлений по URL: {_updateUrl}");
                Debug.WriteLine($"📌 Текущая версия: {_currentVersion}");
                
                // Ищем Update.exe в родительской папке (Squirrel устанавливает его там)
                var appDir = AppDomain.CurrentDomain.BaseDirectory;
                var updateExe = Path.Combine(appDir, "..", "Update.exe");
                
                if (!File.Exists(updateExe))
                {
                    Debug.WriteLine($"⚠️ Update.exe не найден по пути: {updateExe}");
                    Debug.WriteLine($"ℹ️ Автообновление работает только для установленного приложения");
                    return new UpdateInfo { HasUpdate = false, CurrentVersion = _currentVersion };
                }

                Debug.WriteLine($"✅ Update.exe найден: {updateExe}");
                
                // Запускаем Update.exe --checkForUpdate
                var startInfo = new ProcessStartInfo
                {
                    FileName = updateExe,
                    Arguments = $"--checkForUpdate=\"{_updateUrl}\"",
                    UseShellExecute = false,
                    RedirectStandardOutput = true,
                    RedirectStandardError = true,
                    CreateNoWindow = true
                };

                using var process = Process.Start(startInfo);
                if (process == null)
                {
                    Debug.WriteLine($"❌ Не удалось запустить Update.exe");
                    return new UpdateInfo { HasUpdate = false, Error = "Failed to start Update.exe", CurrentVersion = _currentVersion };
                }

                var output = await process.StandardOutput.ReadToEndAsync();
                var error = await process.StandardError.ReadToEndAsync();
                await process.WaitForExitAsync();

                Debug.WriteLine($"Update.exe output: {output}");
                if (!string.IsNullOrEmpty(error))
                {
                    Debug.WriteLine($"Update.exe error: {error}");
                }

                // Если есть обновление, Update.exe вернет информацию о нем
                if (process.ExitCode == 0 && !string.IsNullOrEmpty(output))
                {
                    Debug.WriteLine($"✅ Найдено обновление");
                    return new UpdateInfo
                    {
                        HasUpdate = true,
                        Version = "новая версия",
                        ReleaseNotes = "Доступна новая версия приложения",
                        CurrentVersion = _currentVersion
                    };
                }

                Debug.WriteLine($"ℹ️ Обновлений нет");
                return new UpdateInfo { HasUpdate = false, CurrentVersion = _currentVersion };
            }
            catch (Exception ex)
            {
                Debug.WriteLine($"❌ Ошибка проверки обновлений: {ex.Message}");
                return new UpdateInfo { HasUpdate = false, Error = ex.Message, CurrentVersion = _currentVersion };
            }
        }

        /// <summary>
        /// Скачивает и устанавливает обновление через Update.exe
        /// </summary>
        public async Task<bool> DownloadAndInstallUpdateAsync(IProgress<int>? progress = null)
        {
            try
            {
                Debug.WriteLine($"📥 Начало загрузки обновления...");
                
                var appDir = AppDomain.CurrentDomain.BaseDirectory;
                var updateExe = Path.Combine(appDir, "..", "Update.exe");
                
                if (!File.Exists(updateExe))
                {
                    Debug.WriteLine($"❌ Update.exe не найден");
                    return false;
                }

                // Запускаем Update.exe --update
                var startInfo = new ProcessStartInfo
                {
                    FileName = updateExe,
                    Arguments = $"--update=\"{_updateUrl}\"",
                    UseShellExecute = false,
                    RedirectStandardOutput = true,
                    RedirectStandardError = true,
                    CreateNoWindow = true
                };

                using var process = Process.Start(startInfo);
                if (process == null)
                {
                    Debug.WriteLine($"❌ Не удалось запустить Update.exe");
                    return false;
                }

                var output = await process.StandardOutput.ReadToEndAsync();
                var error = await process.StandardError.ReadToEndAsync();
                await process.WaitForExitAsync();

                Debug.WriteLine($"Update.exe output: {output}");
                if (!string.IsNullOrEmpty(error))
                {
                    Debug.WriteLine($"Update.exe error: {error}");
                }

                if (process.ExitCode == 0)
                {
                    Debug.WriteLine($"✅ Обновление установлено!");
                    return true;
                }

                Debug.WriteLine($"❌ Ошибка установки, код: {process.ExitCode}");
                return false;
            }
            catch (Exception ex)
            {
                Debug.WriteLine($"❌ Ошибка установки: {ex.Message}");
                return false;
            }
        }

        /// <summary>
        /// Перезапускает приложение после обновления
        /// </summary>
        public static void RestartApp()
        {
            try
            {
                Debug.WriteLine($"🔄 Перезапуск приложения...");
                
                var appDir = AppDomain.CurrentDomain.BaseDirectory;
                var updateExe = Path.Combine(appDir, "..", "Update.exe");
                
                if (File.Exists(updateExe))
                {
                    // Запускаем Update.exe --processStart для перезапуска
                    var exeName = Path.GetFileName(Assembly.GetExecutingAssembly().Location);
                    Process.Start(updateExe, $"--processStart=\"{exeName}\"");
                    Environment.Exit(0);
                }
                else
                {
                    Debug.WriteLine($"❌ Update.exe не найден для перезапуска");
                }
            }
            catch (Exception ex)
            {
                Debug.WriteLine($"❌ Ошибка перезапуска: {ex.Message}");
            }
        }
    }

    /// <summary>
    /// Информация об обновлении
    /// </summary>
    public class UpdateInfo
    {
        public bool HasUpdate { get; set; }
        public string Version { get; set; } = "";
        public string CurrentVersion { get; set; } = "";
        public string ReleaseNotes { get; set; } = "";
        public string Error { get; set; } = "";
    }
}
