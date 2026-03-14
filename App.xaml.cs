using System.Configuration;
using System.Data;
using System.Diagnostics;
using System.IO;
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
            
            // Обрабатываем события Squirrel через Update.exe
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
        /// Обрабатывает события Squirrel (установка, обновление, удаление)
        /// </summary>
        private void HandleSquirrelEvents()
        {
            try
            {
                var appDir = AppDomain.CurrentDomain.BaseDirectory;
                var updateExe = Path.Combine(appDir, "..", "Update.exe");
                
                if (!File.Exists(updateExe))
                {
                    Debug.WriteLine("⚠️ Update.exe не найден, пропускаем обработку Squirrel событий");
                    return;
                }

                var args = Environment.GetCommandLineArgs();
                
                // Проверяем аргументы командной строки для Squirrel событий
                if (args.Length > 1)
                {
                    var arg = args[1];
                    
                    if (arg.Contains("squirrel-install") || arg.Contains("squirrel-updated"))
                    {
                        // Создаем ярлыки при установке/обновлении
                        Process.Start(updateExe, "--createShortcut Contract2512.exe");
                        Shutdown();
                        return;
                    }
                    else if (arg.Contains("squirrel-uninstall"))
                    {
                        // Удаляем ярлыки при удалении
                        Process.Start(updateExe, "--removeShortcut Contract2512.exe");
                        Shutdown();
                        return;
                    }
                }
            }
            catch (Exception ex)
            {
                Debug.WriteLine($"❌ Ошибка обработки Squirrel событий: {ex.Message}");
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
                
                var updateService = new AutoUpdateService(updateUrl);
                var updateInfo = await updateService.CheckForUpdatesAsync();

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
            }
        }
    }
}
