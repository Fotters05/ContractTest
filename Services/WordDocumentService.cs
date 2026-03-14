using System;
using System.Collections.Generic;
using System.IO;
using System.Linq;
using DocumentFormat.OpenXml;
using DocumentFormat.OpenXml.Packaging;
using DocumentFormat.OpenXml.Wordprocessing;

namespace Contract2512.Services
{
    public class WordDocumentService
    {
        /// <summary>
        /// Заменяет плейсхолдеры в Word документе с сохранением форматирования
        /// </summary>
        /// <param name="sourceFilePath">Путь к исходному файлу</param>
        /// <param name="targetFilePath">Путь к результирующему файлу</param>
        /// <param name="replacements">Словарь замен: ключ - плейсхолдер, значение - текст для замены</param>
        public void ReplacePlaceholders(string sourceFilePath, string targetFilePath, Dictionary<string, string> replacements)
        {
            if (!File.Exists(sourceFilePath))
            {
                throw new FileNotFoundException($"Файл не найден: {sourceFilePath}");
            }

            // Копируем исходный файл только если пути разные
            if (sourceFilePath != targetFilePath)
            {
                File.Copy(sourceFilePath, targetFilePath, true);
            }

            using (WordprocessingDocument wordDoc = WordprocessingDocument.Open(targetFilePath, true))
            {
                // Получаем основной документ
                MainDocumentPart mainPart = wordDoc.MainDocumentPart;
                if (mainPart == null)
                {
                    throw new InvalidOperationException("Не удалось открыть основной документ");
                }

                // Заменяем в основном тексте
                ReplaceInElement(mainPart.Document, replacements);

                // Заменяем в заголовках
                foreach (HeaderPart headerPart in mainPart.HeaderParts)
                {
                    ReplaceInElement(headerPart.Header, replacements);
                }

                // Заменяем в колонтитулах
                foreach (FooterPart footerPart in mainPart.FooterParts)
                {
                    ReplaceInElement(footerPart.Footer, replacements);
                }

                mainPart.Document.Save();
            }
        }

        /// <summary>
        /// Заменяет плейсхолдеры в элементе документа
        /// </summary>
        private void ReplaceInElement(OpenXmlElement element, Dictionary<string, string> replacements)
        {
            if (element == null) return;

            // Сначала удаляем параграфы с плейсхолдерами, которые заменяются на пустую строку
            // Это нужно сделать до замены, чтобы удалить весь блок
            var paragraphs = element.Descendants<Paragraph>().ToList();
            var paragraphsToRemove = new List<Paragraph>();
            
            foreach (var paragraph in paragraphs)
            {
                var runs = paragraph.Elements<Run>().ToList();
                string paragraphText = string.Join("", runs.SelectMany(r => r.Elements<Text>()).Select(t => t.Text));
                
                // Проверяем, содержит ли параграф плейсхолдер, который заменяется на пустую строку
                foreach (var replacement in replacements)
                {
                    if (string.IsNullOrWhiteSpace(replacement.Value) && paragraphText.Contains(replacement.Key))
                    {
                        // Если это option1, option2 или Option_Time/Option_study, удаляем весь параграф
                        if (replacement.Key == "{{option1}}" || replacement.Key == "{{option2}}" ||
                            replacement.Key.StartsWith("{{Option_Time") || replacement.Key.StartsWith("{{Option_study") ||
                            replacement.Key.StartsWith("{{Option_Itog"))
                        {
                            paragraphsToRemove.Add(paragraph);
                            break;
                        }
                    }
                }
            }
            
            // Удаляем помеченные параграфы
            foreach (var paragraph in paragraphsToRemove)
            {
                paragraph.Remove();
            }

            // Обрабатываем оставшиеся параграфы
            var remainingParagraphs = element.Descendants<Paragraph>().ToList();
            foreach (var paragraph in remainingParagraphs)
            {
                ReplaceInParagraph(paragraph, replacements);
            }

            // Удаляем параграфы, которые стали пустыми после замены
            var paragraphsAfterReplace = element.Descendants<Paragraph>().ToList();
            foreach (var paragraph in paragraphsAfterReplace)
            {
                var runs = paragraph.Elements<Run>().ToList();
                string paragraphText = string.Join("", runs.SelectMany(r => r.Elements<Text>()).Select(t => t.Text));
                
                // Если параграф пустой или содержит только пробелы/переносы строк, удаляем его
                if (string.IsNullOrWhiteSpace(paragraphText))
                {
                    paragraph.Remove();
                }
            }

            // Обрабатываем таблицы
            var tables = element.Descendants<Table>().ToList();
            foreach (var table in tables)
            {
                var cells = table.Descendants<TableCell>().ToList();
                foreach (var cell in cells)
                {
                    var cellParagraphs = cell.Descendants<Paragraph>().ToList();
                    foreach (var cellParagraph in cellParagraphs)
                    {
                        ReplaceInParagraph(cellParagraph, replacements);
                    }
                }
            }
        }

        /// <summary>
        /// Заменяет плейсхолдеры в параграфе с сохранением форматирования
        /// </summary>
        private void ReplaceInParagraph(Paragraph paragraph, Dictionary<string, string> replacements)
        {
            if (paragraph == null) return;

            // Получаем все Text элементы в параграфе
            var textElements = paragraph.Descendants<Text>().ToList();
            if (textElements.Count == 0) return;

            // Собираем полный текст для поиска плейсхолдеров
            string fullText = string.Join("", textElements.Select(t => t.Text));
            if (string.IsNullOrEmpty(fullText)) return;

            // Проверяем каждый плейсхолдер
            foreach (var replacement in replacements)
            {
                if (!fullText.Contains(replacement.Key)) continue;

                // Находим позицию плейсхолдера в полном тексте
                int placeholderIndex = fullText.IndexOf(replacement.Key);
                while (placeholderIndex >= 0)
                {
                    int placeholderLength = replacement.Key.Length;
                    string replacementValue = replacement.Value ?? "";

                    // Находим Text элементы, которые содержат этот плейсхолдер
                    int currentPosition = 0;
                    int startTextIndex = -1;
                    int startOffset = 0;
                    int endTextIndex = -1;
                    int endOffset = 0;

                    for (int i = 0; i < textElements.Count; i++)
                    {
                        int textLength = textElements[i].Text.Length;
                        
                        // Начало плейсхолдера
                        if (startTextIndex == -1 && currentPosition + textLength > placeholderIndex)
                        {
                            startTextIndex = i;
                            startOffset = placeholderIndex - currentPosition;
                        }

                        // Конец плейсхолдера
                        if (currentPosition + textLength >= placeholderIndex + placeholderLength)
                        {
                            endTextIndex = i;
                            endOffset = placeholderIndex + placeholderLength - currentPosition;
                            break;
                        }

                        currentPosition += textLength;
                    }

                    if (startTextIndex == -1 || endTextIndex == -1) break;

                    // Заменяем плейсхолдер
                    if (startTextIndex == endTextIndex)
                    {
                        // Плейсхолдер находится в одном Text элементе
                        string text = textElements[startTextIndex].Text;
                        textElements[startTextIndex].Text = text.Substring(0, startOffset) + replacementValue + text.Substring(endOffset);
                        textElements[startTextIndex].Space = SpaceProcessingModeValues.Preserve;
                    }
                    else
                    {
                        // Плейсхолдер разбит на несколько Text элементов
                        // Заменяем в первом элементе
                        string firstText = textElements[startTextIndex].Text;
                        textElements[startTextIndex].Text = firstText.Substring(0, startOffset) + replacementValue;
                        textElements[startTextIndex].Space = SpaceProcessingModeValues.Preserve;

                        // Очищаем промежуточные элементы
                        for (int i = startTextIndex + 1; i < endTextIndex; i++)
                        {
                            textElements[i].Text = "";
                        }

                        // Обрезаем последний элемент
                        string lastText = textElements[endTextIndex].Text;
                        textElements[endTextIndex].Text = lastText.Substring(endOffset);
                    }

                    // Обновляем fullText для следующей итерации
                    fullText = string.Join("", textElements.Select(t => t.Text));
                    placeholderIndex = fullText.IndexOf(replacement.Key);
                }
            }
        }

        /// <summary>
        /// Открывает Word документ в приложении по умолчанию
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

        /// <summary>
        /// Конвертирует Word документ в PDF используя FreeSpire.Doc
        /// </summary>
        /// <param name="wordFilePath">Путь к Word документу</param>
        /// <param name="pdfFilePath">Путь для сохранения PDF (если null, будет создан рядом с Word файлом)</param>
        /// <returns>Путь к созданному PDF файлу</returns>
        public string ConvertToPdf(string wordFilePath, string pdfFilePath = null)
        {
            if (!File.Exists(wordFilePath))
            {
                throw new FileNotFoundException($"Файл не найден: {wordFilePath}");
            }

            // Если путь к PDF не указан, создаем его на основе пути к Word файлу
            if (string.IsNullOrEmpty(pdfFilePath))
            {
                pdfFilePath = Path.ChangeExtension(wordFilePath, ".pdf");
            }

            // Создаем временную копию для конвертации в PDF с жирным текстом
            string tempFilePath = Path.Combine(Path.GetDirectoryName(wordFilePath), 
                Path.GetFileNameWithoutExtension(wordFilePath) + "_temp.docx");

            try
            {
                // Копируем оригинальный файл во временный
                File.Copy(wordFilePath, tempFilePath, true);

                // Делаем весь текст жирным во временном файле
                MakeAllTextBold(tempFilePath);

                // Используем FreeSpire.Doc для конвертации временного файла
                var document = new Spire.Doc.Document();
                document.LoadFromFile(tempFilePath);
                
                document.SaveToFile(pdfFilePath, Spire.Doc.FileFormat.PDF);

                return pdfFilePath;
            }
            catch (Exception ex)
            {
                throw new InvalidOperationException($"Ошибка при конвертации в PDF: {ex.Message}", ex);
            }
            finally
            {
                // Удаляем временный файл
                if (File.Exists(tempFilePath))
                {
                    try
                    {
                        File.Delete(tempFilePath);
                    }
                    catch
                    {
                        // Игнорируем ошибки удаления временного файла
                    }
                }
            }
        }

        /// <summary>
        /// Делает весь текст в Word документе жирным
        /// </summary>
        private void MakeAllTextBold(string wordFilePath)
        {
            using (WordprocessingDocument wordDoc = WordprocessingDocument.Open(wordFilePath, true))
            {
                MainDocumentPart mainPart = wordDoc.MainDocumentPart;
                if (mainPart == null) return;

                // Обрабатываем основной документ
                SetAllTextBold(mainPart.Document);

                // Обрабатываем заголовки
                foreach (HeaderPart headerPart in mainPart.HeaderParts)
                {
                    SetAllTextBold(headerPart.Header);
                }

                // Обрабатываем футеры
                foreach (FooterPart footerPart in mainPart.FooterParts)
                {
                    SetAllTextBold(footerPart.Footer);
                }

                mainPart.Document.Save();
            }
        }

        /// <summary>
        /// Устанавливает жирное начертание для всех Run элементов в документе
        /// </summary>
        private void SetAllTextBold(OpenXmlElement element)
        {
            if (element == null) return;

            // Находим все Run элементы (они содержат текст и его форматирование)
            var runs = element.Descendants<Run>().ToList();
            
            foreach (var run in runs)
            {
                // Получаем или создаем RunProperties
                RunProperties runProps = run.RunProperties;
                if (runProps == null)
                {
                    runProps = new RunProperties();
                    run.PrependChild(runProps);
                }

                // Проверяем, есть ли уже Bold
                var existingBold = runProps.Elements<Bold>().FirstOrDefault();
                if (existingBold == null)
                {
                    // Добавляем жирное начертание
                    runProps.AppendChild(new Bold());
                }
            }
        }

    }
}

