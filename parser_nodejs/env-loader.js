// Загрузчик переменных окружения
// Этот файл должен импортироваться ПЕРВЫМ во всех модулях
import dotenv from 'dotenv';
import { fileURLToPath } from 'url';
import { dirname, join } from 'path';

const __filename = fileURLToPath(import.meta.url);
const __dirname = dirname(__filename);
const projectRoot = join(__dirname, '..');
const envPath = join(projectRoot, '.env');

console.log('📁 Загрузка .env из:', envPath);

// Загружаем .env
const result = dotenv.config({ path: envPath });

if (result.error) {
  console.error('❌ Ошибка загрузки .env:', result.error.message);
  process.exit(1);
}

console.log('✓ .env загружен успешно');
console.log('🔍 Переменные окружения:');
console.log('   DB_HOST:', process.env.DB_HOST);
console.log('   DB_PORT:', process.env.DB_PORT);
console.log('   DB_NAME:', process.env.DB_NAME);
console.log('   DB_USER:', process.env.DB_USER);
console.log('   DB_PASSWORD:', process.env.DB_PASSWORD ? '***' : '(пусто)');
console.log('');

// Проверяем, что все необходимые переменные загружены
const requiredVars = ['DB_HOST', 'DB_PORT', 'DB_NAME', 'DB_USER', 'DB_PASSWORD'];
const missingVars = requiredVars.filter(varName => !process.env[varName]);

if (missingVars.length > 0) {
  console.error('❌ Отсутствуют обязательные переменные окружения:');
  missingVars.forEach(varName => console.error(`   - ${varName}`));
  console.error('\nПроверьте файл .env в корне проекта!');
  process.exit(1);
}

// Если DB_HOST = localhost, заменяем на 127.0.0.1 для избежания проблем с IPv6
if (process.env.DB_HOST === 'localhost') {
  console.log('🔄 Заменяем localhost на 127.0.0.1');
  process.env.DB_HOST = '127.0.0.1';
}

// Экспортируем для использования в других модулях
export const envLoaded = true;
