using System.Configuration;
using System.Data;
using System.Diagnostics;
using System.IO;
using System.Linq;
using System.Reflection;
using System.Windows;
using Contract2512.Services;
using Contract2512.Views;

namespace Contract2512
{
    /// <summary>
    /// Interaction logic for App.xaml
    /// </summary>
    public partial class App : Application
    {
        protected override async void OnStartup(StartupEventArgs e)
        {
            base.OnStartup(e);
            
            // Обрабатываем события Squirrel через рефлексию
            HandleSquirrelEvents();
            
            // Проверяем и устанавливаем npm пакеты для парсера (если нужно)
            await CheckAndInstallNodePackagesAsync();
            
            // Проверяем наличие настроек подключения к БД
            if (!DbConnectionStringProvider.HasConnectionString())
            {
                // Если настроек нет, показываем окно настроек БД
                var settingsWindow = new DatabaseSettingsWindow();
                var result = settingsWindow.ShowDialog();
                
                // Если пользователь закрыл окно без сохранения настроек, закрываем приложение
                if (result != true)
                {
                    MessageBox.Show(
                        "Для работы приложения необходимо настроить подключение к базе данных.",
                        "Настройки не сохранены",
                        MessageBoxButton.OK,
                        MessageBoxImage.Warning
                    );
                    Shutdown();
                    return;
                }
            }

            // Проверяем обновления (в фоновом режиме, не блокируем запуск)
            _ = CheckForUpdatesAsync();
        }

        /// <summary>
        /// Обрабатывает события Squirrel через рефлексию
        /// </summary>
        private void HandleSquirrelEvents()
        {
            try
            {
                var appDir = AppDomain.CurrentDomain.BaseDirectory;
                var squirrelDll = Path.Combine(appDir, "Clowd.Squirrel.dll");
                
                if (!File.Exists(squirrelDll))
                {
                    Debug.WriteLine("⚠️ Clowd.Squirrel.dll не найден, пропускаем обработку Squirrel событий");
                    return;
                }

                var assembly = Assembly.LoadFrom(squirrelDll);
                var squirrelAwareAppType = assembly.GetType("Clowd.Squirrel.SquirrelAwareApp");
                
                if (squirrelAwareAppType == null)
                {
                    Debug.WriteLine("⚠️ SquirrelAwareApp не найден");
                    return;
                }

                var handleEventsMethod = squirrelAwareAppType.GetMethod("HandleEvents", BindingFlags.Public | BindingFlags.Static);
                
                if (handleEventsMethod == null)
                {
                    Debug.WriteLine("⚠️ HandleEvents не найден");
                    return;
                }

                // Создаем делегаты для событий
                var actionType = typeof(Action<>).MakeGenericType(assembly.GetType("NuGet.Versioning.SemanticVersion")!);
                
                Delegate createShortcut = Delegate.CreateDelegate(actionType, this, GetType().GetMethod(nameof(CreateShortcut), BindingFlags.NonPublic | BindingFlags.Instance)!);
                Delegate removeShortcut = Delegate.CreateDelegate(actionType, this, GetType().GetMethod(nameof(RemoveShortcut), BindingFlags.NonPublic | BindingFlags.Instance)!);

                handleEventsMethod.Invoke(null, new object?[] { createShortcut, createShortcut, removeShortcut, null, null });
                
                Debug.WriteLine("✅ Squirrel события обработаны");
            }
            catch (Exception ex)
            {
                Debug.WriteLine($"❌ Ошибка обработки Squirrel событий: {ex.Message}");
            }
        }

        private void CreateShortcut(object version)
        {
            try
            {
                var appDir = AppDomain.CurrentDomain.BaseDirectory;
                var squirrelDll = Path.Combine(appDir, "Clowd.Squirrel.dll");
                var assembly = Assembly.LoadFrom(squirrelDll);
                var squirrelAwareAppType = assembly.GetType("Clowd.Squirrel.SquirrelAwareApp");
                var method = squirrelAwareAppType?.GetMethod("CreateShortcutForThisExe", BindingFlags.Public | BindingFlags.Static);
                method?.Invoke(null, null);
                Debug.WriteLine("✅ Ярлык создан");
            }
            catch (Exception ex)
            {
                Debug.WriteLine($"❌ Ошибка создания ярлыка: {ex.Message}");
            }
        }

        private void RemoveShortcut(object version)
        {
            try
            {
                var appDir = AppDomain.CurrentDomain.BaseDirectory;
                var squirrelDll = Path.Combine(appDir, "Clowd.Squirrel.dll");
                var assembly = Assembly.LoadFrom(squirrelDll);
                var squirrelAwareAppType = assembly.GetType("Clowd.Squirrel.SquirrelAwareApp");
                var method = squirrelAwareAppType?.GetMethod("RemoveShortcutForThisExe", BindingFlags.Public | BindingFlags.Static);
                method?.Invoke(null, null);
                Debug.WriteLine("✅ Ярлык удален");
            }
            catch (Exception ex)
            {
                Debug.WriteLine($"❌ Ошибка удаления ярлыка: {ex.Message}");
            }
        }

        /// <summary>
        /// Проверяет наличие node_modules и устанавливает npm пакеты если нужно
        /// </summary>
        private async System.Threading.Tasks.Task CheckAndInstallNodePackagesAsync()
        {
            try
            {
                var nodePackageService = new NodePackageService();
                
                // Проверяем наличие node_modules
                if (!nodePackageService.IsNodeModulesInstalled())
                {
                    System.Diagnostics.Debug.WriteLine("📦 node_modules not found, starting npm install...");
                    
                    // Показываем окно установки
                    var installWindow = new NpmInstallWindow();
                    installWindow.ShowDialog();
                    
                    if (!installWindow.InstallSuccess)
                    {
                        System.Diagnostics.Debug.WriteLine("⚠️ npm install failed or was cancelled");
                        
                        var result = MessageBox.Show(
                            "Parser dependencies were not installed.\n\n" +
                            "The parser will not work without these dependencies.\n\n" +
                            "Do you want to continue anyway?",
                            "Warning",
                            MessageBoxButton.YesNo,
                            MessageBoxImage.Warning
                        );
                        
                        if (result == MessageBoxResult.No)
                        {
                            Shutdown();
                            return;
                        }
                    }
                    else
                    {
                        System.Diagnostics.Debug.WriteLine("✅ npm install completed successfully");
                    }
                }
                else
                {
                    System.Diagnostics.Debug.WriteLine("✅ node_modules already installed");
                }
            }
            catch (Exception ex)
            {
                System.Diagnostics.Debug.WriteLine($"❌ Error checking node packages: {ex.Message}");
                // Не блокируем запуск приложения из-за ошибок с npm
            }
        }

        /// <summary>
        /// Проверяет наличие обновлений через Squirrel
        /// </summary>
        private async System.Threading.Tasks.Task CheckForUpdatesAsync()
        {
            try
            {
                // Читаем настройки GitHub из .env
                var githubOwner = EnvConfigService.Get("GITHUB_OWNER") ?? "Fotters05";
                var githubRepo = EnvConfigService.Get("GITHUB_REPO") ?? "contracts2512";
                
                // URL для Squirrel - указываем на папку с релизами на GitHub
                // Squirrel будет искать файл RELEASES по этому URL
                string updateUrl = $"https://github.com/{githubOwner}/{githubRepo}/releases/latest/download";
                
                System.Diagnostics.Debug.WriteLine($"🔍 Проверка обновлений по URL: {updateUrl}");
                
                // ВРЕМЕННО: показываем MessageBox для отладки
                MessageBox.Show($"Начинаем проверку обновлений...\nURL: {updateUrl}", "Debug", MessageBoxButton.OK, MessageBoxImage.Information);
                
                var updateService = new AutoUpdateService(updateUrl);
                var updateInfo = await updateService.CheckForUpdatesAsync();

                // ВРЕМЕННО: показываем результат
                MessageBox.Show($"Результат проверки:\nHasUpdate: {updateInfo.HasUpdate}\nVersion: {updateInfo.Version}\nError: {updateInfo.Error}", "Debug", MessageBoxButton.OK, MessageBoxImage.Information);

                if (updateInfo.HasUpdate)
                {
                    System.Diagnostics.Debug.WriteLine($"✅ Найдено обновление: {updateInfo.Version}");
                    
                    // Показываем окно обновления в UI потоке
                    Dispatcher.Invoke(() =>
                    {
                        var updateWindow = new UpdateWindow(updateInfo, updateService);
                        updateWindow.ShowDialog();
                    });
                }
                else
                {
                    System.Diagnostics.Debug.WriteLine($"ℹ️ Обновлений нет. Текущая версия: {updateInfo.CurrentVersion}");
                    if (!string.IsNullOrEmpty(updateInfo.Error))
                    {
                        System.Diagnostics.Debug.WriteLine($"⚠️ Ошибка: {updateInfo.Error}");
                    }
                }
            }
            catch (Exception ex)
            {
                // Ошибки обновления не должны ломать приложение
                System.Diagnostics.Debug.WriteLine($"❌ Ошибка проверки обновлений: {ex.Message}");
                
                // ВРЕМЕННО: показываем ошибку
                MessageBox.Show($"Ошибка проверки обновлений:\n{ex.Message}\n\nStack:\n{ex.StackTrace}", "Debug Error", MessageBoxButton.OK, MessageBoxImage.Error);
            }
        }
    }
}
