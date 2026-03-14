using System;
using System.Windows;
using Contract2512.Services;

namespace Contract2512.Views
{
    public partial class UpdateWindow : Window
    {
        private readonly UpdateInfo _updateInfo;
        private readonly AutoUpdateService _updateService;

        public UpdateWindow(UpdateInfo updateInfo, AutoUpdateService updateService)
        {
            InitializeComponent();
            
            _updateInfo = updateInfo;
            _updateService = updateService;

            // Заполняем информацию
            VersionText.Text = $"Доступна версия: {updateInfo.Version}";
            DateText.Text = $"Текущая версия: {updateInfo.CurrentVersion}";
            ReleaseNotesText.Text = updateInfo.ReleaseNotes;
        }

        private async void UpdateButton_Click(object sender, RoutedEventArgs e)
        {
            try
            {
                // Отключаем кнопки
                UpdateButton.IsEnabled = false;
                LaterButton.IsEnabled = false;

                // Показываем прогресс
                ProgressPanel.Visibility = Visibility.Visible;

                // Прогресс скачивания
                var progress = new Progress<int>(percent =>
                {
                    ProgressBar.Value = percent;
                    ProgressText.Text = $"Скачивание обновления... {percent}%";
                });

                // Скачиваем и устанавливаем через Squirrel
                var success = await _updateService.DownloadAndInstallUpdateAsync(progress);

                if (success)
                {
                    ProgressText.Text = "Обновление установлено! Перезапуск приложения...";
                    await System.Threading.Tasks.Task.Delay(1000);
                    
                    // Перезапускаем приложение
                    AutoUpdateService.RestartApp();
                }
                else
                {
                    MessageBox.Show(
                        "Не удалось установить обновление. Попробуйте позже.",
                        "Ошибка",
                        MessageBoxButton.OK,
                        MessageBoxImage.Error
                    );

                    UpdateButton.IsEnabled = true;
                    LaterButton.IsEnabled = true;
                    ProgressPanel.Visibility = Visibility.Collapsed;
                }
            }
            catch (Exception ex)
            {
                MessageBox.Show(
                    $"Ошибка при обновлении: {ex.Message}",
                    "Ошибка",
                    MessageBoxButton.OK,
                    MessageBoxImage.Error
                );

                UpdateButton.IsEnabled = true;
                LaterButton.IsEnabled = true;
                ProgressPanel.Visibility = Visibility.Collapsed;
            }
        }

        private void LaterButton_Click(object sender, RoutedEventArgs e)
        {
            DialogResult = false;
            Close();
        }
    }
}
