// ВАЖНО: env-loader.js должен быть импортирован ПЕРВЫМ!
// Это гарантирует, что .env загрузится до импорта config.js
import './env-loader.js';

import pg from 'pg';
import { config } from './config.js';
import { parseAllPrograms, parseDetailsForPrograms } from './parser.js';

const { Pool } = pg;

// Создаем пул подключений к БД
const pool = new Pool(config.database);

/**
 * Проверяет подключение к базе данных
 */
async function testConnection() {
  try {
    console.log('🔍 Параметры подключения:');
    console.log(`   Host: ${config.database.host}`);
    console.log(`   Port: ${config.database.port}`);
    console.log(`   Database: ${config.database.database}`);
    console.log(`   User: ${config.database.user}`);
    console.log('');
    
    const client = await pool.connect();
    console.log('✓ Подключение к базе данных успешно');
    client.release();
    return true;
  } catch (error) {
    console.error('❌ Ошибка подключения к БД:', error.message);
    return false;
  }
}

/**
 * Получает или создает категорию программы
 */
async function getOrCreateCategory(categoryName) {
  const client = await pool.connect();
  
  try {
    // Проверяем существование категории
    const checkQuery = 'SELECT id FROM program_view WHERE name = $1';
    const checkResult = await client.query(checkQuery, [categoryName]);
    
    if (checkResult.rows.length > 0) {
      return checkResult.rows[0].id;
    }
    
    // Создаем новую категорию
    const insertQuery = 'INSERT INTO program_view (name) VALUES ($1) RETURNING id';
    const insertResult = await client.query(insertQuery, [categoryName]);
    
    console.log(`  ✓ Создана категория: ${categoryName}`);
    return insertResult.rows[0].id;
    
  } finally {
    client.release();
  }
}

/**
 * Проверяет существование программы по названию и формату
 */
async function programExists(programName, programFormat) {
  const client = await pool.connect();
  
  try {
    const query = 'SELECT id FROM learning_program WHERE name = $1 AND format = $2';
    const result = await client.query(query, [programName, programFormat]);
    return result.rows.length > 0 ? result.rows[0].id : null;
  } finally {
    client.release();
  }
}

/**
 * Импортирует программу в базу данных
 */
async function importProgram(program) {
  const client = await pool.connect();
  
  try {
    await client.query('BEGIN');
    
    // Проверяем дубликаты (по имени И формату)
    const existingId = await programExists(program.name, program.format || 'Дистанционная');
    if (existingId) {
      console.log(`  ⚠️ Программа уже существует: ${program.name} [${program.format || 'Дистанционная'}] (ID: ${existingId})`);
      await client.query('ROLLBACK');
      return { success: false, reason: 'duplicate', id: existingId };
    }
    
    // Получаем или создаем категорию
    const categoryId = await getOrCreateCategory(program.category);
    
    // Вставляем программу
    const programQuery = `
      INSERT INTO learning_program (name, hours, price, format, program_view_id, source_url, lessons_count)
      VALUES ($1, $2, $3, $4, $5, $6, $7)
      RETURNING id
    `;
    
    const programResult = await client.query(programQuery, [
      program.name,
      program.hours || 72,
      program.price || 10000,
      program.format || 'Дистанционная',
      categoryId,
      program.sourceUrl || program.url,
      program.lessonsCount || program.modules?.length || 0
    ]);
    
    const programId = programResult.rows[0].id;
    
    // Вставляем модули
    if (program.modules && program.modules.length > 0) {
      for (const module of program.modules) {
        const moduleQuery = `
          INSERT INTO program_module (program_id, module_number, module_name, description, hours)
          VALUES ($1, $2, $3, $4, $5)
        `;
        
        await client.query(moduleQuery, [
          programId,
          module.number,
          module.name,
          module.description,
          null // часы модуля не указаны
        ]);
      }
    }
    
    await client.query('COMMIT');
    
    console.log(`  ✓ Импортирована: ${program.name} (ID: ${programId}, модулей: ${program.modules?.length || 0})`);
    return { success: true, id: programId };
    
  } catch (error) {
    await client.query('ROLLBACK');
    console.error(`  ❌ Ошибка импорта "${program.name}":`, error.message);
    return { success: false, reason: 'error', error: error.message };
  } finally {
    client.release();
  }
}

/**
 * Удаляет программы с ID больше или равно указанному
 */
async function deleteProgramsAboveId(minId) {
  const client = await pool.connect();
  
  try {
    await client.query('BEGIN');
    
    // Удаляем модули
    const modulesResult = await client.query(
      'DELETE FROM program_module WHERE program_id >= $1',
      [minId]
    );
    
    // Удаляем программы
    const programsResult = await client.query(
      'DELETE FROM learning_program WHERE id >= $1',
      [minId]
    );
    
    await client.query('COMMIT');
    
    console.log(`✓ Удалено:`);
    console.log(`  - Программ: ${programsResult.rowCount}`);
    console.log(`  - Модулей: ${modulesResult.rowCount}`);
    
    return true;
    
  } catch (error) {
    await client.query('ROLLBACK');
    console.error('❌ Ошибка удаления:', error.message);
    return false;
  } finally {
    client.release();
  }
}

/**
 * Основная функция импорта
 */
async function main() {
  console.log('🚀 ИМПОРТ ПРОГРАММ В БАЗУ ДАННЫХ\n');
  console.log('=' .repeat(60));
  
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
    await pool.end();
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
  
  await pool.end();
  console.log('\n✅ Импорт завершен');
}

// Экспортируем функции
export { testConnection, importProgram, deleteProgramsAboveId };

// Запускаем если вызван напрямую
if (import.meta.url === `file://${process.argv[1]}`) {
  main().catch(error => {
    console.error('❌ Критическая ошибка:', error);
    process.exit(1);
  });
}
