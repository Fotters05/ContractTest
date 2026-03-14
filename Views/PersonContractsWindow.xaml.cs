using System;
using System.Collections.Generic;
using System.Linq;
using System.Windows;
using System.Windows.Input;
using Contract2512.Models;
using Contract2512.Services;
using Wpf.Ui.Controls;
using MessageBox = System.Windows.MessageBox;
using MessageBoxButton = System.Windows.MessageBoxButton;
using MessageBoxImage = System.Windows.MessageBoxImage;

namespace Contract2512.Views
{
    public class ContractWithRole
    {
        public Contract Contract { get; set; }
        public string Role { get; set; }
    }

    public partial class PersonContractsWindow : FluentWindow
    {
        private Person _person;

        public PersonContractsWindow(Person person)
        {
            InitializeComponent();
            _person = person;
            LoadContracts();
            UpdateTitle();
        }

        private void UpdateTitle()
        {
            if (_person != null)
            {
                TitleTextBlock.Text = $"Договоры: {_person.FullName}";
                PersonInfoTextBlock.Text = $"Физическое лицо: {_person.FullName}";
            }
        }

        private void LoadContracts()
        {
            try
            {
                using (var db = new AppDbContext())
                {
                    // Находим все договоры, где человек является либо заказчиком, либо слушателем
                    var contracts = db.Contracts
                        .Where(c => c.PayerId == _person.Id || c.ListenerId == _person.Id)
                        .ToList();

                    // Загружаем связанные данные и определяем роль
                    var contractsWithRole = new List<ContractWithRole>();
                    foreach (var contract in contracts)
                    {
                        contract.ContractType = db.ContractTypes.Find(contract.ContractTypeId);
                        contract.Program = db.LearningPrograms.Find(contract.ProgramId);
                        contract.Payer = db.Persons.Find(contract.PayerId);
                        contract.Listener = db.Persons.Find(contract.ListenerId);

                        string role = "";
                        if (contract.PayerId == _person.Id && contract.ListenerId == _person.Id)
                            role = "Заказчик, Слушатель";
                        else if (contract.PayerId == _person.Id)
                            role = "Заказчик";
                        else if (contract.ListenerId == _person.Id)
                            role = "Слушатель";

                        contractsWithRole.Add(new ContractWithRole
                        {
                            Contract = contract,
                            Role = role
                        });
                    }

                    ContractsDataGrid.ItemsSource = contractsWithRole;
                }
            }
            catch (Exception ex)
            {
                MessageBox.Show(
                    $"Ошибка при загрузке договоров: {ex.Message}",
                    "Ошибка",
                    MessageBoxButton.OK,
                    MessageBoxImage.Error);
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

        private void CloseButton_Click(object sender, RoutedEventArgs e)
        {
            Close();
        }

        private void TitleBar_MouseDown(object sender, MouseButtonEventArgs e)
        {
            if (e.ChangedButton == MouseButton.Left)
            {
                DragMove();
            }
        }

        private void ViewContractButton_Click(object sender, RoutedEventArgs e)
        {
            if (ContractsDataGrid.SelectedItem is ContractWithRole selectedItem)
            {
                try
                {
                    using (var db = new AppDbContext())
                    {
                        var contract = db.Contracts.FirstOrDefault(c => c.Id == selectedItem.Contract.Id);
                        if (contract != null)
                        {
                            // Формируем договор с замененными плейсхолдерами
                            string documentPath = ContractWindow.GenerateContractDocumentForView(contract, db);

                            // Открываем сформированный договор
                            var wordService = new WordDocumentService();
                            wordService.OpenDocument(documentPath);
                        }
                        else
                        {
                            MessageBox.Show(
                                "Договор не найден!",
                                "Ошибка",
                                MessageBoxButton.OK,
                                MessageBoxImage.Warning);
                        }
                    }
                }
                catch (Exception ex)
                {
                    MessageBox.Show(
                        $"Ошибка при просмотре договора: {ex.Message}",
                        "Ошибка",
                        MessageBoxButton.OK,
                        MessageBoxImage.Error);
                }
            }
            else
            {
                MessageBox.Show(
                    "Выберите договор для просмотра!",
                    "Внимание",
                    MessageBoxButton.OK,
                    MessageBoxImage.Warning);
            }
        }
    }
}
