using System;
using System.Windows;
using System.Windows.Input;
using Contract2512.Services;

namespace Contract2512.Views
{
    public partial class UpdateWindow : Wpf.Ui.Controls.FluentWindow
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
            ReleaseNotesText.Text = updateInfo.ReleaseNotes;
        }

        private void TitleBar_MouseDown(object sender, MouseButtonEventArgs e)
        {
            if (e.ChangedButton == MouseButton.Left)
            {
                DragMove();
            }
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
                ProgressBar.IsIndeterminate = true; // Анимация загрузки
                ProgressText.Text = "Скачивание обновления...";

                // Скачиваем и устанавливаем через Squirrel
                var success = await _updateService.DownloadAndInstallUpdateAsync();

                if (success)
                {
                    ProgressBar.IsIndeterminate = false;
                    ProgressBar.Value = 100;
                    ProgressText.Text = "Обновление установлено! Перезапуск...";
                    await System.Threading.Tasks.Task.Delay(1500);
                    
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
