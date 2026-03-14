using System;
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
    public partial class PersonWindow : FluentWindow
    {
        private Person _person;
        private bool _isEditMode;

        public PersonWindow(Person person = null)
        {
            InitializeComponent();
            _person = person;
            _isEditMode = person != null;
            LoadData();
        }

        private void LoadData()
        {
            using (var db = new AppDbContext())
            {
                // Загружаем список полов
                GenderComboBox.ItemsSource = db.Genders.ToList();
                
                // Устанавливаем пол по умолчанию только для нового лица
                if (!_isEditMode)
                {
                    GenderComboBox.SelectedIndex = 0;
                }

                // Загружаем справочники образования
                BaseEducationComboBox.ItemsSource = db.BaseEducations.ToList();
                EducationLevelComboBox.ItemsSource = db.EducationLevels.ToList();

                // Добавляем обработчики для открытия ComboBox при клике на поле
                GenderComboBox.PreviewMouseLeftButtonDown += ComboBox_PreviewMouseLeftButtonDown;
                BaseEducationComboBox.PreviewMouseLeftButtonDown += ComboBox_PreviewMouseLeftButtonDown;
                EducationLevelComboBox.PreviewMouseLeftButtonDown += ComboBox_PreviewMouseLeftButtonDown;

                if (_isEditMode && _person != null)
                {
                    // Заполняем поля данными существующего лица
                    LastNameTextBox.Text = _person.LastName;
                    FirstNameTextBox.Text = _person.FirstName;
                    PatronymicTextBox.Text = _person.Patronymic ?? "";
                    DateOfBirthPicker.SelectedDate = _person.DateOfBirth;
                    
                    // Устанавливаем пол для редактирования
                    GenderComboBox.SelectedValue = _person.GenderId;
                    
                    PlaceOfBirthTextBox.Text = _person.PlaceOfBirth ?? "";
                    CitizenshipTextBox.Text = _person.Citizenship;
                    SnilsTextBox.Text = _person.Snils;
                    InnTextBox.Text = _person.Inn ?? "";
                    WorkplaceTextBox.Text = _person.Workplace ?? "";

                    // Загружаем паспорт
                    var passport = db.Passports.FirstOrDefault(p => p.PersonId == _person.Id);
                    if (passport != null)
                    {
                        PassportSeriesTextBox.Text = passport.Series;
                        PassportNumberTextBox.Text = passport.Number;
                        IssuanceDatePicker.SelectedDate = passport.IssuanceDate;
                        IssuedByTextBox.Text = passport.IssuedBy;
                        DivisionCodeTextBox.Text = passport.DivisionCode;
                        RegistrationDatePicker.SelectedDate = passport.RegistrationDate;
                        RegistrationAddressTextBox.Text = passport.RegistrationAddress ?? "";
                    }

                    // Загружаем контакты
                    if (_person.ContactsId.HasValue)
                    {
                        var contacts = db.Contacts.Find(_person.ContactsId.Value);
                        if (contacts != null)
                        {
                            PostalCodeTextBox.Text = contacts.PostalCode ?? "";
                            RegionTextBox.Text = contacts.Region ?? "";
                            CityTextBox.Text = contacts.City ?? "";
                            ResidenceAddressTextBox.Text = contacts.ResidenceAddress ?? "";
                            ContactPhoneTextBox.Text = contacts.ContactPhone;
                            EmailTextBox.Text = contacts.Email ?? "";
                            HomePhoneTextBox.Text = contacts.HomePhone ?? "";
                            WorkPhoneTextBox.Text = contacts.WorkPhone ?? "";
                        }
                    }

                    // Загружаем образование (берем первое, если есть несколько)
                    var education = db.Educations.FirstOrDefault(e => e.PersonId == _person.Id);
                    if (education != null)
                    {
                        EnrollmentDatePicker.SelectedDate = education.EnrollmentDate;
                        if (education.BaseEducationId.HasValue)
                        {
                            BaseEducationComboBox.SelectedValue = education.BaseEducationId.Value;
                        }
                        if (education.EducationLevelId.HasValue)
                        {
                            EducationLevelComboBox.SelectedValue = education.EducationLevelId.Value;
                        }
                        EducationSeriesTextBox.Text = education.Series ?? "";
                        EducationNumberTextBox.Text = education.Number;
                        EducationIssueDatePicker.SelectedDate = education.IssueDate;
                        EducationIssuedByTextBox.Text = education.IssuedBy;
                        EducationPlaceOfIssueTextBox.Text = education.PlaceOfIssue;
                        EducationCityTextBox.Text = education.City ?? "";
                        EducationSpecialtyTextBox.Text = education.Specialty ?? "";
                    }
                }
            }
        }

        private void SaveButton_Click(object sender, RoutedEventArgs e)
        {
            // Валидация - только Фамилия и Имя обязательны
            if (string.IsNullOrWhiteSpace(LastNameTextBox.Text) ||
                string.IsNullOrWhiteSpace(FirstNameTextBox.Text))
            {
                MessageBox.Show("Заполните Фамилию и Имя!", "Ошибка", MessageBoxButton.OK, MessageBoxImage.Warning);
                return;
            }

            // Валидация СНИЛС
            if (!string.IsNullOrWhiteSpace(SnilsTextBox.Text))
            {
                string snils = SnilsTextBox.Text.Replace("-", "").Replace(" ", "").Trim();
                
                if (snils.Length != 11)
                {
                    MessageBox.Show(
                        $"СНИЛС должен содержать 11 цифр!\n\n" +
                        $"Введено: {snils.Length} цифр\n" +
                        $"Формат: XXX-XXX-XXX XX или 11 цифр подряд",
                        "Ошибка валидации СНИЛС",
                        MessageBoxButton.OK,
                        MessageBoxImage.Warning);
                    SnilsTextBox.Focus();
                    return;
                }
                
                if (!snils.All(char.IsDigit))
                {
                    MessageBox.Show(
                        "СНИЛС должен содержать только цифры!\n\n" +
                        "Формат: XXX-XXX-XXX XX или 11 цифр подряд",
                        "Ошибка валидации СНИЛС",
                        MessageBoxButton.OK,
                        MessageBoxImage.Warning);
                    SnilsTextBox.Focus();
                    return;
                }
            }

            try
            {
                using (var db = new AppDbContext())
                {
                    if (_isEditMode && _person != null)
                    {
                        // Обновление существующего лица
                        var person = db.Persons.Find(_person.Id);
                        if (person != null)
                        {
                            UpdatePersonData(person, db);
                            db.SaveChanges();
                        }
                    }
                    else
                    {
                        // Создание нового лица
                        var person = new Person();
                        db.Persons.Add(person);
                        UpdatePersonData(person, db);
                        db.SaveChanges();
                    }
                    MessageBox.Show("Данные успешно сохранены!", "Успех", MessageBoxButton.OK, MessageBoxImage.Information);
                    DialogResult = true;
                    Close();
                }
            }
            catch (Exception ex)
            {
                string errorMessage = $"Ошибка при сохранении: {ex.Message}";
                
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

        private void UpdatePersonData(Person person, AppDbContext db)
        {
            // Устанавливаем CreatedAt только для новых записей
            if (person.Id == 0)
            {
                person.CreatedAt = DateTime.Now;
            }

            person.LastName = LastNameTextBox.Text;
            person.FirstName = FirstNameTextBox.Text;
            person.Patronymic = string.IsNullOrWhiteSpace(PatronymicTextBox.Text) ? null : PatronymicTextBox.Text;
            person.DateOfBirth = DateOfBirthPicker.SelectedDate;
            person.GenderId = GenderComboBox.SelectedItem != null ? ((Gender)GenderComboBox.SelectedItem).Id : null;
            person.PlaceOfBirth = string.IsNullOrWhiteSpace(PlaceOfBirthTextBox.Text) ? null : PlaceOfBirthTextBox.Text;
            person.Citizenship = string.IsNullOrWhiteSpace(CitizenshipTextBox.Text) ? null : CitizenshipTextBox.Text;
            person.Snils = string.IsNullOrWhiteSpace(SnilsTextBox.Text) ? null : SnilsTextBox.Text;
            person.Inn = string.IsNullOrWhiteSpace(InnTextBox.Text) ? null : InnTextBox.Text;
            person.Workplace = string.IsNullOrWhiteSpace(WorkplaceTextBox.Text) ? null : WorkplaceTextBox.Text;
            person.UpdatedAt = DateTime.Now;

            // Обновляем или создаем контакты - только если есть данные
            bool hasContactData = !string.IsNullOrWhiteSpace(PostalCodeTextBox.Text) ||
                                 !string.IsNullOrWhiteSpace(RegionTextBox.Text) ||
                                 !string.IsNullOrWhiteSpace(CityTextBox.Text) ||
                                 !string.IsNullOrWhiteSpace(ResidenceAddressTextBox.Text) ||
                                 !string.IsNullOrWhiteSpace(ContactPhoneTextBox.Text) ||
                                 !string.IsNullOrWhiteSpace(EmailTextBox.Text) ||
                                 !string.IsNullOrWhiteSpace(HomePhoneTextBox.Text) ||
                                 !string.IsNullOrWhiteSpace(WorkPhoneTextBox.Text);

            Contacts contacts;
            if (hasContactData)
            {
                if (person.ContactsId.HasValue)
                {
                    contacts = db.Contacts.Find(person.ContactsId.Value);
                }
                else
                {
                    contacts = new Contacts();
                    db.Contacts.Add(contacts);
                }

                contacts.PostalCode = string.IsNullOrWhiteSpace(PostalCodeTextBox.Text) ? null : PostalCodeTextBox.Text;
                contacts.Region = string.IsNullOrWhiteSpace(RegionTextBox.Text) ? null : RegionTextBox.Text;
                contacts.City = string.IsNullOrWhiteSpace(CityTextBox.Text) ? null : CityTextBox.Text;
                contacts.ResidenceAddress = string.IsNullOrWhiteSpace(ResidenceAddressTextBox.Text) ? null : ResidenceAddressTextBox.Text;
                contacts.ContactPhone = string.IsNullOrWhiteSpace(ContactPhoneTextBox.Text) ? null : ContactPhoneTextBox.Text;
                contacts.Email = string.IsNullOrWhiteSpace(EmailTextBox.Text) ? null : EmailTextBox.Text;
                contacts.HomePhone = string.IsNullOrWhiteSpace(HomePhoneTextBox.Text) ? null : HomePhoneTextBox.Text;
                contacts.WorkPhone = string.IsNullOrWhiteSpace(WorkPhoneTextBox.Text) ? null : WorkPhoneTextBox.Text;
                contacts.CreatedAt = contacts.CreatedAt ?? DateTime.Now;

                db.SaveChanges(); // Сохраняем контакты, чтобы получить ID
                person.ContactsId = contacts.Id;
            }
            else
            {
                // Если нет данных контактов, удаляем связь
                if (person.ContactsId.HasValue)
                {
                    var existingContacts = db.Contacts.Find(person.ContactsId.Value);
                    if (existingContacts != null)
                    {
                        db.Contacts.Remove(existingContacts);
                    }
                    person.ContactsId = null;
                }
            }

            // Сохраняем изменения, чтобы получить ID для person (если это новый)
            db.SaveChanges();

            // Обновляем или создаем паспорт - только если есть данные
            bool hasPassportData = !string.IsNullOrWhiteSpace(PassportSeriesTextBox.Text) ||
                                   !string.IsNullOrWhiteSpace(PassportNumberTextBox.Text) ||
                                   IssuanceDatePicker.SelectedDate.HasValue ||
                                   !string.IsNullOrWhiteSpace(IssuedByTextBox.Text) ||
                                   !string.IsNullOrWhiteSpace(DivisionCodeTextBox.Text) ||
                                   RegistrationDatePicker.SelectedDate.HasValue ||
                                   !string.IsNullOrWhiteSpace(RegistrationAddressTextBox.Text);

            if (hasPassportData)
            {
                var passport = db.Passports.FirstOrDefault(p => p.PersonId == person.Id);
                if (passport == null)
                {
                    passport = new Passport { PersonId = person.Id };
                    db.Passports.Add(passport);
                }

                passport.Series = string.IsNullOrWhiteSpace(PassportSeriesTextBox.Text) ? null : PassportSeriesTextBox.Text;
                passport.Number = string.IsNullOrWhiteSpace(PassportNumberTextBox.Text) ? null : PassportNumberTextBox.Text;
                passport.IssuanceDate = IssuanceDatePicker.SelectedDate;
                passport.IssuedBy = string.IsNullOrWhiteSpace(IssuedByTextBox.Text) ? null : IssuedByTextBox.Text;
                passport.DivisionCode = string.IsNullOrWhiteSpace(DivisionCodeTextBox.Text) ? null : DivisionCodeTextBox.Text;
                passport.RegistrationDate = RegistrationDatePicker.SelectedDate;
                passport.RegistrationAddress = string.IsNullOrWhiteSpace(RegistrationAddressTextBox.Text) ? null : RegistrationAddressTextBox.Text;
                passport.CreatedAt = passport.CreatedAt ?? DateTime.Now;
            }
            else
            {
                // Если нет данных паспорта, удаляем существующий паспорт
                var existingPassport = db.Passports.FirstOrDefault(p => p.PersonId == person.Id);
                if (existingPassport != null)
                {
                    db.Passports.Remove(existingPassport);
                }
            }

            // Обновляем или создаем образование - только если есть данные
            bool hasEducationData = EnrollmentDatePicker.SelectedDate.HasValue ||
                                   !string.IsNullOrWhiteSpace(EducationNumberTextBox.Text) ||
                                   EducationIssueDatePicker.SelectedDate.HasValue ||
                                   !string.IsNullOrWhiteSpace(EducationIssuedByTextBox.Text) ||
                                   !string.IsNullOrWhiteSpace(EducationPlaceOfIssueTextBox.Text) ||
                                   !string.IsNullOrWhiteSpace(EducationCityTextBox.Text) ||
                                   !string.IsNullOrWhiteSpace(EducationSpecialtyTextBox.Text);

            if (hasEducationData)
            {
                var education = db.Educations.FirstOrDefault(e => e.PersonId == person.Id);
                if (education == null)
                {
                    education = new Education { PersonId = person.Id };
                    db.Educations.Add(education);
                }

                education.EnrollmentDate = EnrollmentDatePicker.SelectedDate;
                education.BaseEducationId = BaseEducationComboBox.SelectedValue != null
                    ? (short?)BaseEducationComboBox.SelectedValue
                    : null;
                education.EducationLevelId = EducationLevelComboBox.SelectedValue != null
                    ? (short?)EducationLevelComboBox.SelectedValue
                    : null;
                education.Series = string.IsNullOrWhiteSpace(EducationSeriesTextBox.Text) ? null : EducationSeriesTextBox.Text;
                education.Number = string.IsNullOrWhiteSpace(EducationNumberTextBox.Text) ? null : EducationNumberTextBox.Text;
                education.IssueDate = EducationIssueDatePicker.SelectedDate;
                education.IssuedBy = string.IsNullOrWhiteSpace(EducationIssuedByTextBox.Text) ? null : EducationIssuedByTextBox.Text;
                education.PlaceOfIssue = string.IsNullOrWhiteSpace(EducationPlaceOfIssueTextBox.Text) ? null : EducationPlaceOfIssueTextBox.Text;
                education.City = string.IsNullOrWhiteSpace(EducationCityTextBox.Text) ? null : EducationCityTextBox.Text;
                education.Specialty = string.IsNullOrWhiteSpace(EducationSpecialtyTextBox.Text) ? null : EducationSpecialtyTextBox.Text;
                education.CreatedAt = education.CreatedAt ?? DateTime.Now;
            }
            else
            {
                // Если нет данных образования, удаляем существующее образование
                var existingEducation = db.Educations.FirstOrDefault(e => e.PersonId == person.Id);
                if (existingEducation != null)
                {
                    db.Educations.Remove(existingEducation);
                }
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

