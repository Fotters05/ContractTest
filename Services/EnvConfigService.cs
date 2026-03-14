using System;
using System.Collections.Generic;
using System.IO;
using System.Linq;
using System.Text;

namespace Contract2512.Services;

public static class EnvConfigService
{
    public const string ConnectionStringKey = "DB_CONNECTION_STRING";

    /// <summary>
    /// Возвращает путь к .env файлу
    /// Для Squirrel-установки: %LocalAppData%\Contract2512\.env (сохраняется между обновлениями)
    /// Для разработки: рядом с exe файлом
    /// </summary>
    public static string GetEnvFilePath()
    {
        // Проверяем, запущено ли приложение из Squirrel установки
        var baseDir = AppDomain.CurrentDomain.BaseDirectory;
        var parentDir = Directory.GetParent(baseDir)?.FullName;
        
        // Если это Squirrel установка (есть папка app-X.X.X), храним .env в родительской папке
        if (parentDir != null && baseDir.Contains("app-") && File.Exists(Path.Combine(parentDir, "Update.exe")))
        {
            // Squirrel установка: храним в %LocalAppData%\Contract2512\.env
            var envPath = Path.Combine(parentDir, ".env");
            
            // Миграция: если .env нет в родительской папке, но есть в текущей app-X.X.X
            if (!File.Exists(envPath))
            {
                var oldEnvPath = Path.Combine(baseDir, ".env");
                if (File.Exists(oldEnvPath))
                {
                    // Копируем старый .env в родительскую папку
                    try
                    {
                        File.Copy(oldEnvPath, envPath, overwrite: false);
                    }
                    catch
                    {
                        // Если не удалось скопировать, создаем новый
                        CreateDefaultEnvFile(envPath);
                    }
                }
                else
                {
                    // Проверяем другие версии app-X.X.X
                    var appDirs = Directory.GetDirectories(parentDir, "app-*");
                    foreach (var appDir in appDirs)
                    {
                        var oldEnv = Path.Combine(appDir, ".env");
                        if (File.Exists(oldEnv))
                        {
                            try
                            {
                                File.Copy(oldEnv, envPath, overwrite: false);
                                break;
                            }
                            catch { }
                        }
                    }
                    
                    // Если так и не нашли, создаем новый
                    if (!File.Exists(envPath))
                    {
                        CreateDefaultEnvFile(envPath);
                    }
                }
            }
            
            return envPath;
        }
        
        // Разработка или обычный запуск: храним рядом с exe
        var fallbackPath = Path.Combine(baseDir, ".env");
        if (!File.Exists(fallbackPath))
        {
            CreateDefaultEnvFile(fallbackPath);
        }
        return fallbackPath;
    }

    /// <summary>
    /// Создает .env файл с дефолтными значениями
    /// </summary>
    private static void CreateDefaultEnvFile(string path)
    {
        try
        {
            var defaultContent = new StringBuilder();
            defaultContent.AppendLine("# Database Connection Settings");
            defaultContent.AppendLine("# Configure your PostgreSQL connection through the application settings window");
            defaultContent.AppendLine();
            defaultContent.AppendLine("# Connection string will be saved here automatically");
            defaultContent.AppendLine("# DB_CONNECTION_STRING=");

            Directory.CreateDirectory(Path.GetDirectoryName(path)!);
            File.WriteAllText(path, defaultContent.ToString(), Encoding.UTF8);
        }
        catch
        {
            // Ignore errors during default file creation
        }
    }

    public static string? Get(string key)
    {
        // Allow process env var override (useful for immediate switch without restart).
        var fromProcessEnv = Environment.GetEnvironmentVariable(key);
        if (!string.IsNullOrWhiteSpace(fromProcessEnv))
            return fromProcessEnv;

        var path = GetEnvFilePath();
        if (!File.Exists(path))
            return null;

        var map = ReadEnvFile(path);
        return map.TryGetValue(key, out var value) ? value : null;
    }

    public static void Set(string key, string value)
    {
        var path = GetEnvFilePath();
        var map = File.Exists(path) ? ReadEnvFile(path) : new Dictionary<string, string>(StringComparer.OrdinalIgnoreCase);

        map[key] = value;
        
        // Если обновляется DB_CONNECTION_STRING, парсим и обновляем отдельные параметры
        if (key == ConnectionStringKey)
        {
            UpdateIndividualDbParams(map, value);
        }
        
        WriteEnvFile(path, map);

        // Apply immediately for the current process.
        Environment.SetEnvironmentVariable(key, value);
    }

    /// <summary>
    /// Парсит строку подключения и обновляет отдельные параметры БД в .env
    /// </summary>
    private static void UpdateIndividualDbParams(Dictionary<string, string> map, string connectionString)
    {
        try
        {
            var parts = connectionString.Split(';', StringSplitOptions.RemoveEmptyEntries);
            
            foreach (var part in parts)
            {
                var kvp = part.Split('=', 2);
                if (kvp.Length != 2) continue;
                
                var key = kvp[0].Trim();
                var value = kvp[1].Trim();
                
                switch (key.ToLowerInvariant())
                {
                    case "host":
                        map["DB_HOST"] = value;
                        break;
                    case "port":
                        map["DB_PORT"] = value;
                        break;
                    case "database":
                        map["DB_NAME"] = value;
                        break;
                    case "username":
                        map["DB_USER"] = value;
                        break;
                    case "password":
                        map["DB_PASSWORD"] = value;
                        break;
                }
            }
        }
        catch
        {
            // Ignore parsing errors
        }
    }

    private static Dictionary<string, string> ReadEnvFile(string path)
    {
        var map = new Dictionary<string, string>(StringComparer.OrdinalIgnoreCase);

        foreach (var rawLine in File.ReadAllLines(path, Encoding.UTF8))
        {
            var line = rawLine.Trim();
            if (line.Length == 0 || line.StartsWith("#", StringComparison.Ordinal))
                continue;

            var idx = line.IndexOf('=');
            if (idx <= 0)
                continue;

            var key = line[..idx].Trim();
            var value = line[(idx + 1)..].Trim();

            // Optional quotes.
            if (value.Length >= 2 && ((value.StartsWith('"') && value.EndsWith('"')) || (value.StartsWith('\'') && value.EndsWith('\''))))
                value = value[1..^1];

            if (key.Length == 0)
                continue;

            map[key] = value;
        }

        return map;
    }

    private static void WriteEnvFile(string path, Dictionary<string, string> map)
    {
        var sb = new StringBuilder();
        
        // Добавляем заголовок
        sb.AppendLine("# Database Connection Settings");
        sb.AppendLine("# Configure your PostgreSQL connection below");
        sb.AppendLine();
        
        // Сначала записываем отдельные параметры БД в определенном порядке
        var dbParams = new[] { "DB_HOST", "DB_PORT", "DB_NAME", "DB_USER", "DB_PASSWORD" };
        foreach (var param in dbParams)
        {
            if (map.TryGetValue(param, out var value))
            {
                sb.AppendLine($"{param}={value}");
            }
        }
        
        sb.AppendLine();
        sb.AppendLine("# Full connection string (auto-generated by app)");
        
        // Затем записываем строку подключения
        if (map.TryGetValue(ConnectionStringKey, out var connStr))
        {
            sb.AppendLine($"{ConnectionStringKey}={connStr}");
        }
        
        // Остальные параметры (если есть)
        var otherKeys = map.Keys
            .Where(k => !dbParams.Contains(k, StringComparer.OrdinalIgnoreCase) && k != ConnectionStringKey)
            .OrderBy(k => k, StringComparer.OrdinalIgnoreCase);
        
        if (otherKeys.Any())
        {
            sb.AppendLine();
            sb.AppendLine("# Other settings");
            foreach (var key in otherKeys)
            {
                sb.AppendLine($"{key}={map[key]}");
            }
        }

        Directory.CreateDirectory(Path.GetDirectoryName(path)!);
        File.WriteAllText(path, sb.ToString(), Encoding.UTF8);
    }
}
