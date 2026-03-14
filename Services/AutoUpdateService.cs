using System;
using System.Diagnostics;
using System.IO;
using System.Linq;
using System.Reflection;
using System.Threading.Tasks;

namespace Contract2512.Services
{
    /// <summary>
    /// Сервис автоматического обновления приложения через Squirrel (с динамической загрузкой)
    /// </summary>
    public class AutoUpdateService
    {
        private readonly string _updateUrl;
        private readonly string _currentVersion;
        private static Assembly? _squirrelAssembly;

        public AutoUpdateService(string updateUrl)
        {
            _updateUrl = updateUrl;
            _currentVersion = GetCurrentVersion();
        }

        /// <summary>
        /// Загружает Squirrel assembly динамически
        /// </summary>
        private static Assembly? LoadSquirrelAssembly()
        {
            if (_squirrelAssembly != null) return _squirrelAssembly;

            try
            {
                // Ищем Clowd.Squirrel.dll в папке приложения
                var appDir = AppDomain.CurrentDomain.BaseDirectory;
                var squirrelDll = Path.Combine(appDir, "Clowd.Squirrel.dll");

                if (File.Exists(squirrelDll))
                {
                    Debug.WriteLine($"✅ Загружаем Squirrel из: {squirrelDll}");
                    _squirrelAssembly = Assembly.LoadFrom(squirrelDll);
                    return _squirrelAssembly;
                }

                Debug.WriteLine($"⚠️ Clowd.Squirrel.dll не найден в: {appDir}");
                return null;
            }
            catch (Exception ex)
            {
                Debug.WriteLine($"❌ Ошибка загрузки Squirrel: {ex.Message}");
                return null;
            }
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
                Debug.WriteLine($"📂 Папка приложения: {AppDomain.CurrentDomain.BaseDirectory}");

                var assembly = LoadSquirrelAssembly();
                if (assembly == null)
                {
                    Debug.WriteLine($"⚠️ Squirrel не загружен, автообновление недоступно");
                    Debug.WriteLine($"ℹ️ Это нормально для запуска из Visual Studio");
                    return new UpdateInfo { HasUpdate = false, CurrentVersion = _currentVersion };
                }

                Debug.WriteLine($"✅ Squirrel assembly загружен: {assembly.FullName}");

                // Создаем UpdateManager через рефлексию
                var updateManagerType = assembly.GetType("Clowd.Squirrel.UpdateManager");
                if (updateManagerType == null)
                {
                    Debug.WriteLine($"❌ UpdateManager не найден");
                    return new UpdateInfo { HasUpdate = false, Error = "UpdateManager not found", CurrentVersion = _currentVersion };
                }

                Debug.WriteLine($"✅ UpdateManager найден");
                Debug.WriteLine($"🌐 Создаем UpdateManager с URL: {_updateUrl}");

                var updateManager = Activator.CreateInstance(updateManagerType, _updateUrl);
                if (updateManager == null)
                {
                    Debug.WriteLine($"❌ Не удалось создать UpdateManager");
                    return new UpdateInfo { HasUpdate = false, Error = "Failed to create UpdateManager", CurrentVersion = _currentVersion };
                }

                Debug.WriteLine($"✅ UpdateManager создан");

                // Вызываем CheckForUpdate
                var checkMethod = updateManagerType.GetMethod("CheckForUpdate");
                if (checkMethod == null)
                {
                    Debug.WriteLine($"❌ Метод CheckForUpdate не найден");
                    return new UpdateInfo { HasUpdate = false, Error = "CheckForUpdate method not found", CurrentVersion = _currentVersion };
                }

                Debug.WriteLine($"🔄 Вызываем CheckForUpdate...");

                var updateInfoTask = checkMethod.Invoke(updateManager, null) as Task;
                if (updateInfoTask == null)
                {
                    Debug.WriteLine($"❌ CheckForUpdate не вернул Task");
                    return new UpdateInfo { HasUpdate = false, Error = "CheckForUpdate failed", CurrentVersion = _currentVersion };
                }

                Debug.WriteLine($"⏳ Ожидаем результат CheckForUpdate...");
                await updateInfoTask.ConfigureAwait(false);
                Debug.WriteLine($"✅ CheckForUpdate завершен");

                // Получаем результат
                var resultProperty = updateInfoTask.GetType().GetProperty("Result");
                var updateInfoResult = resultProperty?.GetValue(updateInfoTask);

                if (updateInfoResult == null)
                {
                    Debug.WriteLine($"ℹ️ Обновлений нет (updateInfoResult == null)");
                    return new UpdateInfo { HasUpdate = false, CurrentVersion = _currentVersion };
                }

                Debug.WriteLine($"✅ Получен результат updateInfo");

                // Проверяем ReleasesToApply
                var releasesToApplyProperty = updateInfoResult.GetType().GetProperty("ReleasesToApply");
                var releasesToApply = releasesToApplyProperty?.GetValue(updateInfoResult) as System.Collections.IList;

                Debug.WriteLine($"📦 ReleasesToApply count: {releasesToApply?.Count ?? 0}");

                if (releasesToApply != null && releasesToApply.Count > 0)
                {
                    Debug.WriteLine($"✅ Найдено обновлений: {releasesToApply.Count}");

                    // Получаем версию
                    var futureReleaseProperty = updateInfoResult.GetType().GetProperty("FutureReleaseEntry");
                    var futureRelease = futureReleaseProperty?.GetValue(updateInfoResult);
                    var versionProperty = futureRelease?.GetType().GetProperty("Version");
                    var version = versionProperty?.GetValue(futureRelease);

                    Debug.WriteLine($"🎯 Новая версия: {version}");

                    return new UpdateInfo
                    {
                        HasUpdate = true,
                        Version = version?.ToString() ?? "новая версия",
                        ReleaseNotes = "Доступна новая версия приложения",
                        CurrentVersion = _currentVersion
                    };
                }

                Debug.WriteLine($"ℹ️ Обновлений нет (ReleasesToApply пуст)");
                return new UpdateInfo { HasUpdate = false, CurrentVersion = _currentVersion };
            }
            catch (Exception ex)
            {
                Debug.WriteLine($"❌ Ошибка проверки обновлений: {ex.Message}");
                Debug.WriteLine($"Stack trace: {ex.StackTrace}");
                if (ex.InnerException != null)
                {
                    Debug.WriteLine($"Inner exception: {ex.InnerException.Message}");
                    Debug.WriteLine($"Inner stack trace: {ex.InnerException.StackTrace}");
                }
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

                var assembly = LoadSquirrelAssembly();
                if (assembly == null) return false;

                var updateManagerType = assembly.GetType("Clowd.Squirrel.UpdateManager");
                if (updateManagerType == null) return false;

                var updateManager = Activator.CreateInstance(updateManagerType, _updateUrl);
                if (updateManager == null) return false;

                // CheckForUpdate
                var checkMethod = updateManagerType.GetMethod("CheckForUpdate");
                var updateInfoTask = checkMethod?.Invoke(updateManager, null) as Task;
                if (updateInfoTask == null) return false;

                await updateInfoTask.ConfigureAwait(false);
                var resultProperty = updateInfoTask.GetType().GetProperty("Result");
                var updateInfoResult = resultProperty?.GetValue(updateInfoTask);
                if (updateInfoResult == null) return false;

                var releasesToApplyProperty = updateInfoResult.GetType().GetProperty("ReleasesToApply");
                var releasesToApply = releasesToApplyProperty?.GetValue(updateInfoResult) as System.Collections.IList;

                if (releasesToApply == null || releasesToApply.Count == 0)
                {
                    Debug.WriteLine($"ℹ️ Нет релизов для применения");
                    return false;
                }

                Debug.WriteLine($"📦 Найдено релизов: {releasesToApply.Count}");

                // DownloadReleases
                var downloadMethod = updateManagerType.GetMethod("DownloadReleases");
                if (downloadMethod != null)
                {
                    Action<int>? progressAction = progress != null ? p => progress.Report(p) : null;
                    var downloadTask = downloadMethod.Invoke(updateManager, new object[] { releasesToApply, progressAction! }) as Task;
                    if (downloadTask != null)
                    {
                        await downloadTask.ConfigureAwait(false);
                        Debug.WriteLine($"✅ Загрузка завершена");
                    }
                }

                // ApplyReleases
                var applyMethod = updateManagerType.GetMethod("ApplyReleases");
                if (applyMethod != null)
                {
                    var applyTask = applyMethod.Invoke(updateManager, new object[] { updateInfoResult }) as Task;
                    if (applyTask != null)
                    {
                        await applyTask.ConfigureAwait(false);
                        Debug.WriteLine($"✅ Обновление установлено!");
                        return true;
                    }
                }

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

                var assembly = LoadSquirrelAssembly();
                if (assembly == null) return;

                var updateManagerType = assembly.GetType("Clowd.Squirrel.UpdateManager");
                var restartMethod = updateManagerType?.GetMethod("RestartApp", BindingFlags.Public | BindingFlags.Static);

                if (restartMethod != null)
                {
                    restartMethod.Invoke(null, null);
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
