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

            // Проверяем обновления и показываем главное окно
            await CheckForUpdatesAsync();
            
            // Открываем главное окно приложения
            var mainWindow = new MainWindow();
            mainWindow.Show();
        }

        /// <summary>
        /// Обрабатывает события Squirrel через Update.exe
        /// </summary>
        private void HandleSquirrelEvents()
        {
            try
            {
                // Проверяем, запущено ли приложение из Squirrel установки
                var appDir = AppDomain.CurrentDomain.BaseDirectory;
                var parentDir = Directory.GetParent(appDir)?.FullName;
                if (parentDir == null) return;

                var updateExe = Path.Combine(parentDir, "Update.exe");
                if (!File.Exists(updateExe))
                {
                    Debug.WriteLine("⚠️ Update.exe не найден, пропускаем обработку Squirrel событий");
                    return;
                }

                Debug.WriteLine("✅ Приложение запущено из Squirrel установки");

                // Squirrel автоматически обрабатывает события через Update.exe
                // Нам не нужно вручную вызывать HandleEvents
                // Update.exe сам создает/удаляет ярлыки при установке/удалении
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
                var githubRepo = EnvConfigService.Get("GITHUB_REPO") ?? "ContractTest";
                var githubToken = EnvConfigService.Get("GITHUB_TOKEN");
                
                // Для приватных репозиториев нужно использовать GitHub API с токеном
                // Формат: https://TOKEN@github.com/owner/repo/releases/latest/download
                string updateUrl;
                if (!string.IsNullOrEmpty(githubToken))
                {
                    // Используем токен для доступа к приватному репозиторию
                    updateUrl = $"https://{githubToken}@github.com/{githubOwner}/{githubRepo}/releases/latest/download";
                    System.Diagnostics.Debug.WriteLine($"🔍 Проверка обновлений (приватный репозиторий)");
                }
                else
                {
                    // Публичный репозиторий
                    updateUrl = $"https://github.com/{githubOwner}/{githubRepo}/releases/latest/download";
                    System.Diagnostics.Debug.WriteLine($"🔍 Проверка обновлений (публичный репозиторий)");
                }
                
                System.Diagnostics.Debug.WriteLine($"🔍 URL: {updateUrl.Replace(githubToken ?? "", "***")}");
                
                var updateService = new AutoUpdateService(updateUrl);
                
                // Показываем окно проверки обновлений
                Dispatcher.Invoke(() =>
                {
                    var checkWindow = new CheckUpdateWindow(updateService);
                    checkWindow.ShowDialog();
                });
            }
            catch (Exception ex)
            {
                // Ошибки обновления не должны ломать приложение
                System.Diagnostics.Debug.WriteLine($"❌ Ошибка проверки обновлений: {ex.Message}");
            }
        }
    }
}
