using System;
using System.Collections.Generic;
using System.Linq;
using System.Windows;
using System.Windows.Controls;
using System.Windows.Media;
using Contract2512.Models;
using Contract2512.Services;

namespace Contract2512.Views
{
    public partial class ProgramDetailsWindow : Wpf.Ui.Controls.FluentWindow
    {
        private readonly LearningProgram _program;
        private List<ProgramModule> _modules;

        public ProgramDetailsWindow(LearningProgram program)
        {
            InitializeComponent();
            _program = program;
            _modules = new List<ProgramModule>();

            LoadProgramData();
        }

        private void LoadProgramData()
        {
            ProgramNameText.Text = _program.Name;
            HoursText.Text = $"{_program.Hours} часов";
            LessonsText.Text = $"{_program.LessonsCount} занятий";
            PriceText.Text = $"{_program.Price:N0} ₽";

            using (var db = new AppDbContext())
            {
                _modules = db.ProgramModules
                    .Where(pm => pm.ProgramId == _program.Id)
                    .OrderBy(pm => pm.ModuleNumber)
                    .ToList();
            }

            DescriptionText.Text = _modules.Count > 0
                ? $"Программа содержит {_modules.Count} модулей"
                : "Модули не загружены. Импортируйте программу с сайта или добавьте модули вручную.";

            DisplayModules();
        }

        private void DisplayModules()
        {
            ModulesPanel.Children.Clear();

            if (_modules.Count == 0)
            {
                NoModulesText.Visibility = Visibility.Visible;
                ModulesPanel.Children.Add(NoModulesText);
                return;
            }

            NoModulesText.Visibility = Visibility.Collapsed;

            foreach (var module in _modules.OrderBy(m => m.ModuleNumber))
            {
                ModulesPanel.Children.Add(CreateModuleCard(module));
            }
        }

        private UIElement CreateModuleCard(ProgramModule module)
        {
            var card = new Border
            {
                Margin = new Thickness(0, 0, 0, 10),
                Padding = new Thickness(16),
                CornerRadius = new CornerRadius(10),
                BorderThickness = new Thickness(1),
                Background = (Brush)FindResource("CardBackground"),
                BorderBrush = (Brush)FindResource("SubtleBorderColor")
            };

            var grid = new Grid();
            grid.ColumnDefinitions.Add(new ColumnDefinition { Width = new GridLength(1, GridUnitType.Star) });
            grid.ColumnDefinitions.Add(new ColumnDefinition { Width = GridLength.Auto });

            var contentPanel = new StackPanel();
            var titlePanel = new StackPanel { Orientation = Orientation.Horizontal };

            titlePanel.Children.Add(new TextBlock
            {
                Text = $"Модуль {module.ModuleNumber}",
                FontWeight = FontWeights.Bold,
                FontSize = 14,
                Margin = new Thickness(0, 0, 10, 0),
                Foreground = (Brush)FindResource("TextPrimary")
            });

            if (module.Hours.HasValue)
            {
                titlePanel.Children.Add(new TextBlock
                {
                    Text = $"({module.Hours} ч.)",
                    VerticalAlignment = VerticalAlignment.Center,
                    Foreground = (Brush)FindResource("TextMuted")
                });
            }

            contentPanel.Children.Add(titlePanel);
            contentPanel.Children.Add(new TextBlock
            {
                Text = module.ModuleName,
                TextWrapping = TextWrapping.Wrap,
                Margin = new Thickness(0, 5, 0, 0),
                Foreground = (Brush)FindResource("TextPrimary")
            });

            if (!string.IsNullOrWhiteSpace(module.Description))
            {
                contentPanel.Children.Add(new TextBlock
                {
                    Text = module.Description,
                    TextWrapping = TextWrapping.Wrap,
                    Margin = new Thickness(0, 5, 0, 0),
                    FontSize = 12,
                    Foreground = (Brush)FindResource("TextSecondary")
                });
            }

            Grid.SetColumn(contentPanel, 0);
            grid.Children.Add(contentPanel);

            var buttonsPanel = new StackPanel
            {
                Orientation = Orientation.Horizontal,
                VerticalAlignment = VerticalAlignment.Top
            };

            var editButton = new Button
            {
                Content = "Редактировать",
                Style = (Style)FindResource("DarkButtonStyle"),
                Margin = new Thickness(8, 0, 0, 0),
                Tag = module
            };
            editButton.Click += EditModuleButton_Click;
            buttonsPanel.Children.Add(editButton);

            var deleteButton = new Button
            {
                Content = "Удалить",
                Style = (Style)FindResource("DarkButtonStyle"),
                Margin = new Thickness(8, 0, 0, 0),
                Tag = module
            };
            deleteButton.Click += DeleteModuleButton_Click;
            buttonsPanel.Children.Add(deleteButton);

            Grid.SetColumn(buttonsPanel, 1);
            grid.Children.Add(buttonsPanel);

            card.Child = grid;
            return card;
        }

        private void LoadFromWebButton_Click(object sender, RoutedEventArgs e)
        {
            MessageBox.Show(
                "Загрузка из окна подробностей временно отключена. Используйте импорт программ с главной страницы.",
                "Информация",
                MessageBoxButton.OK,
                MessageBoxImage.Information);
        }

        private void AddModuleButton_Click(object sender, RoutedEventArgs e)
        {
            var dialog = new ModuleEditDialog(null, _modules.Count + 1);
            if (dialog.ShowDialog() == true && dialog.Module != null)
            {
                dialog.Module.ProgramId = _program.Id;
                _modules.Add(dialog.Module);
                DisplayModules();
            }
        }

        private void EditModuleButton_Click(object sender, RoutedEventArgs e)
        {
            if (sender is Button button && button.Tag is ProgramModule module)
            {
                var dialog = new ModuleEditDialog(module, module.ModuleNumber);
                if (dialog.ShowDialog() == true)
                {
                    DisplayModules();
                }
            }
        }

        private void DeleteModuleButton_Click(object sender, RoutedEventArgs e)
        {
            if (sender is Button button && button.Tag is ProgramModule module)
            {
                var result = MessageBox.Show(
                    $"Удалить модуль {module.ModuleNumber}: {module.ModuleName}?",
                    "Подтверждение",
                    MessageBoxButton.YesNo,
                    MessageBoxImage.Question);

                if (result == MessageBoxResult.Yes)
                {
                    _modules.Remove(module);

                    var number = 1;
                    foreach (var item in _modules.OrderBy(m => m.ModuleNumber))
                    {
                        item.ModuleNumber = number++;
                    }

                    DisplayModules();
                }
            }
        }

        private void SaveButton_Click(object sender, RoutedEventArgs e)
        {
            try
            {
                using (var db = new AppDbContext())
                {
                    var oldModules = db.ProgramModules.Where(pm => pm.ProgramId == _program.Id).ToList();
                    db.ProgramModules.RemoveRange(oldModules);

                    foreach (var module in _modules)
                    {
                        module.Id = 0;
                        module.CreatedAt = DateTime.Now;
                        module.UpdatedAt = DateTime.Now;
                        db.ProgramModules.Add(module);
                    }

                    db.SaveChanges();
                }

                MessageBox.Show(
                    "Данные успешно сохранены!",
                    "Успех",
                    MessageBoxButton.OK,
                    MessageBoxImage.Information);

                DialogResult = true;
                Close();
            }
            catch (Exception ex)
            {
                MessageBox.Show(
                    $"Ошибка при сохранении: {ex.Message}",
                    "Ошибка",
                    MessageBoxButton.OK,
                    MessageBoxImage.Error);
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
    }

    public class ModuleEditDialog : Window
    {
        public ProgramModule? Module { get; private set; }

        private readonly TextBox _numberTextBox;
        private readonly TextBox _nameTextBox;
        private readonly TextBox _hoursTextBox;
        private readonly TextBox _descriptionTextBox;

        public ModuleEditDialog(ProgramModule? module, int defaultNumber)
        {
            Title = module == null ? "Добавить модуль" : "Редактировать модуль";
            Width = 500;
            Height = 400;
            WindowStartupLocation = WindowStartupLocation.CenterOwner;

            Module = module ?? new ProgramModule { ModuleNumber = defaultNumber, ModuleName = string.Empty };

            var grid = new Grid { Margin = new Thickness(20) };
            grid.RowDefinitions.Add(new RowDefinition { Height = GridLength.Auto });
            grid.RowDefinitions.Add(new RowDefinition { Height = GridLength.Auto });
            grid.RowDefinitions.Add(new RowDefinition { Height = GridLength.Auto });
            grid.RowDefinitions.Add(new RowDefinition { Height = new GridLength(1, GridUnitType.Star) });
            grid.RowDefinitions.Add(new RowDefinition { Height = GridLength.Auto });

            var numberLabel = new TextBlock { Text = "Номер модуля:", Margin = new Thickness(0, 0, 0, 5) };
            Grid.SetRow(numberLabel, 0);
            grid.Children.Add(numberLabel);

            _numberTextBox = new TextBox { Text = Module.ModuleNumber.ToString(), Margin = new Thickness(0, 25, 0, 15) };
            Grid.SetRow(_numberTextBox, 0);
            grid.Children.Add(_numberTextBox);

            var nameLabel = new TextBlock { Text = "Название модуля:", Margin = new Thickness(0, 0, 0, 5) };
            Grid.SetRow(nameLabel, 1);
            grid.Children.Add(nameLabel);

            _nameTextBox = new TextBox { Text = Module.ModuleName, Margin = new Thickness(0, 25, 0, 15) };
            Grid.SetRow(_nameTextBox, 1);
            grid.Children.Add(_nameTextBox);

            var hoursLabel = new TextBlock { Text = "Часы (необязательно):", Margin = new Thickness(0, 0, 0, 5) };
            Grid.SetRow(hoursLabel, 2);
            grid.Children.Add(hoursLabel);

            _hoursTextBox = new TextBox { Text = Module.Hours?.ToString() ?? string.Empty, Margin = new Thickness(0, 25, 0, 15) };
            Grid.SetRow(_hoursTextBox, 2);
            grid.Children.Add(_hoursTextBox);

            var descLabel = new TextBlock { Text = "Описание (необязательно):", Margin = new Thickness(0, 0, 0, 5) };
            Grid.SetRow(descLabel, 3);
            grid.Children.Add(descLabel);

            _descriptionTextBox = new TextBox
            {
                Text = Module.Description ?? string.Empty,
                TextWrapping = TextWrapping.Wrap,
                AcceptsReturn = true,
                VerticalScrollBarVisibility = ScrollBarVisibility.Auto,
                Margin = new Thickness(0, 25, 0, 15)
            };
            Grid.SetRow(_descriptionTextBox, 3);
            grid.Children.Add(_descriptionTextBox);

            var buttonsPanel = new StackPanel
            {
                Orientation = Orientation.Horizontal,
                HorizontalAlignment = HorizontalAlignment.Right
            };
            Grid.SetRow(buttonsPanel, 4);

            var saveButton = new Button
            {
                Content = "Сохранить",
                Width = 100,
                Margin = new Thickness(0, 0, 10, 0),
                IsDefault = true
            };
            saveButton.Click += SaveButton_Click;
            buttonsPanel.Children.Add(saveButton);

            var cancelButton = new Button
            {
                Content = "Отмена",
                Width = 100,
                IsCancel = true
            };
            cancelButton.Click += (_, _) => Close();
            buttonsPanel.Children.Add(cancelButton);

            grid.Children.Add(buttonsPanel);
            Content = grid;
        }

        private void SaveButton_Click(object sender, RoutedEventArgs e)
        {
            if (string.IsNullOrWhiteSpace(_nameTextBox.Text))
            {
                MessageBox.Show("Введите название модуля!", "Ошибка", MessageBoxButton.OK, MessageBoxImage.Warning);
                return;
            }

            if (!int.TryParse(_numberTextBox.Text, out var number) || number < 1)
            {
                MessageBox.Show("Введите корректный номер модуля!", "Ошибка", MessageBoxButton.OK, MessageBoxImage.Warning);
                return;
            }

            Module!.ModuleNumber = number;
            Module.ModuleName = _nameTextBox.Text.Trim();
            Module.Description = string.IsNullOrWhiteSpace(_descriptionTextBox.Text) ? null : _descriptionTextBox.Text.Trim();

            if (int.TryParse(_hoursTextBox.Text, out var hours) && hours > 0)
            {
                Module.Hours = hours;
            }
            else
            {
                Module.Hours = null;
            }

            DialogResult = true;
            Close();
        }
    }
}
