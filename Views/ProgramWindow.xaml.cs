using System;
using System.IO;
using System.Linq;
using System.Windows;
using System.Windows.Media.Imaging;
using Microsoft.Win32;
using Contract2512.Models;
using Contract2512.Services;
using Wpf.Ui.Controls;
using MessageBox = System.Windows.MessageBox;
using MessageBoxButton = System.Windows.MessageBoxButton;
using MessageBoxImage = System.Windows.MessageBoxImage;

namespace Contract2512.Views
{
    public partial class ProgramWindow : FluentWindow
    {
        private LearningProgram _program;

        public ProgramWindow(LearningProgram program = null)
        {
            InitializeComponent();
            _program = program;
            LoadData();
            
            if (_program != null)
            {
                LoadProgramData();
            }
        }

        private void LoadData()
        {
            using (var db = new AppDbContext())
            {
                ProgramViewComboBox.ItemsSource = db.ProgramViews.ToList();
            }

            // Добавляем обработчик для открытия ComboBox при клике на поле
            ProgramViewComboBox.PreviewMouseLeftButtonDown += ComboBox_PreviewMouseLeftButtonDown;
        }

        private void LoadProgramData()
        {
            if (_program == null) return;

            NameTextBox.Text = _program.Name;
            FormatTextBox.Text = _program.Format;
            HoursTextBox.Text = _program.Hours.ToString();
            LessonsCountTextBox.Text = _program.LessonsCount.ToString();
            PriceTextBox.Text = _program.Price.ToString();

            using (var db = new AppDbContext())
            {
                var programView = db.ProgramViews.Find(_program.ProgramViewId);
                if (programView != null)
                {
                    ProgramViewComboBox.SelectedItem = ProgramViewComboBox.ItemsSource.Cast<ProgramView>()
                        .FirstOrDefault(pv => pv.Id == programView.Id);
                }
            }

            if (!string.IsNullOrEmpty(_program.Image))
            {
                ImageTextBox.Text = _program.Image;
                LoadPreviewImage(_program.Image);
            }
            
            // Добавляем обработчик изменения текста для автоматической загрузки превью при вводе URL
            ImageTextBox.TextChanged += ImageTextBox_TextChanged;
        }

        private void ImageTextBox_TextChanged(object sender, System.Windows.Controls.TextChangedEventArgs e)
        {
            // Автоматически загружаем превью при изменении текста (для URL)
            if (!string.IsNullOrWhiteSpace(ImageTextBox.Text))
            {
                LoadPreviewImage(ImageTextBox.Text);
            }
            else
            {
                PreviewImage.Source = null;
            }
        }

        private void BrowseImageButton_Click(object sender, RoutedEventArgs e)
        {
            var openFileDialog = new OpenFileDialog
            {
                Filter = "Изображения|*.jpg;*.jpeg;*.png;*.bmp|Все файлы|*.*",
                Title = "Выберите изображение"
            };

            if (openFileDialog.ShowDialog() == true)
            {
                ImageTextBox.Text = openFileDialog.FileName;
                LoadPreviewImage(openFileDialog.FileName);
            }
        }

        private void LoadPreviewImage(string imagePath)
        {
            try
            {
                if (string.IsNullOrWhiteSpace(imagePath))
                {
                    PreviewImage.Source = null;
                    return;
                }

                var bitmap = new BitmapImage();
                bitmap.BeginInit();
                
                // Проверяем, является ли это URL или локальным путем
                if (Uri.TryCreate(imagePath, UriKind.Absolute, out Uri uri) && 
                    (uri.Scheme == Uri.UriSchemeHttp || uri.Scheme == Uri.UriSchemeHttps))
                {
                    // Это URL - загружаем по ссылке
                    bitmap.UriSource = uri;
                }
                else if (File.Exists(imagePath))
                {
                    // Это локальный путь
                    bitmap.UriSource = new Uri(imagePath, UriKind.Absolute);
                }
                else
                {
                    PreviewImage.Source = null;
                    return;
                }
                
                bitmap.CacheOption = BitmapCacheOption.OnLoad;
                bitmap.EndInit();
                PreviewImage.Source = bitmap;
            }
            catch
            {
                PreviewImage.Source = null;
            }
        }

        private void SaveButton_Click(object sender, RoutedEventArgs e)
        {
            if (string.IsNullOrWhiteSpace(NameTextBox.Text))
            {
                MessageBox.Show("Введите название программы!", "Ошибка", MessageBoxButton.OK, MessageBoxImage.Warning);
                return;
            }

            if (string.IsNullOrWhiteSpace(FormatTextBox.Text))
            {
                MessageBox.Show("Введите формат программы!", "Ошибка", MessageBoxButton.OK, MessageBoxImage.Warning);
                return;
            }

            if (ProgramViewComboBox.SelectedItem == null)
            {
                MessageBox.Show("Выберите вид программы!", "Ошибка", MessageBoxButton.OK, MessageBoxImage.Warning);
                return;
            }

            if (!int.TryParse(HoursTextBox.Text, out int hours) || hours < 0)
            {
                MessageBox.Show("Введите корректное количество часов!", "Ошибка", MessageBoxButton.OK, MessageBoxImage.Warning);
                return;
            }

            if (!int.TryParse(LessonsCountTextBox.Text, out int lessonsCount) || lessonsCount < 0)
            {
                MessageBox.Show("Введите корректное количество уроков!", "Ошибка", MessageBoxButton.OK, MessageBoxImage.Warning);
                return;
            }

            if (!decimal.TryParse(PriceTextBox.Text, out decimal price) || price < 0)
            {
                MessageBox.Show("Введите корректную цену!", "Ошибка", MessageBoxButton.OK, MessageBoxImage.Warning);
                return;
            }

            try
            {
                using (var db = new AppDbContext())
                {
                    if (_program == null)
                    {
                        // Создаем новую программу
                        _program = new LearningProgram
                        {
                            Name = NameTextBox.Text.Trim(),
                            Format = FormatTextBox.Text.Trim(),
                            ProgramViewId = ((ProgramView)ProgramViewComboBox.SelectedItem).Id,
                            Hours = hours,
                            LessonsCount = lessonsCount,
                            Price = price,
                            Image = ImageTextBox.Text.Trim(),
                            CreatedAt = DateTime.Now
                        };
                        db.LearningPrograms.Add(_program);
                    }
                    else
                    {
                        // Обновляем существующую программу
                        var program = db.LearningPrograms.Find(_program.Id);
                        if (program != null)
                        {
                            program.Name = NameTextBox.Text.Trim();
                            program.Format = FormatTextBox.Text.Trim();
                            program.ProgramViewId = ((ProgramView)ProgramViewComboBox.SelectedItem).Id;
                            program.Hours = hours;
                            program.LessonsCount = lessonsCount;
                            program.Price = price;
                            program.Image = ImageTextBox.Text.Trim();
                        }
                    }

                    db.SaveChanges();
                    DialogResult = true;
                    Close();
                }
            }
            catch (Exception ex)
            {
                MessageBox.Show($"Ошибка при сохранении: {ex.Message}", "Ошибка", MessageBoxButton.OK, MessageBoxImage.Error);
            }
        }

        private void CancelButton_Click(object sender, RoutedEventArgs e)
        {
            DialogResult = false;
            Close();
        }

        private void MinimizeButton_Click(object sender, RoutedEventArgs e)
        {
            WindowState = WindowState.Minimized;
        }

        private void MaximizeButton_Click(object sender, RoutedEventArgs e)
        {
            if (WindowState == WindowState.Maximized)
            {
                WindowState = WindowState.Normal;
                MaximizeRestoreButton.Content = "□";
            }
            else
            {
                WindowState = WindowState.Maximized;
                MaximizeRestoreButton.Content = "❐";
            }
        }

        private void CloseButton_Click(object sender, RoutedEventArgs e)
        {
            DialogResult = false;
            Close();
        }

        private void TitleBar_MouseDown(object sender, System.Windows.Input.MouseButtonEventArgs e)
        {
            if (e.ChangedButton == System.Windows.Input.MouseButton.Left)
            {
                DragMove();
            }
        }

        // Обработчик для открытия ComboBox при клике на любую часть поля
        private void ComboBox_PreviewMouseLeftButtonDown(object sender, System.Windows.Input.MouseButtonEventArgs e)
        {
            if (sender is System.Windows.Controls.ComboBox comboBox)
            {
                // Если ComboBox закрыт, открываем его
                if (!comboBox.IsDropDownOpen)
                {
                    comboBox.IsDropDownOpen = true;
                    e.Handled = true;
                }
            }
        }

    }
}

