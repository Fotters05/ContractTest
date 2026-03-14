using System;
using System.Diagnostics;
using System.Reflection;
using System.Threading.Tasks;
using Clowd.Squirrel;

namespace Contract2512.Services
{
    /// <summary>
    /// Сервис автоматического обновления приложения через Clowd.Squirrel
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
        /// Проверяет наличие обновлений через Squirrel
        /// </summary>
        public async Task<UpdateInfo> CheckForUpdatesAsync()
        {
            try
            {
                Debug.WriteLine($"🔍 Проверка обновлений по URL: {_updateUrl}");
                Debug.WriteLine($"📌 Текущая версия: {_currentVersion}");
                
                using var updateManager = new UpdateManager(_updateUrl);
                var updateInfo = await updateManager.CheckForUpdate();

                if (updateInfo?.ReleasesToApply?.Count > 0)
                {
                    var newVersion = updateInfo.FutureReleaseEntry?.Version?.ToString() ?? "Unknown";
                    Debug.WriteLine($"✅ Найдено обновление: {newVersion}");
                    
                    return new UpdateInfo
                    {
                        HasUpdate = true,
                        Version = newVersion,
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
        /// Скачивает и устанавливает обновление через Squirrel
        /// </summary>
        public async Task<bool> DownloadAndInstallUpdateAsync(IProgress<int>? progress = null)
        {
            try
            {
                Debug.WriteLine($"📥 Начало загрузки обновления...");
                
                using var updateManager = new UpdateManager(_updateUrl);
                var updateInfo = await updateManager.CheckForUpdate();

                if (updateInfo?.ReleasesToApply?.Count > 0)
                {
                    Debug.WriteLine($"📦 Найдено релизов: {updateInfo.ReleasesToApply.Count}");
                    
                    // Скачиваем релизы с прогрессом
                    await updateManager.DownloadReleases(updateInfo.ReleasesToApply, p => 
                    {
                        progress?.Report(p);
                        Debug.WriteLine($"📥 Прогресс: {p}%");
                    });
                    
                    Debug.WriteLine($"✅ Загрузка завершена, применение обновлений...");
                    
                    // Применяем обновления
                    await updateManager.ApplyReleases(updateInfo);
                    
                    Debug.WriteLine($"✅ Обновление установлено!");
                    return true;
                }

                Debug.WriteLine($"ℹ️ Нет релизов для применения");
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
                UpdateManager.RestartApp();
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
