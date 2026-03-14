// ВАЖНО: env-loader.js должен быть импортирован ПЕРВЫМ!
// Это гарантирует, что .env загрузится до импорта config.js
import './env-loader.js';

import axios from 'axios';
import * as cheerio from 'cheerio';
import { config } from './config.js';

// Создаем HTTP клиент с настройками
const httpClient = axios.create({
  timeout: config.parsing.timeout,
  headers: {
    'User-Agent': 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36',
    'Accept': 'application/json'
  }
});

/**
 * Получает ID категории по slug
 */
async function getCategoryId(categorySlug) {
  try {
    const url = `${config.apiBaseUrl}/course_category?slug=${encodeURIComponent(categorySlug)}`;
    console.log(`📡 Запрос категории: ${categorySlug}`);
    
    const response = await httpClient.get(url);
    
    if (response.data && response.data.length > 0) {
      const categoryId = response.data[0].id;
      console.log(`✓ ID категории "${categorySlug}": ${categoryId}`);
      return categoryId;
    }
    
    console.error(`❌ Категория "${categorySlug}" не найдена`);
    return null;
  } catch (error) {
    console.error(`❌ Ошибка получения категории: ${error.message}`);
    return null;
  }
}

/**
 * Получает список курсов из категории
 */
async function getCoursesFromCategory(categoryId, categoryName) {
  const courses = [];
  let page = 1;
  
  try {
    while (true) {
      const url = `${config.apiBaseUrl}/lp_course?course_category=${categoryId}&per_page=${config.parsing.perPage}&page=${page}`;
      console.log(`\n📡 Запрос курсов (страница ${page})...`);
      
      const response = await httpClient.get(url);
      
      if (!response.data || response.data.length === 0) {
        console.log(`✓ Загружено страниц: ${page - 1}`);
        break;
      }
      
      for (const course of response.data) {
        const courseData = {
          id: course.id,
          name: cleanHtml(course.title?.rendered || 'Без названия'),
          url: course.link,
          category: categoryName,
          slug: course.slug
        };
        
        courses.push(courseData);
        console.log(`  ✓ ${courseData.name}`);
      }
      
      if (response.data.length < config.parsing.perPage) {
        break;
      }
      
      page++;
    }
    
    console.log(`\n✓ Всего курсов в категории "${categoryName}": ${courses.length}`);
    return courses;
    
  } catch (error) {
    console.error(`❌ Ошибка загрузки курсов: ${error.message}`);
    return courses;
  }
}

/**
 * Парсит детальную информацию о курсе
 */
async function parseCourseDetails(courseUrl, courseSlug) {
  try {
    console.log(`\n📄 Парсинг деталей: ${courseUrl}`);
    
    // Загружаем HTML страницы курса
    const htmlResponse = await httpClient.get(courseUrl);
    const $ = cheerio.load(htmlResponse.data);
    
    // Парсим название
    const name = $('h1').first().text().trim() || $('.course-title').first().text().trim() || 'Без названия';
    
    // Парсим формат обучения
    let format = 'Дистанционная';
    $('label').each((i, elem) => {
      const labelText = $(elem).text().trim();
      if (labelText.includes('Формат обучения')) {
        // Берем весь текст родителя и убираем сам label
        const parentText = $(elem).parent().text().trim();
        format = parentText.replace('Формат обучения', '').trim();
      }
    });
    
    // Парсим цену из .course-price или .price
    let price = 10000;
    const priceText = $('.course-price').first().text().trim() || $('.price').first().text().trim();
    if (priceText) {
      const priceMatch = priceText.match(/(\d+[\s,]*\d*)/);
      if (priceMatch) {
        price = parseFloat(priceMatch[1].replace(/[\s,]/g, ''));
      }
    }
    
    // Парсим часы и уроки из текста страницы
    let hours = 72;
    let lessonsCount = 0;
    
    const bodyText = $('body').text();
    
    // Ищем "256 часов" или "72 часа"
    const hoursMatch = bodyText.match(/(\d+)\s*(?:час|ч)/i);
    if (hoursMatch) {
      hours = parseInt(hoursMatch[1]);
    }
    
    // Ищем "144 урока" или "36 уроков"
    const lessonsMatch = bodyText.match(/(\d+)\s*урок/i);
    if (lessonsMatch) {
      lessonsCount = parseInt(lessonsMatch[1]);
    }
    
    // Парсим модули
    const modules = [];
    $('.course-section').each((i, section) => {
      const $section = $(section);
      const moduleName = $section.find('.course-section__title, .section-title, h3, h4').first().text().trim();
      
      if (moduleName) {
        const lessons = [];
        $section.find('.course-item-title').each((j, lesson) => {
          const lessonName = $(lesson).text().trim();
          if (lessonName) {
            lessons.push(lessonName);
          }
        });
        
        // Формируем описание модуля со списком уроков
        let description = null;
        if (lessons.length > 0) {
          description = lessons.map((l, idx) => `${idx + 1}. ${l}`).join('\n');
        }
        
        modules.push({
          number: i + 1,
          name: moduleName,
          lessons: lessons,
          description: description
        });
      }
    });
    
    // Если не нашли уроки в модулях, используем общее количество
    if (lessonsCount === 0 && modules.length > 0) {
      lessonsCount = modules.reduce((sum, m) => sum + m.lessons.length, 0);
    }
    
    console.log(`✓ Часы: ${hours}, Цена: ${price}, Формат: ${format}, Уроков: ${lessonsCount}, Модулей: ${modules.length}`);
    
    return {
      name: cleanHtml(name),
      hours,
      price,
      format,
      lessonsCount,
      modules,
      sourceUrl: courseUrl
    };
    
  } catch (error) {
    console.error(`❌ Ошибка парсинга деталей: ${error.message}`);
    return null;
  }
}

/**
 * Парсит курс из HTML (запасной вариант)
 */
async function parseCourseFromHtml(courseUrl) {
  try {
    const response = await httpClient.get(courseUrl);
    const $ = cheerio.load(response.data);
    
    const name = $('h1').first().text().trim() || $('.course-title').first().text().trim() || 'Без названия';
    
    // Формат
    let format = 'Дистанционная';
    $('label').each((i, elem) => {
      const labelText = $(elem).text().trim();
      if (labelText.includes('Формат обучения')) {
        const parentText = $(elem).parent().text().trim();
        format = parentText.replace('Формат обучения', '').trim();
      }
    });
    
    // Цена
    let price = 10000;
    const priceText = $('.course-price').first().text().trim() || $('.price').first().text().trim();
    if (priceText) {
      const priceMatch = priceText.match(/(\d+[\s,]*\d*)/);
      if (priceMatch) {
        price = parseFloat(priceMatch[1].replace(/[\s,]/g, ''));
      }
    }
    
    // Часы и уроки
    let hours = 72;
    let lessonsCount = 0;
    const bodyText = $('body').text();
    
    const hoursMatch = bodyText.match(/(\d+)\s*(?:час|ч)/i);
    if (hoursMatch) {
      hours = parseInt(hoursMatch[1]);
    }
    
    const lessonsMatch = bodyText.match(/(\d+)\s*урок/i);
    if (lessonsMatch) {
      lessonsCount = parseInt(lessonsMatch[1]);
    }
    
    return {
      name: cleanHtml(name),
      hours,
      price,
      format,
      lessonsCount,
      modules: [],
      sourceUrl: courseUrl
    };
    
  } catch (error) {
    console.error(`❌ Ошибка HTML парсинга: ${error.message}`);
    return null;
  }
}

/**
 * Очищает HTML и декодирует entities
 */
function cleanHtml(html) {
  if (!html) return '';
  
  // Удаляем HTML теги
  let text = html.replace(/<[^>]+>/g, ' ');
  
  // Декодируем HTML entities
  text = text
    .replace(/&amp;/g, '&')
    .replace(/&lt;/g, '<')
    .replace(/&gt;/g, '>')
    .replace(/&quot;/g, '"')
    .replace(/&#039;/g, "'")
    .replace(/&nbsp;/g, ' ')
    .replace(/&hellip;/g, '...');
  
  // Удаляем множественные пробелы
  text = text.replace(/\s+/g, ' ').trim();
  
  return text;
}

/**
 * Парсит все программы из всех категорий
 */
export async function parseAllPrograms() {
  console.log('🚀 НАЧАЛО ПАРСИНГА ПРОГРАММ С 25-12.RU\n');
  console.log('=' .repeat(60));
  
  const allPrograms = [];
  
  for (const [categoryName, categorySlug] of Object.entries(config.categories)) {
    console.log(`\n\n📂 КАТЕГОРИЯ: ${categoryName} (${categorySlug})`);
    console.log('=' .repeat(60));
    
    // Получаем ID категории
    const categoryId = await getCategoryId(categorySlug);
    if (!categoryId) {
      console.log(`⚠️ Пропускаем категорию ${categoryName}`);
      continue;
    }
    
    // Получаем список курсов
    const courses = await getCoursesFromCategory(categoryId, categoryName);
    
    // Добавляем в общий список
    for (const course of courses) {
      allPrograms.push({
        ...course,
        category: categoryName
      });
    }
  }
  
  console.log('\n\n' + '=' .repeat(60));
  console.log(`✅ ПАРСИНГ ЗАВЕРШЕН`);
  console.log(`📊 Всего программ: ${allPrograms.length}`);
  console.log('=' .repeat(60));
  
  return allPrograms;
}

/**
 * Парсит детали для списка программ
 */
export async function parseDetailsForPrograms(programs) {
  console.log(`\n🔍 ПАРСИНГ ДЕТАЛЕЙ ДЛЯ ${programs.length} ПРОГРАММ\n`);
  
  const detailedPrograms = [];
  
  for (let i = 0; i < programs.length; i++) {
    const program = programs[i];
    console.log(`\n[${i + 1}/${programs.length}] ${program.name}`);
    
    const details = await parseCourseDetails(program.url, program.slug);
    
    if (details) {
      detailedPrograms.push({
        ...program,
        ...details
      });
    } else {
      // Если не удалось спарсить детали, добавляем с базовыми данными
      detailedPrograms.push({
        ...program,
        hours: 72,
        price: 10000,
        format: 'Дистанционная',
        lessonsCount: 0,
        modules: []
      });
    }
    
    // Небольшая задержка между запросами
    await new Promise(resolve => setTimeout(resolve, 500));
  }
  
  console.log(`\n✅ Детали загружены для ${detailedPrograms.length} программ`);
  return detailedPrograms;
}

// Экспортируем функции
export { getCategoryId, getCoursesFromCategory, parseCourseDetails, cleanHtml };
