using System;
using System.Collections.Generic;
using System.IO;
using System.Linq;
using System.Net.Http;
using System.Text.RegularExpressions;
using System.Threading.Tasks;
using Contract2512.Models;

namespace Contract2512.Services
{
    /// <summary>
    /// Сервис для парсинга данных о программах с сайта 25-12.ru
    /// </summary>
    public class WebParserService
    {
        private readonly HttpClient _httpClient;

        public WebParserService()
        {
            var handler = new HttpClientHandler
            {
                // Отключаем проверку SSL сертификатов (если есть проблемы с сертификатами)
                ServerCertificateCustomValidationCallback = (message, cert, chain, errors) => true,
                // Автоматически следуем редиректам
                AllowAutoRedirect = true,
                // Используем системный прокси
                UseProxy = true,
                UseDefaultCredentials = true
            };

            _httpClient = new HttpClient(handler)
            {
                Timeout = TimeSpan.FromSeconds(30) // Увеличиваем таймаут до 30 секунд
            };
            
            _httpClient.DefaultRequestHeaders.Add("User-Agent", "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/120.0.0.0 Safari/537.36");
            _httpClient.DefaultRequestHeaders.Add("Accept", "text/html,application/xhtml+xml,application/xml;q=0.9,image/webp,*/*;q=0.8");
            _httpClient.DefaultRequestHeaders.Add("Accept-Language", "ru-RU,ru;q=0.9,en-US;q=0.8,en;q=0.7");
        }

        /* СТАРЫЙ МЕТОД - НЕ ИСПОЛЬЗУЕТСЯ (парсинг теперь через Node.js)
        /// <summary>
        /// Парсит содержание программы по URL
        /// </summary>
        public async Task<(ProgramContent? content, List<ProgramModule> modules)> ParseProgramFromUrl(string url)
        {
            // Этот метод больше не используется
            // Парсинг теперь выполняется через Node.js парсер
            throw new NotImplementedException("Используйте Node.js парсер для импорта программ");
        }
        */

        /// <summary>
        /// Альтернативный метод парсинга модулей
        /// </summary>
        private List<ProgramModule> ParseModulesAlternative(string html)
        {
            var modules = new List<ProgramModule>();
            
            // Ищем секцию с содержанием программы
            var contentSection = ExtractText(html, @"(?:Содержание программы|Program Content|Учебный план)(.*?)(?:</section>|</div>|<section)", 1);
            
            if (!string.IsNullOrEmpty(contentSection))
            {
                // Ищем все элементы списка или блоки с номерами
                var items = Regex.Matches(contentSection, 
                    @"(?:<li>|<p>|<div>)\s*(?:Модуль\s*)?(\d+)[\.:\s]+([^<]+)",
                    RegexOptions.IgnoreCase);

                foreach (Match item in items)
                {
                    var module = new ProgramModule
                    {
                        ModuleNumber = int.Parse(item.Groups[1].Value),
                        ModuleName = CleanHtml(item.Groups[2].Value).Trim(),
                        CreatedAt = DateTime.Now,
                        UpdatedAt = DateTime.Now
                    };

                    if (!string.IsNullOrWhiteSpace(module.ModuleName))
                    {
                        modules.Add(module);
                    }
                }
            }

            return modules;
        }

        /// <summary>
        /// Извлекает текст по регулярному выражению
        /// </summary>
        private string? ExtractText(string html, string pattern, int groupIndex)
        {
            var match = Regex.Match(html, pattern, RegexOptions.IgnoreCase | RegexOptions.Singleline);
            if (match.Success && match.Groups.Count > groupIndex)
            {
                return CleanHtml(match.Groups[groupIndex].Value).Trim();
            }
            return null;
        }

        /// <summary>
        /// Очищает HTML теги и декодирует HTML entities
        /// </summary>
        private string CleanHtml(string html)
        {
            if (string.IsNullOrEmpty(html))
                return string.Empty;

            // Удаляем HTML теги
            var text = Regex.Replace(html, @"<[^>]+>", " ");
            
            // Декодируем HTML entities
            text = System.Net.WebUtility.HtmlDecode(text);
            
            // Удаляем множественные пробелы
            text = Regex.Replace(text, @"\s+", " ");
            
            return text.Trim();
        }

        /// <summary>
        /// Получает список всех курсов из категории через WordPress REST API
        /// </summary>
        public async Task<List<(string name, string url)>> GetCoursesFromCategory(string categoryUrl)
        {
            var courses = new List<(string name, string url)>();
            
            try
            {
                Console.WriteLine($"\n=== НАЧАЛО ПАРСИНГА КАТЕГОРИИ ЧЕРЕЗ REST API ===");
                Console.WriteLine($"URL категории: {categoryUrl}");
                
                // Извлекаем slug категории из URL
                // Формат: https://25-12.ru/course-category/название-категории/
                var categorySlug = categoryUrl.TrimEnd('/').Split('/').Last();
                Console.WriteLine($"Slug категории: {categorySlug}");
                
                // Шаг 1: Получаем ID категории через WordPress REST API
                var categoryApiUrl = $"https://25-12.ru/wp-json/wp/v2/course_category?slug={Uri.EscapeDataString(categorySlug)}";
                Console.WriteLine($"Запрос категории: {categoryApiUrl}");
                
                string categoryJson;
                try
                {
                    categoryJson = await _httpClient.GetStringAsync(categoryApiUrl);
                }
                catch (HttpRequestException httpEx)
                {
                    Console.WriteLine($"❌ HTTP ошибка при запросе категории: {httpEx.Message}");
                    Console.WriteLine($"InnerException: {httpEx.InnerException?.Message}");
                    throw new Exception($"Не удалось подключиться к сайту 25-12.ru. Проверьте подключение к интернету.\nДетали: {httpEx.Message}", httpEx);
                }
                catch (TaskCanceledException timeoutEx)
                {
                    Console.WriteLine($"❌ Таймаут при запросе категории: {timeoutEx.Message}");
                    throw new Exception("Превышено время ожидания ответа от сайта. Попробуйте еще раз.", timeoutEx);
                }
                
                Console.WriteLine($"Ответ категории (первые 200 символов): {categoryJson.Substring(0, Math.Min(200, categoryJson.Length))}");
                
                // Парсим JSON чтобы получить ID категории
                var categoryIdMatch = Regex.Match(categoryJson, @"""id"":(\d+)");
                if (!categoryIdMatch.Success)
                {
                    Console.WriteLine("❌ Не удалось найти ID категории в JSON");
                    return courses;
                }
                
                var categoryId = categoryIdMatch.Groups[1].Value;
                Console.WriteLine($"✓ ID категории: {categoryId}");
                
                // Шаг 2: Получаем курсы через WordPress REST API
                var page = 1;
                var perPage = 100; // Максимум курсов за раз
                
                while (true)
                {
                    var coursesApiUrl = $"https://25-12.ru/wp-json/wp/v2/lp_course?course_category={categoryId}&per_page={perPage}&page={page}";
                    Console.WriteLine($"\nЗапрос курсов (страница {page}): {coursesApiUrl}");
                    
                    string coursesJson;
                    try
                    {
                        coursesJson = await _httpClient.GetStringAsync(coursesApiUrl);
                    }
                    catch (HttpRequestException httpEx)
                    {
                        Console.WriteLine($"❌ HTTP ошибка при запросе курсов: {httpEx.Message}");
                        Console.WriteLine($"InnerException: {httpEx.InnerException?.Message}");
                        if (page == 1)
                        {
                            throw new Exception($"Не удалось загрузить курсы с сайта.\nДетали: {httpEx.Message}", httpEx);
                        }
                        break; // Если не первая страница, просто выходим из цикла
                    }
                    catch (TaskCanceledException timeoutEx)
                    {
                        Console.WriteLine($"❌ Таймаут при запросе курсов: {timeoutEx.Message}");
                        if (page == 1)
                        {
                            throw new Exception("Превышено время ожидания ответа от сайта. Попробуйте еще раз.", timeoutEx);
                        }
                        break;
                    }
                    
                    Console.WriteLine($"Получен JSON (размер: {coursesJson.Length} символов)");
                    
                    // Сохраняем JSON для отладки (первые 2000 символов)
                    Console.WriteLine($"\n=== ОБРАЗЕЦ JSON (первые 2000 символов) ===");
                    Console.WriteLine(coursesJson.Substring(0, Math.Min(2000, coursesJson.Length)));
                    Console.WriteLine("=== КОНЕЦ ОБРАЗЦА ===\n");
                    
                    // Ищем все ссылки на курсы в JSON - пробуем разные варианты
                    var linkMatches = Regex.Matches(coursesJson, @"""link"":""(https:(?:\\\/|\/)+25-12\.ru(?:\\\/|\/)courses(?:\\\/|\/)[^""]+)""");
                    
                    // Если не нашли, пробуем без экранирования
                    if (linkMatches.Count == 0)
                    {
                        Console.WriteLine("Пробуем альтернативную регулярку для ссылок...");
                        linkMatches = Regex.Matches(coursesJson, @"""link"":""(https:[^""]*25-12\.ru[^""]*courses[^""]+)""");
                    }
                    
                    var titleMatches = Regex.Matches(coursesJson, @"""title"":\{""rendered"":""([^""]+)""");
                    
                    Console.WriteLine($"Найдено ссылок: {linkMatches.Count}, названий: {titleMatches.Count}");
                    
                    if (linkMatches.Count == 0)
                    {
                        Console.WriteLine($"Курсов больше нет на странице {page}");
                        break;
                    }
                    
                    // Объединяем ссылки и названия
                    for (int i = 0; i < linkMatches.Count; i++)
                    {
                        var courseUrl = linkMatches[i].Groups[1].Value.Replace("\\/", "/");
                        var courseName = i < titleMatches.Count 
                            ? CleanHtml(System.Net.WebUtility.HtmlDecode(titleMatches[i].Groups[1].Value))
                            : "Без названия";
                        
                        // Декодируем URL если он закодирован
                        courseUrl = Uri.UnescapeDataString(courseUrl);
                        
                        if (!courses.Any(c => c.url == courseUrl))
                        {
                            courses.Add((courseName, courseUrl));
                            Console.WriteLine($"  ✓ Добавлен: {courseName}");
                            Console.WriteLine($"    URL: {courseUrl}");
                        }
                    }
                    
                    // Если курсов меньше чем perPage, значит это последняя страница
                    if (linkMatches.Count < perPage)
                    {
                        Console.WriteLine($"Это последняя страница (курсов: {linkMatches.Count} < {perPage})");
                        break;
                    }
                    
                    page++;
                }
                
                Console.WriteLine($"\n=== ИТОГО: {courses.Count} курсов ===\n");
            }
            catch (Exception ex) when (!(ex is HttpRequestException || ex is TaskCanceledException))
            {
                Console.WriteLine($"\n!!! ОШИБКА: {ex.Message}");
                Console.WriteLine($"Stack trace: {ex.StackTrace}\n");
                throw new Exception($"Не удалось загрузить курсы из категории: {ex.Message}", ex);
            }

            return courses;
        }

        /// <summary>
        /// Парсит базовую информацию о программе со страницы курса
        /// </summary>
        public async Task<(string name, int hours, decimal price, string format)?> ParseProgramBasicInfo(string url)
        {
            try
            {
                Console.WriteLine($"\n--- Парсинг программы: {url}");
                
                // Извлекаем slug курса из URL
                var courseSlug = url.TrimEnd('/').Split('/').Last();
                Console.WriteLine($"Slug курса: {courseSlug}");
                
                // Пробуем получить данные через REST API
                var apiUrl = $"https://25-12.ru/wp-json/wp/v2/lp_course?slug={Uri.EscapeDataString(courseSlug)}";
                Console.WriteLine($"API запрос: {apiUrl}");
                
                try
                {
                    var apiJson = await _httpClient.GetStringAsync(apiUrl);
                    
                    if (!string.IsNullOrEmpty(apiJson) && apiJson != "[]")
                    {
                        Console.WriteLine($"Получен JSON из API (размер: {apiJson.Length})");
                        
                        // Парсим название
                        var nameMatch = Regex.Match(apiJson, @"""title"":\{""rendered"":""([^""]+)""");
                        var name = nameMatch.Success ? CleanHtml(System.Net.WebUtility.HtmlDecode(nameMatch.Groups[1].Value)) : null;
                        
                        // Парсим метаданные курса из JSON
                        var metaMatch = Regex.Match(apiJson, @"""meta"":\{([^\}]+)\}");
                        string metaJson = metaMatch.Success ? metaMatch.Groups[1].Value : "";
                        
                        // Парсим часы из мета-данных
                        int hours = 72; // По умолчанию
                        var hoursMatch = Regex.Match(apiJson, @"""_lp_duration"":""(\d+)""");
                        if (hoursMatch.Success && int.TryParse(hoursMatch.Groups[1].Value, out int parsedHours))
                        {
                            hours = parsedHours;
                        }
                        else
                        {
                            // Пробуем найти в контенте
                            var contentMatch = Regex.Match(apiJson, @"(\d+)\s*(?:час|ч\.|hours?)");
                            if (contentMatch.Success && int.TryParse(contentMatch.Groups[1].Value, out parsedHours))
                            {
                                hours = parsedHours;
                            }
                        }
                        
                        // Парсим цену из мета-данных
                        decimal price = 10000; // По умолчанию
                        var priceMatch = Regex.Match(apiJson, @"""_lp_price"":""([\d\s]+)""");
                        if (priceMatch.Success)
                        {
                            var priceStr = priceMatch.Groups[1].Value.Replace(" ", "").Replace("\u00A0", "");
                            if (decimal.TryParse(priceStr, out decimal parsedPrice))
                            {
                                price = parsedPrice;
                            }
                        }
                        else
                        {
                            // Пробуем найти в контенте
                            var contentPriceMatch = Regex.Match(apiJson, @"(\d+[\s\d]*)\s*(?:₽|руб|rub)");
                            if (contentPriceMatch.Success)
                            {
                                var priceStr = contentPriceMatch.Groups[1].Value.Replace(" ", "").Replace("\u00A0", "");
                                if (decimal.TryParse(priceStr, out decimal parsedPrice))
                                {
                                    price = parsedPrice;
                                }
                            }
                        }
                        
                        // Формат пока оставляем по умолчанию, будет парситься из HTML
                        var format = "Дистанционная";
                        
                        Console.WriteLine($"✓ Название: {name}");
                        Console.WriteLine($"✓ Часы: {hours}");
                        Console.WriteLine($"✓ Цена: {price}");
                        Console.WriteLine($"✓ Формат (временно): {format}");
                        
                        if (!string.IsNullOrWhiteSpace(name))
                        {
                            // Загружаем HTML для парсинга формата
                            try
                            {
                                var html = await _httpClient.GetStringAsync(url);
                                format = ParseFormatFromHtml(html);
                                Console.WriteLine($"✓ Формат из HTML: {format}");
                            }
                            catch (Exception htmlEx)
                            {
                                Console.WriteLine($"Не удалось загрузить HTML для формата: {htmlEx.Message}");
                            }
                            
                            return (name, hours, price, format);
                        }
                    }
                }
                catch (Exception apiEx)
                {
                    Console.WriteLine($"Ошибка API запроса: {apiEx.Message}, пробуем HTML парсинг...");
                }
                
                // Если API не сработал, парсим HTML
                var htmlFull = await _httpClient.GetStringAsync(url);
                
                // Парсим название
                var htmlName = ExtractText(htmlFull, @"<h1[^>]*>(.*?)</h1>", 1);
                if (string.IsNullOrWhiteSpace(htmlName))
                {
                    htmlName = ExtractText(htmlFull, @"<title>(.*?)</title>", 1);
                }
                
                // Парсим часы из <span class="course-duration">
                var hoursText = ExtractText(htmlFull, @"<span[^>]*class=""[^""]*course-duration[^""]*""[^>]*>(\d+)\s*(?:час|ч\.?|hours?)", 1);
                int htmlHours = 72;
                if (!string.IsNullOrEmpty(hoursText))
                {
                    int.TryParse(hoursText, out htmlHours);
                }
                
                // Парсим цену
                var priceText = ExtractText(htmlFull, @"(\d+[\s\d]*)\s*(?:₽|руб|rub)", 1);
                decimal htmlPrice = 10000;
                if (!string.IsNullOrEmpty(priceText))
                {
                    priceText = priceText.Replace(" ", "").Replace("\u00A0", "");
                    decimal.TryParse(priceText, out htmlPrice);
                }
                
                // Парсим формат
                var htmlFormat = ParseFormatFromHtml(htmlFull);
                
                Console.WriteLine($"✓ HTML парсинг - Название: {htmlName}, Часы: {htmlHours}, Цена: {htmlPrice}, Формат: {htmlFormat}");
                
                if (!string.IsNullOrWhiteSpace(htmlName))
                {
                    return (htmlName, htmlHours, htmlPrice, htmlFormat);
                }
            }
            catch (Exception ex)
            {
                Console.WriteLine($"Ошибка парсинга базовой информации: {ex.Message}");
            }
            
            return null;
        }

        /// <summary>
        /// Парсит формат обучения из HTML
        /// </summary>
        private string ParseFormatFromHtml(string html)
        {
            // Ищем секцию с форматом: <label>Формат обучения</label> ... <span class="instructor-display-name">...</span>
            var formatMatch = Regex.Match(html, 
                @"<label>Формат обучения</label>.*?<span[^>]*class=""[^""]*instructor-display-name[^""]*""[^>]*>([^<]+)</span>",
                RegexOptions.IgnoreCase | RegexOptions.Singleline);
            
            if (formatMatch.Success)
            {
                var format = CleanHtml(formatMatch.Groups[1].Value).Trim();
                Console.WriteLine($"Найден формат: {format}");
                return format;
            }
            
            // Если не нашли, пробуем альтернативный вариант
            formatMatch = Regex.Match(html,
                @"<label>Формат обучения</label>.*?<a[^>]*>([^<]+)</a>",
                RegexOptions.IgnoreCase | RegexOptions.Singleline);
            
            if (formatMatch.Success)
            {
                var format = CleanHtml(formatMatch.Groups[1].Value).Trim();
                Console.WriteLine($"Найден формат (альтернативный): {format}");
                return format;
            }
            
            Console.WriteLine("Формат не найден, используем значение по умолчанию");
            return "Дистанционная";
        }

        /// <summary>
        /// Импортирует программы из всех категорий сайта
        /// </summary>
        public async Task<List<(string name, int hours, decimal price, string format, string category, string url)>> ImportProgramsFromAllCategories()
        {
            var allPrograms = new List<(string name, int hours, decimal price, string format, string category, string url)>();
            
            // URL категорий на сайте
            var categories = new Dictionary<string, string>
            {
                { "ПП", "https://25-12.ru/course-category/%D0%BF%D1%80%D0%BE%D1%84%D0%B5%D1%81%D1%81%D0%B8%D0%BE%D0%BD%D0%B0%D0%BB%D1%8C%D0%BD%D0%B0%D1%8F-%D0%BF%D0%B5%D1%80%D0%B5%D0%BF%D0%BE%D0%B4%D0%B3%D0%BE%D1%82%D0%BE%D0%B2%D0%BA%D0%B0/" },
                { "ПК", "https://25-12.ru/course-category/%D0%BF%D0%BE%D0%B2%D1%8B%D1%88%D0%B5%D0%BD%D0%B8%D0%B5-%D0%BA%D0%B2%D0%B0%D0%BB%D0%B8%D1%84%D0%B8%D0%BA%D0%B0%D1%86%D0%B8%D0%B8/" },
                { "ДОП", "https://25-12.ru/course-category/%d0%ba%d1%83%d1%80%d1%81%d1%8b-%d0%b4%d0%bb%d1%8f-%d0%b4%d0%b5%d1%82%d0%b5%d0%b9-%d0%b8-%d0%bf%d0%be%d0%b4%d1%80%d0%be%d1%81%d1%82%d0%ba%d0%be%d0%b2/" }
            };
            
            foreach (var category in categories)
            {
                try
                {
                    var courses = await GetCoursesFromCategory(category.Value);
                    
                    foreach (var course in courses)
                    {
                        var basicInfo = await ParseProgramBasicInfo(course.url);
                        
                        if (basicInfo.HasValue)
                        {
                            allPrograms.Add((
                                basicInfo.Value.name,
                                basicInfo.Value.hours,
                                basicInfo.Value.price,
                                basicInfo.Value.format,
                                category.Key,
                                course.url
                            ));
                        }
                        
                        // Небольшая задержка между запросами, чтобы не перегружать сервер
                        await Task.Delay(500);
                    }
                }
                catch (Exception ex)
                {
                    Console.WriteLine($"Ошибка импорта категории {category.Key}: {ex.Message}");
                }
            }
            
            return allPrograms;
        }
    }
}
