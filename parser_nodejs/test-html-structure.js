import axios from 'axios';
import * as cheerio from 'cheerio';

// Тестовый URL курса
const testUrl = 'https://25-12.ru/courses/%d0%ba%d0%be%d0%bc%d0%bf%d1%8c%d1%8e%d1%82%d0%b5%d1%80%d0%bd%d0%be%d0%b5-%d0%b7%d1%80%d0%b5%d0%bd%d0%b8%d0%b5-%d0%b8-%d0%b8%d1%81%d0%ba%d1%83%d1%81%d1%81%d1%82%d0%b2%d0%b5%d0%bd%d0%bd%d1%8b%d0%b9-2/';

async function testHtmlStructure() {
  try {
    console.log('🔍 Загрузка страницы:', testUrl);
    
    const response = await axios.get(testUrl, {
      headers: {
        'User-Agent': 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36'
      }
    });
    
    const $ = cheerio.load(response.data);
    
    console.log('\n📋 СТРУКТУРА СТРАНИЦЫ:\n');
    
    // Название
    console.log('1. НАЗВАНИЕ:');
    console.log('   h1:', $('h1').first().text().trim());
    console.log('   .course-title:', $('.course-title').text().trim());
    console.log('   .entry-title:', $('.entry-title').text().trim());
    
    // Формат
    console.log('\n2. ФОРМАТ ОБУЧЕНИЯ:');
    $('label').each((i, elem) => {
      const labelText = $(elem).text().trim();
      if (labelText.includes('Формат')) {
        console.log('   Label:', labelText);
        console.log('   Next span:', $(elem).next('span').text().trim());
        console.log('   Next .instructor-display-name:', $(elem).next('.instructor-display-name').text().trim());
        console.log('   Parent:', $(elem).parent().text().trim());
      }
    });
    
    // Часы
    console.log('\n3. ЧАСЫ/ПРОДОЛЖИТЕЛЬНОСТЬ:');
    $('label').each((i, elem) => {
      const labelText = $(elem).text().trim();
      if (labelText.includes('Продолжительность') || labelText.includes('Длительность') || labelText.includes('час')) {
        console.log('   Label:', labelText);
        console.log('   Next span:', $(elem).next('span').text().trim());
        console.log('   Next element:', $(elem).next().text().trim());
        console.log('   Parent:', $(elem).parent().text().trim());
      }
    });
    
    // Цена
    console.log('\n4. ЦЕНА:');
    const priceSelectors = [
      '.course-price',
      '.price',
      '.lp-course-price',
      '.course-payment .price',
      'span:contains("₽")',
      'div:contains("₽")'
    ];
    
    priceSelectors.forEach(selector => {
      const elem = $(selector).first();
      if (elem.length) {
        console.log(`   ${selector}:`, elem.text().trim());
      }
    });
    
    // Поиск всех упоминаний рублей
    console.log('\n   Все упоминания ₽:');
    $('*').each((i, elem) => {
      const text = $(elem).text();
      if (text.includes('₽') && text.length < 100) {
        console.log('   -', text.trim());
      }
    });
    
    // Модули
    console.log('\n5. МОДУЛИ/СЕКЦИИ:');
    const sectionSelectors = [
      '.lp-course-curriculum .course-section',
      '.course-curriculum .section',
      '.curriculum-section',
      '.course-section'
    ];
    
    sectionSelectors.forEach(selector => {
      const sections = $(selector);
      if (sections.length) {
        console.log(`   ${selector}: найдено ${sections.length} секций`);
        sections.slice(0, 2).each((i, section) => {
          const title = $(section).find('.course-section__title, .section-title, h3, h4').first().text().trim();
          console.log(`     ${i + 1}. ${title}`);
        });
      }
    });
    
    console.log('\n✅ Тест завершен');
    
  } catch (error) {
    console.error('❌ Ошибка:', error.message);
  }
}

testHtmlStructure();
