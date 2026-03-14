using System.Windows;
using System.Windows.Controls;
using System.Windows.Markup;
using MessageBox = System.Windows.MessageBox;
using MessageBoxButton = System.Windows.MessageBoxButton;
using MessageBoxImage = System.Windows.MessageBoxImage;
using FluentWindow = Wpf.Ui.Controls.FluentWindow;

namespace Contract2512.Views
{
    public partial class TeacherDialog : FluentWindow
    {
        public string TeacherName { get; private set; } = string.Empty;

        public TeacherDialog()
        {
            InitializeComponent();
        }

        private void InitializeComponent()
        {
            Title = "Добавить преподавателя";
            WindowStartupLocation = WindowStartupLocation.CenterOwner;
            Width = 400;
            Height = 200;
            ExtendsContentIntoTitleBar = true;

            var grid = new Grid();
            grid.Background = new System.Windows.Media.LinearGradientBrush(
                System.Windows.Media.Color.FromRgb(30, 27, 75),
                System.Windows.Media.Color.FromRgb(15, 23, 42),
                new Point(0, 0),
                new Point(1, 1));

            grid.RowDefinitions.Add(new RowDefinition { Height = new GridLength(32) });
            grid.RowDefinitions.Add(new RowDefinition { Height = new GridLength(1, GridUnitType.Star) });

            var titleBar = new Grid();
            titleBar.MouseDown += (_, e) =>
            {
                if (e.ChangedButton == System.Windows.Input.MouseButton.Left)
                {
                    DragMove();
                }
            };

            titleBar.Children.Add(new System.Windows.Controls.TextBlock
            {
                Text = "Добавить преподавателя",
                Foreground = System.Windows.Media.Brushes.White,
                VerticalAlignment = VerticalAlignment.Center,
                Margin = new Thickness(12, 0, 0, 0)
            });
            Grid.SetRow(titleBar, 0);
            grid.Children.Add(titleBar);

            var contentBorder = new Border
            {
                Margin = new Thickness(20),
                Background = new System.Windows.Media.SolidColorBrush(System.Windows.Media.Color.FromRgb(30, 41, 59)) { Opacity = 0.32 },
                CornerRadius = new CornerRadius(12),
                BorderBrush = new System.Windows.Media.SolidColorBrush(System.Windows.Media.Color.FromRgb(71, 85, 105)),
                BorderThickness = new Thickness(1)
            };

            var contentGrid = new Grid { Margin = new Thickness(20) };
            contentGrid.RowDefinitions.Add(new RowDefinition { Height = GridLength.Auto });
            contentGrid.RowDefinitions.Add(new RowDefinition { Height = GridLength.Auto });
            contentGrid.RowDefinitions.Add(new RowDefinition { Height = new GridLength(1, GridUnitType.Star) });
            contentGrid.RowDefinitions.Add(new RowDefinition { Height = GridLength.Auto });

            contentGrid.Children.Add(new System.Windows.Controls.TextBlock
            {
                Text = "ФИО преподавателя:",
                FontSize = 14,
                Foreground = new System.Windows.Media.SolidColorBrush(System.Windows.Media.Color.FromRgb(209, 213, 219)),
                Margin = new Thickness(0, 0, 0, 5)
            });

            var textBox = new System.Windows.Controls.TextBox
            {
                FontSize = 14,
                Padding = new Thickness(8, 6, 8, 6),
                Background = new System.Windows.Media.SolidColorBrush(System.Windows.Media.Color.FromRgb(30, 41, 59)) { Opacity = 0.4 },
                Foreground = System.Windows.Media.Brushes.White,
                BorderBrush = new System.Windows.Media.SolidColorBrush(System.Windows.Media.Color.FromRgb(100, 116, 139)),
                BorderThickness = new Thickness(1),
                CaretBrush = System.Windows.Media.Brushes.White,
                FocusVisualStyle = null,
                Style = CreateDarkTextBoxStyle()
            };
            Grid.SetRow(textBox, 1);
            contentGrid.Children.Add(textBox);

            var buttonPanel = new StackPanel
            {
                Orientation = Orientation.Horizontal,
                HorizontalAlignment = HorizontalAlignment.Right,
                Margin = new Thickness(0, 15, 0, 0)
            };

            var okButton = CreateDialogButton("Добавить");
            okButton.Margin = new Thickness(0, 0, 10, 0);
            okButton.Click += (_, _) =>
            {
                if (string.IsNullOrWhiteSpace(textBox.Text))
                {
                    MessageBox.Show("Введите ФИО преподавателя.", "Внимание", MessageBoxButton.OK, MessageBoxImage.Warning);
                    return;
                }

                TeacherName = textBox.Text.Trim();
                DialogResult = true;
                Close();
            };

            var cancelButton = CreateDialogButton("Отмена");
            cancelButton.Click += (_, _) =>
            {
                DialogResult = false;
                Close();
            };

            buttonPanel.Children.Add(okButton);
            buttonPanel.Children.Add(cancelButton);
            Grid.SetRow(buttonPanel, 3);
            contentGrid.Children.Add(buttonPanel);

            contentBorder.Child = contentGrid;
            Grid.SetRow(contentBorder, 1);
            grid.Children.Add(contentBorder);

            Content = grid;
        }

        private static System.Windows.Controls.Button CreateDialogButton(string text)
        {
            return new System.Windows.Controls.Button
            {
                Content = text,
                Padding = new Thickness(16, 10, 16, 10),
                Background = new System.Windows.Media.SolidColorBrush(System.Windows.Media.Color.FromRgb(75, 85, 99)) { Opacity = 0.3 },
                Foreground = System.Windows.Media.Brushes.White,
                BorderThickness = new Thickness(0),
                Cursor = System.Windows.Input.Cursors.Hand,
                FontWeight = FontWeights.SemiBold,
                FontSize = 14
            };
        }

        private static Style CreateDarkTextBoxStyle()
        {
            return (Style)XamlReader.Parse(
                """
                <Style xmlns="http://schemas.microsoft.com/winfx/2006/xaml/presentation"
                       xmlns:x="http://schemas.microsoft.com/winfx/2006/xaml"
                       TargetType="TextBox">
                    <Setter Property="Background" Value="#661E293B"/>
                    <Setter Property="Foreground" Value="White"/>
                    <Setter Property="BorderBrush" Value="#64748B"/>
                    <Setter Property="BorderThickness" Value="1"/>
                    <Setter Property="Padding" Value="8,6"/>
                    <Setter Property="FocusVisualStyle" Value="{x:Null}"/>
                    <Setter Property="Template">
                        <Setter.Value>
                            <ControlTemplate TargetType="TextBox">
                                <Border Background="{TemplateBinding Background}"
                                        BorderBrush="{TemplateBinding BorderBrush}"
                                        BorderThickness="{TemplateBinding BorderThickness}"
                                        CornerRadius="6"
                                        Padding="{TemplateBinding Padding}">
                                    <ScrollViewer x:Name="PART_ContentHost"
                                                  Background="Transparent"
                                                  Foreground="{TemplateBinding Foreground}"/>
                                </Border>
                            </ControlTemplate>
                        </Setter.Value>
                    </Setter>
                </Style>
                """);
        }
    }
}
