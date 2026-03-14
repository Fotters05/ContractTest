using System;
using System.Diagnostics;
using System.IO;
using System.Windows;

namespace Contract2512.Views
{
    public partial class ParserWindow : Window
    {
        private bool _isCompleted = false;

        public ParserWindow()
        {
            InitializeComponent();
            Loaded += ParserWindow_Loaded;
        }

        private async void ParserWindow_Loaded(object sender, RoutedEventArgs e)
        {
            await StartParsing();
        }

        private async System.Threading.Tasks.Task StartParsing()
        {
            try
            {
                // Определяем путь к парсеру в зависимости от режима запуска
                string parserPath = GetParserPath();
                
                // Проверяем существование папки
                if (!Directory.Exists(parserPath))
                {
                    StatusTextBlock.Text = "Ошибка: Папка парсера не найдена";
                    StatusTextBlock.Foreground = System.Windows.Media.Brushes.Red;
                    OutputTextBox.AppendText($"Папка не найдена: {parserPath}\n");
                    OutputTextBox.AppendText($"Текущая директория: {AppDomain.CurrentDomain.BaseDirectory}\n");
                    OutputTextBox.AppendText($"Проверьте, что папка parser_nodejs находится рядом с exe файлом\n");
                    CloseButton.IsEnabled = true;
                    return;
                }

                StatusTextBlock.Text = "Запуск парсера...";
                OutputTextBox.AppendText("🚀 Запуск импорта программ...\n");
                OutputTextBox.AppendText($"📁 Путь: {parserPath}\n");
                OutputTextBox.AppendText("=" + new string('=', 60) + "\n\n");

                var processInfo = new ProcessStartInfo
                {
                    FileName = "cmd.exe",
                    Arguments = $"/c cd /d \"{parserPath}\" && node index.js import",
                    UseShellExecute = false,
                    RedirectStandardOutput = true,
                    RedirectStandardError = true,
                    CreateNoWindow = true,
                    StandardOutputEncoding = System.Text.Encoding.UTF8,
                    StandardErrorEncoding = System.Text.Encoding.UTF8
                };

                using (var process = Process.Start(processInfo))
                {
                    if (process != null)
                    {
                        // Читаем вывод в реальном времени
                        process.OutputDataReceived += (s, e) =>
                        {
                            if (!string.IsNullOrEmpty(e.Data))
                            {
                                Dispatcher.Invoke(() =>
                                {
                                    OutputTextBox.AppendText(e.Data + "\n");
                                    OutputTextBox.ScrollToEnd();
                                });
                            }
                        };

                        process.ErrorDataReceived += (s, e) =>
                        {
                            if (!string.IsNullOrEmpty(e.Data))
                            {
                                Dispatcher.Invoke(() =>
                                {
                                    OutputTextBox.AppendText("❌ ERROR: " + e.Data + "\n");
                                    OutputTextBox.ScrollToEnd();
                                });
                            }
                        };

                        process.BeginOutputReadLine();
                        process.BeginErrorReadLine();

                        StatusTextBlock.Text = "Парсинг в процессе...";

                        await process.WaitForExitAsync();

                        _isCompleted = true;
                        CloseButton.IsEnabled = true;

                        if (process.ExitCode == 0)
                        {
                            StatusTextBlock.Text = "✅ Парсинг завершен успешно!";
                            StatusTextBlock.Foreground = System.Windows.Media.Brushes.Green;
                            
                            OutputTextBox.AppendText("\n" + new string('=', 60) + "\n");
                            OutputTextBox.AppendText("✅ ИМПОРТ ЗАВЕРШЕН УСПЕШНО!\n");
                            OutputTextBox.ScrollToEnd();

                            MessageBox.Show(
                                "Импорт программ завершен успешно!\n\nСписок программ будет обновлен.",
                                "Успех",
                                MessageBoxButton.OK,
                                MessageBoxImage.Information);
                        }
                        else
                        {
                            StatusTextBlock.Text = "⚠️ Парсинг завершен с ошибками";
                            StatusTextBlock.Foreground = System.Windows.Media.Brushes.Orange;
                            
                            OutputTextBox.AppendText("\n" + new string('=', 60) + "\n");
                            OutputTextBox.AppendText("⚠️ ИМПОРТ ЗАВЕРШЕН С ОШИБКАМИ\n");
                            OutputTextBox.ScrollToEnd();

                            MessageBox.Show(
                                "Парсинг завершен с ошибками.\n\nПроверьте лог выше.",
                                "Внимание",
                                MessageBoxButton.OK,
                                MessageBoxImage.Warning);
                        }
                    }
                }
            }
            catch (Exception ex)
            {
                _isCompleted = true;
                CloseButton.IsEnabled = true;
                
                StatusTextBlock.Text = "❌ Ошибка запуска парсера";
                StatusTextBlock.Foreground = System.Windows.Media.Brushes.Red;
                
                OutputTextBox.AppendText($"\n❌ КРИТИЧЕСКАЯ ОШИБКА:\n{ex.Message}\n");
                OutputTextBox.ScrollToEnd();

                MessageBox.Show(
                    $"Ошибка запуска парсера:\n\n{ex.Message}\n\nУбедитесь что:\n" +
                    "1. Node.js установлен\n" +
                    "2. Выполнена команда 'npm install' в папке парсера\n" +
                    "3. Путь к парсеру правильный",
                    "Ошибка",
                    MessageBoxButton.OK,
                    MessageBoxImage.Error);
            }
        }

        private void CloseButton_Click(object sender, RoutedEventArgs e)
        {
            DialogResult = _isCompleted;
            Close();
        }

        /// <summary>
        /// Определяет путь к папке парсера в зависимости от режима запуска
        /// </summary>
        private string GetParserPath()
        {
            // Получаем директорию exe файла
            string exeDir = AppDomain.CurrentDomain.BaseDirectory;
            
            // Сначала проверяем путь для опубликованного приложения (parser_nodejs рядом с exe)
            string publishedPath = Path.Combine(exeDir, "parser_nodejs");
            
            if (Directory.Exists(publishedPath))
            {
                return publishedPath;
            }
            
            // Если не найдено, пробуем путь для режима разработки (Debug/Release)
            string projectRoot = Path.GetFullPath(Path.Combine(exeDir, @"..\..\..\"));
            string devPath = Path.Combine(projectRoot, "parser_nodejs");
            
            return devPath;
        }

        protected override void OnClosing(System.ComponentModel.CancelEventArgs e)
        {
            if (!_isCompleted)
            {
                var result = MessageBox.Show(
                    "Парсинг еще не завершен. Закрыть окно?",
                    "Подтверждение",
                    MessageBoxButton.YesNo,
                    MessageBoxImage.Question);

                if (result == MessageBoxResult.No)
                {
                    e.Cancel = true;
                }
            }

            base.OnClosing(e);
        }
    }
}
