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
                var appDir = AppDomain.CurrentDomain.BaseDirectory;
                Debug.WriteLine($"📂 Папка приложения: {appDir}");

                // Update.exe находится на уровень выше папки app-X.X.X
                var parentDir = Directory.GetParent(appDir)?.FullName;
                if (parentDir == null)
                {
                    Debug.WriteLine($"⚠️ Не удалось получить родительскую папку");
                    return null;
                }

                var updateExe = Path.Combine(parentDir, "Update.exe");
                Debug.WriteLine($"🔍 Ищем Update.exe: {updateExe}");
                Debug.WriteLine($"✓ Файл существует: {File.Exists(updateExe)}");

                if (File.Exists(updateExe))
                {
                    return updateExe;
                }

                Debug.WriteLine($"⚠️ Update.exe не найден, приложение запущено не из Squirrel установки");
                return null;
            }
            catch (Exception ex)
            {
                Debug.WriteLine($"❌ Ошибка поиска Update.exe: {ex.Message}");
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
                Debug.WriteLine($"🔍 Проверка обновлений по URL: {_updateUrl}");
                Debug.WriteLine($"📌 Текущая версия: {_currentVersion}");

                var updateExe = FindUpdateExe();
                if (updateExe == null)
                {
                    Debug.WriteLine($"⚠️ Update.exe не найден, автообновление недоступно");
                    Debug.WriteLine($"ℹ️ Это нормально для запуска из Visual Studio");
                    return new UpdateInfo { HasUpdate = false, CurrentVersion = _currentVersion };
                }

                Debug.WriteLine($"✅ Update.exe найден: {updateExe}");
                Debug.WriteLine($"🔄 Запускаем проверку обновлений...");
                Debug.WriteLine($"🌐 Полный URL: {_updateUrl}");
                Debug.WriteLine($"📝 Команда: {updateExe} --checkForUpdate --url \"{_updateUrl}\"");

                // Запускаем Update.exe --checkForUpdate --url <updateUrl>
                var startInfo = new ProcessStartInfo
                {
                    FileName = updateExe,
                    Arguments = $"--checkForUpdate --url \"{_updateUrl}\"",
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
                        Debug.WriteLine($"📤 Update.exe: {e.Data}");
                    }
                };

                process.ErrorDataReceived += (sender, e) =>
                {
                    if (!string.IsNullOrEmpty(e.Data))
                    {
                        error += e.Data + "\n";
                        Debug.WriteLine($"⚠️ Update.exe error: {e.Data}");
                    }
                };

                process.Start();
                process.BeginOutputReadLine();
                process.BeginErrorReadLine();

                await process.WaitForExitAsync();

                Debug.WriteLine($"✅ Update.exe завершен с кодом: {process.ExitCode}");
                Debug.WriteLine($"📤 Output: {output}");
                Debug.WriteLine($"⚠️ Error: {error}");

                // ДИАГНОСТИКА: Показываем полный вывод Update.exe
                var diagnosticMessage = $"ExitCode: {process.ExitCode}\n\n";
                diagnosticMessage += $"Output:\n{output}\n\n";
                diagnosticMessage += $"Error:\n{error}";
                System.Windows.MessageBox.Show(diagnosticMessage, "Update.exe диагностика", System.Windows.MessageBoxButton.OK);

                // ExitCode 0 = обновление доступно
                // ExitCode 1 = обновлений нет
                // ExitCode 2+ = ошибка
                if (process.ExitCode == 0)
                {
                    Debug.WriteLine($"✅ Найдено обновление!");

                    // Пытаемся извлечь версию из вывода
                    var versionMatch = Regex.Match(output, @"(\d+\.\d+\.\d+)");
                    var newVersion = versionMatch.Success ? versionMatch.Groups[1].Value : "новая версия";

                    Debug.WriteLine($"🎯 Новая версия: {newVersion}");

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
                    Debug.WriteLine($"ℹ️ Обновлений нет");
                    return new UpdateInfo { HasUpdate = false, CurrentVersion = _currentVersion };
                }
                else
                {
                    Debug.WriteLine($"❌ Ошибка проверки обновлений: {error}");
                    return new UpdateInfo { HasUpdate = false, Error = error, CurrentVersion = _currentVersion };
                }
            }
            catch (Exception ex)
            {
                Debug.WriteLine($"❌ Ошибка проверки обновлений: {ex.Message}");
                Debug.WriteLine($"Stack trace: {ex.StackTrace}");
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

                // Запускаем Update.exe --update <updateUrl>
                var startInfo = new ProcessStartInfo
                {
                    FileName = updateExe,
                    Arguments = $"--update \"{_updateUrl}\"",
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
