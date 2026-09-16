# Лабораторная работа №2. Развертывание Windows Server в VirtualBox

**МДК.02.02 Техническое сопровождение интегрированных систем**
**Специальность:** 09.02.08 Интеллектуальные интегрированные системы

---

## 🎯 Цель работы

Научиться создавать виртуальную машину, устанавливать Windows Server, настраивать базовые роли (веб-сервер IIS, DNS) и сетевое взаимодействие.

---

## 📝 Задание

### Часть 1. Создание виртуальной машины
1. Скачайте **Windows Server 2022 Evaluation** (ISO) с официального сайта Microsoft.
2. В VirtualBox создайте VM:
   - Имя: `WS-<ВашаФамилия>` (например, `WS-Ivanov`)
   - Тип: Microsoft Windows / Windows 2022 (64-bit)
   - RAM: не менее 4 ГБ
   - Диск: не менее 40 ГБ (VDI, dynamically allocated)
   - Сеть: **Сетевой мост (Bridged Adapter)** — чтобы VM была в одной сети с хостом
3. Установите Windows Server (Standard, Desktop Experience).

### Часть 2. Базовая настройка
4. Задайте **пароль администратора** (запомните его!).
5. Переименуйте сервер в `SRV-<Фамилия>` (через `sconfig` или Server Manager).
6. Настройте **статический IP-адрес** в подсети вашей домашней/учебной сети.
   - Пример: если хост `192.168.1.10`, то VM — `192.168.1.50`
7. Проверьте связь с хостом: `ping <IP хоста>`.

### Часть 3. Установка ролей
8. Установите роль **Web Server (IIS)**.
9. Установите роль **DNS Server**.
10. Создайте простую HTML-страницу `index.html` в `C:\inetpub\wwwroot\`:
    ```html
    <html>
      <body>
        <h1>Студент: <Ваше ФИО></h1>
        <h2>Группа: <Ваша группа></h2>
        <p>Сервер: SRV-<Фамилия></p>
      </body>
    </html>
    
Проверьте доступность сайта:

С VM: http://localhost

С хоста: http://<IP_VM>


Скриншоты
Сделайте скриншоты (папка screenshots/):

01-vbox-settings.png — настройки VM в VirtualBox

02-win-version.png — winver (версия Windows)

03-ipconfig.png — вывод ipconfig /all

04-iis-status.png — IIS Manager со статусом Running

05-browser-localhost.png — сайт из браузера на VM

06-browser-host.png — сайт из браузера на хосте (с IP)

07-dns-manager.png — DNS Manager

08-ping-host.png — ping до хоста