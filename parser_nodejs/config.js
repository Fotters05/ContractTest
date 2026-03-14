// Конфигурация парсера
export const config = {
  // WordPress REST API
  apiBaseUrl: 'https://25-12.ru/wp-json/wp/v2',
  
  // Категории программ
  categories: {
    'ПП': 'профессиональная-переподготовка',
    'ПК': 'повышение-квалификации',
    'ДОП': 'курсы-для-детей-и-подростков'
  },
  
  // База данных PostgreSQL (читаем ТОЛЬКО из переменных окружения)
  database: {
    host: process.env.DB_HOST,
    port: parseInt(process.env.DB_PORT),
    user: process.env.DB_USER,
    password: process.env.DB_PASSWORD,
    database: process.env.DB_NAME
  },
  
  // Настройки парсинга
  parsing: {
    perPage: 100,        // Количество курсов за запрос
    timeout: 30000,      // Таймаут запроса (мс)
    retryAttempts: 3,    // Количество попыток при ошибке
    retryDelay: 2000     // Задержка между попытками (мс)
  }
};

// Отладка: выводим конфигурацию БД
console.log('🔧 Конфигурация БД из config.js:');
console.log('   host:', config.database.host);
console.log('   port:', config.database.port);
console.log('   database:', config.database.database);
console.log('   user:', config.database.user);
console.log('   password:', config.database.password ? '***' : '(пусто)');
console.log('');
