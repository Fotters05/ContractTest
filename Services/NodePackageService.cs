using System;
using System.Diagnostics;
using System.IO;
using System.Threading.Tasks;
using System.Windows;

namespace Contract2512.Services
{
    /// <summary>
    /// Service for managing Node.js packages (npm install)
    /// </summary>
    public class NodePackageService
    {
        private readonly string _parserPath;
        private readonly string _nodeModulesPath;

        public NodePackageService()
        {
            // Определяем путь к парсеру в зависимости от режима запуска
            var appDir = AppDomain.CurrentDomain.BaseDirectory;
            
            // Сначала проверяем путь для опубликованного приложения (parser_nodejs рядом с exe)
            string publishedPath = Path.Combine(appDir, "parser_nodejs");
            
            if (Directory.Exists(publishedPath))
            {
                _parserPath = publishedPath;
            }
            else
            {
                // Если не найдено, пробуем путь для режима разработки (Debug/Release)
                string projectRoot = Path.GetFullPath(Path.Combine(appDir, @"..\..\..\"));
                _parserPath = Path.Combine(projectRoot, "parser_nodejs");
            }
            
            _nodeModulesPath = Path.Combine(_parserPath, "node_modules");
            
            System.Diagnostics.Debug.WriteLine($"📁 App directory: {appDir}");
            System.Diagnostics.Debug.WriteLine($"📁 Parser path: {_parserPath}");
            System.Diagnostics.Debug.WriteLine($"📁 Parser exists: {Directory.Exists(_parserPath)}");
        }

        /// <summary>
        /// Checks if node_modules folder exists
        /// </summary>
        public bool IsNodeModulesInstalled()
        {
            return Directory.Exists(_nodeModulesPath);
        }

        /// <summary>
        /// Checks if Node.js is installed on the system
        /// </summary>
        public async Task<bool> IsNodeJsInstalledAsync()
        {
            try
            {
                var process = new Process
                {
                    StartInfo = new ProcessStartInfo
                    {
                        FileName = "node",
                        Arguments = "--version",
                        UseShellExecute = false,
                        RedirectStandardOutput = true,
                        RedirectStandardError = true,
                        CreateNoWindow = true
                    }
                };

                process.Start();
                await process.WaitForExitAsync();

                return process.ExitCode == 0;
            }
            catch
            {
                return false;
            }
        }

        /// <summary>
        /// Installs npm packages in parser_nodejs folder
        /// </summary>
        public async Task<(bool success, string output)> InstallPackagesAsync(IProgress<string>? progress = null)
        {
            try
            {
                if (!Directory.Exists(_parserPath))
                {
                    return (false, $"Parser folder not found: {_parserPath}");
                }

                progress?.Report("Starting npm install...");

                var process = new Process
                {
                    StartInfo = new ProcessStartInfo
                    {
                        FileName = "cmd.exe",
                        Arguments = "/c npm install",
                        WorkingDirectory = _parserPath,
                        UseShellExecute = false,
                        RedirectStandardOutput = true,
                        RedirectStandardError = true,
                        CreateNoWindow = true
                    }
                };

                var output = "";
                var error = "";

                process.OutputDataReceived += (sender, e) =>
                {
                    if (!string.IsNullOrEmpty(e.Data))
                    {
                        output += e.Data + Environment.NewLine;
                        progress?.Report(e.Data);
                        Debug.WriteLine($"npm: {e.Data}");
                    }
                };

                process.ErrorDataReceived += (sender, e) =>
                {
                    if (!string.IsNullOrEmpty(e.Data))
                    {
                        error += e.Data + Environment.NewLine;
                        Debug.WriteLine($"npm error: {e.Data}");
                    }
                };

                process.Start();
                process.BeginOutputReadLine();
                process.BeginErrorReadLine();

                await process.WaitForExitAsync();

                if (process.ExitCode == 0)
                {
                    progress?.Report("npm install completed successfully!");
                    return (true, output);
                }
                else
                {
                    return (false, $"npm install failed with exit code {process.ExitCode}\n{error}");
                }
            }
            catch (Exception ex)
            {
                return (false, $"Error during npm install: {ex.Message}");
            }
        }

        /// <summary>
        /// Shows dialog to install Node.js if not found
        /// </summary>
        public void ShowNodeJsInstallDialog()
        {
            var result = MessageBox.Show(
                "Node.js is not installed on your system.\n\n" +
                "The parser requires Node.js to work.\n\n" +
                "Would you like to download Node.js now?",
                "Node.js Required",
                MessageBoxButton.YesNo,
                MessageBoxImage.Warning
            );

            if (result == MessageBoxResult.Yes)
            {
                try
                {
                    Process.Start(new ProcessStartInfo
                    {
                        FileName = "https://nodejs.org/",
                        UseShellExecute = true
                    });
                }
                catch (Exception ex)
                {
                    MessageBox.Show(
                        $"Failed to open browser: {ex.Message}\n\n" +
                        "Please visit https://nodejs.org/ manually to download Node.js",
                        "Error",
                        MessageBoxButton.OK,
                        MessageBoxImage.Error
                    );
                }
            }
        }
    }
}
