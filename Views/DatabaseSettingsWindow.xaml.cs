using System;
using System.Threading.Tasks;
using System.Windows;
using System.Windows.Input;
using Contract2512.Services;
using Npgsql;

namespace Contract2512.Views;

public partial class DatabaseSettingsWindow
{
    public string EnvPathText { get; }

    public DatabaseSettingsWindow()
    {
        InitializeComponent();
        DataContext = this;

        var envPath = EnvConfigService.GetEnvFilePath();
        EnvPathText = $"Файл настроек: {envPath}";

        ConnectionStringTextBox.Text = EnvConfigService.Get(EnvConfigService.ConnectionStringKey)
            ?? DbConnectionStringProvider.GetConnectionString();
    }

    private void TitleBar_MouseDown(object sender, MouseButtonEventArgs e)
    {
        if (e.LeftButton == MouseButtonState.Pressed)
            DragMove();
    }

    private async void ConnectButton_Click(object sender, RoutedEventArgs e)
    {
        var cs = (ConnectionStringTextBox.Text ?? string.Empty).Trim();
        if (string.IsNullOrWhiteSpace(cs))
        {
            SetStatus("Введите строку подключения.", isError: true);
            return;
        }

        ConnectButton.IsEnabled = false;
        try
        {
            SetStatus("Проверяю подключение...", isError: false);

            var ok = await TestConnectionAsync(cs);
            if (!ok)
                return;

            EnvConfigService.Set(EnvConfigService.ConnectionStringKey, cs);
            SetStatus("Подключение успешно. Настройки сохранены.", isError: false);

            DialogResult = true;
            Close();
        }
        finally
        {
            ConnectButton.IsEnabled = true;
        }
    }

    private void CloseButton_Click(object sender, RoutedEventArgs e)
    {
        Close();
    }

    private async Task<bool> TestConnectionAsync(string connectionString)
    {
        try
        {
            await using var conn = new NpgsqlConnection(connectionString);
            await conn.OpenAsync();
            await conn.CloseAsync();
            return true;
        }
        catch (Exception ex)
        {
            SetStatus($"Ошибка подключения: {ex.Message}", isError: true);
            return false;
        }
    }

    private void SetStatus(string text, bool isError)
    {
        StatusTextBlock.Text = text;
        StatusTextBlock.Foreground = isError
            ? new System.Windows.Media.SolidColorBrush(System.Windows.Media.Color.FromRgb(239, 68, 68)) // #EF4444
            : (System.Windows.Media.Brush)FindResource("TextSecondary");
    }
}
