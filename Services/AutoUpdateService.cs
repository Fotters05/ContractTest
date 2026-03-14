using System;
using System.Diagnostics;
using System.Reflection;
using System.Threading.Tasks;

namespace Contract2512.Services
{
    /// <summary>
    /// Сервис автоматического обновления приложения через Clowd.Squirrel
    /// </summary>
    public class AutoUpdateService
    {
        private readonly string _updateUrl;
        private readonly string _currentVersion;
        private readonly Assembly? _squirrelAssembly;

        public AutoUpdateService(string updateUrl)
        {
            _updateUrl = updateUrl;
            _currentVersion = GetCurrentVersion();
            
            try
            {
                _squirrelAssembly = Assembly.Load("Clowd.Squirrel");
            }
            catch
            {
                _squirrelAssembly = null;
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
            if (_squirrelAssembly == null)
            {
                return new UpdateInfo { HasUpdate = false, Error = "Squirrel not loaded", CurrentVersion = _currentVersion };
            }

            try
            {
                Debug.WriteLine($"🔍 Проверка обновлений по URL: {_updateUrl}");
                Debug.WriteLine($"📌 Текущая версия: {_currentVersion}");
                
                var updateManagerType = _squirrelAssembly.GetType("Clowd.Squirrel.UpdateManager");
                if (updateManagerType == null) throw new Exception("UpdateManager not found");

                var updateManager = Activator.CreateInstance(updateManagerType, _updateUrl);
                if (updateManager == null) throw new Exception("Failed to create UpdateManager");

                try
                {
                    var checkMethod = updateManagerType.GetMethod("CheckForUpdate");
                    if (checkMethod == null) throw new Exception("CheckForUpdate not found");

                    var checkTask = checkMethod.Invoke(updateManager, null) as Task;
                    if (checkTask == null) throw new Exception("CheckForUpdate returned null");

                    await checkTask;
                    
                    var resultProperty = checkTask.GetType().GetProperty("Result");
                    var updateInfo = resultProperty?.GetValue(checkTask);

                    if (updateInfo != null)
                    {
                        var releasesToApplyProp = updateInfo.GetType().GetProperty("ReleasesToApply");
                        var releasesToApply = releasesToApplyProp?.GetValue(updateInfo) as System.Collections.IList;

                        if (releasesToApply != null && releasesToApply.Count > 0)
                        {
                            var futureReleaseProp = updateInfo.GetType().GetProperty("FutureReleaseEntry");
                            var futureRelease = futureReleaseProp?.GetValue(updateInfo);

                            if (futureRelease != null)
                            {
                                var versionProp = futureRelease.GetType().GetProperty("Version");
                                var version = versionProp?.GetValue(futureRelease);
                                
                                Debug.WriteLine($"✅ Найдено обновление: {version}");
                                
                                return new UpdateInfo
                                {
                                    HasUpdate = true,
                                    Version = version?.ToString() ?? "Unknown",
                                    ReleaseNotes = "Доступна новая версия приложения",
                                    CurrentVersion = _currentVersion
                                };
                            }
                        }
                    }

                    Debug.WriteLine($"ℹ️ Обновлений нет");
                    return new UpdateInfo { HasUpdate = false, CurrentVersion = _currentVersion };
                }
                finally
                {
                    if (updateManager is IDisposable disposable)
                    {
                        disposable.Dispose();
                    }
                }
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
            if (_squirrelAssembly == null)
            {
                return false;
            }

            try
            {
                Debug.WriteLine($"📥 Начало загрузки обновления...");
                
                var updateManagerType = _squirrelAssembly.GetType("Clowd.Squirrel.UpdateManager");
                if (updateManagerType == null) throw new Exception("UpdateManager not found");

                var updateManager = Activator.CreateInstance(updateManagerType, _updateUrl);
                if (updateManager == null) throw new Exception("Failed to create UpdateManager");

                try
                {
                    var checkMethod = updateManagerType.GetMethod("CheckForUpdate");
                    if (checkMethod == null) throw new Exception("CheckForUpdate not found");

                    var checkTask = checkMethod.Invoke(updateManager, null) as Task;
                    if (checkTask == null) throw new Exception("CheckForUpdate returned null");

                    await checkTask;
                    
                    var resultProperty = checkTask.GetType().GetProperty("Result");
                    var updateInfo = resultProperty?.GetValue(checkTask);

                    if (updateInfo != null)
                    {
                        var releasesToApplyProp = updateInfo.GetType().GetProperty("ReleasesToApply");
                        var releasesToApply = releasesToApplyProp?.GetValue(updateInfo) as System.Collections.IList;

                        if (releasesToApply != null && releasesToApply.Count > 0)
                        {
                            Debug.WriteLine($"📦 Найдено релизов: {releasesToApply.Count}");
                            
                            var downloadMethod = updateManagerType.GetMethod("DownloadReleases");
                            if (downloadMethod != null)
                            {
                                Action<int>? progressAction = null;
                                if (progress != null)
                                {
                                    progressAction = p =>
                                    {
                                        progress.Report(p);
                                        Debug.WriteLine($"📥 Прогресс: {p}%");
                                    };
                                }

                                var downloadTask = downloadMethod.Invoke(updateManager, new object[] { releasesToApply, progressAction! }) as Task;
                                if (downloadTask != null)
                                {
                                    await downloadTask;
                                }
                            }
                            
                            Debug.WriteLine($"✅ Загрузка завершена, применение обновлений...");
                            
                            var applyMethod = updateManagerType.GetMethod("ApplyReleases");
                            if (applyMethod != null)
                            {
                                var applyTask = applyMethod.Invoke(updateManager, new object[] { updateInfo }) as Task;
                                if (applyTask != null)
                                {
                                    await applyTask;
                                }
                            }
                            
                            Debug.WriteLine($"✅ Обновление установлено!");
                            return true;
                        }
                    }

                    Debug.WriteLine($"ℹ️ Нет релизов для применения");
                    return false;
                }
                finally
                {
                    if (updateManager is IDisposable disposable)
                    {
                        disposable.Dispose();
                    }
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
                
                var assembly = Assembly.Load("Clowd.Squirrel");
                var type = assembly.GetType("Clowd.Squirrel.UpdateManager");
                var method = type?.GetMethod("RestartApp", BindingFlags.Public | BindingFlags.Static);
                method?.Invoke(null, null);
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
