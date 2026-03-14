import { getCategoryId, getCoursesFromCategory, parseCourseDetails } from './parser.js';
import { testConnection } from './import-to-db.js';

/**
 * Тестирует получение ID категории
 */
async function testGetCategoryId() {
  console.log('\n📋 ТЕСТ: Получение ID категории');
  console.log('=' .repeat(60));
  
  const categorySlug = 'профессиональная-переподготовка';
  const categoryId = await getCategoryId(categorySlug);
  
  if (categoryId) {
    console.log(`✅ Тест пройден: ID = ${categoryId}`);
    return true;
  } else {
    console.log('❌ Тест провален: ID не получен');
    return false;
  }
}

/**
 * Тестирует получение списка курсов
 */
async function testGetCourses() {
  console.log('\n📋 ТЕСТ: Получение списка курсов');
  console.log('=' .repeat(60));
  
  const categorySlug = 'профессиональная-переподготовка';
  const categoryId = await getCategoryId(categorySlug);
  
  if (!categoryId) {
    console.log('❌ Тест провален: не удалось получить ID категории');
    return false;
  }
  
  const courses = await getCoursesFromCategory(categoryId, 'ПП');
  
  if (courses.length > 0) {
    console.log(`✅ Тест пройден: получено ${courses.length} курсов`);
    console.log(`\nПример первого курса:`);
    console.log(JSON.stringify(courses[0], null, 2));
    return true;
  } else {
    console.log('❌ Тест провален: курсы не получены');
    return false;
  }
}

/**
 * Тестирует парсинг деталей курса
 */
async function testParseCourseDetails() {
  console.log('\n📋 ТЕСТ: Парсинг деталей курса');
  console.log('=' .repeat(60));
  
  // Получаем первый курс из категории
  const categorySlug = 'профессиональная-переподготовка';
  const categoryId = await getCategoryId(categorySlug);
  
  if (!categoryId) {
    console.log('❌ Тест провален: не удалось получить ID категории');
    return false;
  }
  
  const courses = await getCoursesFromCategory(categoryId, 'ПП');
  
  if (courses.length === 0) {
    console.log('❌ Тест провален: курсы не получены');
    return false;
  }
  
  const firstCourse = courses[0];
  console.log(`\nПарсим курс: ${firstCourse.name}`);
  
  const details = await parseCourseDetails(firstCourse.url, firstCourse.slug);
  
  if (details) {
    console.log(`✅ Тест пройден`);
    console.log(`\nДетали курса:`);
    console.log(`  Название: ${details.name}`);
    console.log(`  Часы: ${details.hours}`);
    console.log(`  Цена: ${details.price}`);
    console.log(`  Формат: ${details.format}`);
    console.log(`  Модулей: ${details.modules?.length || 0}`);
    
    if (details.modules && details.modules.length > 0) {
      console.log(`\nПример первого модуля:`);
      console.log(JSON.stringify(details.modules[0], null, 2));
    }
    
    return true;
  } else {
    console.log('❌ Тест провален: детали не получены');
    return false;
  }
}

/**
 * Тестирует подключение к БД
 */
async function testDatabaseConnection() {
  console.log('\n📋 ТЕСТ: Подключение к базе данных');
  console.log('=' .repeat(60));
  
  const connected = await testConnection();
  
  if (connected) {
    console.log('✅ Тест пройден: подключение работает');
    return true;
  } else {
    console.log('❌ Тест провален: подключение не работает');
    return false;
  }
}

/**
 * Запускает все тесты
 */
async function runAllTests() {
  console.log('\n╔════════════════════════════════════════════════════════════╗');
  console.log('║              ТЕСТИРОВАНИЕ ПАРСЕРА 25-12.RU                ║');
  console.log('╚════════════════════════════════════════════════════════════╝');
  
  const results = {
    total: 0,
    passed: 0,
    failed: 0
  };
  
  // Тест 1: Получение ID категории
  results.total++;
  if (await testGetCategoryId()) {
    results.passed++;
  } else {
    results.failed++;
  }
  
  // Тест 2: Получение списка курсов
  results.total++;
  if (await testGetCourses()) {
    results.passed++;
  } else {
    results.failed++;
  }
  
  // Тест 3: Парсинг деталей курса
  results.total++;
  if (await testParseCourseDetails()) {
    results.passed++;
  } else {
    results.failed++;
  }
  
  // Тест 4: Подключение к БД
  results.total++;
  if (await testDatabaseConnection()) {
    results.passed++;
  } else {
    results.failed++;
  }
  
  // Итоги
  console.log('\n\n' + '=' .repeat(60));
  console.log('📊 РЕЗУЛЬТАТЫ ТЕСТИРОВАНИЯ:');
  console.log(`  Всего тестов: ${results.total}`);
  console.log(`  ✅ Пройдено: ${results.passed}`);
  console.log(`  ❌ Провалено: ${results.failed}`);
  console.log('=' .repeat(60));
  
  if (results.failed === 0) {
    console.log('\n🎉 ВСЕ ТЕСТЫ ПРОЙДЕНЫ!');
  } else {
    console.log('\n⚠️ НЕКОТОРЫЕ ТЕСТЫ ПРОВАЛЕНЫ');
  }
}

// Запускаем тесты
runAllTests().catch(error => {
  console.error('\n❌ Критическая ошибка:', error);
  process.exit(1);
});
