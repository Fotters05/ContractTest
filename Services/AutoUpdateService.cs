using System;
using System.Diagnostics;
using System.IO;
using System.Reflection;
using System.Text.RegularExpressions;
using System.Threading.Tasks;

namespace Contract2512.Services
{
    /// <summary>
    /// Сервис автоматического обновления приложения через Update.exe (Squirrel)
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
        /// Находит Update.exe в установленном приложении
        /// </summary>
        private string? FindUpdateExe()
        {
            try
            {
                var appDir = AppDomain.CurrentDomain.BaseDirectory.TrimEnd('\\', '/');
                UpdateLogger.Log($"📂 Папка приложения: {appDir}");

                // Update.exe находится на уровень выше папки app-X.X.X
                var parentDir = Directory.GetParent(appDir)?.FullName;
                if (parentDir == null)
                {
                    UpdateLogger.Log($"⚠️ Не удалось получить родительскую папку");
                    return null;
                }

                UpdateLogger.Log($"📂 Родительская папка: {parentDir}");

                var updateExe = Path.Combine(parentDir, "Update.exe");
                UpdateLogger.Log($"🔍 Ищем Update.exe по пути: {updateExe}");
                UpdateLogger.Log($"✓ Файл существует: {File.Exists(updateExe)}");

                // Показываем содержимое родительской папки
                if (Directory.Exists(parentDir))
                {
                    UpdateLogger.Log($"📁 Содержимое папки {parentDir}:");
                    foreach (var file in Directory.GetFiles(parentDir))
                    {
                        UpdateLogger.Log($"  - {Path.GetFileName(file)}");
                    }
                }

                if (File.Exists(updateExe))
                {
                    return updateExe;
                }

                UpdateLogger.Log($"⚠️ Update.exe не найден, приложение запущено не из Squirrel установки");
                return null;
            }
            catch (Exception ex)
            {
                UpdateLogger.Log($"❌ Ошибка поиска Update.exe: {ex.Message}");
                return null;
            }
        }

        /// <summary>
        /// Проверяет наличие обновлений через Update.exe
        /// </summary>
        public async Task<UpdateInfo> CheckForUpdatesAsync()
        {
            try
            {
                UpdateLogger.LogSection("НАЧАЛО ПРОВЕРКИ ОБНОВЛЕНИЙ");
                UpdateLogger.Log($"URL для проверки: {_updateUrl}");
                UpdateLogger.Log($"Текущая версия: {_currentVersion}");

                var updateExe = FindUpdateExe();
                if (updateExe == null)
                {
                    UpdateLogger.Log("⚠️ Update.exe не найден - приложение запущено не из Squirrel установки");
                    return new UpdateInfo { HasUpdate = false, CurrentVersion = _currentVersion };
                }

                UpdateLogger.Log($"✅ Update.exe найден: {updateExe}");
                UpdateLogger.Log($"Команда: {updateExe} --checkForUpdate=\"{_updateUrl}\"");

                // Запускаем Update.exe --checkForUpdate="URL"
                var startInfo = new ProcessStartInfo
                {
                    FileName = updateExe,
                    Arguments = $"--checkForUpdate=\"{_updateUrl}\"",
                    UseShellExecute = false,
                    RedirectStandardOutput = true,
                    RedirectStandardError = true,
                    CreateNoWindow = true
                };

                using var process = new Process { StartInfo = startInfo };
                var output = "";
                var error = "";

                process.OutputDataReceived += (sender, e) =>
                {
                    if (!string.IsNullOrEmpty(e.Data))
                    {
                        output += e.Data + "\n";
                        UpdateLogger.Log($"[Update.exe OUT] {e.Data}");
                    }
                };

                process.ErrorDataReceived += (sender, e) =>
                {
                    if (!string.IsNullOrEmpty(e.Data))
                    {
                        error += e.Data + "\n";
                        UpdateLogger.Log($"[Update.exe ERR] {e.Data}");
                    }
                };

                UpdateLogger.Log("Запуск Update.exe...");
                process.Start();
                process.BeginOutputReadLine();
                process.BeginErrorReadLine();

                await process.WaitForExitAsync();

                UpdateLogger.Log($"Update.exe завершен с кодом: {process.ExitCode}");
                UpdateLogger.LogSection("РЕЗУЛЬТАТ ПРОВЕРКИ");
                UpdateLogger.Log($"ExitCode: {process.ExitCode}");
                UpdateLogger.Log($"Output:\n{output}");
                UpdateLogger.Log($"Error:\n{error}");

                // ExitCode 0 = обновление доступно
                // ExitCode 1 = обновлений нет
                // ExitCode 2+ = ошибка
                if (process.ExitCode == 0)
                {
                    Debug.WriteLine($"✅ Найдено обновление!");

                    // Пытаемся извлечь версию из вывода
                    var versionMatch = Regex.Match(output, @"(\d+\.\d+\.\d+)");
                    var newVersion = versionMatch.Success ? versionMatch.Groups[1].Value : "новая версия";

                    UpdateLogger.Log($"✅ ОБНОВЛЕНИЕ НАЙДЕНО! Новая версия: {newVersion}");

                    return new UpdateInfo
                    {
                        HasUpdate = true,
                        Version = newVersion,
                        ReleaseNotes = "Доступна новая версия приложения",
                        CurrentVersion = _currentVersion
                    };
                }
                else if (process.ExitCode == 1)
                {
                    UpdateLogger.Log("ℹ️ Обновлений нет (ExitCode = 1)");
                    return new UpdateInfo { HasUpdate = false, CurrentVersion = _currentVersion };
                }
                else
                {
                    UpdateLogger.Log($"❌ Ошибка проверки обновлений (ExitCode = {process.ExitCode})");
                    UpdateLogger.Log($"Лог сохранен в: {UpdateLogger.GetLogFilePath()}");
                    return new UpdateInfo { HasUpdate = false, Error = $"ExitCode: {process.ExitCode}\n{error}", CurrentVersion = _currentVersion };
                }
            }
            catch (Exception ex)
            {
                UpdateLogger.Log($"❌ ИСКЛЮЧЕНИЕ: {ex.Message}");
                UpdateLogger.Log($"Stack trace: {ex.StackTrace}");
                UpdateLogger.Log($"Лог сохранен в: {UpdateLogger.GetLogFilePath()}");
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
                Debug.WriteLine($"📥 Начало загрузки и установки обновления...");

                var updateExe = FindUpdateExe();
                if (updateExe == null)
                {
                    Debug.WriteLine($"❌ Update.exe не найден");
                    return false;
                }

                Debug.WriteLine($"✅ Update.exe найден: {updateExe}");
                Debug.WriteLine($"🔄 Запускаем установку обновления...");

                // Запускаем Update.exe --update="URL"
                var startInfo = new ProcessStartInfo
                {
                    FileName = updateExe,
                    Arguments = $"--update=\"{_updateUrl}\"",
                    UseShellExecute = false,
                    RedirectStandardOutput = true,
                    RedirectStandardError = true,
                    CreateNoWindow = true
                };

                using var process = new Process { StartInfo = startInfo };

                process.OutputDataReceived += (sender, e) =>
                {
                    if (!string.IsNullOrEmpty(e.Data))
                    {
                        Debug.WriteLine($"📤 Update.exe: {e.Data}");
                        
                        // Пытаемся извлечь прогресс из вывода
                        var progressMatch = Regex.Match(e.Data, @"(\d+)%");
                        if (progressMatch.Success && int.TryParse(progressMatch.Groups[1].Value, out var percent))
                        {
                            progress?.Report(percent);
                        }
                    }
                };

                process.ErrorDataReceived += (sender, e) =>
                {
                    if (!string.IsNullOrEmpty(e.Data))
                    {
                        Debug.WriteLine($"⚠️ Update.exe error: {e.Data}");
                    }
                };

                process.Start();
                process.BeginOutputReadLine();
                process.BeginErrorReadLine();

                await process.WaitForExitAsync();

                Debug.WriteLine($"✅ Update.exe завершен с кодом: {process.ExitCode}");

                if (process.ExitCode == 0)
                {
                    Debug.WriteLine($"✅ Обновление успешно установлено!");
                    return true;
                }
                else
                {
                    Debug.WriteLine($"❌ Ошибка установки обновления, код: {process.ExitCode}");
                    return false;
                }
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

                // Получаем путь к Update.exe
                var appDir = AppDomain.CurrentDomain.BaseDirectory;
                var parentDir = Directory.GetParent(appDir)?.FullName;
                if (parentDir == null) return;

                var updateExe = Path.Combine(parentDir, "Update.exe");
                if (!File.Exists(updateExe))
                {
                    Debug.WriteLine($"⚠️ Update.exe не найден для перезапуска");
                    return;
                }

                // Запускаем Update.exe --processStart Contract2512.exe
                var startInfo = new ProcessStartInfo
                {
                    FileName = updateExe,
                    Arguments = "--processStart Contract2512.exe",
                    UseShellExecute = false,
                    CreateNoWindow = true
                };

                Process.Start(startInfo);
                Debug.WriteLine($"✅ Команда перезапуска отправлена");

                // Закрываем текущее приложение
                System.Windows.Application.Current.Shutdown();
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
