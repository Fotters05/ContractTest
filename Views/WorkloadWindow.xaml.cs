using System;
using System.Collections.Generic;
using System.IO;
using System.Linq;
using System.Text.RegularExpressions;
using System.Windows;
using System.Windows.Controls;
using Contract2512.Models;
using Contract2512.Services;
using Microsoft.EntityFrameworkCore;
using MessageBox = System.Windows.MessageBox;
using MessageBoxButton = System.Windows.MessageBoxButton;
using MessageBoxImage = System.Windows.MessageBoxImage;
using FluentWindow = Wpf.Ui.Controls.FluentWindow;

namespace Contract2512.Views
{
    public partial class WorkloadWindow : FluentWindow
    {
        private List<Contract> _availableContracts = new();
        private List<Contract> _selectedContracts = new();

        public WorkloadWindow()
        {
            InitializeComponent();
            LoadData();
            UpdateSelectedListenersSummary();
        }

        private void LoadData()
        {
            LoadPrograms();
            LoadTeachers();
        }

        private void LoadPrograms()
        {
            try
            {
                using var db = new AppDbContext();
                ProgramComboBox.ItemsSource = db.LearningPrograms
                    .AsNoTracking()
                    .OrderBy(p => p.Name)
                    .ToList();
            }
            catch (Exception ex)
            {
                MessageBox.Show($"Ошибка при загрузке программ: {ex.Message}", "Ошибка", MessageBoxButton.OK, MessageBoxImage.Error);
            }
        }

        private void LoadTeachers()
        {
            try
            {
                using var db = new AppDbContext();
                TeacherComboBox.ItemsSource = db.Teachers
                    .AsNoTracking()
                    .OrderBy(t => t.FullName)
                    .ToList();
            }
            catch (Exception ex)
            {
                MessageBox.Show($"Ошибка при загрузке преподавателей: {ex.Message}", "Ошибка", MessageBoxButton.OK, MessageBoxImage.Error);
            }
        }

        private void ProgramComboBox_SelectionChanged(object sender, SelectionChangedEventArgs e)
        {
            if (ProgramComboBox.SelectedItem is not LearningProgram selectedProgram)
            {
                ProgramInfoTextBlock.Text = "Выберите программу обучения";
                GroupNamePanel.Visibility = Visibility.Collapsed;
                _availableContracts.Clear();
                _selectedContracts.Clear();
                UpdateSelectedListenersSummary();
                GenerateButton.IsEnabled = false;
                return;
            }

            try
            {
                using var db = new AppDbContext();
                var programType = db.ProgramViews
                    .Where(pv => pv.Id == selectedProgram.ProgramViewId)
                    .Select(pv => pv.Name)
                    .FirstOrDefault() ?? "Не указан";

                ProgramInfoTextBlock.Text =
                    $"Название: {selectedProgram.Name}\n" +
                    $"Тип программы: {programType}\n" +
                    $"Формат: {selectedProgram.Format}\n" +
                    $"Объем: {selectedProgram.Hours} академических часов\n" +
                    $"Количество уроков: {selectedProgram.LessonsCount}\n" +
                    $"Цена: {selectedProgram.Price:N2} ₽";

                _availableContracts = db.Contracts
                    .AsNoTracking()
                    .Include(c => c.Listener)
                    .Where(c => c.ProgramId == selectedProgram.Id)
                    .OrderByDescending(c => c.ContractDate)
                    .ToList()
                    .Where(c => c.Listener != null)
                    .GroupBy(c => c.ListenerId)
                    .Select(group => group.First())
                    .OrderBy(c => c.Listener!.LastName)
                    .ThenBy(c => c.Listener!.FirstName)
                    .ToList();
            }
            catch (Exception ex)
            {
                MessageBox.Show($"Ошибка при загрузке договоров слушателей: {ex.Message}", "Ошибка", MessageBoxButton.OK, MessageBoxImage.Error);
                _availableContracts.Clear();
            }

            GroupNamePanel.Visibility = IsGroupProgram(selectedProgram) ? Visibility.Visible : Visibility.Collapsed;
            if (!IsGroupProgram(selectedProgram))
            {
                GroupNameTextBox.Text = string.Empty;
            }

            _selectedContracts.Clear();
            UpdateSelectedListenersSummary();
            GenerateButton.IsEnabled = true;
        }

        private void AddTeacherButton_Click(object sender, RoutedEventArgs e)
        {
            var dialog = new TeacherDialog { Owner = this };
            if (dialog.ShowDialog() != true)
            {
                return;
            }

            try
            {
                using var db = new AppDbContext();
                var teacher = new Teacher { FullName = dialog.TeacherName };
                db.Teachers.Add(teacher);
                db.SaveChanges();
                LoadTeachers();
                TeacherComboBox.SelectedItem = teacher;
                MessageBox.Show("Преподаватель успешно добавлен.", "Успех", MessageBoxButton.OK, MessageBoxImage.Information);
            }
            catch (Exception ex)
            {
                MessageBox.Show($"Ошибка при добавлении преподавателя: {ex.Message}", "Ошибка", MessageBoxButton.OK, MessageBoxImage.Error);
            }
        }

        private void SelectListenersButton_Click(object sender, RoutedEventArgs e)
        {
            if (ProgramComboBox.SelectedItem is not LearningProgram selectedProgram)
            {
                MessageBox.Show("Сначала выберите программу обучения.", "Внимание", MessageBoxButton.OK, MessageBoxImage.Warning);
                return;
            }

            if (_availableContracts.Count == 0)
            {
                MessageBox.Show("Для выбранной программы не найдено договоров слушателей.", "Внимание", MessageBoxButton.OK, MessageBoxImage.Warning);
                return;
            }

            var dialog = new ListenerSelectionDialog(_availableContracts, _selectedContracts, IsGroupProgram(selectedProgram))
            {
                Owner = this
            };

            if (dialog.ShowDialog() == true)
            {
                _selectedContracts = dialog.SelectedContracts;
                UpdateSelectedListenersSummary();
            }
        }

        private void GenerateButton_Click(object sender, RoutedEventArgs e)
        {
            if (ProgramComboBox.SelectedItem is not LearningProgram selectedProgram)
            {
                MessageBox.Show("Выберите программу обучения.", "Внимание", MessageBoxButton.OK, MessageBoxImage.Warning);
                return;
            }

            bool isGroupMode = IsGroupProgram(selectedProgram);
            if (_selectedContracts.Count == 0)
            {
                MessageBox.Show(isGroupMode ? "Для группового режима выберите слушателей." : "Выберите слушателя по договору.", "Внимание", MessageBoxButton.OK, MessageBoxImage.Warning);
                return;
            }

            if (!isGroupMode && _selectedContracts.Count > 1)
            {
                MessageBox.Show("В индивидуальном режиме можно выбрать только одного слушателя.", "Внимание", MessageBoxButton.OK, MessageBoxImage.Warning);
                return;
            }

            var groupName = GroupNameTextBox.Text?.Trim() ?? string.Empty;
            if (isGroupMode && string.IsNullOrWhiteSpace(groupName))
            {
                MessageBox.Show("Укажите название группы для группового режима.", "Внимание", MessageBoxButton.OK, MessageBoxImage.Warning);
                return;
            }

            try
            {
                List<ProgramModule> modules;
                string programType;

                using (var lookupDb = new AppDbContext())
                {
                    programType = lookupDb.ProgramViews
                        .Where(pv => pv.Id == selectedProgram.ProgramViewId)
                        .Select(pv => pv.Name)
                        .FirstOrDefault() ?? string.Empty;

                    modules = lookupDb.ProgramModules
                        .Where(m => m.ProgramId == selectedProgram.Id)
                        .OrderBy(m => m.ModuleNumber)
                        .ToList();
                }

                if (modules.Count == 0)
                {
                    MessageBox.Show("У выбранной программы нет модулей.", "Внимание", MessageBoxButton.OK, MessageBoxImage.Warning);
                    return;
                }

                var templatePath = @"C:\Dogovora\Шаблон формирования учебной нагрузки.xlsx";
                if (!File.Exists(templatePath))
                {
                    MessageBox.Show($"Файл шаблона не найден:\n{templatePath}", "Ошибка", MessageBoxButton.OK, MessageBoxImage.Error);
                    return;
                }

                var documentsFolder = Path.Combine(Environment.GetFolderPath(Environment.SpecialFolder.MyDocuments), "Учебная нагрузка");
                Directory.CreateDirectory(documentsFolder);

                using var db = new AppDbContext();
                EnsureWorkloadTablesCreated(db);

                var now = DateTime.Now;
                var batch = new WorkloadBatch
                {
                    ProgramId = selectedProgram.Id,
                    TeacherId = (TeacherComboBox.SelectedItem as Teacher)?.Id,
                    GroupName = isGroupMode ? groupName : null,
                    IsGroup = isGroupMode,
                    CreatedAt = now
                };

                db.WorkloadBatches.Add(batch);
                db.SaveChanges();

                var generatedFiles = new List<string>();
                var excelService = new ExcelDocumentService();

                foreach (var contract in _selectedContracts)
                {
                    if (contract.Listener == null)
                    {
                        continue;
                    }

                    var targetPath = Path.Combine(documentsFolder, BuildFileName(selectedProgram.Name, contract.Listener.FullName, now, generatedFiles.Count));
                    var replacements = BuildReplacements(selectedProgram, programType, contract, isGroupMode ? groupName : string.Empty);
                    excelService.GenerateWorkloadDocument(templatePath, targetPath, replacements, modules);
                    SaveWorkloadDocumentToDatabase(db, batch, selectedProgram, contract, programType, targetPath, modules, isGroupMode, groupName, now);
                    generatedFiles.Add(targetPath);
                }

                if (generatedFiles.Count == 0)
                {
                    MessageBox.Show("Не удалось сформировать ни одного документа.", "Ошибка", MessageBoxButton.OK, MessageBoxImage.Error);
                    return;
                }

                excelService.OpenDocument(generatedFiles[0]);
                MessageBox.Show(
                    generatedFiles.Count == 1
                        ? $"Документ успешно сформирован:\n{generatedFiles[0]}"
                        : $"Сформировано документов: {generatedFiles.Count}\nПапка: {documentsFolder}",
                    "Успех",
                    MessageBoxButton.OK,
                    MessageBoxImage.Information);

                DialogResult = true;
                Close();
            }
            catch (Exception ex)
            {
                MessageBox.Show($"Ошибка при формировании документов: {ex.Message}", "Ошибка", MessageBoxButton.OK, MessageBoxImage.Error);
            }
        }

        private Dictionary<string, string> BuildReplacements(LearningProgram selectedProgram, string programType, Contract contract, string groupName)
        {
            return new Dictionary<string, string>
            {
                { "{{Program_Name}}", selectedProgram.Name ?? string.Empty },
                { "{{Program_Type}}", programType },
                { "{{Time}}", selectedProgram.Hours.ToString() },
                { "{{Teacher}}", TeacherComboBox.SelectedItem is Teacher teacher ? teacher.FullName : string.Empty },
                { "{{Teatcher}}", TeacherComboBox.SelectedItem is Teacher teacherAlias ? teacherAlias.FullName : string.Empty },
                { "{{FIO_Slushatel}}", contract.Listener?.FullName ?? string.Empty },
                { "{{Group_Name}}", groupName },
                { "{{Date Start}}", contract.StartDate?.ToString("dd.MM.yyyy") ?? string.Empty },
                { "{{Date End}}", contract.EndDate?.ToString("dd.MM.yyyy") ?? string.Empty }
            };
        }

        private void CancelButton_Click(object sender, RoutedEventArgs e)
        {
            DialogResult = false;
            Close();
        }

        private void UpdateSelectedListenersSummary()
        {
            if (_selectedContracts.Count == 0)
            {
                SelectedListenersTextBlock.Text = "Слушатели не выбраны";
                return;
            }

            SelectedListenersTextBlock.Text = string.Join(
                Environment.NewLine,
                _selectedContracts.Where(c => c.Listener != null).Select(c =>
                {
                    string start = c.StartDate?.ToString("dd.MM.yyyy") ?? "без даты";
                    string end = c.EndDate?.ToString("dd.MM.yyyy") ?? "без даты";
                    return $"{c.Listener!.FullName} ({start} - {end})";
                }));
        }

        private static bool IsGroupProgram(LearningProgram program)
        {
            return !string.IsNullOrWhiteSpace(program.Format) &&
                   program.Format.Contains("С преподавателем в группе", StringComparison.OrdinalIgnoreCase);
        }

        private static string BuildFileName(string programName, string listenerName, DateTime timestamp, int index)
        {
            string fileName = $"Учебная_нагрузка_{programName}_{listenerName}_{timestamp:yyyyMMdd_HHmmss}_{index + 1}.xlsx";
            foreach (var invalidChar in Path.GetInvalidFileNameChars())
            {
                fileName = fileName.Replace(invalidChar, '_');
            }

            return fileName;
        }

        private static void SaveWorkloadDocumentToDatabase(AppDbContext db, WorkloadBatch batch, LearningProgram selectedProgram, Contract contract, string programType, string targetPath, List<ProgramModule> modules, bool isGroupMode, string groupName, DateTime timestamp)
        {
            var workloadDocument = new WorkloadDocument
            {
                BatchId = batch.Id,
                ProgramId = selectedProgram.Id,
                ContractId = contract.Id,
                ListenerId = contract.ListenerId,
                TeacherId = batch.TeacherId,
                ProgramType = string.IsNullOrWhiteSpace(programType) ? null : programType.Trim(),
                GroupName = isGroupMode ? groupName : null,
                IsGroup = isGroupMode,
                FileName = Path.GetFileName(targetPath),
                FilePath = targetPath,
                GeneratedAt = timestamp,
                CreatedAt = timestamp
            };

            db.WorkloadDocuments.Add(workloadDocument);
            db.SaveChanges();

            var scheduleEntries = BuildScheduleEntries(modules, workloadDocument.Id, timestamp);
            if (scheduleEntries.Count > 0)
            {
                db.WorkloadScheduleEntries.AddRange(scheduleEntries);
                db.SaveChanges();
            }
        }

        private static void EnsureWorkloadTablesCreated(AppDbContext db)
        {
            db.Database.ExecuteSqlRaw(
                """
                CREATE TABLE IF NOT EXISTS public.workload_batch
                (
                    id BIGINT GENERATED BY DEFAULT AS IDENTITY PRIMARY KEY,
                    program_id BIGINT NOT NULL,
                    teacher_id BIGINT NULL,
                    group_name VARCHAR(255) NULL,
                    is_group BOOLEAN NOT NULL DEFAULT FALSE,
                    created_at TIMESTAMP WITHOUT TIME ZONE NOT NULL DEFAULT NOW(),
                    CONSTRAINT fk_workload_batch_program FOREIGN KEY (program_id) REFERENCES public.learning_program(id) ON DELETE RESTRICT,
                    CONSTRAINT fk_workload_batch_teacher FOREIGN KEY (teacher_id) REFERENCES public.teacher(id) ON DELETE SET NULL
                );

                CREATE INDEX IF NOT EXISTS ix_workload_batch_program_id ON public.workload_batch(program_id);
                CREATE INDEX IF NOT EXISTS ix_workload_batch_teacher_id ON public.workload_batch(teacher_id);

                CREATE TABLE IF NOT EXISTS public.workload_document
                (
                    id BIGINT GENERATED BY DEFAULT AS IDENTITY PRIMARY KEY,
                    program_id BIGINT NOT NULL,
                    batch_id BIGINT NULL,
                    contract_id BIGINT NULL,
                    listener_id BIGINT NULL,
                    teacher_id BIGINT NULL,
                    program_type VARCHAR(255) NULL,
                    group_name VARCHAR(255) NULL,
                    is_group BOOLEAN NOT NULL DEFAULT FALSE,
                    file_name VARCHAR(500) NOT NULL,
                    file_path VARCHAR(1000) NOT NULL,
                    generated_at TIMESTAMP WITHOUT TIME ZONE NOT NULL DEFAULT NOW(),
                    created_at TIMESTAMP WITHOUT TIME ZONE NOT NULL DEFAULT NOW()
                );

                ALTER TABLE public.workload_document ADD COLUMN IF NOT EXISTS batch_id BIGINT NULL;
                ALTER TABLE public.workload_document ADD COLUMN IF NOT EXISTS contract_id BIGINT NULL;
                ALTER TABLE public.workload_document ADD COLUMN IF NOT EXISTS listener_id BIGINT NULL;
                ALTER TABLE public.workload_document ADD COLUMN IF NOT EXISTS group_name VARCHAR(255) NULL;
                ALTER TABLE public.workload_document ADD COLUMN IF NOT EXISTS is_group BOOLEAN NOT NULL DEFAULT FALSE;

                CREATE INDEX IF NOT EXISTS ix_workload_document_program_id ON public.workload_document(program_id);
                CREATE INDEX IF NOT EXISTS ix_workload_document_teacher_id ON public.workload_document(teacher_id);
                CREATE INDEX IF NOT EXISTS ix_workload_document_batch_id ON public.workload_document(batch_id);
                CREATE INDEX IF NOT EXISTS ix_workload_document_contract_id ON public.workload_document(contract_id);
                CREATE INDEX IF NOT EXISTS ix_workload_document_listener_id ON public.workload_document(listener_id);

                CREATE TABLE IF NOT EXISTS public.workload_schedule_entry
                (
                    id BIGINT GENERATED BY DEFAULT AS IDENTITY PRIMARY KEY,
                    workload_document_id BIGINT NOT NULL,
                    lesson_number INTEGER NOT NULL,
                    module_number INTEGER NULL,
                    module_name VARCHAR(500) NULL,
                    topic TEXT NOT NULL,
                    lesson_date DATE NULL,
                    day_of_week VARCHAR(50) NULL,
                    start_time TIME WITHOUT TIME ZONE NULL,
                    end_time TIME WITHOUT TIME ZONE NULL,
                    hours INTEGER NULL,
                    created_at TIMESTAMP WITHOUT TIME ZONE NOT NULL DEFAULT NOW()
                );

                CREATE INDEX IF NOT EXISTS ix_workload_schedule_entry_document_id ON public.workload_schedule_entry(workload_document_id);

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

        private static List<WorkloadScheduleEntry> BuildScheduleEntries(List<ProgramModule> modules, long workloadDocumentId, DateTime createdAt)
        {
            var result = new List<WorkloadScheduleEntry>();
            int lessonNumber = 1;

            foreach (var module in modules.OrderBy(m => m.ModuleNumber))
            {
                foreach (var topic in ExtractTopics(module.Description))
                {
                    result.Add(new WorkloadScheduleEntry
                    {
                        WorkloadDocumentId = workloadDocumentId,
                        LessonNumber = lessonNumber++,
                        ModuleNumber = module.ModuleNumber,
                        ModuleName = string.IsNullOrWhiteSpace(module.ModuleName) ? null : module.ModuleName.Trim(),
                        Topic = topic,
                        LessonDate = null,
                        DayOfWeek = null,
                        StartTime = null,
                        EndTime = null,
                        Hours = 1,
                        CreatedAt = createdAt
                    });
                }
            }

            return result;
        }

        private static List<string> ExtractTopics(string? description)
        {
            if (string.IsNullOrWhiteSpace(description))
            {
                return new List<string>();
            }

            return description
                .Split(new[] { "\r\n", "\r", "\n" }, StringSplitOptions.RemoveEmptyEntries)
                .Select(line => Regex.Replace(line.Trim(), @"^\d+[\.\)]\s*", string.Empty))
                .Where(line => !string.IsNullOrWhiteSpace(line))
                .ToList();
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
