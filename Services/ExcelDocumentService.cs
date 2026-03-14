using System;
using System.Collections.Generic;
using System.IO;
using System.Linq;
using System.Text.RegularExpressions;
using ClosedXML.Excel;
using Contract2512.Models;

namespace Contract2512.Services
{
    public class ExcelDocumentService
    {
        private const string WorkloadFontName = "Montserrat";
        private const double WorkloadFontSize = 12;
        private const int DateColumn = 1;
        private const int DayOfWeekColumn = 2;
        private const int StartTimeColumn = 3;
        private const int EndTimeColumn = 4;
        private const int HoursColumn = 5;
        private const int ThemeColumn = 6;
        private const int TeacherColumn = 7;

        /// <summary>
        /// Заменяет плейсхолдеры в Excel документе
        /// </summary>
        public void ReplacePlaceholders(string sourceFilePath, string targetFilePath, Dictionary<string, string> replacements)
        {
            if (!File.Exists(sourceFilePath))
            {
                throw new FileNotFoundException($"Файл не найден: {sourceFilePath}");
            }

            if (sourceFilePath != targetFilePath)
            {
                File.Copy(sourceFilePath, targetFilePath, true);
            }

            using (var workbook = new XLWorkbook(targetFilePath))
            {
                foreach (var worksheet in workbook.Worksheets)
                {
                    ReplacePlaceholdersInWorksheet(worksheet, replacements);
                }

                workbook.Save();
            }
        }

        /// <summary>
        /// Генерирует документ учебной нагрузки с заполнением таблицы модулями
        /// </summary>
        public void GenerateWorkloadDocument(
            string sourceFilePath,
            string targetFilePath,
            Dictionary<string, string> replacements,
            List<ProgramModule> modules)
        {
            if (!File.Exists(sourceFilePath))
            {
                throw new FileNotFoundException($"Файл не найден: {sourceFilePath}");
            }

            if (sourceFilePath != targetFilePath)
            {
                File.Copy(sourceFilePath, targetFilePath, true);
            }

            using (var workbook = new XLWorkbook(targetFilePath))
            {
                foreach (var workbookSheet in workbook.Worksheets)
                {
                    ReplacePlaceholdersInWorksheet(workbookSheet, replacements);
                    ApplyWorksheetFont(workbookSheet);
                }

                var worksheet = workbook.Worksheet(1);
                int tableStartRow = FindTableStartRow(worksheet);
                if (tableStartRow > 0)
                {
                    FillModulesTable(worksheet, tableStartRow, modules, GetTeacherName(replacements));
                }

                workbook.Save();
            }
        }

        /// <summary>
        /// Находит первую строку данных сразу под заголовком таблицы
        /// </summary>
        private int FindTableStartRow(IXLWorksheet worksheet)
        {
            for (int row = 1; row <= 50; row++)
            {
                string dateHeader = worksheet.Cell(row, DateColumn).GetString().Trim().ToLowerInvariant();
                string themeHeader = worksheet.Cell(row, ThemeColumn).GetString().Trim().ToLowerInvariant();

                if (dateHeader.Contains("дата") || dateHeader.Contains("date"))
                {
                    return row + 1;
                }

                if (themeHeader.Contains("тема") || themeHeader.Contains("topic"))
                {
                    return row + 1;
                }
            }

            return 10;
        }

        /// <summary>
        /// Заполняет таблицу строками модулей и тем, не затирая футер шаблона
        /// </summary>
        private void FillModulesTable(IXLWorksheet worksheet, int startRow, List<ProgramModule> modules, string teacherName)
        {
            var rows = BuildScheduleRows(modules);
            if (rows.Count == 0)
            {
                return;
            }

            int footerRow = FindFooterRow(worksheet, startRow);
            int availableRows = Math.Max(footerRow - startRow, 1);
            int rowsToInsert = rows.Count - availableRows;
            if (rowsToInsert > 0)
            {
                worksheet.Row(footerRow).InsertRowsAbove(rowsToInsert);
                footerRow += rowsToInsert;
            }

            var moduleTemplateStyle = worksheet.Range(startRow, DateColumn, startRow, TeacherColumn).Style;
            double moduleTemplateHeight = worksheet.Row(startRow).Height;

            int lessonTemplateRow = Math.Min(footerRow, startRow + 1);
            var lessonTemplateStyles = Enumerable.Range(DateColumn, TeacherColumn)
                .Select(column => worksheet.Cell(lessonTemplateRow, column).Style)
                .ToArray();
            double lessonTemplateHeight = worksheet.Row(lessonTemplateRow).Height;

            int currentRow = startRow;
            foreach (var row in rows)
            {
                ClearRow(worksheet, currentRow);

                if (row.IsModuleHeader)
                {
                    var moduleRange = worksheet.Range(currentRow, DateColumn, currentRow, TeacherColumn);
                    moduleRange.Style = moduleTemplateStyle;
                    moduleRange.Merge();
                    moduleRange.Value = row.Theme;
                    ApplyModuleHeaderFormatting(moduleRange);
                    worksheet.Row(currentRow).Height = moduleTemplateHeight;
                }
                else
                {
                    for (int column = DateColumn; column <= TeacherColumn; column++)
                    {
                        worksheet.Cell(currentRow, column).Style = lessonTemplateStyles[column - DateColumn];
                    }

                    worksheet.Cell(currentRow, DateColumn).Value = "";
                    worksheet.Cell(currentRow, DayOfWeekColumn).Value = "";
                    worksheet.Cell(currentRow, StartTimeColumn).Value = "";
                    worksheet.Cell(currentRow, EndTimeColumn).Value = "";
                    worksheet.Cell(currentRow, HoursColumn).Value = row.Hours;
                    worksheet.Cell(currentRow, ThemeColumn).Value = row.Theme;
                    worksheet.Cell(currentRow, TeacherColumn).Value = teacherName;
                    ApplyLessonRowFormatting(worksheet.Range(currentRow, DateColumn, currentRow, TeacherColumn));
                    worksheet.Row(currentRow).Height = lessonTemplateHeight;
                }

                currentRow++;
            }
        }

        private void ReplacePlaceholdersInWorksheet(IXLWorksheet worksheet, Dictionary<string, string> replacements)
        {
            foreach (var cell in worksheet.CellsUsed())
            {
                if (!cell.Value.IsText)
                {
                    continue;
                }

                string cellValue = cell.Value.GetText();
                foreach (var replacement in replacements)
                {
                    if (cellValue.Contains(replacement.Key))
                    {
                        cellValue = cellValue.Replace(replacement.Key, replacement.Value ?? "");
                    }
                }

                cell.Value = cellValue;
            }
        }

        private void ApplyWorksheetFont(IXLWorksheet worksheet)
        {
            var usedRange = worksheet.RangeUsed();
            if (usedRange == null)
            {
                return;
            }

            usedRange.Style.Font.FontName = WorkloadFontName;
            usedRange.Style.Font.FontSize = WorkloadFontSize;
        }

        private void ApplyModuleHeaderFormatting(IXLRange moduleRange)
        {
            moduleRange.Style.Font.FontName = WorkloadFontName;
            moduleRange.Style.Font.FontSize = WorkloadFontSize;
            moduleRange.Style.Font.Bold = true;
            moduleRange.Style.Alignment.Horizontal = XLAlignmentHorizontalValues.Center;
            moduleRange.Style.Alignment.Vertical = XLAlignmentVerticalValues.Center;
            moduleRange.Style.Alignment.WrapText = true;
            moduleRange.Style.Border.OutsideBorder = XLBorderStyleValues.Thin;
        }

        private void ApplyLessonRowFormatting(IXLRange lessonRange)
        {
            lessonRange.Style.Font.FontName = WorkloadFontName;
            lessonRange.Style.Font.FontSize = WorkloadFontSize;
            lessonRange.Style.Alignment.Vertical = XLAlignmentVerticalValues.Center;
            lessonRange.Cell(1, ThemeColumn - DateColumn + 1).Style.Alignment.WrapText = true;

            foreach (var cell in lessonRange.Cells())
            {
                cell.Style.Border.LeftBorder = XLBorderStyleValues.Thin;
                cell.Style.Border.RightBorder = XLBorderStyleValues.Thin;
                cell.Style.Border.TopBorder = XLBorderStyleValues.Thin;
                cell.Style.Border.BottomBorder = XLBorderStyleValues.Thin;
            }
        }

        private int FindFooterRow(IXLWorksheet worksheet, int startRow)
        {
            int lastRow = worksheet.LastRowUsed()?.RowNumber() ?? startRow;
            for (int row = startRow; row <= Math.Max(lastRow, startRow + 20); row++)
            {
                string rowText = string.Join(" ",
                    Enumerable.Range(DateColumn, TeacherColumn)
                        .Select(column => worksheet.Cell(row, column).GetString())
                        .Where(value => !string.IsNullOrWhiteSpace(value)))
                    .Trim()
                    .ToLowerInvariant();

                if (rowText.Contains("итоговая аттестация") || rowText.Contains("примечания"))
                {
                    return row;
                }
            }

            return startRow + 1;
        }

        private void ClearRow(IXLWorksheet worksheet, int rowNumber)
        {
            var mergedRanges = worksheet.MergedRanges
                .Where(range => range.FirstRow().RowNumber() == rowNumber || range.LastRow().RowNumber() == rowNumber)
                .ToList();

            foreach (var mergedRange in mergedRanges)
            {
                mergedRange.Unmerge();
            }

            worksheet.Range(rowNumber, DateColumn, rowNumber, TeacherColumn).Clear(XLClearOptions.Contents);
        }

        private List<ScheduleRow> BuildScheduleRows(List<ProgramModule> modules)
        {
            var rows = new List<ScheduleRow>();

            foreach (var module in modules.OrderBy(m => m.ModuleNumber))
            {
                rows.Add(new ScheduleRow(true, BuildModuleTitle(module), null));

                foreach (var topic in ExtractTopics(module.Description))
                {
                    rows.Add(new ScheduleRow(false, topic, 1));
                }
            }

            return rows;
        }

        private string BuildModuleTitle(ProgramModule module)
        {
            if (!string.IsNullOrWhiteSpace(module.ModuleName))
            {
                return module.ModuleName.Trim();
            }

            return $"Модуль {module.ModuleNumber}";
        }

        private List<string> ExtractTopics(string? description)
        {
            if (string.IsNullOrWhiteSpace(description))
            {
                return new List<string>();
            }

            return description
                .Split(new[] { "\r\n", "\r", "\n" }, StringSplitOptions.RemoveEmptyEntries)
                .Select(line => Regex.Replace(line.Trim(), @"^\d+[\.\)]\s*", ""))
                .Where(line => !string.IsNullOrWhiteSpace(line))
                .ToList();
        }

        private string GetTeacherName(Dictionary<string, string> replacements)
        {
            if (replacements.TryGetValue("{{Teacher}}", out var teacher) && !string.IsNullOrWhiteSpace(teacher))
            {
                return teacher;
            }

            if (replacements.TryGetValue("{{Teatcher}}", out teacher) && !string.IsNullOrWhiteSpace(teacher))
            {
                return teacher;
            }

            return string.Empty;
        }

        /// <summary>
        /// Открывает Excel документ в приложении по умолчанию
        /// </summary>
        public void OpenDocument(string filePath)
        {
            if (!File.Exists(filePath))
            {
                throw new FileNotFoundException($"Файл не найден: {filePath}");
            }

            var processStartInfo = new System.Diagnostics.ProcessStartInfo
            {
                FileName = filePath,
                UseShellExecute = true
            };
            System.Diagnostics.Process.Start(processStartInfo);
        }

        private sealed record ScheduleRow(bool IsModuleHeader, string Theme, int? Hours);
    }
}
