using System;
using System.Linq;
using System.Windows;
using Contract2512.Models;
using Contract2512.Services;
using Microsoft.EntityFrameworkCore;
using MessageBox = System.Windows.MessageBox;
using MessageBoxButton = System.Windows.MessageBoxButton;
using MessageBoxImage = System.Windows.MessageBoxImage;
using MessageBoxResult = System.Windows.MessageBoxResult;
using Wpf.Ui.Controls;

namespace Contract2512.Views
{
    public partial class HolidayCalendarWindow : FluentWindow
    {
        public HolidayCalendarWindow()
        {
            InitializeComponent();
            EnsureHolidayTableCreated();
            LoadHolidays();
            HolidayDatePicker.SelectedDate = DateTime.Today;
        }

        private void LoadHolidays()
        {
            try
            {
                using var db = new AppDbContext();
                HolidayListBox.ItemsSource = db.HolidayCalendarDays
                    .AsNoTracking()
                    .OrderBy(h => h.HolidayDate)
                    .ToList();
            }
            catch (Exception ex)
            {
                MessageBox.Show(
                    $"Ошибка при загрузке календаря праздников: {ex.Message}",
                    "Ошибка",
                    MessageBoxButton.OK,
                    MessageBoxImage.Error);
            }
        }

        private void AddHolidayButton_Click(object sender, RoutedEventArgs e)
        {
            if (!HolidayDatePicker.SelectedDate.HasValue)
            {
                MessageBox.Show(
                    "Укажите дату нерабочего дня.",
                    "Внимание",
                    MessageBoxButton.OK,
                    MessageBoxImage.Warning);
                return;
            }

            var holidayDate = HolidayDatePicker.SelectedDate.Value.Date;
            var holidayName = string.IsNullOrWhiteSpace(HolidayNameTextBox.Text)
                ? "Праздничный день"
                : HolidayNameTextBox.Text.Trim();

            try
            {
                using var db = new AppDbContext();
                EnsureHolidayTableCreated(db);

                var existing = db.HolidayCalendarDays.FirstOrDefault(h => h.HolidayDate == holidayDate);
                if (existing != null)
                {
                    existing.HolidayName = holidayName;
                }
                else
                {
                    db.HolidayCalendarDays.Add(new HolidayCalendarDay
                    {
                        HolidayDate = holidayDate,
                        HolidayName = holidayName,
                        CreatedAt = DateTime.Now
                    });
                }

                db.SaveChanges();
                HolidayNameTextBox.Clear();
                LoadHolidays();
            }
            catch (Exception ex)
            {
                MessageBox.Show(
                    $"Ошибка при сохранении праздничного дня: {ex.Message}",
                    "Ошибка",
                    MessageBoxButton.OK,
                    MessageBoxImage.Error);
            }
        }

        private void DeleteHolidayButton_Click(object sender, RoutedEventArgs e)
        {
            if (sender is not FrameworkElement element || element.Tag is not long holidayId)
            {
                return;
            }

            var result = MessageBox.Show(
                "Удалить выбранный нерабочий день из календаря?",
                "Подтверждение",
                MessageBoxButton.YesNo,
                MessageBoxImage.Question);

            if (result != MessageBoxResult.Yes)
            {
                return;
            }

            try
            {
                using var db = new AppDbContext();
                var holiday = db.HolidayCalendarDays.Find(holidayId);
                if (holiday == null)
                {
                    return;
                }

                db.HolidayCalendarDays.Remove(holiday);
                db.SaveChanges();
                LoadHolidays();
            }
            catch (Exception ex)
            {
                MessageBox.Show(
                    $"Ошибка при удалении праздничного дня: {ex.Message}",
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

        private void EnsureHolidayTableCreated()
        {
            using var db = new AppDbContext();
            EnsureHolidayTableCreated(db);
        }

        private static void EnsureHolidayTableCreated(AppDbContext db)
        {
            db.Database.ExecuteSqlRaw(
                """
                CREATE TABLE IF NOT EXISTS public.holiday_calendar_day
                (
                    id BIGINT GENERATED BY DEFAULT AS IDENTITY PRIMARY KEY,
                    holiday_date DATE NOT NULL,
                    holiday_name VARCHAR(255) NULL,
                    created_at TIMESTAMP WITHOUT TIME ZONE NOT NULL DEFAULT NOW()
                );

                CREATE UNIQUE INDEX IF NOT EXISTS ix_holiday_calendar_day_holiday_date
                    ON public.holiday_calendar_day(holiday_date);
                """);
        }
    }
}
