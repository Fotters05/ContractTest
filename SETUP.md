# 🚀 Быстрая настройка Contract2512

## 1️⃣ Настройка базы данных

1. Скопируй `.env.example` в `.env`:
```bash
copy .env.example .env
```

2. Запусти приложение - откроется окно настроек БД
3. Введи параметры подключения к PostgreSQL
4. Нажми "Сохранить"

✅ Готово! Настройки сохранены в `.env`

---

## 2️⃣ Настройка автообновления (для приватного репозитория)

### Создай GitHub токен:

1. Перейди на https://github.com/settings/tokens
2. Нажми **"Generate new token (classic)"**
3. Название: `Contract2512 Auto-Update`
4. Срок: **No expiration**
5. Scope: **✅ repo**
6. Скопируй токен

### Добавь токен в `.env`:

```env
GITHUB_OWNER=твой-username
GITHUB_REPO=contracts2512
GITHUB_TOKEN=ghp_твой_токен_здесь
```

✅ Готово! Приложение будет автоматически обновляться

📖 Подробная инструкция: [AUTO_UPDATE_GUIDE.md](AUTO_UPDATE_GUIDE.md)

---

## 3️⃣ Настройка Node.js парсера

1. Установи Node.js (если еще не установлен): https://nodejs.org/

2. Перейди в папку парсера:
```bash
cd parser_nodejs
```

3. Установи зависимости:
```bash
npm install
```

4. Запусти парсер:
```bash
node index.js
```

✅ Готово! Парсер использует настройки БД из `.env`

---

## 📋 Структура .env файла

```env
# База данных
DB_HOST=localhost
DB_PORT=5432
DB_NAME=MPT2512
DB_USER=postgres
DB_PASSWORD=твой_пароль

# Строка подключения (генерируется автоматически)
DB_CONNECTION_STRING=Host=localhost;Port=5432;Database=MPT2512;Username=postgres;Password=твой_пароль

# GitHub автообновление
GITHUB_OWNER=твой-username
GITHUB_REPO=contracts2512
GITHUB_TOKEN=ghp_твой_токен
```

---

## ❓ Проблемы?

### Приложение не запускается?
- Проверь, что PostgreSQL запущен
- Проверь параметры подключения в `.env`

### Парсер не работает?
- Проверь, что Node.js установлен: `node --version`
- Проверь, что зависимости установлены: `npm install`

### Обновления не приходят?
- Проверь, что токен добавлен в `.env`
- Проверь, что токен имеет scope `repo`
- Проверь, что `GITHUB_OWNER` и `GITHUB_REPO` указаны правильно

---

## 🎉 Готово!

Теперь все настроено и работает! 🚀
