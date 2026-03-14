using System;

namespace Contract2512.Services;

public static class DbConnectionStringProvider
{
    public static string? GetConnectionString()
    {
        return EnvConfigService.Get(EnvConfigService.ConnectionStringKey);
    }
    
    public static bool HasConnectionString()
    {
        var connectionString = GetConnectionString();
        return !string.IsNullOrWhiteSpace(connectionString);
    }
}
