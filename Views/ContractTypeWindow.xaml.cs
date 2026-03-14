using System;
using System.IO;
using System.Windows;
using System.Windows.Input;
using Contract2512.Models;
using Contract2512.Services;
using Microsoft.Win32;
using Wpf.Ui.Controls;
using MessageBox = System.Windows.MessageBox;
using MessageBoxButton = System.Windows.MessageBoxButton;
using MessageBoxImage = System.Windows.MessageBoxImage;

namespace Contract2512.Views
{
    public partial class ContractTypeWindow : FluentWindow
    {
        private ContractType _contractType;
        private bool _isEditMode;

        public ContractTypeWindow(ContractType contractType = null)
        {
            InitializeComponent();
            _contractType = contractType;
            _isEditMode = contractType != null;
            
            if (_isEditMode)
            {
                LoadData();
            }
        }

        private void LoadData()
        {
            if (_contractType != null)
            {
                NameTextBox.Text = _contractType.Name;
                FilePathTextBox.Text = _contractType.FilePath;
            }
        }

        private void BrowseFileButton_Click(object sender, RoutedEventArgs e)
        {
            var openFileDialog = new OpenFileDialog
            {
                Filter = "Word документы (*.docx)|*.docx|Все файлы (*.*)|*.*",
                Title = "Выберите файл договора"
            };

            if (openFileDialog.ShowDialog() == true)
            {
                FilePathTextBox.Text = openFileDialog.FileName;
            }
        }

        private void SaveButton_Click(object sender, RoutedEventArgs e)
        {
            if (string.IsNullOrWhiteSpace(NameTextBox.Text))
            {
                MessageBox.Show("Введите название типа договора!", "Ошибка", MessageBoxButton.OK, MessageBoxImage.Warning);
                return;
            }

            if (string.IsNullOrWhiteSpace(FilePathTextBox.Text))
            {
                MessageBox.Show("Выберите путь к файлу договора!", "Ошибка", MessageBoxButton.OK, MessageBoxImage.Warning);
                return;
            }

            if (!File.Exists(FilePathTextBox.Text))
            {
                MessageBox.Show("Указанный файл не существует!", "Ошибка", MessageBoxButton.OK, MessageBoxImage.Warning);
                return;
            }

            try
            {
                using (var db = new AppDbContext())
                {
                    if (_isEditMode && _contractType != null)
                    {
                        // Редактирование существующего типа договора
                        var contractType = db.ContractTypes.Find(_contractType.Id);
                        if (contractType != null)
                        {
                            contractType.Name = NameTextBox.Text.Trim();
                            contractType.FilePath = FilePathTextBox.Text.Trim();
                            db.SaveChanges();
                            MessageBox.Show("Тип договора успешно обновлен!", "Успех", MessageBoxButton.OK, MessageBoxImage.Information);
                        }
                    }
                    else
                    {
                        // Создание нового типа договора
                        var contractType = new ContractType
                        {
                            Name = NameTextBox.Text.Trim(),
                            FilePath = FilePathTextBox.Text.Trim()
                        };
                        db.ContractTypes.Add(contractType);
                        db.SaveChanges();
                        MessageBox.Show("Тип договора успешно создан!", "Успех", MessageBoxButton.OK, MessageBoxImage.Information);
                    }
                }

                DialogResult = true;
                Close();
            }
            catch (Exception ex)
            {
                MessageBox.Show(
                    $"Ошибка при сохранении типа договора: {ex.Message}",
                    "Ошибка",
                    MessageBoxButton.OK,
                    MessageBoxImage.Error);
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

        private void TitleBar_MouseDown(object sender, MouseButtonEventArgs e)
        {
            if (e.ChangedButton == MouseButton.Left)
            {
                DragMove();
            }
        }
    }
}


