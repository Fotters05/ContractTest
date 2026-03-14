import axios from 'axios';
import * as cheerio from 'cheerio';

// Тестовый URL курса
const testUrl = 'https://25-12.ru/courses/%d0%ba%d0%be%d0%bc%d0%bf%d1%8c%d1%8e%d1%82%d0%b5%d1%80%d0%bd%d0%be%d0%b5-%d0%b7%d1%80%d0%b5%d0%bd%d0%b8%d0%b5-%d0%b8-%d0%b8%d1%81%d0%ba%d1%83%d1%81%d1%81%d1%82%d0%b2%d0%b5%d0%bd%d0%bd%d1%8b%d0%b9-2/';

async function testLessonContent() {
  try {
    console.log('🔍 Загрузка страницы:', testUrl);
    
    const response = await axios.get(testUrl, {
      headers: {
        'User-Agent': 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36'
      }
    });
    
    const $ = cheerio.load(response.data);
    
    console.log('\n📋 СТРУКТУРА МОДУЛЕЙ И УРОКОВ:\n');
    
    // Ищем модули
    $('.course-section').each((moduleIndex, section) => {
      const $section = $(section);
      
      // Название модуля
      const moduleName = $section.find('.course-section__title, .section-title, h3, h4').first().text().trim();
      console.log(`\n${'='.repeat(60)}`);
      console.log(`МОДУЛЬ ${moduleIndex + 1}: ${moduleName}`);
      console.log('='.repeat(60));
      
      // Ищем уроки в модуле
      const lessonSelectors = [
        '.course-item',
        '.section-item',
        '.curriculum-item',
        'li.course-item'
      ];
      
      let lessons = $();
      for (const selector of lessonSelectors) {
        lessons = $section.find(selector);
        if (lessons.length > 0) {
          console.log(`\nНайдено уроков (${selector}): ${lessons.length}`);
          break;
        }
      }
      
      // Парсим каждый урок
      lessons.slice(0, 3).each((lessonIndex, lesson) => {
        const $lesson = $(lesson);
        
        console.log(`\n--- Урок ${lessonIndex + 1} ---`);
        
        // Название урока
        const lessonTitle = $lesson.find('.course-item-title, .item-title, .lesson-title').text().trim();
        console.log('Название:', lessonTitle);
        
        // Выводим весь HTML урока для анализа
        console.log('\nHTML структура урока:');
        console.log($lesson.html().substring(0, 500));
        console.log('\n...\n');
        
        // Все классы элемента урока
        console.log('Классы урока:', $lesson.attr('class'));
        
        // Все дочерние элементы
        console.log('\nДочерние элементы:');
        $lesson.children().each((i, child) => {
          const $child = $(child);
          console.log(`  - ${child.name} (class: ${$child.attr('class') || 'нет'})`);
          console.log(`    Текст: ${$child.text().trim().substring(0, 80)}`);
        });
      });
    });
    
    console.log('\n\n✅ Тест завершен');
    
  } catch (error) {
    console.error('❌ Ошибка:', error.message);
  }
}

testLessonContent();
