using System;
using System.Threading.Tasks;
using System.Windows;
using System.Windows.Controls;
using Contract2512.Services;

namespace Contract2512.Views
{
    public partial class NpmInstallWindow : Window
    {
        private readonly NodePackageService _nodePackageService;
        private bool _installSuccess = false;

        public bool InstallSuccess => _installSuccess;

        public NpmInstallWindow()
        {
            InitializeComponent();
            _nodePackageService = new NodePackageService();
            Loaded += OnLoaded;
        }

        private async void OnLoaded(object sender, RoutedEventArgs e)
        {
            await InstallPackagesAsync();
        }

        private async Task InstallPackagesAsync()
        {
            try
            {
                // Check if Node.js is installed
                StatusTextBlock.Text = "Checking Node.js installation...";
                var isNodeInstalled = await _nodePackageService.IsNodeJsInstalledAsync();

                if (!isNodeInstalled)
                {
                    StatusTextBlock.Text = "Node.js not found!";
                    ProgressBar.IsIndeterminate = false;
                    
                    await Task.Delay(500);
                    
                    _nodePackageService.ShowNodeJsInstallDialog();
                    Close();
                    return;
                }

                // Install packages
                StatusTextBlock.Text = "Installing npm packages...";
                
                var progress = new Progress<string>(message =>
                {
                    Dispatcher.Invoke(() =>
                    {
                        LogTextBlock.Text += message + Environment.NewLine;
                        
                        // Auto-scroll to bottom
                        if (LogTextBlock.Parent is ScrollViewer scrollViewer)
                        {
                            scrollViewer.ScrollToEnd();
                        }
                    });
                });

                var (success, output) = await _nodePackageService.InstallPackagesAsync(progress);

                if (success)
                {
                    _installSuccess = true;
                    StatusTextBlock.Text = "Installation completed successfully!";
                    ProgressBar.IsIndeterminate = false;
                    ProgressBar.Value = 100;
                    
                    await Task.Delay(1500);
                    Close();
                }
                else
                {
                    StatusTextBlock.Text = "Installation failed!";
                    ProgressBar.IsIndeterminate = false;
                    
                    MessageBox.Show(
                        $"Failed to install npm packages:\n\n{output}",
                        "Installation Error",
                        MessageBoxButton.OK,
                        MessageBoxImage.Error
                    );
                    
                    Close();
                }
            }
            catch (Exception ex)
            {
                StatusTextBlock.Text = "Error occurred!";
                ProgressBar.IsIndeterminate = false;
                
                MessageBox.Show(
                    $"Error during installation:\n\n{ex.Message}",
                    "Error",
                    MessageBoxButton.OK,
                    MessageBoxImage.Error
                );
                
                Close();
            }
        }
    }
}
