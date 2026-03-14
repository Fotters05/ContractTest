// ВАЖНО: env-loader.js должен быть импортирован ПЕРВЫМ!
// Это гарантирует, что .env загрузится до импорта config.js
import './env-loader.js';

import { parseAllPrograms, parseDetailsForPrograms } from './parser.js';
import { testConnection, importProgram, deleteProgramsAboveId } from './import-to-db.js';
import fs from 'fs/promises';

/**
 * Показывает справку
 */
function showHelp() {
  console.log(`
╔════════════════════════════════════════════════════════════╗
║         ПАРСЕР ПРОГРАММ С САЙТА 25-12.RU                  ║
╚════════════════════════════════════════════════════════════╝

ИСПОЛЬЗОВАНИЕ:
  node index.js [команда] [опции]

КОМАНДЫ:
  parse              Спарсить программы и сохранить в JSON
  import             Спарсить и импортировать в БД
  test               Проверить подключение к БД
  clean [id]         Удалить программы с ID > указанного
  help               Показать эту справку

ПРИМЕРЫ:
  node index.js parse              # Парсинг в programs.json
  node index.js import             # Парсинг и импорт в БД
  node index.js test               # Проверка подключения
  node index.js clean 8            # Удалить программы с ID > 8

ФАЙЛЫ:
  programs.json      Результат парсинга (базовая информация)
  programs_full.json Результат парсинга (с деталями)
  `);
}

/**
 * Команда: парсинг программ
 */
async function commandParse() {
  console.log('🚀 ПАРСИНГ ПРОГРАММ\n');
  
  // Парсим базовую информацию
  const programs = await parseAllPrograms();
  
  if (programs.length === 0) {
    console.log('\n⚠️ Программы не найдены');
    return;
  }
  
  // Сохраняем базовую информацию
  await fs.writeFile('programs.json', JSON.stringify(programs, null, 2), 'utf-8');
  console.log(`\n💾 Сохранено в programs.json (${programs.length} программ)`);
  
  // Парсим детали
  console.log('\n🔍 Загрузка деталей...\n');
  const detailedPrograms = await parseDetailsForPrograms(programs);
  
  // Сохраняем полную информацию
  await fs.writeFile('programs_full.json', JSON.stringify(detailedPrograms, null, 2), 'utf-8');
  console.log(`\n💾 Сохранено в programs_full.json (${detailedPrograms.length} программ с деталями)`);
  
  console.log('\n✅ Парсинг завершен');
}

/**
 * Команда: импорт в БД
 */
async function commandImport() {
  console.log('🚀 ИМПОРТ ПРОГРАММ В БАЗУ ДАННЫХ\n');
  
  // Проверяем подключение
  const connected = await testConnection();
  if (!connected) {
    console.error('\n❌ Не удалось подключиться к базе данных');
    process.exit(1);
  }
  
  // Парсим программы
  console.log('\n📡 Парсинг программ с сайта...\n');
  const programs = await parseAllPrograms();
  
  if (programs.length === 0) {
    console.log('\n⚠️ Программы не найдены');
    return;
  }
  
  // Парсим детали
  console.log('\n🔍 Загрузка деталей программ...\n');
  const detailedPrograms = await parseDetailsForPrograms(programs);
  
  // Импортируем в БД
  console.log('\n💾 ИМПОРТ В БАЗУ ДАННЫХ\n');
  console.log('=' .repeat(60));
  
  const stats = {
    total: detailedPrograms.length,
    imported: 0,
    duplicates: 0,
    errors: 0
  };
  
  for (const program of detailedPrograms) {
    const result = await importProgram(program);
    
    if (result.success) {
      stats.imported++;
    } else if (result.reason === 'duplicate') {
      stats.duplicates++;
    } else {
      stats.errors++;
    }
  }
  
  // Статистика
  console.log('\n' + '=' .repeat(60));
  console.log('📊 СТАТИСТИКА ИМПОРТА:');
  console.log(`  Всего программ: ${stats.total}`);
  console.log(`  ✓ Импортировано: ${stats.imported}`);
  console.log(`  ⚠️ Дубликатов: ${stats.duplicates}`);
  console.log(`  ❌ Ошибок: ${stats.errors}`);
  console.log('=' .repeat(60));
  
  console.log('\n✅ Импорт завершен');
}

/**
 * Команда: проверка подключения
 */
async function commandTest() {
  console.log('🔍 ПРОВЕРКА ПОДКЛЮЧЕНИЯ К БАЗЕ ДАННЫХ\n');
  
  const connected = await testConnection();
  
  if (connected) {
    console.log('\n✅ Подключение работает');
  } else {
    console.log('\n❌ Подключение не работает');
    process.exit(1);
  }
}

/**
 * Команда: очистка программ
 */
async function commandClean(minId) {
  const id = parseInt(minId);
  
  if (isNaN(id)) {
    console.error('❌ Укажите корректный ID: node index.js clean [id]');
    process.exit(1);
  }
  
  console.log(`🗑️ УДАЛЕНИЕ ПРОГРАММ С ID > ${id}\n`);
  
  // Проверяем подключение
  const connected = await testConnection();
  if (!connected) {
    console.error('\n❌ Не удалось подключиться к базе данных');
    process.exit(1);
  }
  
  // Удаляем
  const success = await deleteProgramsAboveId(id);
  
  if (success) {
    console.log('\n✅ Удаление завершено');
  } else {
    console.log('\n❌ Ошибка удаления');
    process.exit(1);
  }
}

/**
 * Главная функция
 */
async function main() {
  const args = process.argv.slice(2);
  const command = args[0] || 'help';
  
  try {
    switch (command) {
      case 'parse':
        await commandParse();
        break;
        
      case 'import':
        await commandImport();
        break;
        
      case 'test':
        await commandTest();
        break;
        
      case 'clean':
        await commandClean(args[1]);
        break;
        
      case 'help':
      default:
        showHelp();
        break;
    }
  } catch (error) {
    console.error('\n❌ Критическая ошибка:', error.message);
    console.error(error.stack);
    process.exit(1);
  }
}

// Запускаем
main();
