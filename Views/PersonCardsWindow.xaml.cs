using System;
using System.Collections.Generic;
using System.IO;
using System.Linq;
using System.Windows;
using Contract2512.Models;
using Contract2512.Services;
using Wpf.Ui.Controls;
using MessageBox = System.Windows.MessageBox;
using MessageBoxButton = System.Windows.MessageBoxButton;
using MessageBoxImage = System.Windows.MessageBoxImage;

namespace Contract2512.Views
{
    public partial class PersonCardsWindow : FluentWindow
    {
        private Person _person;

        public PersonCardsWindow(Person person)
        {
            InitializeComponent();
            _person = person;
            TitleTextBlock.Text = $"Личные карточки - {person.FullName}";
            LoadCards();
        }

        private void LoadCards()
        {
            try
            {
                // Путь к папке с личными карточками
                string cardsFolder = Path.Combine(Environment.GetFolderPath(Environment.SpecialFolder.MyDocuments), "Личные карточки");

                if (!Directory.Exists(cardsFolder))
                {
                    MessageBox.Show(
                        "Папка с личными карточками не найдена!",
                        "Внимание",
                        MessageBoxButton.OK,
                        MessageBoxImage.Warning);
                    return;
                }

                // Ищем все личные карточки для выбранного клиента
                var cardFiles = Directory.GetFiles(cardsFolder, $"*{_person.LastName}*.docx")
                    .Select(f => new CardFileInfo
                    {
                        FilePath = f,
                        FileName = Path.GetFileName(f),
                        ContractNumber = ExtractContractNumber(Path.GetFileName(f)),
                        CreatedDate = File.GetLastWriteTime(f)
                    })
                    .OrderByDescending(c => c.CreatedDate)
                    .ToList();

                if (cardFiles.Count == 0)
                {
                    MessageBox.Show(
                        $"Личные карточки для {_person.FullName} не найдены!",
                        "Внимание",
                        MessageBoxButton.OK,
                        MessageBoxImage.Information);
                }

                CardsDataGrid.ItemsSource = cardFiles;
            }
            catch (Exception ex)
            {
                MessageBox.Show(
                    $"Ошибка при загрузке личных карточек: {ex.Message}",
                    "Ошибка",
                    MessageBoxButton.OK,
                    MessageBoxImage.Error);
            }
        }

        private string ExtractContractNumber(string fileName)
        {
            // Извлекаем номер договора из имени файла
            // Формат: "Личная карточка_ДОП-01 04.12.25_Фамилия.docx"
            try
            {
                var parts = fileName.Split('_');
                if (parts.Length >= 2)
                {
                    return parts[1]; // Номер договора
                }
            }
            catch
            {
                // Игнорируем ошибки
            }
            return "";
        }

        private void OpenCardButton_Click(object sender, RoutedEventArgs e)
        {
            if (CardsDataGrid.SelectedItem is CardFileInfo selectedCard)
            {
                try
                {
                    var wordService = new WordDocumentService();
                    wordService.OpenDocument(selectedCard.FilePath);
                }
                catch (Exception ex)
                {
                    MessageBox.Show(
                        $"Ошибка при открытии личной карточки: {ex.Message}",
                        "Ошибка",
                        MessageBoxButton.OK,
                        MessageBoxImage.Error);
                }
            }
            else
            {
                MessageBox.Show(
                    "Выберите личную карточку для открытия!",
                    "Внимание",
                    MessageBoxButton.OK,
                    MessageBoxImage.Warning);
            }
        }

        private void CardsDataGrid_MouseDoubleClick(object sender, System.Windows.Input.MouseButtonEventArgs e)
        {
            if (CardsDataGrid.SelectedItem is CardFileInfo selectedCard)
            {
                try
                {
                    var wordService = new WordDocumentService();
                    wordService.OpenDocument(selectedCard.FilePath);
                }
                catch (Exception ex)
                {
                    MessageBox.Show(
                        $"Ошибка при открытии личной карточки: {ex.Message}",
                        "Ошибка",
                        MessageBoxButton.OK,
                        MessageBoxImage.Error);
                }
            }
        }

        private void CloseButton_Click(object sender, RoutedEventArgs e)
        {
            Close();
        }

        private void TitleBar_MouseDown(object sender, System.Windows.Input.MouseButtonEventArgs e)
        {
            if (e.ChangedButton == System.Windows.Input.MouseButton.Left)
            {
                DragMove();
            }
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
    }

    // Класс для отображения информации о файле личной карточки
    public class CardFileInfo
    {
        public string FilePath { get; set; } = "";
        public string FileName { get; set; } = "";
        public string ContractNumber { get; set; } = "";
        public DateTime CreatedDate { get; set; }
    }
}
