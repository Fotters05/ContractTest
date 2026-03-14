# Automatic npm Install Feature

## Overview
The application now automatically checks for and installs npm packages for the parser on first run.

## How It Works

### 1. On Application Startup
When the app starts (`App.xaml.cs`), it:
1. Checks if `parser_nodejs/node_modules` folder exists
2. If missing, shows installation window
3. Runs `npm install` in `parser_nodejs` folder
4. Shows progress in real-time

### 2. Node.js Detection
- Checks if Node.js is installed on the system
- If not found, shows dialog with link to download Node.js
- Opens https://nodejs.org/ in browser

### 3. Installation Process
- Runs `npm install` command in `parser_nodejs` folder
- Shows real-time output in progress window
- Auto-scrolls log to show latest messages
- Displays success/error status

### 4. Error Handling
- If Node.js not installed → shows download dialog
- If npm install fails → shows error message
- User can choose to continue without parser or exit app

## Files Created

### Services/NodePackageService.cs
Service for managing npm packages:
- `IsNodeModulesInstalled()` - checks if node_modules exists
- `IsNodeJsInstalledAsync()` - checks if Node.js is installed
- `InstallPackagesAsync()` - runs npm install with progress reporting
- `ShowNodeJsInstallDialog()` - shows Node.js download dialog

### Views/NpmInstallWindow.xaml
Progress window UI:
- Header with title and description
- Scrollable log area showing npm output
- Progress bar (indeterminate during install)
- Status text at bottom

### Views/NpmInstallWindow.xaml.cs
Progress window logic:
- Checks Node.js installation
- Runs npm install with progress updates
- Auto-scrolls log to bottom
- Closes automatically on success
- Shows error dialogs on failure

## Modified Files

### App.xaml.cs
Added `CheckAndInstallNodePackagesAsync()` method:
- Called on app startup (before database check)
- Shows NpmInstallWindow if node_modules missing
- Allows user to continue or exit if install fails

### Contract2512.csproj
- Version updated to 1.0.9
- parser_nodejs folder already included (excluding node_modules)

## User Experience

### First Run (no node_modules)
1. App starts
2. Window appears: "Installing Parser Dependencies"
3. Shows npm install output in real-time
4. Window closes automatically when done
5. App continues to main window

### Subsequent Runs (node_modules exists)
1. App starts
2. Quick check (no window shown)
3. App continues to main window immediately

### If Node.js Not Installed
1. App detects missing Node.js
2. Shows dialog: "Node.js is not installed..."
3. User clicks "Yes" → opens nodejs.org in browser
4. User clicks "No" → app continues (parser won't work)

## Benefits

✅ No need to copy node_modules during build (saves space)
✅ No need to run npm install manually
✅ Works on any machine with Node.js installed
✅ User-friendly progress window
✅ Graceful error handling
✅ Only installs once (checks on every startup)

## Technical Details

### npm install Command
```bash
cmd.exe /c npm install
```
- Runs in `parser_nodejs` folder
- Uses package.json dependencies
- Creates node_modules folder
- Installs: axios, cheerio, dotenv, pg

### Process Management
- Uses `System.Diagnostics.Process`
- Redirects stdout and stderr
- Reports progress via `IProgress<string>`
- Async/await for non-blocking execution

### Error Scenarios Handled
1. Node.js not installed → show download dialog
2. npm install fails → show error message
3. Parser folder missing → show error message
4. User cancels → allow continue or exit

## Testing

### Test Scenarios
1. ✅ First run without node_modules
2. ✅ Subsequent runs with node_modules
3. ✅ Node.js not installed
4. ✅ npm install fails
5. ✅ User cancels installation

### How to Test
1. Delete `parser_nodejs/node_modules` folder
2. Run application
3. Watch installation window appear
4. Verify npm packages are installed
5. Run app again → should skip installation

## Version History

### v1.0.9 (Current)
- ✅ Added automatic npm install on first run
- ✅ Created NodePackageService
- ✅ Created NpmInstallWindow
- ✅ Integrated into app startup
- ✅ Node.js detection and download dialog

### v1.0.8 (Previous)
- Auto-update system for private repos
- GitHub token support
- .env file handling

## Next Steps

If you want to enhance this feature:
1. Add retry logic for failed installs
2. Add option to manually trigger npm install
3. Show npm version in about dialog
4. Cache npm install status to avoid repeated checks
5. Add npm update functionality
