using System;
using System.IO;
using Microsoft.EntityFrameworkCore;
using System.Linq;
using System.Windows;
using Contract2512.Models;
using Contract2512.Services;
using Contract2512.Views;
using Wpf.Ui.Controls;
using System.ComponentModel;

namespace Contract2512
{
    public partial class MainWindow : FluentWindow
    {
        private System.Collections.ObjectModel.ObservableCollection<Contract> _allContracts;
        private System.Windows.Threading.DispatcherTimer _autoRefreshTimer;
        private bool _dbConfigMissingNotified;

        public MainWindow()
        {
            InitializeComponent();
            LoadData();
            SetupNavigation();
            SetupDataGridClips();
            SetupAutoRefresh();
        }

        private void SetupAutoRefresh()
        {
            // Создаем таймер для автообновления данных каждые 5 секунд
            _autoRefreshTimer = new System.Windows.Threading.DispatcherTimer();
            _autoRefreshTimer.Interval = TimeSpan.FromSeconds(5);
            _autoRefreshTimer.Tick += AutoRefreshTimer_Tick;
            _autoRefreshTimer.Start();
            
            System.Diagnostics.Debug.WriteLine("Автообновление данных запущено (каждые 5 секунд)");
        }

        private void AutoRefreshTimer_Tick(object sender, EventArgs e)
        {
            try
            {
                LoadData();
                System.Diagnostics.Debug.WriteLine($"Данные автоматически обновлены: {DateTime.Now:HH:mm:ss}");
            }
            catch (Exception ex)
            {
                System.Diagnostics.Debug.WriteLine($"Ошибка при автообновлении: {ex.Message}");
            }
        }

        private void SetupDataGridClips()
        {
            // Устанавливаем Clip для DataGrid при загрузке
            if (PersonsDataGridBorder != null)
            {
                var rect = new System.Windows.Rect(0, 0, PersonsDataGridBorder.ActualWidth, PersonsDataGridBorder.ActualHeight);
                PersonsDataGridBorder.Clip = new System.Windows.Media.RectangleGeometry(rect)
                {
                    RadiusX = 12,
                    RadiusY = 12
                };
            }
            
            if (ContractsDataGridBorder != null)
            {
                var rect = new System.Windows.Rect(0, 0, ContractsDataGridBorder.ActualWidth, ContractsDataGridBorder.ActualHeight);
                ContractsDataGridBorder.Clip = new System.Windows.Media.RectangleGeometry(rect)
                {
                    RadiusX = 12,
                    RadiusY = 12
                };
            }
        }

        private void SetupNavigation()
        {
            // Устанавливаем начальное выделение для "Физические лица"
            BtnPersons.Tag = "Selected";
            UpdateMenuSelection(BtnPersons);
        }

        private void UpdateMenuSelection(System.Windows.Controls.Border selectedButton)
        {
            // Сбрасываем выделение всех кнопок
            BtnPersons.Tag = null;
            BtnContracts.Tag = null;
            BtnPrograms.Tag = null;
            BtnContractTypes.Tag = null;
            BtnOrganizations.Tag = null;
            BtnWorkload.Tag = null;
            
            // Устанавливаем выделение выбранной кнопки
            if (selectedButton != null)
            {
                selectedButton.Tag = "Selected";
            }
        }

        private void BtnPersons_Click(object sender, RoutedEventArgs e)
        {
            UpdateMenuSelection(BtnPersons);
            PersonsPanel.Visibility = Visibility.Visible;
            ContractsPanel.Visibility = Visibility.Collapsed;
            ProgramsPanel.Visibility = Visibility.Collapsed;
            ContractTypesPanel.Visibility = Visibility.Collapsed;
            OrganizationsPanel.Visibility = Visibility.Collapsed;
            WorkloadPanel.Visibility = Visibility.Collapsed;
        }

        private void BtnContracts_Click(object sender, RoutedEventArgs e)
        {
            UpdateMenuSelection(BtnContracts);
            PersonsPanel.Visibility = Visibility.Collapsed;
            ContractsPanel.Visibility = Visibility.Visible;
            ProgramsPanel.Visibility = Visibility.Collapsed;
            ContractTypesPanel.Visibility = Visibility.Collapsed;
            OrganizationsPanel.Visibility = Visibility.Collapsed;
            WorkloadPanel.Visibility = Visibility.Collapsed;
        }

        private void BtnPrograms_Click(object sender, RoutedEventArgs e)
        {
            UpdateMenuSelection(BtnPrograms);
            PersonsPanel.Visibility = Visibility.Collapsed;
            ContractsPanel.Visibility = Visibility.Collapsed;
            ProgramsPanel.Visibility = Visibility.Visible;
            ContractTypesPanel.Visibility = Visibility.Collapsed;
            OrganizationsPanel.Visibility = Visibility.Collapsed;
            WorkloadPanel.Visibility = Visibility.Collapsed;
        }

        private void BtnContractTypes_Click(object sender, RoutedEventArgs e)
        {
            UpdateMenuSelection(BtnContractTypes);
            PersonsPanel.Visibility = Visibility.Collapsed;
            ContractsPanel.Visibility = Visibility.Collapsed;
            ProgramsPanel.Visibility = Visibility.Collapsed;
            ContractTypesPanel.Visibility = Visibility.Visible;
            OrganizationsPanel.Visibility = Visibility.Collapsed;
            WorkloadPanel.Visibility = Visibility.Collapsed;
            LoadContractTypes();
        }

        private void BtnOrganizations_Click(object sender, RoutedEventArgs e)
        {
            UpdateMenuSelection(BtnOrganizations);
            PersonsPanel.Visibility = Visibility.Collapsed;
            ContractsPanel.Visibility = Visibility.Collapsed;
            ProgramsPanel.Visibility = Visibility.Collapsed;
            ContractTypesPanel.Visibility = Visibility.Collapsed;
            OrganizationsPanel.Visibility = Visibility.Visible;
            WorkloadPanel.Visibility = Visibility.Collapsed;
            LoadOrganizations();
        }

        private void BtnWorkload_Click(object sender, RoutedEventArgs e)
        {
            UpdateMenuSelection(BtnWorkload);
            PersonsPanel.Visibility = Visibility.Collapsed;
            ContractsPanel.Visibility = Visibility.Collapsed;
            ProgramsPanel.Visibility = Visibility.Collapsed;
            ContractTypesPanel.Visibility = Visibility.Collapsed;
            OrganizationsPanel.Visibility = Visibility.Collapsed;
            WorkloadPanel.Visibility = Visibility.Visible;
            LoadWorkloadDocuments();
        }

        private void BtnSupport_Click(object sender, RoutedEventArgs e)
        {
            // Не обновляем выделение меню, так как это не вкладка, а окно
            var window = new SupportWindow();
            window.Owner = this;
            window.ShowDialog();
        }

        private void BtnSettings_Click(object sender, RoutedEventArgs e)
        {
            // Не обновляем выделение меню, так как это не вкладка, а окно
            try
            {
                var window = new DatabaseSettingsWindow();
                window.Owner = this;

                var result = window.ShowDialog();
                if (result == true)
                {
                    try
                    {
                        _dbConfigMissingNotified = false;
                        LoadData();
                    }
                    catch (Exception ex)
                    {
                        System.Windows.MessageBox.Show(
                            $"Ошибка загрузки данных после подключения к БД:\n{ex.Message}",
                            "Ошибка",
                            System.Windows.MessageBoxButton.OK,
                            System.Windows.MessageBoxImage.Error);
                    }
                }
            }
            catch (Exception ex)
            {
                System.Windows.MessageBox.Show(
                    $"Не удалось открыть окно настроек БД:\n{ex}",
                    "Ошибка",
                    System.Windows.MessageBoxButton.OK,
                    System.Windows.MessageBoxImage.Error);
            }
        }

        private bool IsDbConfigured()
        {
            var cs = EnvConfigService.Get(EnvConfigService.ConnectionStringKey);
            return !string.IsNullOrWhiteSpace(cs);
        }

        private void NotifyDbConfigMissingOnce()
        {
            if (_dbConfigMissingNotified)
                return;

            _dbConfigMissingNotified = true;
            System.Windows.MessageBox.Show(
                "Не задана строка подключения к базе данных.\nОткройте Настройки и укажите строку подключения.",
                "Подключение к БД",
                System.Windows.MessageBoxButton.OK,
                System.Windows.MessageBoxImage.Information);
        }

        private void PersonsDataGridBorder_SizeChanged(object sender, SizeChangedEventArgs e)
        {
            if (sender is System.Windows.Controls.Border border)
            {
                var rect = new System.Windows.Rect(0, 0, border.ActualWidth, border.ActualHeight);
                border.Clip = new System.Windows.Media.RectangleGeometry(rect)
                {
                    RadiusX = 12,
                    RadiusY = 12
                };
            }
        }

        private void ContractsDataGridBorder_SizeChanged(object sender, SizeChangedEventArgs e)
        {
            if (sender is System.Windows.Controls.Border border)
            {
                var rect = new System.Windows.Rect(0, 0, border.ActualWidth, border.ActualHeight);
                border.Clip = new System.Windows.Media.RectangleGeometry(rect)
                {
                    RadiusX = 12,
                    RadiusY = 12
                };
            }
        }

        private void ContractTypesDataGridBorder_SizeChanged(object sender, SizeChangedEventArgs e)
        {
            if (sender is System.Windows.Controls.Border border)
            {
                var rect = new System.Windows.Rect(0, 0, border.ActualWidth, border.ActualHeight);
                border.Clip = new System.Windows.Media.RectangleGeometry(rect)
                {
                    RadiusX = 12,
                    RadiusY = 12
                };
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
                MaximizeIcon.Text = "□";
            }
            else
            {
                WindowState = WindowState.Maximized;
                MaximizeIcon.Text = "❐";
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

        private void LoadData()
        {
            if (!IsDbConfigured())
            {
                NotifyDbConfigMissingOnce();
                return;
            }

            LoadPersons();
            LoadContracts();
            LoadPrograms();
            LoadWorkloadDocuments();
        }

        private void LoadPersons()
        {
            if (!IsDbConfigured())
                return;

            try
            {
                using (var db = new AppDbContext())
                {
                    var persons = db.Persons
                        .Include(p => p.Gender)
                        .Include(p => p.Contacts)
                        .ToList();
                    PersonsDataGrid.ItemsSource = persons;
                }
            }
            catch (Exception ex)
            {
                System.Windows.MessageBox.Show(
                    $"Ошибка при загрузке данных: {ex.Message}",
                    "Ошибка",
                    System.Windows.MessageBoxButton.OK,
                    System.Windows.MessageBoxImage.Error);
            }
        }

        private void LoadContracts()
        {
            if (!IsDbConfigured())
                return;

            try
            {
                using (var db = new AppDbContext())
                {
                    var contracts = db.Contracts
                        .Include(c => c.ContractType)
                        .Include(c => c.Program)
                        .Include(c => c.Payer)
                            .ThenInclude(p => p.Contacts)
                        .Include(c => c.Listener)
                            .ThenInclude(p => p.Contacts)
                        .ToList();
                    
                    // Сохраняем все договоры для фильтрации
                    _allContracts = new System.Collections.ObjectModel.ObservableCollection<Contract>(contracts);
                    ApplyContractFilter();
                }
            }
            catch (Exception ex)
            {
                System.Windows.MessageBox.Show(
                    $"Ошибка при загрузке договоров: {ex.Message}",
                    "Ошибка",
                    System.Windows.MessageBoxButton.OK,
                    System.Windows.MessageBoxImage.Error);
            }
        }

        private void ApplyContractFilter()
        {
            if (_allContracts == null)
                return;

            string searchText = ContractSearchTextBox?.Text?.Trim() ?? "";
            
            if (string.IsNullOrWhiteSpace(searchText))
            {
                ContractsDataGrid.ItemsSource = _allContracts;
            }
            else
            {
                var filtered = _allContracts
                    .Where(c => c.ContractNumber != null && 
                               c.ContractNumber.IndexOf(searchText, StringComparison.OrdinalIgnoreCase) >= 0)
                    .ToList();
                ContractsDataGrid.ItemsSource = filtered;
            }
        }

        private void ContractSearchTextBox_TextChanged(object sender, System.Windows.Controls.TextChangedEventArgs e)
        {
            ApplyContractFilter();
        }

        private void AddPersonButton_Click(object sender, RoutedEventArgs e)
        {
            var window = new PersonWindow();
            ((Window)window).Owner = this;
            if (((Window)window).ShowDialog() == true)
            {
                LoadPersons();
            }
        }

        private void EditPersonButton_Click(object sender, RoutedEventArgs e)
        {
            if (PersonsDataGrid.SelectedItem is Person selectedPerson)
            {
                var window = new PersonWindow(selectedPerson);
                ((Window)window).Owner = this;
                if (((Window)window).ShowDialog() == true)
                {
                    LoadPersons();
                }
            }
            else
            {
                System.Windows.MessageBox.Show(
                    "Выберите физическое лицо для редактирования!",
                    "Внимание",
                    System.Windows.MessageBoxButton.OK,
                    System.Windows.MessageBoxImage.Warning);
            }
        }

        private void DeletePersonButton_Click(object sender, RoutedEventArgs e)
        {
            if (PersonsDataGrid.SelectedItem is Person selectedPerson)
            {
                var result = System.Windows.MessageBox.Show(
                    $"Вы уверены, что хотите удалить {selectedPerson.FullName}?",
                    "Подтверждение удаления",
                    System.Windows.MessageBoxButton.YesNo,
                    System.Windows.MessageBoxImage.Question);

                if (result == System.Windows.MessageBoxResult.Yes)
                {
                    try
                    {
                        using (var db = new AppDbContext())
                        {
                            var person = db.Persons.Find(selectedPerson.Id);
                            if (person != null)
                            {
                                db.Persons.Remove(person);
                                db.SaveChanges();
                                LoadPersons();
                                System.Windows.MessageBox.Show(
                                    "Физическое лицо успешно удалено!",
                                    "Успех",
                                    System.Windows.MessageBoxButton.OK,
                                    System.Windows.MessageBoxImage.Information);
                            }
                        }
                    }
                    catch (Exception ex)
                    {
                        System.Windows.MessageBox.Show(
                            $"Ошибка при удалении: {ex.Message}",
                            "Ошибка",
                            System.Windows.MessageBoxButton.OK,
                            System.Windows.MessageBoxImage.Error);
                    }
                }
            }
            else
            {
                System.Windows.MessageBox.Show(
                    "Выберите физическое лицо для удаления!",
                    "Внимание",
                    System.Windows.MessageBoxButton.OK,
                    System.Windows.MessageBoxImage.Warning);
            }
        }

        private void CreateContractForPersonButton_Click(object sender, RoutedEventArgs e)
        {
            if (PersonsDataGrid.SelectedItem is Person selectedPerson)
            {
                var window = new ContractWindow(selectedPerson, selectedPerson);
                ((Window)window).Owner = this;
                if (((Window)window).ShowDialog() == true)
                {
                    LoadContracts();
                }
            }
            else
            {
                System.Windows.MessageBox.Show(
                    "Выберите физическое лицо!",
                    "Внимание",
                    System.Windows.MessageBoxButton.OK,
                    System.Windows.MessageBoxImage.Warning);
            }
        }

        private void CreateContractButton_Click(object sender, RoutedEventArgs e)
        {
            var window = new ContractWindow();
            ((Window)window).Owner = this;
            if (((Window)window).ShowDialog() == true)
            {
                LoadContracts();
            }
        }

        private void OpenContractButton_Click(object sender, RoutedEventArgs e)
        {
            if (ContractsDataGrid.SelectedItem is Contract selectedContract)
            {
                try
                {
                    using (var db = new AppDbContext())
                    {
                        var contract = db.Contracts.FirstOrDefault(c => c.Id == selectedContract.Id);
                        if (contract != null)
                        {
                            // Получаем путь к сохраненному договору
                            string documentsFolder = Path.Combine(AppDomain.CurrentDomain.BaseDirectory, "Документы", "Договоры");
                            string fileName = $"Договор_{contract.ContractNumber}_{contract.Listener?.LastName}_{contract.ContractDate:yyyyMMdd}.docx";
                            string documentPath = Path.Combine(documentsFolder, fileName);

                            if (File.Exists(documentPath))
                            {
                                // Открываем сохраненный договор
                                var wordService = new WordDocumentService();
                                wordService.OpenDocument(documentPath);
                            }
                            else
                            {
                                System.Windows.MessageBox.Show(
                                    "Файл договора не найден! Возможно, он был удален или перемещен.",
                                    "Ошибка",
                                    System.Windows.MessageBoxButton.OK,
                                    System.Windows.MessageBoxImage.Warning);
                            }
                        }
                        else
                        {
                            System.Windows.MessageBox.Show(
                                "Договор не найден!",
                                "Ошибка",
                                System.Windows.MessageBoxButton.OK,
                                System.Windows.MessageBoxImage.Warning);
                        }
                    }
                }
                catch (Exception ex)
                {
                    System.Windows.MessageBox.Show(
                        $"Ошибка при открытии договора: {ex.Message}",
                        "Ошибка",
                        System.Windows.MessageBoxButton.OK,
                        System.Windows.MessageBoxImage.Error);
                }
            }
            else
            {
                System.Windows.MessageBox.Show(
                    "Выберите договор для открытия!",
                    "Внимание",
                    System.Windows.MessageBoxButton.OK,
                    System.Windows.MessageBoxImage.Warning);
            }
        }

        private void ViewContractButton_Click(object sender, RoutedEventArgs e)
        {
            if (ContractsDataGrid.SelectedItem is Contract selectedContract)
            {
                try
                {
                    using (var db = new AppDbContext())
                    {
                        var contract = db.Contracts.FirstOrDefault(c => c.Id == selectedContract.Id);
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
                            System.Windows.MessageBox.Show(
                                "Договор не найден!",
                                "Ошибка",
                                System.Windows.MessageBoxButton.OK,
                                System.Windows.MessageBoxImage.Warning);
                        }
                    }
                }
                catch (Exception ex)
                {
                    System.Windows.MessageBox.Show(
                        $"Ошибка при открытии договора: {ex.Message}",
                        "Ошибка",
                        System.Windows.MessageBoxButton.OK,
                        System.Windows.MessageBoxImage.Error);
                }
            }
            else
            {
                System.Windows.MessageBox.Show(
                    "Выберите договор для просмотра!",
                    "Внимание",
                    System.Windows.MessageBoxButton.OK,
                    System.Windows.MessageBoxImage.Warning);
            }
        }

        private void LoadPrograms()
        {
            if (!IsDbConfigured())
                return;

            try
            {
                using (var db = new AppDbContext())
            {
                var programs = db.LearningPrograms.ToList();
                var programViewModels = programs.Select(p =>
                {
                    // Загружаем вид программы
                    var programView = db.ProgramViews.Find(p.ProgramViewId);

                    return new ProgramViewModel
                    {
                        Id = p.Id,
                            Name = p.Name ?? "",
                            Format = p.Format ?? "",
                        Hours = p.Hours,
                        LessonsCount = p.LessonsCount,
                        Price = p.Price,
                        ImagePath = GetImagePath(p.Image),
                        ProgramViewName = programView?.Name ?? ""
                    };
                }).ToList();

                ProgramsItemsControl.ItemsSource = programViewModels;
            }
            }
            catch (Exception ex)
            {
                System.Windows.MessageBox.Show(
                    $"Ошибка при загрузке программ: {ex.Message}",
                    "Ошибка",
                    System.Windows.MessageBoxButton.OK,
                    System.Windows.MessageBoxImage.Error);
            }
        }

        private string? GetImagePath(string? image)
        {
            if (string.IsNullOrEmpty(image))
                return null;

            // Проверяем, является ли это URL
            if (Uri.TryCreate(image, UriKind.Absolute, out Uri? uri) &&
                (uri.Scheme == Uri.UriSchemeHttp || uri.Scheme == Uri.UriSchemeHttps))
            {
                // Это URL - возвращаем как есть
                return image;
            }
            // Проверяем, существует ли локальный файл
            else if (System.IO.File.Exists(image))
            {
                return image;
            }

            return null;
        }

        private void AddProgramButton_Click(object sender, RoutedEventArgs e)
        {
            var window = new ProgramWindow();
            ((Window)window).Owner = this;
            if (((Window)window).ShowDialog() == true)
            {
                LoadPrograms();
            }
        }

        private void EditProgramButton_Click(object sender, RoutedEventArgs e)
        {
            var selectedProgram = GetSelectedProgram();
            if (selectedProgram != null)
            {
                using (var db = new AppDbContext())
                {
                    var program = db.LearningPrograms.Find(selectedProgram.Id);
                    if (program != null)
                    {
                        var window = new ProgramWindow(program);
                        ((Window)window).Owner = this;
                        if (((Window)window).ShowDialog() == true)
                        {
                            LoadPrograms();
                            ClearSelection();
                        }
                    }
                }
            }
            else
            {
                System.Windows.MessageBox.Show(
                    "Выберите программу для редактирования!",
                    "Внимание",
                    System.Windows.MessageBoxButton.OK,
                    System.Windows.MessageBoxImage.Warning);
            }
        }

        private void DeleteProgramButton_Click(object sender, RoutedEventArgs e)
        {
            var selectedProgram = GetSelectedProgram();
            if (selectedProgram != null)
            {
                var result = System.Windows.MessageBox.Show(
                    $"Вы уверены, что хотите удалить программу \"{selectedProgram.Name}\"?",
                    "Подтверждение удаления",
                    System.Windows.MessageBoxButton.YesNo,
                    System.Windows.MessageBoxImage.Question);

                if (result == System.Windows.MessageBoxResult.Yes)
                {
                    try
                    {
                        using (var db = new AppDbContext())
                        {
                            var program = db.LearningPrograms.Find(selectedProgram.Id);
                            if (program != null)
                            {
                                db.LearningPrograms.Remove(program);
                                db.SaveChanges();
                                LoadPrograms();
                                ClearSelection();
                                System.Windows.MessageBox.Show(
                                    "Программа успешно удалена!",
                                    "Успех",
                                    System.Windows.MessageBoxButton.OK,
                                    System.Windows.MessageBoxImage.Information);
                            }
                        }
                    }
                    catch (Exception ex)
                    {
                        System.Windows.MessageBox.Show(
                            $"Ошибка при удалении: {ex.Message}",
                            "Ошибка",
                            System.Windows.MessageBoxButton.OK,
                            System.Windows.MessageBoxImage.Error);
                    }
                }
            }
            else
            {
                System.Windows.MessageBox.Show(
                    "Выберите программу для удаления!",
                    "Внимание",
                    System.Windows.MessageBoxButton.OK,
                    System.Windows.MessageBoxImage.Warning);
            }
        }

        private void ViewProgramDetailsButton_Click(object sender, RoutedEventArgs e)
        {
            var selectedProgram = GetSelectedProgram();
            if (selectedProgram != null)
            {
                using (var db = new AppDbContext())
                {
                    var program = db.LearningPrograms.Find(selectedProgram.Id);
                    if (program != null)
                    {
                        var window = new ProgramDetailsWindow(program);
                        window.Owner = this;
                        window.ShowDialog();
                    }
                }
            }
            else
            {
                System.Windows.MessageBox.Show(
                    "Выберите программу для просмотра подробностей!",
                    "Внимание",
                    System.Windows.MessageBoxButton.OK,
                    System.Windows.MessageBoxImage.Warning);
            }
        }

        private void ImportProgramsButton_Click(object sender, RoutedEventArgs e)
        {
            var result = System.Windows.MessageBox.Show(
                "Запустить импорт программ с сайта 25-12.ru?\n\n" +
                "Это займет несколько минут.\n" +
                "Новые программы будут добавлены в базу данных.",
                "Импорт программ",
                System.Windows.MessageBoxButton.YesNo,
                System.Windows.MessageBoxImage.Question);

            if (result == System.Windows.MessageBoxResult.Yes)
            {
                var parserWindow = new ParserWindow();
                parserWindow.Owner = this;
                bool? dialogResult = parserWindow.ShowDialog();

                // Если импорт завершен успешно, обновляем список программ
                if (dialogResult == true)
                {
                    LoadPrograms();
                    System.Windows.MessageBox.Show(
                        "Список программ обновлен!",
                        "Готово",
                        System.Windows.MessageBoxButton.OK,
                        System.Windows.MessageBoxImage.Information);
                }
            }
        }


        private ProgramViewModel? GetSelectedProgram()
        {
            if (ProgramsItemsControl.ItemsSource != null)
            {
                foreach (ProgramViewModel program in ProgramsItemsControl.ItemsSource)
                {
                    if (program.IsSelected)
                    {
                        return program;
                    }
                }
            }
            return null;
        }

        private void ClearSelection()
        {
            if (ProgramsItemsControl.ItemsSource != null)
            {
                foreach (ProgramViewModel program in ProgramsItemsControl.ItemsSource)
                {
                    program.IsSelected = false;
                }
            }
        }

        private void ProgramCheckBox_Click(object sender, RoutedEventArgs e)
        {
            // Предотвращаем всплытие события на карточку
            e.Handled = true;

            // Снимаем выделение с других программ (только одна может быть выбрана)
            if (sender is System.Windows.Controls.CheckBox checkBox && checkBox.IsChecked == true)
            {
                if (ProgramsItemsControl.ItemsSource != null)
                {
                    foreach (ProgramViewModel program in ProgramsItemsControl.ItemsSource)
                    {
                        if (program != checkBox.Tag as ProgramViewModel)
                        {
                            program.IsSelected = false;
                        }
                    }
                }
            }
        }

        private void ProgramCard_MouseLeftButtonDown(object sender, System.Windows.Input.MouseButtonEventArgs e)
        {
            // Игнорируем клик, если он был на CheckBox
            if (e.OriginalSource is System.Windows.Controls.CheckBox)
            {
                return;
            }

            if (sender is System.Windows.FrameworkElement element && element.Tag is ProgramViewModel program)
            {
                // Переключаем выделение при двойном клике
                if (e.ClickCount == 2)
                {
                    // Двойной клик - открываем редактирование
                    ClearSelection();
                    program.IsSelected = true;
                    EditProgramButton_Click(sender, e);
                }
                else
                {
                    // Одинарный клик - просто выделяем
                    ClearSelection();
                    program.IsSelected = true;
                }
            }
        }

        private void NavigationViewItem_Click(object sender, RoutedEventArgs e)
        {

        }

        private void PersonsDataGrid_MouseDoubleClick(object sender, System.Windows.Input.MouseButtonEventArgs e)
        {
            if (PersonsDataGrid.SelectedItem is Person selectedPerson)
            {
                var window = new PersonContractsWindow(selectedPerson);
                window.Owner = this;
                window.ShowDialog();
            }
        }

        private void LoadContractTypes()
        {
            if (!IsDbConfigured())
                return;

            try
            {
                using (var db = new AppDbContext())
                {
                    var contractTypes = db.ContractTypes.ToList();
                    ContractTypesDataGrid.ItemsSource = contractTypes;
                }
            }
            catch (Exception ex)
            {
                System.Windows.MessageBox.Show(
                    $"Ошибка при загрузке типов договоров: {ex.Message}",
                    "Ошибка",
                    System.Windows.MessageBoxButton.OK,
                    System.Windows.MessageBoxImage.Error);
            }
        }

        private void AddContractTypeButton_Click(object sender, RoutedEventArgs e)
        {
            var window = new ContractTypeWindow();
            window.Owner = this;
            if (window.ShowDialog() == true)
            {
                LoadContractTypes();
            }
        }

        private void EditContractTypeButton_Click(object sender, RoutedEventArgs e)
        {
            if (ContractTypesDataGrid.SelectedItem is ContractType selectedContractType)
            {
                var window = new ContractTypeWindow(selectedContractType);
                window.Owner = this;
                if (window.ShowDialog() == true)
                {
                    LoadContractTypes();
                }
            }
            else
            {
                System.Windows.MessageBox.Show(
                    "Выберите тип договора для редактирования!",
                    "Внимание",
                    System.Windows.MessageBoxButton.OK,
                    System.Windows.MessageBoxImage.Warning);
            }
        }

        private void DeleteContractTypeButton_Click(object sender, RoutedEventArgs e)
        {
            if (ContractTypesDataGrid.SelectedItem is ContractType selectedContractType)
                {
                var result = System.Windows.MessageBox.Show(
                    $"Вы уверены, что хотите удалить тип договора \"{selectedContractType.Name}\"?",
                    "Подтверждение удаления",
                    System.Windows.MessageBoxButton.YesNo,
                    System.Windows.MessageBoxImage.Question);

                if (result == System.Windows.MessageBoxResult.Yes)
                {
                    try
                    {
                        using (var db = new AppDbContext())
                        {
                            // Проверяем, используется ли этот тип договора
                            var contractsCount = db.Contracts.Count(c => c.ContractTypeId == selectedContractType.Id);
                            if (contractsCount > 0)
                            {
                                System.Windows.MessageBox.Show(
                                    $"Невозможно удалить тип договора, так как он используется в {contractsCount} договоре(ах)!",
                                    "Ошибка",
                                    System.Windows.MessageBoxButton.OK,
                                    System.Windows.MessageBoxImage.Warning);
                                return;
                            }

                            var contractType = db.ContractTypes.Find(selectedContractType.Id);
                            if (contractType != null)
                {
                                db.ContractTypes.Remove(contractType);
                                db.SaveChanges();
                                LoadContractTypes();
                                System.Windows.MessageBox.Show(
                                    "Тип договора успешно удален!",
                                    "Успех",
                                    System.Windows.MessageBoxButton.OK,
                                    System.Windows.MessageBoxImage.Information);
                            }
                        }
                    }
                    catch (Exception ex)
                    {
                        System.Windows.MessageBox.Show(
                            $"Ошибка при удалении: {ex.Message}",
                            "Ошибка",
                            System.Windows.MessageBoxButton.OK,
                            System.Windows.MessageBoxImage.Error);
                }
                }
            }
            else
            {
                System.Windows.MessageBox.Show(
                    "Выберите тип договора для удаления!",
                    "Внимание",
                    System.Windows.MessageBoxButton.OK,
                    System.Windows.MessageBoxImage.Warning);
            }
        }

        private void ViewPersonContractsButton_Click(object sender, RoutedEventArgs e)
        {
            if (PersonsDataGrid.SelectedItem is Person selectedPerson)
            {
                var window = new PersonContractsWindow(selectedPerson);
                window.Owner = this;
                window.ShowDialog();
            }
            else
            {
                System.Windows.MessageBox.Show(
                    "Выберите физическое лицо для просмотра договоров!",
                    "Внимание",
                    System.Windows.MessageBoxButton.OK,
                    System.Windows.MessageBoxImage.Warning);
            }
        }

        private void ViewPersonCardsButton_Click(object sender, RoutedEventArgs e)
        {
            if (PersonsDataGrid.SelectedItem is Person selectedPerson)
            {
                var window = new PersonCardsWindow(selectedPerson);
                window.Owner = this;
                window.ShowDialog();
            }
            else
            {
                System.Windows.MessageBox.Show(
                    "Выберите физическое лицо для просмотра личных карточек!",
                    "Внимание",
                    System.Windows.MessageBoxButton.OK,
                    System.Windows.MessageBoxImage.Warning);
            }
        }

        private void OrganizationsDataGridBorder_SizeChanged(object sender, SizeChangedEventArgs e)
        {
            if (sender is System.Windows.Controls.Border border)
            {
                var rect = new System.Windows.Rect(0, 0, border.ActualWidth, border.ActualHeight);
                border.Clip = new System.Windows.Media.RectangleGeometry(rect)
                {
                    RadiusX = 12,
                    RadiusY = 12
                };
            }
        }

        private void WorkloadDocumentsDataGridBorder_SizeChanged(object sender, SizeChangedEventArgs e)
        {
            if (sender is System.Windows.Controls.Border border)
            {
                var rect = new System.Windows.Rect(0, 0, border.ActualWidth, border.ActualHeight);
                border.Clip = new System.Windows.Media.RectangleGeometry(rect)
                {
                    RadiusX = 12,
                    RadiusY = 12
                };
            }
        }

        private void LoadWorkloadDocuments()
        {
            if (!IsDbConfigured())
                return;

            try
            {
                using (var db = new AppDbContext())
                {
                    var workloadDocuments = db.WorkloadDocuments
                        .AsNoTracking()
                        .Include(w => w.Program)
                        .Include(w => w.Listener)
                        .Include(w => w.Teacher)
                        .OrderByDescending(w => w.GeneratedAt)
                        .ToList();

                    WorkloadDocumentsDataGrid.ItemsSource = workloadDocuments;
                }
            }
            catch (Exception ex)
            {
                System.Diagnostics.Debug.WriteLine($"Ошибка при загрузке учебной нагрузки: {ex.Message}");
            }
        }

        private void LoadOrganizations()
        {
            if (!IsDbConfigured())
                return;

            try
            {
                using (var db = new AppDbContext())
                {
                    var organizations = db.Organizations
                        .AsNoTracking()
                        .ToList();
                    
                    OrganizationsDataGrid.ItemsSource = organizations;
                }
            }
            catch (Exception ex)
            {
                System.Windows.MessageBox.Show(
                    $"Ошибка при загрузке организаций: {ex.Message}",
                    "Ошибка",
                    System.Windows.MessageBoxButton.OK,
                    System.Windows.MessageBoxImage.Error);
            }
        }

        private void AddOrganizationButton_Click(object sender, RoutedEventArgs e)
        {
            var window = new OrganizationEditWindow();
            window.Owner = this;
            if (window.ShowDialog() == true)
            {
                LoadOrganizations();
            }
        }

        private void EditOrganizationButton_Click(object sender, RoutedEventArgs e)
        {
            if (OrganizationsDataGrid.SelectedItem is Organization selectedOrg)
            {
                var window = new OrganizationEditWindow(selectedOrg);
                window.Owner = this;
                if (window.ShowDialog() == true)
                {
                    LoadOrganizations();
                }
            }
            else
            {
                System.Windows.MessageBox.Show(
                    "Выберите организацию для редактирования!",
                    "Внимание",
                    System.Windows.MessageBoxButton.OK,
                    System.Windows.MessageBoxImage.Warning);
            }
        }

        private void DeleteOrganizationButton_Click(object sender, RoutedEventArgs e)
        {
            if (OrganizationsDataGrid.SelectedItem is Organization selectedOrg)
            {
                var result = System.Windows.MessageBox.Show(
                    $"Вы уверены, что хотите удалить организацию '{selectedOrg.OrganizationName}'?",
                    "Подтверждение удаления",
                    System.Windows.MessageBoxButton.YesNo,
                    System.Windows.MessageBoxImage.Question);

                if (result == System.Windows.MessageBoxResult.Yes)
                {
                    try
                    {
                        using (var db = new AppDbContext())
                        {
                            var orgToDelete = db.Organizations.Find(selectedOrg.Id);
                            if (orgToDelete != null)
                            {
                                db.Organizations.Remove(orgToDelete);
                                db.SaveChanges();
                                LoadOrganizations();
                                System.Windows.MessageBox.Show(
                                    "Организация успешно удалена!",
                                    "Успех",
                                    System.Windows.MessageBoxButton.OK,
                                    System.Windows.MessageBoxImage.Information);
                            }
                        }
                    }
                    catch (Exception ex)
                    {
                        System.Windows.MessageBox.Show(
                            $"Ошибка при удалении организации: {ex.Message}",
                            "Ошибка",
                            System.Windows.MessageBoxButton.OK,
                            System.Windows.MessageBoxImage.Error);
                    }
                }
            }
            else
            {
                System.Windows.MessageBox.Show(
                    "Выберите организацию для удаления!",
                    "Внимание",
                    System.Windows.MessageBoxButton.OK,
                    System.Windows.MessageBoxImage.Warning);
            }
        }

        protected override void OnClosing(CancelEventArgs e)
        {
            // Останавливаем таймер при закрытии окна
            if (_autoRefreshTimer != null)
            {
                _autoRefreshTimer.Stop();
                _autoRefreshTimer = null;
                System.Diagnostics.Debug.WriteLine("Автообновление остановлено");
            }
            
            base.OnClosing(e);
        }

        private void PersonsDataGrid_SelectionChanged(object sender, System.Windows.Controls.SelectionChangedEventArgs e)
        {

        }

        private void CreateWorkloadButton_Click(object sender, RoutedEventArgs e)
        {
            var window = new WorkloadWindow();
            window.Owner = this;
            var result = window.ShowDialog();
            if (result == true)
            {
                LoadWorkloadDocuments();
            }
        }

        private void OpenHolidayCalendarButton_Click(object sender, RoutedEventArgs e)
        {
            var window = new HolidayCalendarWindow();
            window.Owner = this;
            window.ShowDialog();
        }

        private void OpenWorkloadDocumentButton_Click(object sender, RoutedEventArgs e)
        {
            if (WorkloadDocumentsDataGrid.SelectedItem is not WorkloadDocument selectedDocument)
            {
                System.Windows.MessageBox.Show(
                    "Выберите файл учебной нагрузки!",
                    "Внимание",
                    System.Windows.MessageBoxButton.OK,
                    System.Windows.MessageBoxImage.Warning);
                return;
            }

            if (string.IsNullOrWhiteSpace(selectedDocument.FilePath) || !File.Exists(selectedDocument.FilePath))
            {
                System.Windows.MessageBox.Show(
                    "Файл не найден. Возможно, он был удален или перемещен.",
                    "Ошибка",
                    System.Windows.MessageBoxButton.OK,
                    System.Windows.MessageBoxImage.Warning);
                return;
            }

            try
            {
                var excelService = new ExcelDocumentService();
                excelService.OpenDocument(selectedDocument.FilePath);
            }
            catch (Exception ex)
            {
                System.Windows.MessageBox.Show(
                    $"Ошибка при открытии файла: {ex.Message}",
                    "Ошибка",
                    System.Windows.MessageBoxButton.OK,
                    System.Windows.MessageBoxImage.Error);
            }
        }

        private void RefreshWorkloadDocumentsButton_Click(object sender, RoutedEventArgs e)
        {
            LoadWorkloadDocuments();
        }
    }

    // Класс для отображения программ в карточках
    public class ProgramViewModel : INotifyPropertyChanged
    {
        private bool _isSelected;

        public long Id { get; set; }
        public string Name { get; set; } = "";
        public string Format { get; set; } = "";
        public int Hours { get; set; }
        public int LessonsCount { get; set; }
        public decimal Price { get; set; }
        public string? ImagePath { get; set; }
        public string ProgramViewName { get; set; } = "";

        public bool IsSelected
        {
            get { return _isSelected; }
            set
            {
                if (_isSelected != value)
                {
                    _isSelected = value;
                    OnPropertyChanged(nameof(IsSelected));
                }
            }
        }

        public event PropertyChangedEventHandler? PropertyChanged;

        protected virtual void OnPropertyChanged(string propertyName)
        {
            PropertyChanged?.Invoke(this, new PropertyChangedEventArgs(propertyName));
        }
    }
}
