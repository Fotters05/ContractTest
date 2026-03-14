using System;
using System.Linq;
using System.Text.RegularExpressions;
using System.Windows;
using Microsoft.EntityFrameworkCore;
using Contract2512.Models;
using Contract2512.Services;
using Wpf.Ui.Controls;
using MessageBox = System.Windows.MessageBox;
using MessageBoxButton = System.Windows.MessageBoxButton;
using MessageBoxImage = System.Windows.MessageBoxImage;

namespace Contract2512.Views
{
    public partial class OrganizationEditWindow : FluentWindow
    {
        private Organization _organization;
        private bool _isEditMode;

        public OrganizationEditWindow(Organization organization = null)
        {
            InitializeComponent();
            
            _isEditMode = organization != null;
            _organization = organization;

            if (_isEditMode)
            {
                Title = "Редактирование организации";
                LoadOrganizationData();
            }
            else
            {
                Title = "Добавление организации";
            }
        }

        private void LoadOrganizationData()
        {
            OrganizationNameTextBox.Text = _organization.OrganizationName;
            DirectorFioTextBox.Text = _organization.DirectorFio;
            OgrnTextBox.Text = _organization.Ogrn;
            InnTextBox.Text = _organization.Inn;
            KppTextBox.Text = _organization.Kpp;
            LegalAddressTextBox.Text = _organization.LegalAddress;
            EmailTextBox.Text = _organization.Email;
            PhoneTextBox.Text = _organization.Phone;
        }

        private void SaveButton_Click(object sender, RoutedEventArgs e)
        {
            // Валидация
            if (string.IsNullOrWhiteSpace(OrganizationNameTextBox.Text))
            {
                MessageBox.Show("Введите название организации!", "Ошибка", MessageBoxButton.OK, MessageBoxImage.Warning);
                return;
            }

            if (string.IsNullOrWhiteSpace(DirectorFioTextBox.Text))
            {
                MessageBox.Show("Введите ФИО директора!", "Ошибка", MessageBoxButton.OK, MessageBoxImage.Warning);
                return;
            }

            if (string.IsNullOrWhiteSpace(OgrnTextBox.Text) || !Regex.IsMatch(OgrnTextBox.Text, @"^\d{13}$"))
            {
                MessageBox.Show("ОГРН должен содержать ровно 13 цифр!", "Ошибка", MessageBoxButton.OK, MessageBoxImage.Warning);
                return;
            }

            if (string.IsNullOrWhiteSpace(InnTextBox.Text) || !Regex.IsMatch(InnTextBox.Text, @"^\d{10}$"))
            {
                MessageBox.Show("ИНН должен содержать ровно 10 цифр!", "Ошибка", MessageBoxButton.OK, MessageBoxImage.Warning);
                return;
            }

            if (string.IsNullOrWhiteSpace(KppTextBox.Text) || !Regex.IsMatch(KppTextBox.Text, @"^\d{9}$"))
            {
                MessageBox.Show("КПП должен содержать ровно 9 цифр!", "Ошибка", MessageBoxButton.OK, MessageBoxImage.Warning);
                return;
            }

            if (string.IsNullOrWhiteSpace(LegalAddressTextBox.Text))
            {
                MessageBox.Show("Введите юридический адрес!", "Ошибка", MessageBoxButton.OK, MessageBoxImage.Warning);
                return;
            }

            try
            {
                using (var db = new AppDbContext())
                {
                    if (_isEditMode)
                    {
                        // Редактирование существующей организации
                        var orgToUpdate = db.Organizations.Find(_organization.Id);
                        if (orgToUpdate != null)
                        {
                            orgToUpdate.OrganizationName = OrganizationNameTextBox.Text.Trim();
                            orgToUpdate.DirectorFio = DirectorFioTextBox.Text.Trim();
                            orgToUpdate.Ogrn = OgrnTextBox.Text.Trim();
                            orgToUpdate.Inn = InnTextBox.Text.Trim();
                            orgToUpdate.Kpp = KppTextBox.Text.Trim();
                            orgToUpdate.LegalAddress = LegalAddressTextBox.Text.Trim();
                            orgToUpdate.Email = string.IsNullOrWhiteSpace(EmailTextBox.Text) ? null : EmailTextBox.Text.Trim();
                            orgToUpdate.Phone = string.IsNullOrWhiteSpace(PhoneTextBox.Text) ? null : PhoneTextBox.Text.Trim();
                            orgToUpdate.UpdatedAt = DateTime.Now;

                            db.SaveChanges();
                            MessageBox.Show("Организация успешно обновлена!", "Успех", MessageBoxButton.OK, MessageBoxImage.Information);
                        }
                    }
                    else
                    {
                        // Создание новой организации
                        var organization = new Organization
                        {
                            OrganizationName = OrganizationNameTextBox.Text.Trim(),
                            DirectorFio = DirectorFioTextBox.Text.Trim(),
                            Ogrn = OgrnTextBox.Text.Trim(),
                            Inn = InnTextBox.Text.Trim(),
                            Kpp = KppTextBox.Text.Trim(),
                            LegalAddress = LegalAddressTextBox.Text.Trim(),
                            Email = string.IsNullOrWhiteSpace(EmailTextBox.Text) ? null : EmailTextBox.Text.Trim(),
                            Phone = string.IsNullOrWhiteSpace(PhoneTextBox.Text) ? null : PhoneTextBox.Text.Trim(),
                            CreatedAt = DateTime.Now
                        };

                        db.Organizations.Add(organization);
                        db.SaveChanges();

                        MessageBox.Show("Организация успешно добавлена!", "Успех", MessageBoxButton.OK, MessageBoxImage.Information);
                    }

                    DialogResult = true;
                    Close();
                }
            }
            catch (Exception ex)
            {
                string errorMessage = $"Ошибка при сохранении организации: {ex.Message}";
                
                if (ex.InnerException != null)
                {
                    errorMessage += $"\n\nВнутренняя ошибка: {ex.InnerException.Message}";
                    
                    if (ex.InnerException.InnerException != null)
                    {
                        errorMessage += $"\n\nДетали: {ex.InnerException.InnerException.Message}";
                    }
                }
                
                MessageBox.Show(errorMessage, "Ошибка", MessageBoxButton.OK, MessageBoxImage.Error);
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
    }
}
