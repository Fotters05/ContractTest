using System;
using System.Threading.Tasks;
using System.Windows;
using System.Windows.Input;
using Contract2512.Services;

namespace Contract2512.Views
{
    public partial class CheckUpdateWindow : Wpf.Ui.Controls.FluentWindow
    {
        private readonly AutoUpdateService _updateService;
        private UpdateInfo? _updateInfo;

        public CheckUpdateWindow(AutoUpdateService updateService)
        {
            InitializeComponent();
            _updateService = updateService;
            Loaded += CheckUpdateWindow_Loaded;
        }

        private async void CheckUpdateWindow_Loaded(object sender, RoutedEventArgs e)
        {
            await CheckForUpdatesAsync();
        }

        private async Task CheckForUpdatesAsync()
        {
            try
            {
                // Проверяем обновления
                StatusTextBlock.Text = "Проверка наличия обновлений...";
                DetailsTextBlock.Text = "Подключение к серверу GitHub...";
                
                await Task.Delay(500); // Небольшая задержка для визуального эффекта
                
                _updateInfo = await _updateService.CheckForUpdatesAsync();

                if (_updateInfo.HasUpdate)
                {
                    // Обновление найдено
                    IconTextBlock.Text = "✅";
                    StatusTextBlock.Text = "Доступно обновление!";
                    DetailsTextBlock.Text = $"Найдена новая версия {_updateInfo.Version}\nТекущая версия: {_updateInfo.CurrentVersion}";
                    ProgressBar.IsIndeterminate = false;
                    ProgressBar.Value = 100;
                    
                    await Task.Delay(1500);
                    
                    // Показываем окно обновления
                    DialogResult = true;
                    Close();
                    
                    // Открываем окно установки обновления
                    var updateWindow = new UpdateWindow(_updateInfo, _updateService);
                    updateWindow.ShowDialog();
                }
                else if (!string.IsNullOrEmpty(_updateInfo.Error))
                {
                    // Ошибка при проверке
                    IconTextBlock.Text = "⚠️";
                    StatusTextBlock.Text = "Ошибка проверки обновлений";
                    DetailsTextBlock.Text = $"Не удалось проверить обновления.\n{_updateInfo.Error}";
                    ProgressBar.IsIndeterminate = false;
                    ProgressBar.Visibility = Visibility.Collapsed;
                    
                    await Task.Delay(3000);
                    DialogResult = false;
                    Close();
                }
                else
                {
                    // Обновлений нет
                    IconTextBlock.Text = "✓";
                    StatusTextBlock.Text = "У вас последняя версия";
                    DetailsTextBlock.Text = $"Текущая версия: {_updateInfo.CurrentVersion}\nОбновления не требуются";
                    ProgressBar.IsIndeterminate = false;
                    ProgressBar.Value = 100;
                    
                    await Task.Delay(2000);
                    DialogResult = false;
                    Close();
                }
            }
            catch (Exception ex)
            {
                IconTextBlock.Text = "❌";
                StatusTextBlock.Text = "Ошибка";
                DetailsTextBlock.Text = $"Произошла ошибка: {ex.Message}";
                ProgressBar.IsIndeterminate = false;
                ProgressBar.Visibility = Visibility.Collapsed;
                
                await Task.Delay(3000);
                DialogResult = false;
                Close();
            }
        }

        private void TitleBar_MouseDown(object sender, MouseButtonEventArgs e)
        {
            if (e.ChangedButton == MouseButton.Left)
            {
                DragMove();
            }
        }
    }
}
